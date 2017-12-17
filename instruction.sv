// add [M+imm], R
module inst_01_add_M_imm_R( //  add [M+imm], R ; 01 (mod R M) imm /*{{{*/
  input    wire [ 1:0] mod
  , input  wire [ 2:0] m
  , input  wire [31:0] r_reg
  , input  wire [31:0] m_reg
  , input  wire [31:0] m_reg_plus_imm8
  , input  wire [31:0] m_reg_plus_imm32
  , input  wire [31:0] memval_m_reg
  , input  wire [31:0] memval_m_reg_plus_imm8
  , input  wire [31:0] memval_m_reg_plus_imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  logic        e_write_flag;
  logic [31:0] e_write_addr;
  logic [31:0] e_write_value;

  logic [31:0] e_eax;
  logic [31:0] e_ecx;
  logic [31:0] e_edx;
  logic [31:0] e_ebx;
  logic [31:0] e_esp;
  logic [31:0] e_ebp;
  logic [31:0] e_esi;
  logic [31:0] e_edi;
  logic [31:0] e_eip;
  logic        e_cf;
  logic        e_zf;
  logic        e_sf;
  logic        e_of;

  assign next_write_flag  = e_write_flag;
  assign next_write_addr  = e_write_addr;
  assign next_write_value = e_write_value;

  assign next_eax         = e_eax;
  assign next_ecx         = e_ecx;
  assign next_edx         = e_edx;
  assign next_ebx         = e_ebx;
  assign next_esp         = e_esp;
  assign next_ebp         = e_ebp;
  assign next_esi         = e_esi;
  assign next_edi         = e_edi;
  assign next_eip         = e_eip;
  assign next_cf          = e_cf;
  assign next_zf          = e_zf;
  assign next_sf          = e_sf;
  assign next_of          = e_of;

  always_comb begin
    case(mod[1:0])
      2'b00: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg;
        e_write_value = memval_m_reg + r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+2;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b01: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg_plus_imm8;
        e_write_value = memval_m_reg_plus_imm8 + r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+3;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b10: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg_plus_imm32;
        e_write_value = memval_m_reg_plus_imm32 + r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+6;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b11: begin/*{{{*/
        e_write_flag  = 0;
        e_write_addr  = 0;
        e_write_value = 0;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
        e_eip         = eip+2;
        case (m[2:0])
          3'b000: begin e_eax = m_reg+r_reg;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b001: begin e_ecx = m_reg+r_reg;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b010: begin e_edx = m_reg+r_reg;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b011: begin e_ebx = m_reg+r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b100: begin e_esp = m_reg+r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b101: begin e_ebp = m_reg+r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
          3'b110: begin e_esi = m_reg+r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
          3'b111: begin e_edi = m_reg+r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
        endcase
      end/*}}}*/
    endcase
  end
endmodule/*}}}*/

// jcc imm32
module inst_0f_jcc_imm32(   //  jcc imm32; 0f imm32 /*{{{*/
  input    wire [31:0] imm8
  , input  wire [31:0] modrm_imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;

  logic [31:0] e_eip;
  assign next_eip = e_eip;

  logic [31:0] no_jump;
  assign no_jump = eip + 6;

  logic [31:0] jump;
  assign jump = eip + 6 + modrm_imm32;

  always_comb begin
    case(imm8)
      8'h80: e_eip = (of == 1)  ? jump : no_jump;
      8'h81: e_eip = (of == 0)  ? jump : no_jump;

      8'h82: e_eip = (cf == 1) ? jump : no_jump;
      8'h83: e_eip = (cf == 0) ? jump : no_jump;

      8'h84: e_eip = (zf == 1)  ? jump : no_jump;
      8'h85: e_eip = (zf == 0)  ? jump : no_jump;

      8'h86: e_eip = ((cf == 1) | (zf == 1)) ? jump : no_jump;
      8'h87: e_eip = ((cf == 0) & (zf == 0)) ? jump : no_jump;

      8'h88: e_eip = (sf == 1)  ? jump : no_jump;
      8'h89: e_eip = (sf == 0)  ? jump : no_jump;
      8'h8c: e_eip = (sf != of) ? jump : no_jump;
      8'h8d: e_eip = (sf == of) ? jump : no_jump;
      8'h8e: e_eip = ((zf == 1) | (sf != of)) ? jump : no_jump;
      8'h8f: e_eip = ((zf != 1) & (sf == of)) ? jump : no_jump;
      default: e_eip = no_jump;
    endcase
  end

endmodule/*}}}*/

// sub [M+imm], R
module inst_29_sub_M_imm_R( //  sub [M+imm], R ; 29 (mod R M) imm /*{{{*/
  input    wire [ 1:0] mod
  , input  wire [ 2:0] m
  , input  wire [31:0] r_reg
  , input  wire [31:0] m_reg
  , input  wire [31:0] m_reg_plus_imm8
  , input  wire [31:0] m_reg_plus_imm32
  , input  wire [31:0] memval_m_reg
  , input  wire [31:0] memval_m_reg_plus_imm8
  , input  wire [31:0] memval_m_reg_plus_imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  logic        e_write_flag;
  logic [31:0] e_write_addr;
  logic [31:0] e_write_value;

  logic [31:0] e_eax;
  logic [31:0] e_ecx;
  logic [31:0] e_edx;
  logic [31:0] e_ebx;
  logic [31:0] e_esp;
  logic [31:0] e_ebp;
  logic [31:0] e_esi;
  logic [31:0] e_edi;
  logic [31:0] e_eip;
  logic        e_cf;
  logic        e_zf;
  logic        e_sf;
  logic        e_of;

  assign next_write_flag  = e_write_flag;
  assign next_write_addr  = e_write_addr;
  assign next_write_value = e_write_value;

  assign next_eax         = e_eax;
  assign next_ecx         = e_ecx;
  assign next_edx         = e_edx;
  assign next_ebx         = e_ebx;
  assign next_esp         = e_esp;
  assign next_ebp         = e_ebp;
  assign next_esi         = e_esi;
  assign next_edi         = e_edi;
  assign next_eip         = e_eip;
  assign next_cf          = e_cf;
  assign next_zf          = e_zf;
  assign next_sf          = e_sf;
  assign next_of          = e_of;

  always_comb begin
    case(mod[1:0])
      2'b00: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg;
        e_write_value = memval_m_reg - r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+2;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b01: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg_plus_imm8;
        e_write_value = memval_m_reg_plus_imm8 - r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+3;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b10: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg_plus_imm32;
        e_write_value = memval_m_reg_plus_imm32 - r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+6;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b11: begin/*{{{*/
        e_write_flag  = 0;
        e_write_addr  = 0;
        e_write_value = 0;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
        e_eip         = eip+2;
        case (m[2:0])
          3'b000: begin e_eax = m_reg-r_reg;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b001: begin e_ecx = m_reg-r_reg;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b010: begin e_edx = m_reg-r_reg;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b011: begin e_ebx = m_reg-r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b100: begin e_esp = m_reg-r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b101: begin e_ebp = m_reg-r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
          3'b110: begin e_esi = m_reg-r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
          3'b111: begin e_edi = m_reg-r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
        endcase
      end/*}}}*/
    endcase
  end
endmodule/*}}}*/

// cmp [M+imm], R
module inst_39_cmp_M_imm_R( //  cmp [M+imm], R ; 39 (mod R M) imm /*{{{*/
  input    wire [ 1:0] mod
  , input  wire [ 2:0] m
  , input  wire [31:0] r_reg
  , input  wire [31:0] m_reg
  , input  wire [31:0] m_reg_plus_imm8
  , input  wire [31:0] m_reg_plus_imm32
  , input  wire [31:0] memval_m_reg
  , input  wire [31:0] memval_m_reg_plus_imm8
  , input  wire [31:0] memval_m_reg_plus_imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  logic [31:0] e_eip;
  logic e_cf;
  logic e_zf;
  logic e_sf;
  logic e_of;

  assign next_write_flag    = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;

  assign next_eip         = e_eip;
  assign next_cf          = e_cf;
  assign next_zf          = e_zf;
  assign next_sf          = e_sf;
  assign next_of          = e_of;

  // キャリーフラグ等計算用のワイヤーを宣言
  logic [31:0] flag_calc_32;
  logic [32:0] flag_calc_33;

  always_comb begin
    case(mod[1:0])
      2'b00: begin/*{{{*/
        flag_calc_32 = memval_m_reg - r_reg;
        flag_calc_33 = {memval_m_reg, 1'b0} + {(-r_reg), 1'b0};

        e_cf = flag_calc_33[32];
        e_zf = (flag_calc_32 == 0) ? 1'b1 : 1'b0;
        e_sf = flag_calc_32[31];
        e_of = (memval_m_reg[31] != r_reg[31]) & (memval_m_reg[31] != flag_calc_32[31]);
        e_eip = eip + 2;
      end/*}}}*/
      2'b01: begin/*{{{*/
        flag_calc_32 = memval_m_reg_plus_imm8 - r_reg;
        flag_calc_33 = {memval_m_reg_plus_imm8, 1'b0} + {(-r_reg), 1'b0};

        e_cf = flag_calc_33[32];
        e_zf = (flag_calc_32 == 0) ? 1'b1 : 1'b0;
        e_sf = flag_calc_32[31];
        e_of = (memval_m_reg_plus_imm8[31] != r_reg[31]) & (memval_m_reg_plus_imm8[31] != flag_calc_32[31]);
        e_eip = eip + 3;
      end/*}}}*/
      2'b10: begin/*{{{*/
        flag_calc_32 = memval_m_reg_plus_imm32 - r_reg;
        flag_calc_33 = {memval_m_reg_plus_imm32, 1'b0} + {(-r_reg), 1'b0};

        e_cf = flag_calc_33[32];
        e_zf = (flag_calc_32 == 0) ? 1'b1 : 1'b0;
        e_sf = flag_calc_32[31];
        e_of = (memval_m_reg_plus_imm32[31] != r_reg[31]) & (memval_m_reg_plus_imm32[31] != flag_calc_32[31]);
        e_eip = eip + 6;
      end/*}}}*/
      2'b11: begin/*{{{*/
        flag_calc_32 = m_reg - r_reg;
        flag_calc_33 = {m_reg, 1'b0} + {(-r_reg), 1'b0};

        e_cf = flag_calc_33[32];
        e_zf = (flag_calc_32 == 0) ? 1'b1 : 1'b0;
        e_sf = flag_calc_32[31];
        e_of = (m_reg[31] != r_reg[31]) & (m_reg[31] != flag_calc_32[31]);
        e_eip = eip + 2;
      end/*}}}*/
    endcase
  end
endmodule/*}}}*/

// push exx
module inst_50_push_eax( //  push eax; 50 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = eax;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_51_push_ecx( //  push ecx; 51 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = ecx;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_52_push_edx( //  push edx; 52 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = edx;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_53_push_ebx( //  push ebx; 53 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = ebx;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_54_push_esp( //  push esp; 54 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = esp;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_55_push_ebp( //  push ebp; 55 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = ebp;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_56_push_esi( //  push esi; 56 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = esi;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_57_push_edi( //  push edi; 57 /*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = edi;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/

// pop exx
module inst_58_pop_eax( //  pop eax; 58 /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = stack_value;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_59_pop_ecx( //  pop ecx; 59 /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = stack_value;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_5a_pop_edx( //  pop edx; 5a /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = stack_value;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_5b_pop_ebx( //  pop ebx; 5b /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = stack_value;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_5c_pop_esp( //  pop esp; 5c /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = stack_value;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_5d_pop_ebp( //  pop ebp; 5d /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = stack_value;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_5e_pop_esi( //  pop esi; 5e /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = stack_value;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/
module inst_5f_pop_edi( //  pop edi; 5f /*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = stack_value;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/

// jcc imm8
module inst_70_jo_imm8(  //  jo  imm8; 70 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (of == 1) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_71_jno_imm8( //  jno imm8; 71 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (of == 0) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_72_jb_imm8(  //  jb  imm8; 72 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (cf == 1) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_73_jae_imm8( //  jae imm8; 73 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (cf == 0) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_74_je_imm8(  //  je  imm8; 74 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (zf == 1) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_75_jne_imm8( //  jne imm8; 75 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (zf == 0) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_76_jbe_imm8( //  jbe imm8; 76 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = ((cf == 1) | (zf == 1)) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_77_ja_imm8(  //  ja  imm8; 77 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = ((cf == 0) & (zf == 0)) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_78_js_imm8(  //  js  imm8; 78 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (sf == 1) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_79_jns_imm8( //  jns imm8; 79 imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (sf == 0) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_7c_jl_imm8(  //  jl  imm8; 7c imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (sf != of) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_7d_jge_imm8( //  jge imm8; 7d imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = (sf == of) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_7e_jle_imm8( //  jle imm8; 7e imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = ((zf == 1) | (sf != of)) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/
module inst_7f_jg_imm8(  //  jg  imm8; 7f imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip = ((zf != 1) & (sf == of)) ? (eip + 2) + imm8 : (eip + 2);
endmodule/*}}}*/

// calc(R) M, imm8
module inst_83_calcR_M_imm8( // calc(R) M, imm8; 83 (11 R M) imm8 /*{{{*/
  input    wire [ 1:0] mod
  , input  wire [ 2:0] r
  , input  wire [ 2:0] m
  , input  wire [31:0] m_reg
  , input  wire [31:0] modrm_imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag    = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  logic [31:0] e_eax;
  logic [31:0] e_ecx;
  logic [31:0] e_edx;
  logic [31:0] e_ebx;
  logic [31:0] e_esp;
  logic [31:0] e_ebp;
  logic [31:0] e_esi;
  logic [31:0] e_edi;
  logic [31:0] e_eip;
  logic        e_cf;
  logic        e_zf;
  logic        e_sf;
  logic        e_of;

  assign next_eax = e_eax;
  assign next_ecx = e_ecx;
  assign next_edx = e_edx;
  assign next_ebx = e_ebx;
  assign next_esp = e_esp;
  assign next_ebp = e_ebp;
  assign next_esi = e_esi;
  assign next_edi = e_edi;
  assign next_eip = e_eip;
  assign next_cf  = e_cf;
  assign next_zf  = e_zf;
  assign next_sf  = e_sf;
  assign next_of  = e_of;

  // キャリーフラグ等計算用のワイヤーを宣言
  logic [31:0] flag_calc_32;
  logic [32:0] flag_calc_33;

  always_comb begin
    case(mod)
      2'b11: begin
        case(r)
          3'b000: begin/*{{{*/
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
            e_eip         = eip+3;
            case (m[2:0])
              3'b000: begin e_eax = m_reg + modrm_imm8;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b001: begin e_ecx = m_reg + modrm_imm8;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b010: begin e_edx = m_reg + modrm_imm8;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b011: begin e_ebx = m_reg + modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b100: begin e_esp = m_reg + modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b101: begin e_ebp = m_reg + modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
              3'b110: begin e_esi = m_reg + modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
              3'b111: begin e_edi = m_reg + modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
            endcase
          end/*}}}*/
          3'b101: begin/*{{{*/
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
            e_eip         = eip+3;
            case (m[2:0])
              3'b000: begin e_eax = m_reg - modrm_imm8;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b001: begin e_ecx = m_reg - modrm_imm8;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b010: begin e_edx = m_reg - modrm_imm8;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b011: begin e_ebx = m_reg - modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b100: begin e_esp = m_reg - modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b101: begin e_ebp = m_reg - modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
              3'b110: begin e_esi = m_reg - modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
              3'b111: begin e_edi = m_reg - modrm_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
            endcase
          end/*}}}*/
          3'b111: begin/*{{{*/
            e_eax         = eax;
            e_ecx         = ecx;
            e_edx         = edx;
            e_ebx         = ebx;
            e_esp         = esp;
            e_ebp         = ebp;
            e_esi         = esi;
            e_edi         = edi;
            e_eip         = eip+3;

            flag_calc_32 = m_reg - modrm_imm8;
            flag_calc_33 = {m_reg, 1'b0} + {(-modrm_imm8), 1'b0};

            e_cf = flag_calc_33[32];
            e_zf = (flag_calc_32 == 0) ? 1'b1 : 1'b0;
            e_sf = flag_calc_32[31];
            e_of = (m_reg[31] != modrm_imm8[31]) & (m_reg[31] != flag_calc_32[31]);
          end/*}}}*/
          default: begin/*{{{*/
            e_eax         = eax;
            e_ecx         = ecx;
            e_edx         = edx;
            e_ebx         = ebx;
            e_esp         = esp;
            e_ebp         = ebp;
            e_esi         = esi;
            e_edi         = edi;
            e_eip         = eip;
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
          end/*}}}*/
        endcase
      end
      default: begin/*{{{*/
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
    endcase
  end
endmodule/*}}}*/

// mov [M+imm], R
module inst_89_mov_M_imm_R( //  mov [M+imm], R ; 89 (mod R M) imm /*{{{*/
  input    wire [ 1:0] mod
  , input  wire [ 2:0] m
  , input  wire [31:0] r_reg
  , input  wire [31:0] m_reg
  , input  wire [31:0] m_reg_plus_imm8
  , input  wire [31:0] m_reg_plus_imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  logic        e_write_flag;
  logic [31:0] e_write_addr;
  logic [31:0] e_write_value;

  logic [31:0] e_eax;
  logic [31:0] e_ecx;
  logic [31:0] e_edx;
  logic [31:0] e_ebx;
  logic [31:0] e_esp;
  logic [31:0] e_ebp;
  logic [31:0] e_esi;
  logic [31:0] e_edi;
  logic [31:0] e_eip;
  logic        e_cf;
  logic        e_zf;
  logic        e_sf;
  logic        e_of;

  assign next_write_flag  = e_write_flag;
  assign next_write_addr  = e_write_addr;
  assign next_write_value = e_write_value;

  assign next_eax         = e_eax;
  assign next_ecx         = e_ecx;
  assign next_edx         = e_edx;
  assign next_ebx         = e_ebx;
  assign next_esp         = e_esp;
  assign next_ebp         = e_ebp;
  assign next_esi         = e_esi;
  assign next_edi         = e_edi;
  assign next_eip         = e_eip;
  assign next_cf          = e_cf;
  assign next_zf          = e_zf;
  assign next_sf          = e_sf;
  assign next_of          = e_of;

  always_comb begin
    case(mod[1:0])
      2'b00: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg;
        e_write_value = r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+2;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b01: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg_plus_imm8;
        e_write_value = r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+3;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b10: begin/*{{{*/
        e_write_flag  = 1;
        e_write_addr  = m_reg_plus_imm32;
        e_write_value = r_reg;
        e_eax         = eax;
        e_ecx         = ecx;
        e_edx         = edx;
        e_ebx         = ebx;
        e_esp         = esp;
        e_ebp         = ebp;
        e_esi         = esi;
        e_edi         = edi;
        e_eip         = eip+6;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
      end/*}}}*/
      2'b11: begin/*{{{*/
        e_write_flag  = 0;
        e_write_addr  = 0;
        e_write_value = 0;
        e_cf          = cf;
        e_zf          = zf;
        e_sf          = sf;
        e_of          = of;
        e_eip         = eip+2;
        case (m[2:0])
          3'b000: begin e_eax = r_reg;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b001: begin e_ecx = r_reg;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b010: begin e_edx = r_reg;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b011: begin e_ebx = r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b100: begin e_esp = r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
          3'b101: begin e_ebp = r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
          3'b110: begin e_esi = r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
          3'b111: begin e_edi = r_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
        endcase
      end/*}}}*/
    endcase
  end
endmodule/*}}}*/

// mov R, [M+imm]
module inst_8b_mov_R_M_imm( //  mov R, [M+imm] ; 8b (mod R M) imm /*{{{*/
  input    wire [ 1:0] mod
  , input  wire [ 2:0] r
  , input  wire [31:0] r_reg
  , input  wire [31:0] m_reg
  , input  wire [31:0] memval_m_reg
  , input  wire [31:0] memval_m_reg_plus_imm8
  , input  wire [31:0] memval_m_reg_plus_imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  logic        e_write_flag;
  logic [31:0] e_write_addr;
  logic [31:0] e_write_value;

  logic [31:0] e_eax;
  logic [31:0] e_ecx;
  logic [31:0] e_edx;
  logic [31:0] e_ebx;
  logic [31:0] e_esp;
  logic [31:0] e_ebp;
  logic [31:0] e_esi;
  logic [31:0] e_edi;
  logic [31:0] e_eip;
  logic        e_cf;
  logic        e_zf;
  logic        e_sf;
  logic        e_of;

  assign next_write_flag  = e_write_flag;
  assign next_write_addr  = e_write_addr;
  assign next_write_value = e_write_value;

  assign next_eax         = e_eax;
  assign next_ecx         = e_ecx;
  assign next_edx         = e_edx;
  assign next_ebx         = e_ebx;
  assign next_esp         = e_esp;
  assign next_ebp         = e_ebp;
  assign next_esi         = e_esi;
  assign next_edi         = e_edi;
  assign next_eip         = e_eip;
  assign next_cf          = e_cf;
  assign next_zf          = e_zf;
  assign next_sf          = e_sf;
  assign next_of          = e_of;

  always_comb begin
    case(mod[1:0])
          2'b00: begin/*{{{*/
            e_write_flag  = 0;
            e_write_addr  = 0;
            e_write_value = 0;
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
            e_eip         = eip+2;
            case (r[2:0])
              3'b000: begin e_eax = memval_m_reg;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b001: begin e_ecx = memval_m_reg;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b010: begin e_edx = memval_m_reg;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b011: begin e_ebx = memval_m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b100: begin e_esp = memval_m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b101: begin e_ebp = memval_m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
              3'b110: begin e_esi = memval_m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
              3'b111: begin e_edi = memval_m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
            endcase
          end/*}}}*/
          2'b01: begin/*{{{*/
            e_write_flag  = 0;
            e_write_addr  = 0;
            e_write_value = 0;
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
            e_eip         = eip+3;
            case (r[2:0])
              3'b000: begin e_eax = memval_m_reg_plus_imm8;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b001: begin e_ecx = memval_m_reg_plus_imm8;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b010: begin e_edx = memval_m_reg_plus_imm8;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b011: begin e_ebx = memval_m_reg_plus_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b100: begin e_esp = memval_m_reg_plus_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b101: begin e_ebp = memval_m_reg_plus_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
              3'b110: begin e_esi = memval_m_reg_plus_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
              3'b111: begin e_edi = memval_m_reg_plus_imm8;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
            endcase
          end/*}}}*/
          2'b10: begin/*{{{*/
            e_write_flag  = 0;
            e_write_addr  = 0;
            e_write_value = 0;
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
            e_eip         = eip+6;
            case (r[2:0])
              3'b000: begin e_eax = memval_m_reg_plus_imm32;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b001: begin e_ecx = memval_m_reg_plus_imm32;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b010: begin e_edx = memval_m_reg_plus_imm32;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b011: begin e_ebx = memval_m_reg_plus_imm32;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b100: begin e_esp = memval_m_reg_plus_imm32;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b101: begin e_ebp = memval_m_reg_plus_imm32;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
              3'b110: begin e_esi = memval_m_reg_plus_imm32;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
              3'b111: begin e_edi = memval_m_reg_plus_imm32;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
            endcase
          end/*}}}*/
          2'b11: begin/*{{{*/
            e_write_flag  = 0;
            e_write_addr  = 0;
            e_write_value = 0;
            e_cf          = cf;
            e_zf          = zf;
            e_sf          = sf;
            e_of          = of;
            e_eip         = eip+2;
            case (r[2:0])
              3'b000: begin e_eax = m_reg;/*e_eax = eax;*/e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b001: begin e_ecx = m_reg;  e_eax = eax;/*e_ecx = ecx;*/e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b010: begin e_edx = m_reg;  e_eax = eax;  e_ecx = ecx;/*e_edx = edx;*/e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b011: begin e_ebx = m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;/*e_ebx = ebx;*/e_esp = esp;  e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b100: begin e_esp = m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;/*e_esp = esp;*/e_ebp = ebp;  e_esi = esi;  e_edi = edi;  end
              3'b101: begin e_ebp = m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;/*e_ebp = ebp;*/e_esi = esi;  e_edi = edi;  end
              3'b110: begin e_esi = m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;/*e_esi = esi;*/e_edi = edi;  end
              3'b111: begin e_edi = m_reg;  e_eax = eax;  e_ecx = ecx;  e_edx = edx;  e_ebx = ebx;  e_esp = esp;  e_ebp = ebp;  e_esi = esi;/*e_edi = edi;*/end
            endcase
          end/*}}}*/
    endcase
  end
endmodule/*}}}*/

// mov exx, imm
module inst_b8_mov_eax_imm32( //  mov eax, imm32 ; b8 imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = imm32;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_b9_mov_ecx_imm32( //  mov ecx, imm32 ; b9 imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = imm32;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_ba_mov_edx_imm32( //  mov edx, imm32 ; ba imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = imm32;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_bb_mov_ebx_imm32( //  mov ebx, imm32 ; bb imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = imm32;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_bc_mov_esp_imm32( //  mov esp, imm32 ; bc imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = imm32;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_bd_mov_ebp_imm32( //  mov ebp, imm32 ; bd imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = imm32;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_be_mov_esi_imm32( //  mov esi, imm32 ; be imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = imm32;
  assign next_edi         = edi;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
module inst_bf_mov_edi_imm32( //  mov edi, imm32 ; bf imm32 /*{{{*/
  input    reg  [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;
  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = imm32;
  assign next_eip         = eip+5;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/

// ret
module inst_c3_ret(       //  ret; c3/*{{{*/
  input    wire [31:0] stack_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp+4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = stack_value;
endmodule/*}}}*/

// leave
module inst_c9_leave(     //  leave; c9/*{{{*/
  input    wire [31:0] stack_value
  , input  wire [31:0] ebp_leave_value
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = ebp+4;
  assign next_ebp         = ebp_leave_value;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip+1;
endmodule/*}}}*/

// call imm32
module inst_e8_call(      //  call imm32; e8 imm32/*{{{*/
  input    wire [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 1;
  assign next_write_addr  = esp-4;
  assign next_write_value = eip+5; // call命令の一個下のeipを入れる

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp-4;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = (eip+5) + imm32;
endmodule/*}}}*/

// jmp imm32
module inst_e9_jmp_imm32( //  jmp imm32; e9 imm32/*{{{*/
  input    wire [31:0] imm32
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip + 5 + imm32;
endmodule/*}}}*/

// jmp imm8
module inst_eb_jmp_imm8(  //  jmp imm8;  eb imm8 /*{{{*/
  input    wire [31:0] imm8
  , output wire        next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);
  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
  assign next_eip         = eip + 2 + imm8;
endmodule/*}}}*/

// hlt
module inst_f4_hlt(       //  hlt; f4/*{{{*/
  output wire          next_write_flag
  , output wire [31:0] next_write_addr
  , output wire [31:0] next_write_value
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi
  , input  reg  [31:0] eip
  , input  reg         cf
  , input  reg         zf
  , input  reg         sf
  , input  reg         of
  , output wire [31:0] next_eax
  , output wire [31:0] next_ecx
  , output wire [31:0] next_edx
  , output wire [31:0] next_ebx
  , output wire [31:0] next_esp
  , output wire [31:0] next_ebp
  , output wire [31:0] next_esi
  , output wire [31:0] next_edi
  , output wire [31:0] next_eip
  , output wire        next_cf
  , output wire        next_zf
  , output wire        next_sf
  , output wire        next_of
);

  assign next_write_flag  = 0;
  assign next_write_addr  = 0;
  assign next_write_value = 0;

  assign next_eax         = eax;
  assign next_ecx         = ecx;
  assign next_edx         = edx;
  assign next_ebx         = ebx;
  assign next_esp         = esp;
  assign next_ebp         = ebp;
  assign next_esi         = esi;
  assign next_edi         = edi;
  assign next_eip         = eip;
  assign next_cf          = cf;
  assign next_zf          = zf;
  assign next_sf          = sf;
  assign next_of          = of;
endmodule/*}}}*/
