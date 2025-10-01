//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/17/2025 06:13:40 PM
// Design Name: 
// Module Name: SdfUnit1
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


//----------------------------------------------------------------------
//  SdfUnit: Radix-2^2 Single-Path Delay Feedback Unit for N-Point FFT
//----------------------------------------------------------------------
module FFT256Stg5 #(
    parameter   WIDTH = 16  //  Data Bit Length
)(
    input               clock,  //  Master Clock
    input               reset,  //  Active High Asynchronous Reset
    input               di_en,  //  Input Data Enable
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)
    output              do_en,  //  Output Data Enable
    output  [WIDTH-1:0] do_re,  //  Output Data (Real)
    output  [WIDTH-1:0] do_im   //  Output Data (Imag)
);

//  log2 constant function

// in Verilog, the function will take its name as the variable which its value is the return value
// In this case, log2 acts as the fucntion name and the function will take the value of variable 'log2' as the return value

//----------------------------------------------------------------------
//  Internal Regs and Nets
//----------------------------------------------------------------------
//  1st Butterfly
reg [7:0]       di_count;   //  Input Data Count
wire            bf1_bf;     //  Butterfly Add/Sub Enable

// Butterfly
wire[WIDTH-1:0] bf1_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf1_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf1_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf1_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf1_y1_im;  //  Data #1 from Butterfly (Imag)

// Delay Buffer
wire[WIDTH-1:0] db1_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db1_di_im;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db1_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db1_do_im;  //  Data from DelayBuffer (Imag)


wire[WIDTH-1:0] bf1_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf1_sp_im;  //  Single-Path Data Output (Imag)
reg             bf1_sp_en;  //  Single-Path Data Enable
reg [7:0]       bf1_count;  //  Single-Path Data Count
reg             valid_out;
wire            bf1_start;  //  Single-Path Output Trigger
wire            bf1_end;    //  End of Single-Path Data
wire            bf1_mj;     //  Twiddle (-j) Enable
reg [WIDTH-1:0] bf1_do_re;  //  1st Butterfly Output Data (Real)
reg [WIDTH-1:0] bf1_do_im;  //  1st Butterfly Output Data (Imag)

//----------------------------------------------------------------------
//  1st Butterfly
//----------------------------------------------------------------------
always @(posedge clock or posedge reset) begin
    if (reset) begin
        di_count <= {8{1'b0}};	// di_count = 6'b000000
    end else begin
        di_count <= di_en ? (di_count + 1'b1) : {8{1'b0}}; // if di_en = 1 then increment else still equal zero
    end
end
assign  bf1_bf = di_count[3];// bf1_bf = 1 when di_count >= 31

//  Set unknown value x for verification
assign  bf1_x0_re = bf1_bf ? db1_do_re : {WIDTH{1'bx}};		// The first operand (x0) of butterfly is stored in delay buffer
assign  bf1_x0_im = bf1_bf ? db1_do_im : {WIDTH{1'bx}};

assign  bf1_x1_re = bf1_bf ? di_re : {WIDTH{1'bx}};			// The second operand (x1) of butterfly is current input
assign  bf1_x1_im = bf1_bf ? di_im : {WIDTH{1'bx}};

Butterfly #(.WIDTH(WIDTH),.RH(0)) BF1 (
    .x0_re  (bf1_x0_re  ),  //  i
    .x0_im  (bf1_x0_im  ),  //  i
    .x1_re  (bf1_x1_re  ),  //  i
    .x1_im  (bf1_x1_im  ),  //  i
    .y0_re  (bf1_y0_re  ),  //  o
    .y0_im  (bf1_y0_im  ),  //  o
    .y1_re  (bf1_y1_re  ),  //  o
    .y1_im  (bf1_y1_im  )   //  o
);

DelayBuffer #(.DEPTH(8),.WIDTH(WIDTH)) DB1 (	//It is a kind of FIFO
    .clock  (clock      ),  //  i
    .di_re  (db1_di_re  ),  //  i
    .di_im  (db1_di_im  ),  //  i
    .do_re  (db1_do_re  ),  //  o
    .do_im  (db1_do_im  )   //  o
);

assign  db1_di_re = bf1_bf ? bf1_y1_re : di_re;										// if bf1_bf = 0, take input. Else take output (different) of butterfly						
assign  db1_di_im = bf1_bf ? bf1_y1_im : di_im;

assign  bf1_sp_re = bf1_bf ? bf1_y0_re : bf1_mj ?  db1_do_im : db1_do_re;	// if bf1_bf = 1, bf1_sp equals output (sum) of butterfly
assign  bf1_sp_im = bf1_bf ? bf1_y0_im : bf1_mj ? -db1_do_re : db1_do_im;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        bf1_sp_en <= 1'b0;
        bf1_count <= {8{1'b0}};
        valid_out <= 1'b0;
    end else begin
        bf1_sp_en <= bf1_start ? 1'b1 : bf1_end ? 1'b0 : bf1_sp_en;	// if bf1_start = 1, then equals 1, else if bf1_end = 1, equals 0, else maintains old value.
        bf1_count <= bf1_sp_en ? (bf1_count + 1'b1) : {8{1'b0}};	// if bf1_sp_en = 1, then count
        valid_out <= bf1_sp_en;
    end
end
assign  bf1_start = (di_count == 7);	// bf1_start = 1 if di_count equals 31 
assign  bf1_end = (bf1_count == 255);			// bf1_end = 1 if bf1_count = 63
assign  bf1_mj = (bf1_count[3:2] == 2'b11); // bf1_mj = 1 if bf1_count >= 48

always @(posedge clock) begin		//bf1_do equals bf1_sp
    bf1_do_re <= bf1_sp_re;
    bf1_do_im <= bf1_sp_im;
end

assign  do_en = valid_out;
assign  do_re = valid_out ? bf1_do_re : {WIDTH{1'bx}};
assign  do_im = valid_out ? bf1_do_im : {WIDTH{1'bx}};

endmodule

