//----------------------------------------------------------------------
//  SdfUnit: Radix-2^2 Single-Path Delay Feedback Unit for N-Point FFT
//----------------------------------------------------------------------
module FFT256Stg8 #(
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


//----------------------------------------------------------------------
//  Internal Regs and Nets
//----------------------------------------------------------------------
//  1st Butterfly
reg [7:0]       di_count;   //  Input Data Count


//  2nd Butterfly
wire             bf2_bf;     //  Butterfly Add/Sub Enable
// Butterfly
wire[WIDTH-1:0] bf2_x0_re;  //  Data #0 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x0_im;  //  Data #0 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_x1_re;  //  Data #1 to Butterfly (Real)
wire[WIDTH-1:0] bf2_x1_im;  //  Data #1 to Butterfly (Imag)
wire[WIDTH-1:0] bf2_y0_re;  //  Data #0 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y0_im;  //  Data #0 from Butterfly (Imag)
wire[WIDTH-1:0] bf2_y1_re;  //  Data #1 from Butterfly (Real)
wire[WIDTH-1:0] bf2_y1_im;  //  Data #1 from Butterfly (Imag)

// DelayBuffer
wire[WIDTH-1:0] db2_di_re;  //  Data to DelayBuffer (Real)
wire[WIDTH-1:0] db2_di_im;  //  Data to DelayBuffer (Imag)
wire[WIDTH-1:0] db2_do_re;  //  Data from DelayBuffer (Real)
wire[WIDTH-1:0] db2_do_im;  //  Data from DelayBuffer (Imag)

wire[WIDTH-1:0] bf2_sp_re;  //  Single-Path Data Output (Real)
wire[WIDTH-1:0] bf2_sp_im;  //  Single-Path Data Output (Imag)
reg             bf2_sp_en;  //  Single-Path Data Enable
reg [7:0]       bf2_count;  //  Single-Path Data Count
reg [7:0]       tw_count;
wire            bf2_start;  //  Single-Path Output Trigger
wire            bf2_end;    //  End of Single-Path Data
reg [WIDTH-1:0] bf2_do_re;  //  2nd Butterfly Output Data (Real)
reg [WIDTH-1:0] bf2_do_im;  //  2nd Butterfly Output Data (Imag)
reg             bf2_do_en;  //  2nd Butterfly Output Data Enable

always @(posedge clock or posedge reset) begin
    if (reset) begin
        di_count <= {8{1'b0}};	// di_count = 6'b000000
    end else begin
        di_count <= di_en ? (di_count + 1'b1) : {8{1'b0}}; // if di_en = 1 then increment else still equal zero
    end
end

//----------------------------------------------------------------------
//  2nd Butterfly
//----------------------------------------------------------------------
assign bf2_bf = di_count[0]; // if 16 <= bf1_count <= 32 or 48 <= bf1_count <= 63


//  Set unknown value x for verification
assign  bf2_x0_re = bf2_bf ? db2_do_re : {WIDTH{1'bx}};		// the first operand of 2nd Butterfly is delay buffer output
assign  bf2_x0_im = bf2_bf ? db2_do_im : {WIDTH{1'bx}};

assign  bf2_x1_re = bf2_bf ? di_re : {WIDTH{1'bx}};		// the second operand of 2nd Bufferfly is bf1 output
assign  bf2_x1_im = bf2_bf ? di_im : {WIDTH{1'bx}};

//  Negative bias occurs when RH=0 and positive bias occurs when RH=1.
//  Using both alternately reduces the overall rounding error.
Butterfly #(.WIDTH(WIDTH),.RH(1)) BF2 (
    .x0_re  (bf2_x0_re  ),  //  i
    .x0_im  (bf2_x0_im  ),  //  i
    .x1_re  (bf2_x1_re  ),  //  i
    .x1_im  (bf2_x1_im  ),  //  i
    .y0_re  (bf2_y0_re  ),  //  o
    .y0_im  (bf2_y0_im  ),  //  o
    .y1_re  (bf2_y1_re  ),  //  o
    .y1_im  (bf2_y1_im  )   //  o
);

DelayBuffer #(.DEPTH(1),.WIDTH(WIDTH)) DB2 (
    .clock  (clock      ),  //  i
    .di_re  (db2_di_re  ),  //  i
    .di_im  (db2_di_im  ),  //  i
    .do_re  (db2_do_re  ),  //  o
    .do_im  (db2_do_im  )   //  o
);

assign  db2_di_re = bf2_bf ? bf2_y1_re : di_re;	//If bf2_bf = 1, then take output (different) of 2nd butterfly else take bf1 output
assign  db2_di_im = bf2_bf ? bf2_y1_im : di_im;

assign  bf2_sp_re = bf2_bf ? bf2_y0_re : db2_do_re;	//If bf2_bf = 1, then take output (sum) of 2nd butterfly else take delay buffer 2 output
assign  bf2_sp_im = bf2_bf ? bf2_y0_im : db2_do_im;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        bf2_sp_en <= 1'b0;
        bf2_count <= {8{1'b0}};
    end else begin
        bf2_sp_en <= bf2_start ? 1'b1 : bf2_end ? 1'b0 : bf2_sp_en;
        bf2_count <= bf2_sp_en ? (bf2_count + 1'b1) : {8{1'b0}};
    end
end

assign bf2_start = ((di_count == 0) & di_en);	//	bf1 == 15
assign bf2_end   = (bf2_count == 255);		// bf2_end = 1 when bf2_count == 63

always @(posedge clock) begin
    bf2_do_re <= bf2_sp_re;
    bf2_do_im <= bf2_sp_im;
end

assign  do_en = bf2_sp_en;
assign  do_re = bf2_sp_re;
assign  do_im = bf2_sp_im;

endmodule