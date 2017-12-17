`define MEMSIZE 768

`define PAR_CLOCK 20_000
module top( input CLK100MHZ, input RESET, output reg [15:0] OUT);

  logic [26:0] counter;
  logic CLOCK;

  always_comb begin
    if (counter < `PAR_CLOCK / 2) CLOCK = 0;
    else                          CLOCK = 1;
  end

  always @(posedge CLK100MHZ) begin
    if (RESET | counter < `PAR_CLOCK) counter <= counter + 1;
    else                              counter <= 0;
  end

  cpu cpu_0(CLOCK, RESET, OUT);

endmodule


module cpu( input CLOCK, input RESET, output reg [15:0] OUT);

  // メモリの宣言/*{{{*/
  logic [7:0] memory [`MEMSIZE-1:0];/*}}}*/
  // メモリ直前のワイヤの宣言/*{{{*/
  logic        write_flag;
  logic [31:0] write_addr;
  logic [31:0] write_value;/*}}}*/
  // レジスタの宣言/*{{{*/
  logic [31:0] eax; // FF
  logic [31:0] ecx; // FF
  logic [31:0] edx; // FF
  logic [31:0] ebx; // FF
  logic [31:0] esp; // FF
  logic [31:0] ebp; // FF
  logic [31:0] esi; // FF
  logic [31:0] edi; // FF
  logic [31:0] eip; // FF
  logic cf, zf, sf, of; // wire
  /*}}}*/
  // レジスタ直前のワイヤの宣言/*{{{*/
  logic [31:0] next_eax; // wire
  logic [31:0] next_ecx; // wire
  logic [31:0] next_edx; // wire
  logic [31:0] next_ebx; // wire
  logic [31:0] next_esp; // wire
  logic [31:0] next_ebp; // wire
  logic [31:0] next_esi; // wire
  logic [31:0] next_edi; // wire
  logic [31:0] next_eip; // wire
  logic next_cf, next_zf, next_sf, next_of; // wire/*}}}*/

  // メモリから値をフェッチ
  // オペコードのワイヤを作成/*{{{*/
  logic [7:0] opecode;
  assign opecode = memory[eip];/*}}}*/
  // ModRMを作成/*{{{*/
  logic [31:0] imm8;
  logic [31:0] imm32;
  logic [31:0] modrm_imm8;
  logic [31:0] modrm_imm32;
  logic [ 1:0] mod;
  logic [ 2:0] r;
  logic [ 2:0] m;
  logic [31:0] r_reg;
  logic [31:0] m_reg;
  logic [31:0] m_reg_plus_imm8 ; // M+imm8
  logic [31:0] m_reg_plus_imm32; // M+imm32

  logic [ 7:0] around_eip [6:0];
  assign around_eip[0] = memory[eip+0];
  assign around_eip[1] = memory[eip+1];
  assign around_eip[2] = memory[eip+2];
  assign around_eip[3] = memory[eip+3];
  assign around_eip[4] = memory[eip+4];
  assign around_eip[5] = memory[eip+5];

  make_modrm make_modrm_0(
    around_eip,
    eax, ecx, edx, ebx, esp, ebp, esi, edi,
    imm8, imm32, modrm_imm8, modrm_imm32,
    mod, r, m, r_reg, m_reg,
    m_reg_plus_imm8, m_reg_plus_imm32
  );

  // [M+imm]系
  logic [31:0] memval_m_reg;
  logic [31:0] memval_m_reg_plus_imm8;
  logic [31:0] memval_m_reg_plus_imm32;
  assign memval_m_reg            = {memory[m_reg           +3], memory[m_reg           +2], memory[m_reg           +1], memory[m_reg           ]};
  assign memval_m_reg_plus_imm8  = {memory[m_reg_plus_imm8 +3], memory[m_reg_plus_imm8 +2], memory[m_reg_plus_imm8 +1], memory[m_reg_plus_imm8 ]};
  assign memval_m_reg_plus_imm32 = {memory[m_reg_plus_imm32+3], memory[m_reg_plus_imm32+2], memory[m_reg_plus_imm32+1], memory[m_reg_plus_imm32]};/*}}}*/
  // スタック関連のワイヤを作成/*{{{*/
  logic  [31:0] stack_value;
  assign stack_value     = {memory[esp+3], memory[esp+2], memory[esp+1], memory[esp]};
  logic  [31:0] ebp_leave_value ;
  assign ebp_leave_value = {memory[ebp+3], memory[ebp+2], memory[ebp+1], memory[ebp]};
  /*}}}*/

  // フリップフロップを更新/*{{{*/
  always @(posedge CLOCK) begin
    case(RESET)
      // リセットOFFで通常更新
      1'b0: begin
        // メモリの更新/*{{{*/
        case(write_flag)
          1'b1: begin
            memory[write_addr  ] <= write_value[ 7: 0];
            memory[write_addr+1] <= write_value[15: 8];
            memory[write_addr+2] <= write_value[23:16];
            memory[write_addr+3] <= write_value[31:24];
            // $display("muji        addr:%h mem:%h %h %h %h" ,             write_addr, memory[write_addr], memory[write_addr+1], memory[write_addr+2], memory[write_addr+3]);
            // $display("next flag:%b addr:%h mem:%h %h %h %h", write_flag, write_addr, write_value[ 7: 0], write_value[15: 8], write_value[23:16], write_value[31:24]);
          end
          default:;
        endcase/*}}}*/
        // レジスタの更新/*{{{*/
        OUT <= next_eax[15:0];
        eax <= next_eax;
        ecx <= next_ecx;
        edx <= next_edx;
        ebx <= next_ebx;
        esp <= next_esp;
        ebp <= next_ebp;
        esi <= next_esi;
        edi <= next_edi;
        eip <= next_eip;
        cf  <= next_cf;
        zf  <= next_zf;
        sf  <= next_sf;
        of  <= next_of;
        // $display("muji eip:%h eax:%h ecx:%h edx:%h ebx:%h esp:%h ebp:%h esi:%h edi:%h",      eip,      eax,      ecx,      edx,      ebx,      esp,      ebp,      esi,      edi);
        // $display("next eip:%h eax:%h ecx:%h edx:%h ebx:%h esp:%h ebp:%h esi:%h edi:%h", next_eip, next_eax, next_ecx, next_edx, next_ebx, next_esp, next_ebp, next_esi, next_edi);/*}}}*/
      end

      // リセットONの場合
      1'b1: begin $display("RESET ON");
        // メモリの初期化/*{{{*/
        memory[ 0] <= 8'heb;
        memory[ 1] <= 8'h00;
        memory[ 2] <= 8'h55;
        memory[ 3] <= 8'h89;
        memory[ 4] <= 8'he5;
        memory[ 5] <= 8'h83;
        memory[ 6] <= 8'hec;
        memory[ 7] <= 8'h10;
        memory[ 8] <= 8'hb8;
        memory[ 9] <= 8'h0a;
        memory[10] <= 8'h00;
        memory[11] <= 8'h00;
        memory[12] <= 8'h00;
        memory[13] <= 8'h50;
        memory[14] <= 8'he8;
        memory[15] <= 8'h0f;
        memory[16] <= 8'h00;
        memory[17] <= 8'h00;
        memory[18] <= 8'h00;
        memory[19] <= 8'h5a;
        memory[20] <= 8'h50;
        memory[21] <= 8'h89;
        memory[22] <= 8'h45;
        memory[23] <= 8'hfc;
        memory[24] <= 8'h8b;
        memory[25] <= 8'h45;
        memory[26] <= 8'hfc;
        memory[27] <= 8'h50;
        memory[28] <= 8'h58;
        memory[29] <= 8'he9;
        memory[30] <= 8'hc0;
        memory[31] <= 8'h00;
        memory[32] <= 8'h00;
        memory[33] <= 8'h00;
        memory[34] <= 8'h55;
        memory[35] <= 8'h89;
        memory[36] <= 8'he5;
        memory[37] <= 8'h83;
        memory[38] <= 8'hec;
        memory[39] <= 8'h10;
        memory[40] <= 8'h8b;
        memory[41] <= 8'h45;
        memory[42] <= 8'h08;
        memory[43] <= 8'h50;
        memory[44] <= 8'hb8;
        memory[45] <= 8'h02;
        memory[46] <= 8'h00;
        memory[47] <= 8'h00;
        memory[48] <= 8'h00;
        memory[49] <= 8'h50;
        memory[50] <= 8'h5a;
        memory[51] <= 8'h58;
        memory[52] <= 8'h39;
        memory[53] <= 8'hd0;
        memory[54] <= 8'h7f;
        memory[55] <= 8'h07;
        memory[56] <= 8'hb8;
        memory[57] <= 8'h00;
        memory[58] <= 8'h00;
        memory[59] <= 8'h00;
        memory[60] <= 8'h00;
        memory[61] <= 8'heb;
        memory[62] <= 8'h05;
        memory[63] <= 8'hb8;
        memory[64] <= 8'h01;
        memory[65] <= 8'h00;
        memory[66] <= 8'h00;
        memory[67] <= 8'h00;
        memory[68] <= 8'h50;
        memory[69] <= 8'h58;
        memory[70] <= 8'h83;
        memory[71] <= 8'hf8;
        memory[72] <= 8'h00;
        memory[73] <= 8'h74;
        memory[74] <= 8'h36;
        memory[75] <= 8'h8b;
        memory[76] <= 8'h45;
        memory[77] <= 8'h08;
        memory[78] <= 8'h50;
        memory[79] <= 8'hb8;
        memory[80] <= 8'h02;
        memory[81] <= 8'h00;
        memory[82] <= 8'h00;
        memory[83] <= 8'h00;
        memory[84] <= 8'h50;
        memory[85] <= 8'h5a;
        memory[86] <= 8'h58;
        memory[87] <= 8'h29;
        memory[88] <= 8'hd0;
        memory[89] <= 8'h50;
        memory[90] <= 8'he8;
        memory[91] <= 8'hc3;
        memory[92] <= 8'hff;
        memory[93] <= 8'hff;
        memory[94] <= 8'hff;
        memory[95] <= 8'h5a;
        memory[96] <= 8'h50;
        memory[97] <= 8'h8b;
        memory[98] <= 8'h45;
        memory[99] <= 8'h08;
        memory[100] <= 8'h50;
        memory[101] <= 8'hb8;
        memory[102] <= 8'h01;
        memory[103] <= 8'h00;
        memory[104] <= 8'h00;
        memory[105] <= 8'h00;
        memory[106] <= 8'h50;
        memory[107] <= 8'h5a;
        memory[108] <= 8'h58;
        memory[109] <= 8'h29;
        memory[110] <= 8'hd0;
        memory[111] <= 8'h50;
        memory[112] <= 8'he8;
        memory[113] <= 8'had;
        memory[114] <= 8'hff;
        memory[115] <= 8'hff;
        memory[116] <= 8'hff;
        memory[117] <= 8'h5a;
        memory[118] <= 8'h50;
        memory[119] <= 8'h5a;
        memory[120] <= 8'h58;
        memory[121] <= 8'h01;
        memory[122] <= 8'hd0;
        memory[123] <= 8'h50;
        memory[124] <= 8'h89;
        memory[125] <= 8'h45;
        memory[126] <= 8'hfc;
        memory[127] <= 8'heb;
        memory[128] <= 8'h5a;
        memory[129] <= 8'h8b;
        memory[130] <= 8'h45;
        memory[131] <= 8'h08;
        memory[132] <= 8'h50;
        memory[133] <= 8'hb8;
        memory[134] <= 8'h02;
        memory[135] <= 8'h00;
        memory[136] <= 8'h00;
        memory[137] <= 8'h00;
        memory[138] <= 8'h50;
        memory[139] <= 8'h5a;
        memory[140] <= 8'h58;
        memory[141] <= 8'h39;
        memory[142] <= 8'hd0;
        memory[143] <= 8'h74;
        memory[144] <= 8'h07;
        memory[145] <= 8'hb8;
        memory[146] <= 8'h00;
        memory[147] <= 8'h00;
        memory[148] <= 8'h00;
        memory[149] <= 8'h00;
        memory[150] <= 8'heb;
        memory[151] <= 8'h05;
        memory[152] <= 8'hb8;
        memory[153] <= 8'h01;
        memory[154] <= 8'h00;
        memory[155] <= 8'h00;
        memory[156] <= 8'h00;
        memory[157] <= 8'h50;
        memory[158] <= 8'h58;
        memory[159] <= 8'h83;
        memory[160] <= 8'hf8;
        memory[161] <= 8'h00;
        memory[162] <= 8'h74;
        memory[163] <= 8'h0b;
        memory[164] <= 8'hb8;
        memory[165] <= 8'h01;
        memory[166] <= 8'h00;
        memory[167] <= 8'h00;
        memory[168] <= 8'h00;
        memory[169] <= 8'h50;
        memory[170] <= 8'h89;
        memory[171] <= 8'h45;
        memory[172] <= 8'hfc;
        memory[173] <= 8'heb;
        memory[174] <= 8'h2c;
        memory[175] <= 8'h8b;
        memory[176] <= 8'h45;
        memory[177] <= 8'h08;
        memory[178] <= 8'h50;
        memory[179] <= 8'hb8;
        memory[180] <= 8'h01;
        memory[181] <= 8'h00;
        memory[182] <= 8'h00;
        memory[183] <= 8'h00;
        memory[184] <= 8'h50;
        memory[185] <= 8'h5a;
        memory[186] <= 8'h58;
        memory[187] <= 8'h39;
        memory[188] <= 8'hd0;
        memory[189] <= 8'h74;
        memory[190] <= 8'h07;
        memory[191] <= 8'hb8;
        memory[192] <= 8'h00;
        memory[193] <= 8'h00;
        memory[194] <= 8'h00;
        memory[195] <= 8'h00;
        memory[196] <= 8'heb;
        memory[197] <= 8'h05;
        memory[198] <= 8'hb8;
        memory[199] <= 8'h01;
        memory[200] <= 8'h00;
        memory[201] <= 8'h00;
        memory[202] <= 8'h00;
        memory[203] <= 8'h50;
        memory[204] <= 8'h58;
        memory[205] <= 8'h83;
        memory[206] <= 8'hf8;
        memory[207] <= 8'h00;
        memory[208] <= 8'h74;
        memory[209] <= 8'h09;
        memory[210] <= 8'hb8;
        memory[211] <= 8'h01;
        memory[212] <= 8'h00;
        memory[213] <= 8'h00;
        memory[214] <= 8'h00;
        memory[215] <= 8'h50;
        memory[216] <= 8'h89;
        memory[217] <= 8'h45;
        memory[218] <= 8'hfc;
        memory[219] <= 8'h8b;
        memory[220] <= 8'h45;
        memory[221] <= 8'hfc;
        memory[222] <= 8'h50;
        memory[223] <= 8'h58;
        memory[224] <= 8'hc9;
        memory[225] <= 8'hc3;
        memory[226] <= 8'hf4;
        /*}}}*/
        // レジスタの初期化/*{{{*/
        OUT <= 16'hffff;
        eax <= 32'h00000000;
        ecx <= 32'h00000000;
        edx <= 32'h00000000;
        ebx <= 32'h00000000;
        esp <= `MEMSIZE;
        ebp <= 32'h00000000;
        esi <= 32'h00000000;
        edi <= 32'h00000000;
        eip <= 32'h00000000;
        cf  <= 1'b0;
        zf  <= 1'b0;
        sf  <= 1'b0;
        of  <= 1'b0;/*}}}*/
      end

      default: $display("Undefined Reset Button");
    endcase
  end/*}}}*/
  // ワイヤを更新/*{{{*/
  make_next_reg make_next_reg_0(
    write_flag, write_addr, write_value
    , opecode
    , imm8, imm32, modrm_imm8, modrm_imm32
    , mod, r, m, r_reg, m_reg
    , m_reg_plus_imm8, m_reg_plus_imm32
    , memval_m_reg, memval_m_reg_plus_imm8, memval_m_reg_plus_imm32
    , stack_value, ebp_leave_value
    ,      eax,      ecx,      edx,      ebx,      esp,      ebp,      esi,      edi,      eip,      cf,      zf,      sf,      of
    , next_eax, next_ecx, next_edx, next_ebx, next_esp, next_ebp, next_esi, next_edi, next_eip, next_cf, next_zf, next_sf, next_of
  );/*}}}*/
endmodule
