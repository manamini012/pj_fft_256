//----------------------------------------------------------------------
//  Twiddle: 256-Point Twiddle Table for Radix-2^2 Butterfly
//----------------------------------------------------------------------
module Twiddle256 #(
    parameter   TW_FF = 1   //  Use Output Register
)(
    input           clock,  //  Master Clock
    input   [7:0]   addr,   //  Twiddle Factor Number
    output  [15:0]  tw_re,  //  Twiddle Factor (Real)
    output  [15:0]  tw_im   //  Twiddle Factor (Imag)
);

wire[15:0]  wn_re[0:255];    //  Twiddle Table (Real)
wire[15:0]  wn_im[0:255];    //  Twiddle Table (Imag)
wire[15:0]  mx_re;          //  Multiplexer output (Real)
wire[15:0]  mx_im;          //  Multiplexer output (Imag)
reg [15:0]  ff_re;          //  Register output (Real)
reg [15:0]  ff_im;          //  Register output (Imag)

assign  mx_re = wn_re[addr];
assign  mx_im = wn_im[addr];

always @(posedge clock) begin
    ff_re <= mx_re;
    ff_im <= mx_im;
end

assign  tw_re = TW_FF ? ff_re : mx_re;
assign  tw_im = TW_FF ? ff_im : mx_im;

//----------------------------------------------------------------------
//  Twiddle Factor Value
//----------------------------------------------------------------------
//  Multiplication is bypassed when twiddle address is 0.
//  Setting wn_re[0] = 0 and wn_im[0] = 0 makes it easier to check the waveform.
//  It may also reduce power consumption slightly.
//
//      wn_re = cos(-2pi*n/64)          wn_im = sin(-2pi*n/64)
assign  wn_re[0] = 16'h7fff;   assign  wn_im[0]  = 16'h0000;   //  0
assign  wn_re[1] = 16'h7ff6;   assign  wn_im[1]  = 16'hfcdc;   //  1
assign  wn_re[2] = 16'h7fd9;   assign  wn_im[2]  = 16'hf9b8;   //  2
assign  wn_re[3] = 16'h7fa7;   assign  wn_im[3]  = 16'hf695;   //  3
assign  wn_re[4] = 16'h7f62;   assign  wn_im[4]  = 16'hf374;   //  4
assign  wn_re[5] = 16'h7f0a;   assign  wn_im[5]  = 16'hf055;   //  5
assign  wn_re[6] = 16'h7e9d;   assign  wn_im[6]  = 16'hed38;   //  6
assign  wn_re[7] = 16'h7e1e;   assign  wn_im[7]  = 16'hea1e;   //  7
assign  wn_re[8] = 16'h7d8a;   assign  wn_im[8]  = 16'he707;   //  8
assign  wn_re[9] = 16'h7ce4;   assign  wn_im[9]  = 16'he3f4;   //  9
assign  wn_re[10] = 16'h7c2a;   assign  wn_im[10]  = 16'he0e6;   //  10
assign  wn_re[11] = 16'h7b5d;   assign  wn_im[11]  = 16'hdddc;   //  11
assign  wn_re[12] = 16'h7a7d;   assign  wn_im[12]  = 16'hdad8;   //  12
assign  wn_re[13] = 16'h798a;   assign  wn_im[13]  = 16'hd7d9;   //  13
assign  wn_re[14] = 16'h7885;   assign  wn_im[14]  = 16'hd4e1;   //  14
assign  wn_re[15] = 16'h776c;   assign  wn_im[15]  = 16'hd1ef;   //  15
assign  wn_re[16] = 16'h7642;   assign  wn_im[16]  = 16'hcf04;   //  16
assign  wn_re[17] = 16'h7505;   assign  wn_im[17]  = 16'hcc21;   //  17
assign  wn_re[18] = 16'h73b6;   assign  wn_im[18]  = 16'hc946;   //  18
assign  wn_re[19] = 16'h7255;   assign  wn_im[19]  = 16'hc673;   //  19
assign  wn_re[20] = 16'h70e3;   assign  wn_im[20]  = 16'hc3a9;   //  20
assign  wn_re[21] = 16'h6f5f;   assign  wn_im[21]  = 16'hc0e9;   //  21
assign  wn_re[22] = 16'h6dca;   assign  wn_im[22]  = 16'hbe32;   //  22
assign  wn_re[23] = 16'h6c24;   assign  wn_im[23]  = 16'hbb85;   //  23
assign  wn_re[24] = 16'h6a6e;   assign  wn_im[24]  = 16'hb8e3;   //  24
assign  wn_re[25] = 16'h68a7;   assign  wn_im[25]  = 16'hb64c;   //  25
assign  wn_re[26] = 16'h66d0;   assign  wn_im[26]  = 16'hb3c0;   //  26
assign  wn_re[27] = 16'h64e9;   assign  wn_im[27]  = 16'hb140;   //  27
assign  wn_re[28] = 16'h62f2;   assign  wn_im[28]  = 16'haecc;   //  28
assign  wn_re[29] = 16'h60ec;   assign  wn_im[29]  = 16'hac65;   //  29
assign  wn_re[30] = 16'h5ed7;   assign  wn_im[30]  = 16'haa0a;   //  30
assign  wn_re[31] = 16'h5cb4;   assign  wn_im[31]  = 16'ha7bd;   //  31
assign  wn_re[32] = 16'h5a82;   assign  wn_im[32]  = 16'ha57e;   //  32
assign  wn_re[33] = 16'h5843;   assign  wn_im[33]  = 16'ha34c;   //  33
assign  wn_re[34] = 16'h55f6;   assign  wn_im[34]  = 16'ha129;   //  34
assign  wn_re[35] = 16'h539b;   assign  wn_im[35]  = 16'h9f14;   //  35
assign  wn_re[36] = 16'h5134;   assign  wn_im[36]  = 16'h9d0e;   //  36
assign  wn_re[37] = 16'h4ec0;   assign  wn_im[37]  = 16'h9b17;   //  37
assign  wn_re[38] = 16'h4c40;   assign  wn_im[38]  = 16'h9930;   //  38
assign  wn_re[39] = 16'h49b4;   assign  wn_im[39]  = 16'h9759;   //  39
assign  wn_re[40] = 16'h471d;   assign  wn_im[40]  = 16'h9592;   //  40
assign  wn_re[41] = 16'h447b;   assign  wn_im[41]  = 16'h93dc;   //  41
assign  wn_re[42] = 16'h41ce;   assign  wn_im[42]  = 16'h9236;   //  42
assign  wn_re[43] = 16'h3f17;   assign  wn_im[43]  = 16'h90a1;   //  43
assign  wn_re[44] = 16'h3c57;   assign  wn_im[44]  = 16'h8f1d;   //  44
assign  wn_re[45] = 16'h398d;   assign  wn_im[45]  = 16'h8dab;   //  45
assign  wn_re[46] = 16'h36ba;   assign  wn_im[46]  = 16'h8c4a;   //  46
assign  wn_re[47] = 16'h33df;   assign  wn_im[47]  = 16'h8afb;   //  47
assign  wn_re[48] = 16'h30fc;   assign  wn_im[48]  = 16'h89be;   //  48
assign  wn_re[49] = 16'h2e11;   assign  wn_im[49]  = 16'h8894;   //  49
assign  wn_re[50] = 16'h2b1f;   assign  wn_im[50]  = 16'h877b;   //  50
assign  wn_re[51] = 16'h2827;   assign  wn_im[51]  = 16'h8676;   //  51
assign  wn_re[52] = 16'h2528;   assign  wn_im[52]  = 16'h8583;   //  52
assign  wn_re[53] = 16'h2224;   assign  wn_im[53]  = 16'h84a3;   //  53
assign  wn_re[54] = 16'h1f1a;   assign  wn_im[54]  = 16'h83d6;   //  54
assign  wn_re[55] = 16'h1c0c;   assign  wn_im[55]  = 16'h831c;   //  55
assign  wn_re[56] = 16'h18f9;   assign  wn_im[56]  = 16'h8276;   //  56
assign  wn_re[57] = 16'h15e2;   assign  wn_im[57]  = 16'h81e2;   //  57
assign  wn_re[58] = 16'h12c8;   assign  wn_im[58]  = 16'h8163;   //  58
assign  wn_re[59] = 16'h0fab;   assign  wn_im[59]  = 16'h80f6;   //  59
assign  wn_re[60] = 16'h0c8c;   assign  wn_im[60]  = 16'h809e;   //  60
assign  wn_re[61] = 16'h096b;   assign  wn_im[61]  = 16'h8059;   //  61
assign  wn_re[62] = 16'h0648;   assign  wn_im[62]  = 16'h8027;   //  62
assign  wn_re[63] = 16'h0324;   assign  wn_im[63]  = 16'h800a;   //  63
assign  wn_re[64] = 16'h0000;   assign  wn_im[64]  = 16'h8000;   //  64
assign  wn_re[65] = 16'hfcdc;   assign  wn_im[65]  = 16'h800a;   //  65
assign  wn_re[66] = 16'hf9b8;   assign  wn_im[66]  = 16'h8027;   //  66
assign  wn_re[67] = 16'hf695;   assign  wn_im[67]  = 16'h8059;   //  67
assign  wn_re[68] = 16'hf374;   assign  wn_im[68]  = 16'h809e;   //  68
assign  wn_re[69] = 16'hf055;   assign  wn_im[69]  = 16'h80f6;   //  69
assign  wn_re[70] = 16'hed38;   assign  wn_im[70]  = 16'h8163;   //  70
assign  wn_re[71] = 16'hea1e;   assign  wn_im[71]  = 16'h81e2;   //  71
assign  wn_re[72] = 16'he707;   assign  wn_im[72]  = 16'h8276;   //  72
assign  wn_re[73] = 16'he3f4;   assign  wn_im[73]  = 16'h831c;   //  73
assign  wn_re[74] = 16'he0e6;   assign  wn_im[74]  = 16'h83d6;   //  74
assign  wn_re[75] = 16'hdddc;   assign  wn_im[75]  = 16'h84a3;   //  75
assign  wn_re[76] = 16'hdad8;   assign  wn_im[76]  = 16'h8583;   //  76
assign  wn_re[77] = 16'hd7d9;   assign  wn_im[77]  = 16'h8676;   //  77
assign  wn_re[78] = 16'hd4e1;   assign  wn_im[78]  = 16'h877b;   //  78
assign  wn_re[79] = 16'hd1ef;   assign  wn_im[79]  = 16'h8894;   //  79
assign  wn_re[80] = 16'hcf04;   assign  wn_im[80]  = 16'h89be;   //  80
assign  wn_re[81] = 16'hcc21;   assign  wn_im[81]  = 16'h8afb;   //  81
assign  wn_re[82] = 16'hc946;   assign  wn_im[82]  = 16'h8c4a;   //  82
assign  wn_re[83] = 16'hc673;   assign  wn_im[83]  = 16'h8dab;   //  83
assign  wn_re[84] = 16'hc3a9;   assign  wn_im[84]  = 16'h8f1d;   //  84
assign  wn_re[85] = 16'hc0e9;   assign  wn_im[85]  = 16'h90a1;   //  85
assign  wn_re[86] = 16'hbe32;   assign  wn_im[86]  = 16'h9236;   //  86
assign  wn_re[87] = 16'hbb85;   assign  wn_im[87]  = 16'h93dc;   //  87
assign  wn_re[88] = 16'hb8e3;   assign  wn_im[88]  = 16'h9592;   //  88
assign  wn_re[89] = 16'hb64c;   assign  wn_im[89]  = 16'h9759;   //  89
assign  wn_re[90] = 16'hb3c0;   assign  wn_im[90]  = 16'h9930;   //  90
assign  wn_re[91] = 16'hb140;   assign  wn_im[91]  = 16'h9b17;   //  91
assign  wn_re[92] = 16'haecc;   assign  wn_im[92]  = 16'h9d0e;   //  92
assign  wn_re[93] = 16'hac65;   assign  wn_im[93]  = 16'h9f14;   //  93
assign  wn_re[94] = 16'haa0a;   assign  wn_im[94]  = 16'ha129;   //  94
assign  wn_re[95] = 16'ha7bd;   assign  wn_im[95]  = 16'ha34c;   //  95
assign  wn_re[96] = 16'ha57e;   assign  wn_im[96]  = 16'ha57e;   //  96
assign  wn_re[97] = 16'ha34c;   assign  wn_im[97]  = 16'ha7bd;   //  97
assign  wn_re[98] = 16'ha129;   assign  wn_im[98]  = 16'haa0a;   //  98
assign  wn_re[99] = 16'h9f14;   assign  wn_im[99]  = 16'hac65;   //  99
assign  wn_re[100] = 16'h9d0e;   assign  wn_im[100]  = 16'haecc;   //  100
assign  wn_re[101] = 16'h9b17;   assign  wn_im[101]  = 16'hb140;   //  101
assign  wn_re[102] = 16'h9930;   assign  wn_im[102]  = 16'hb3c0;   //  102
assign  wn_re[103] = 16'h9759;   assign  wn_im[103]  = 16'hb64c;   //  103
assign  wn_re[104] = 16'h9592;   assign  wn_im[104]  = 16'hb8e3;   //  104
assign  wn_re[105] = 16'h93dc;   assign  wn_im[105]  = 16'hbb85;   //  105
assign  wn_re[106] = 16'h9236;   assign  wn_im[106]  = 16'hbe32;   //  106
assign  wn_re[107] = 16'h90a1;   assign  wn_im[107]  = 16'hc0e9;   //  107
assign  wn_re[108] = 16'h8f1d;   assign  wn_im[108]  = 16'hc3a9;   //  108
assign  wn_re[109] = 16'h8dab;   assign  wn_im[109]  = 16'hc673;   //  109
assign  wn_re[110] = 16'h8c4a;   assign  wn_im[110]  = 16'hc946;   //  110
assign  wn_re[111] = 16'h8afb;   assign  wn_im[111]  = 16'hcc21;   //  111
assign  wn_re[112] = 16'h89be;   assign  wn_im[112]  = 16'hcf04;   //  112
assign  wn_re[113] = 16'h8894;   assign  wn_im[113]  = 16'hd1ef;   //  113
assign  wn_re[114] = 16'h877b;   assign  wn_im[114]  = 16'hd4e1;   //  114
assign  wn_re[115] = 16'h8676;   assign  wn_im[115]  = 16'hd7d9;   //  115
assign  wn_re[116] = 16'h8583;   assign  wn_im[116]  = 16'hdad8;   //  116
assign  wn_re[117] = 16'h84a3;   assign  wn_im[117]  = 16'hdddc;   //  117
assign  wn_re[118] = 16'h83d6;   assign  wn_im[118]  = 16'he0e6;   //  118
assign  wn_re[119] = 16'h831c;   assign  wn_im[119]  = 16'he3f4;   //  119
assign  wn_re[120] = 16'h8276;   assign  wn_im[120]  = 16'he707;   //  120
assign  wn_re[121] = 16'h81e2;   assign  wn_im[121]  = 16'hea1e;   //  121
assign  wn_re[122] = 16'h8163;   assign  wn_im[122]  = 16'hed38;   //  122
assign  wn_re[123] = 16'h80f6;   assign  wn_im[123]  = 16'hf055;   //  123
assign  wn_re[124] = 16'h809e;   assign  wn_im[124]  = 16'hf374;   //  124
assign  wn_re[125] = 16'h8059;   assign  wn_im[125]  = 16'hf695;   //  125
assign  wn_re[126] = 16'h8027;   assign  wn_im[126]  = 16'hf9b8;   //  126
assign  wn_re[127] = 16'h800a;   assign  wn_im[127]  = 16'hfcdc;   //  127
assign  wn_re[128] = 16'h8000;   assign  wn_im[128]  = 16'h0000;   //  128
assign  wn_re[129] = 16'h800a;   assign  wn_im[129]  = 16'h0324;   //  129
assign  wn_re[130] = 16'h8027;   assign  wn_im[130]  = 16'h0648;   //  130
assign  wn_re[131] = 16'h8059;   assign  wn_im[131]  = 16'h096b;   //  131
assign  wn_re[132] = 16'h809e;   assign  wn_im[132]  = 16'h0c8c;   //  132
assign  wn_re[133] = 16'h80f6;   assign  wn_im[133]  = 16'h0fab;   //  133
assign  wn_re[134] = 16'h8163;   assign  wn_im[134]  = 16'h12c8;   //  134
assign  wn_re[135] = 16'h81e2;   assign  wn_im[135]  = 16'h15e2;   //  135
assign  wn_re[136] = 16'h8276;   assign  wn_im[136]  = 16'h18f9;   //  136
assign  wn_re[137] = 16'h831c;   assign  wn_im[137]  = 16'h1c0c;   //  137
assign  wn_re[138] = 16'h83d6;   assign  wn_im[138]  = 16'h1f1a;   //  138
assign  wn_re[139] = 16'h84a3;   assign  wn_im[139]  = 16'h2224;   //  139
assign  wn_re[140] = 16'h8583;   assign  wn_im[140]  = 16'h2528;   //  140
assign  wn_re[141] = 16'h8676;   assign  wn_im[141]  = 16'h2827;   //  141
assign  wn_re[142] = 16'h877b;   assign  wn_im[142]  = 16'h2b1f;   //  142
assign  wn_re[143] = 16'h8894;   assign  wn_im[143]  = 16'h2e11;   //  143
assign  wn_re[144] = 16'h89be;   assign  wn_im[144]  = 16'h30fc;   //  144
assign  wn_re[145] = 16'h8afb;   assign  wn_im[145]  = 16'h33df;   //  145
assign  wn_re[146] = 16'h8c4a;   assign  wn_im[146]  = 16'h36ba;   //  146
assign  wn_re[147] = 16'h8dab;   assign  wn_im[147]  = 16'h398d;   //  147
assign  wn_re[148] = 16'h8f1d;   assign  wn_im[148]  = 16'h3c57;   //  148
assign  wn_re[149] = 16'h90a1;   assign  wn_im[149]  = 16'h3f17;   //  149
assign  wn_re[150] = 16'h9236;   assign  wn_im[150]  = 16'h41ce;   //  150
assign  wn_re[151] = 16'h93dc;   assign  wn_im[151]  = 16'h447b;   //  151
assign  wn_re[152] = 16'h9592;   assign  wn_im[152]  = 16'h471d;   //  152
assign  wn_re[153] = 16'h9759;   assign  wn_im[153]  = 16'h49b4;   //  153
assign  wn_re[154] = 16'h9930;   assign  wn_im[154]  = 16'h4c40;   //  154
assign  wn_re[155] = 16'h9b17;   assign  wn_im[155]  = 16'h4ec0;   //  155
assign  wn_re[156] = 16'h9d0e;   assign  wn_im[156]  = 16'h5134;   //  156
assign  wn_re[157] = 16'h9f14;   assign  wn_im[157]  = 16'h539b;   //  157
assign  wn_re[158] = 16'ha129;   assign  wn_im[158]  = 16'h55f6;   //  158
assign  wn_re[159] = 16'ha34c;   assign  wn_im[159]  = 16'h5843;   //  159
assign  wn_re[160] = 16'ha57e;   assign  wn_im[160]  = 16'h5a82;   //  160
assign  wn_re[161] = 16'ha7bd;   assign  wn_im[161]  = 16'h5cb4;   //  161
assign  wn_re[162] = 16'haa0a;   assign  wn_im[162]  = 16'h5ed7;   //  162
assign  wn_re[163] = 16'hac65;   assign  wn_im[163]  = 16'h60ec;   //  163
assign  wn_re[164] = 16'haecc;   assign  wn_im[164]  = 16'h62f2;   //  164
assign  wn_re[165] = 16'hb140;   assign  wn_im[165]  = 16'h64e9;   //  165
assign  wn_re[166] = 16'hb3c0;   assign  wn_im[166]  = 16'h66d0;   //  166
assign  wn_re[167] = 16'hb64c;   assign  wn_im[167]  = 16'h68a7;   //  167
assign  wn_re[168] = 16'hb8e3;   assign  wn_im[168]  = 16'h6a6e;   //  168
assign  wn_re[169] = 16'hbb85;   assign  wn_im[169]  = 16'h6c24;   //  169
assign  wn_re[170] = 16'hbe32;   assign  wn_im[170]  = 16'h6dca;   //  170
assign  wn_re[171] = 16'hc0e9;   assign  wn_im[171]  = 16'h6f5f;   //  171
assign  wn_re[172] = 16'hc3a9;   assign  wn_im[172]  = 16'h70e3;   //  172
assign  wn_re[173] = 16'hc673;   assign  wn_im[173]  = 16'h7255;   //  173
assign  wn_re[174] = 16'hc946;   assign  wn_im[174]  = 16'h73b6;   //  174
assign  wn_re[175] = 16'hcc21;   assign  wn_im[175]  = 16'h7505;   //  175
assign  wn_re[176] = 16'hcf04;   assign  wn_im[176]  = 16'h7642;   //  176
assign  wn_re[177] = 16'hd1ef;   assign  wn_im[177]  = 16'h776c;   //  177
assign  wn_re[178] = 16'hd4e1;   assign  wn_im[178]  = 16'h7885;   //  178
assign  wn_re[179] = 16'hd7d9;   assign  wn_im[179]  = 16'h798a;   //  179
assign  wn_re[180] = 16'hdad8;   assign  wn_im[180]  = 16'h7a7d;   //  180
assign  wn_re[181] = 16'hdddc;   assign  wn_im[181]  = 16'h7b5d;   //  181
assign  wn_re[182] = 16'he0e6;   assign  wn_im[182]  = 16'h7c2a;   //  182
assign  wn_re[183] = 16'he3f4;   assign  wn_im[183]  = 16'h7ce4;   //  183
assign  wn_re[184] = 16'he707;   assign  wn_im[184]  = 16'h7d8a;   //  184
assign  wn_re[185] = 16'hea1e;   assign  wn_im[185]  = 16'h7e1e;   //  185
assign  wn_re[186] = 16'hed38;   assign  wn_im[186]  = 16'h7e9d;   //  186
assign  wn_re[187] = 16'hf055;   assign  wn_im[187]  = 16'h7f0a;   //  187
assign  wn_re[188] = 16'hf374;   assign  wn_im[188]  = 16'h7f62;   //  188
assign  wn_re[189] = 16'hf695;   assign  wn_im[189]  = 16'h7fa7;   //  189
assign  wn_re[190] = 16'hf9b8;   assign  wn_im[190]  = 16'h7fd9;   //  190
assign  wn_re[191] = 16'hfcdc;   assign  wn_im[191]  = 16'h7ff6;   //  191
assign  wn_re[192] = 16'h0000;   assign  wn_im[192]  = 16'h7fff;   //  192
assign  wn_re[193] = 16'h0324;   assign  wn_im[193]  = 16'h7ff6;   //  193
assign  wn_re[194] = 16'h0648;   assign  wn_im[194]  = 16'h7fd9;   //  194
assign  wn_re[195] = 16'h096b;   assign  wn_im[195]  = 16'h7fa7;   //  195
assign  wn_re[196] = 16'h0c8c;   assign  wn_im[196]  = 16'h7f62;   //  196
assign  wn_re[197] = 16'h0fab;   assign  wn_im[197]  = 16'h7f0a;   //  197
assign  wn_re[198] = 16'h12c8;   assign  wn_im[198]  = 16'h7e9d;   //  198
assign  wn_re[199] = 16'h15e2;   assign  wn_im[199]  = 16'h7e1e;   //  199
assign  wn_re[200] = 16'h18f9;   assign  wn_im[200]  = 16'h7d8a;   //  200
assign  wn_re[201] = 16'h1c0c;   assign  wn_im[201]  = 16'h7ce4;   //  201
assign  wn_re[202] = 16'h1f1a;   assign  wn_im[202]  = 16'h7c2a;   //  202
assign  wn_re[203] = 16'h2224;   assign  wn_im[203]  = 16'h7b5d;   //  203
assign  wn_re[204] = 16'h2528;   assign  wn_im[204]  = 16'h7a7d;   //  204
assign  wn_re[205] = 16'h2827;   assign  wn_im[205]  = 16'h798a;   //  205
assign  wn_re[206] = 16'h2b1f;   assign  wn_im[206]  = 16'h7885;   //  206
assign  wn_re[207] = 16'h2e11;   assign  wn_im[207]  = 16'h776c;   //  207
assign  wn_re[208] = 16'h30fc;   assign  wn_im[208]  = 16'h7642;   //  208
assign  wn_re[209] = 16'h33df;   assign  wn_im[209]  = 16'h7505;   //  209
assign  wn_re[210] = 16'h36ba;   assign  wn_im[210]  = 16'h73b6;   //  210
assign  wn_re[211] = 16'h398d;   assign  wn_im[211]  = 16'h7255;   //  211
assign  wn_re[212] = 16'h3c57;   assign  wn_im[212]  = 16'h70e3;   //  212
assign  wn_re[213] = 16'h3f17;   assign  wn_im[213]  = 16'h6f5f;   //  213
assign  wn_re[214] = 16'h41ce;   assign  wn_im[214]  = 16'h6dca;   //  214
assign  wn_re[215] = 16'h447b;   assign  wn_im[215]  = 16'h6c24;   //  215
assign  wn_re[216] = 16'h471d;   assign  wn_im[216]  = 16'h6a6e;   //  216
assign  wn_re[217] = 16'h49b4;   assign  wn_im[217]  = 16'h68a7;   //  217
assign  wn_re[218] = 16'h4c40;   assign  wn_im[218]  = 16'h66d0;   //  218
assign  wn_re[219] = 16'h4ec0;   assign  wn_im[219]  = 16'h64e9;   //  219
assign  wn_re[220] = 16'h5134;   assign  wn_im[220]  = 16'h62f2;   //  220
assign  wn_re[221] = 16'h539b;   assign  wn_im[221]  = 16'h60ec;   //  221
assign  wn_re[222] = 16'h55f6;   assign  wn_im[222]  = 16'h5ed7;   //  222
assign  wn_re[223] = 16'h5843;   assign  wn_im[223]  = 16'h5cb4;   //  223
assign  wn_re[224] = 16'h5a82;   assign  wn_im[224]  = 16'h5a82;   //  224
assign  wn_re[225] = 16'h5cb4;   assign  wn_im[225]  = 16'h5843;   //  225
assign  wn_re[226] = 16'h5ed7;   assign  wn_im[226]  = 16'h55f6;   //  226
assign  wn_re[227] = 16'h60ec;   assign  wn_im[227]  = 16'h539b;   //  227
assign  wn_re[228] = 16'h62f2;   assign  wn_im[228]  = 16'h5134;   //  228
assign  wn_re[229] = 16'h64e9;   assign  wn_im[229]  = 16'h4ec0;   //  229
assign  wn_re[230] = 16'h66d0;   assign  wn_im[230]  = 16'h4c40;   //  230
assign  wn_re[231] = 16'h68a7;   assign  wn_im[231]  = 16'h49b4;   //  231
assign  wn_re[232] = 16'h6a6e;   assign  wn_im[232]  = 16'h471d;   //  232
assign  wn_re[233] = 16'h6c24;   assign  wn_im[233]  = 16'h447b;   //  233
assign  wn_re[234] = 16'h6dca;   assign  wn_im[234]  = 16'h41ce;   //  234
assign  wn_re[235] = 16'h6f5f;   assign  wn_im[235]  = 16'h3f17;   //  235
assign  wn_re[236] = 16'h70e3;   assign  wn_im[236]  = 16'h3c57;   //  236
assign  wn_re[237] = 16'h7255;   assign  wn_im[237]  = 16'h398d;   //  237
assign  wn_re[238] = 16'h73b6;   assign  wn_im[238]  = 16'h36ba;   //  238
assign  wn_re[239] = 16'h7505;   assign  wn_im[239]  = 16'h33df;   //  239
assign  wn_re[240] = 16'h7642;   assign  wn_im[240]  = 16'h30fc;   //  240
assign  wn_re[241] = 16'h776c;   assign  wn_im[241]  = 16'h2e11;   //  241
assign  wn_re[242] = 16'h7885;   assign  wn_im[242]  = 16'h2b1f;   //  242
assign  wn_re[243] = 16'h798a;   assign  wn_im[243]  = 16'h2827;   //  243
assign  wn_re[244] = 16'h7a7d;   assign  wn_im[244]  = 16'h2528;   //  244
assign  wn_re[245] = 16'h7b5d;   assign  wn_im[245]  = 16'h2224;   //  245
assign  wn_re[246] = 16'h7c2a;   assign  wn_im[246]  = 16'h1f1a;   //  246
assign  wn_re[247] = 16'h7ce4;   assign  wn_im[247]  = 16'h1c0c;   //  247
assign  wn_re[248] = 16'h7d8a;   assign  wn_im[248]  = 16'h18f9;   //  248
assign  wn_re[249] = 16'h7e1e;   assign  wn_im[249]  = 16'h15e2;   //  249
assign  wn_re[250] = 16'h7e9d;   assign  wn_im[250]  = 16'h12c8;   //  250
assign  wn_re[251] = 16'h7f0a;   assign  wn_im[251]  = 16'h0fab;   //  251
assign  wn_re[252] = 16'h7f62;   assign  wn_im[252]  = 16'h0c8c;   //  252
assign  wn_re[253] = 16'h7fa7;   assign  wn_im[253]  = 16'h096b;   //  253
assign  wn_re[254] = 16'h7fd9;   assign  wn_im[254]  = 16'h0648;   //  254
assign  wn_re[255] = 16'h7ff6;   assign  wn_im[255]  = 16'h0324;   //  255


endmodule

