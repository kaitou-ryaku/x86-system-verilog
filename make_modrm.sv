module make_modrm (
  input    reg  [ 7:0] memory_eip [6:0]
  , input  reg  [31:0] eax
  , input  reg  [31:0] ecx
  , input  reg  [31:0] edx
  , input  reg  [31:0] ebx
  , input  reg  [31:0] esp
  , input  reg  [31:0] ebp
  , input  reg  [31:0] esi
  , input  reg  [31:0] edi

  , output wire [31:0] imm8
  , output wire [31:0] imm32
  , output wire [31:0] modrm_imm8
  , output wire [31:0] modrm_imm32
  , output wire [ 1:0] mod
  , output wire [ 2:0] r
  , output wire [ 2:0] m
  , output wire [31:0] r_reg
  , output wire [31:0] m_reg
  , output wire [31:0] m_reg_plus_imm8  // M+imm8
  , output wire [31:0] m_reg_plus_imm32 // M+imm32
);

  logic  [7:0] modrm;
  assign modrm = memory_eip[1];
  assign mod = modrm[7:6];
  assign r   = modrm[5:3];
  assign m   = modrm[2:0];

  assign imm8       [ 7:0] = memory_eip[1];
  assign modrm_imm8 [ 7:0] = memory_eip[2];
  assign imm8       [31:8] = imm8       [7] ? 24'hffffff : 24'h000000;
  assign modrm_imm8 [31:8] = modrm_imm8 [7] ? 24'hffffff : 24'h000000;

  assign imm32      [31:0] = {memory_eip[4], memory_eip[3], memory_eip[2], memory_eip[1]};
  assign modrm_imm32[31:0] = {memory_eip[5], memory_eip[4], memory_eip[3], memory_eip[2]};

  logic [31:0] end_r_reg;
  logic [31:0] end_m_reg;
  assign r_reg = end_r_reg;
  assign m_reg = end_m_reg;

  // M+imm系
  logic [31:0] end_m_reg_plus_imm8;
  logic [31:0] end_m_reg_plus_imm32;
  assign m_reg_plus_imm8  = end_m_reg_plus_imm8;
  assign m_reg_plus_imm32 = end_m_reg_plus_imm32;

  always_comb begin
    case(r)
      3'b000: end_r_reg = eax;
      3'b001: end_r_reg = ecx;
      3'b010: end_r_reg = edx;
      3'b011: end_r_reg = ebx;
      3'b100: end_r_reg = esp;
      3'b101: end_r_reg = ebp;
      3'b110: end_r_reg = esi;
      3'b111: end_r_reg = edi;
    endcase

    case(m)
      3'b000: end_m_reg = eax;
      3'b001: end_m_reg = ecx;
      3'b010: end_m_reg = edx;
      3'b011: end_m_reg = ebx;
      3'b100: end_m_reg = esp;
      3'b101: end_m_reg = ebp;
      3'b110: end_m_reg = esi;
      3'b111: end_m_reg = edi;
    endcase

    end_m_reg_plus_imm8  = m_reg + modrm_imm8;
    end_m_reg_plus_imm32 = m_reg + modrm_imm32;
  end

endmodule
