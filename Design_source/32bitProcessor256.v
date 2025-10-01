`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/19/2025 09:49:57 AM
// Design Name: 
// Module Name: Processor256_32bit
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


module Processor256_32bit #(
     parameter   WIDTH = 32
)(
    input               clock,  //  Master Clock                    
    input               reset,  //  Active High Asynchronous Reset  
    input               di_en,  //  Input Data Enable               
    input   [WIDTH-1:0] di_re,  //  Input Data (Real)               
    input   [WIDTH-1:0] di_im,  //  Input Data (Imag)               
    output              do_en,  //  Output Data Enable              
    output  [WIDTH-1:0] do_re,  //  Output Data (Real)              
    output  [WIDTH-1:0] do_im  //  Output Data (Imag)               
);

wire            unit1_do_en;
wire[WIDTH-1:0] unit1_do_re;
wire[WIDTH-1:0] unit1_do_im;

wire            unit2_do_en;
wire[WIDTH-1:0] unit2_do_re;
wire[WIDTH-1:0] unit2_do_im;

wire            unit3_do_en;
wire[WIDTH-1:0] unit3_do_re;
wire[WIDTH-1:0] unit3_do_im;

wire            unit4_do_en;
wire[WIDTH-1:0] unit4_do_re;
wire[WIDTH-1:0] unit4_do_im;

wire            unit5_do_en;
wire[WIDTH-1:0] unit5_do_re;
wire[WIDTH-1:0] unit5_do_im;

wire            unit6_do_en;
wire[WIDTH-1:0] unit6_do_re;
wire[WIDTH-1:0] unit6_do_im;

wire            unit7_do_en;
wire[WIDTH-1:0] unit7_do_re;
wire[WIDTH-1:0] unit7_do_im;

FFT256Stg1 Stage1 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (di_en      ),  //  i
    .di_re  (di_re      ),  //  i
    .di_im  (di_im      ),  //  i
    .do_en  (unit1_do_en  ),  //  o
    .do_re  (unit1_do_re  ),  //  o
    .do_im  (unit1_do_im  )   //  o
);

FFT256Stg2 Stage2 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit1_do_en  ),  //  i
    .di_re  (unit1_do_re  ),  //  i
    .di_im  (unit1_do_im  ),  //  i
    .do_en  (unit2_do_en  ),  //  o
    .do_re  (unit2_do_re  ),  //  o
    .do_im  (unit2_do_im  )   //  o
);

FFT256Stg3 Stage3 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit2_do_en  ),  //  i
    .di_re  (unit2_do_re  ),  //  i
    .di_im  (unit2_do_im  ),  //  i
    .do_en  (unit3_do_en  ),  //  o
    .do_re  (unit3_do_re  ),  //  o
    .do_im  (unit3_do_im  )   //  o
);

FFT256Stg4 Stage4 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit3_do_en  ),  //  i
    .di_re  (unit3_do_re  ),  //  i
    .di_im  (unit3_do_im  ),  //  i
    .do_en  (unit4_do_en  ),  //  o
    .do_re  (unit4_do_re  ),  //  o
    .do_im  (unit4_do_im  )   //  o
);

FFT256Stg5 Stage5 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit4_do_en  ),  //  i
    .di_re  (unit4_do_re  ),  //  i
    .di_im  (unit4_do_im  ),  //  i
    .do_en  (unit5_do_en  ),  //  o
    .do_re  (unit5_do_re  ),  //  o
    .do_im  (unit5_do_im  )   //  o
);

FFT256Stg6 Stage6 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit5_do_en  ),  //  i
    .di_re  (unit5_do_re  ),  //  i
    .di_im  (unit5_do_im  ),  //  i
    .do_en  (unit6_do_en  ),  //  o
    .do_re  (unit6_do_re  ),  //  o
    .do_im  (unit6_do_im  )   //  o
);

FFT256Stg7 Stage7 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit6_do_en  ),  //  i
    .di_re  (unit6_do_re  ),  //  i
    .di_im  (unit6_do_im  ),  //  i
    .do_en  (unit7_do_en  ),  //  o
    .do_re  (unit7_do_re  ),  //  o
    .do_im  (unit7_do_im  )   //  o
);

FFT256Stg8 Stage8 (
    .clock  (clock      ),  //  i
    .reset  (reset      ),  //  i
    .di_en  (unit7_do_en  ),  //  i
    .di_re  (unit7_do_re  ),  //  i
    .di_im  (unit7_do_im  ),  //  i
    .do_en  (do_en  ),  //  o
    .do_re  (do_re  ),  //  o
    .do_im  (do_im  )   //  o
);

endmodule
