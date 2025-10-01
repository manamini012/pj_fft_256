//----------------------------------------------------------------------
//  Multiply: Complex Multiplier
//----------------------------------------------------------------------
// c1 = a + bi
// c2 = c + di
// rs = x + yi 
// where: x = a*c - b*d
//			 y = a*d + b*c
module Multiplier #(
    parameter   WIDTH = 16
)(
    input   signed  [WIDTH-1:0] a_re,	// a
    input   signed  [WIDTH-1:0] a_im,	// b
    input   signed  [WIDTH-1:0] b_re,	// c
    input   signed  [WIDTH-1:0] b_im,	// d
    output  signed  [WIDTH-1:0] m_re,	// x
    output  signed  [WIDTH-1:0] m_im	// y
);

wire signed [WIDTH*2-1:0]   arbr, arbi, aibr, aibi;
wire signed [WIDTH-1:0]     sc_arbr, sc_arbi, sc_aibr, sc_aibi;

//  Signed Multiplication
assign  arbr = a_re * b_re;	// a*c
assign  arbi = a_re * b_im;	// a*d
assign  aibr = a_im * b_re;	// b*c
assign  aibi = a_im * b_im;	// b*d

//  Scaling
assign  sc_arbr = arbr >>> (WIDTH-1);	// a*c
assign  sc_arbi = arbi >>> (WIDTH-1);  // a*d
assign  sc_aibr = aibr >>> (WIDTH-1);  // b*c
assign  sc_aibi = aibi >>> (WIDTH-1);  // b*d

//  Sub/Add
//  These sub/add may overflow if unnormalized data is input.
assign  m_re = sc_arbr - sc_aibi;	// x = a*c - b*d
assign  m_im = sc_arbi + sc_aibr;	// y = a*d + b*c

endmodule

