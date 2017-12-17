module make_next_reg(
  output wire          write_flag
  , output wire [31:0] write_addr
  , output wire [31:0] write_value

  , input  wire [ 7:0] opecode
  , input  wire [31:0] imm8
  , input  wire [31:0] imm32
  , input  wire [31:0] modrm_imm8
  , input  wire [31:0] modrm_imm32
  , input  wire [ 1:0] mod
  , input  wire [ 2:0] r
  , input  wire [ 2:0] m
  , input  wire [31:0] r_reg
  , input  wire [31:0] m_reg
  , input  wire [31:0] m_reg_plus_imm8
  , input  wire [31:0] m_reg_plus_imm32
  , input  wire [31:0] memval_m_reg
  , input  wire [31:0] memval_m_reg_plus_imm8
  , input  wire [31:0] memval_m_reg_plus_imm32
  , input  wire [31:0] stack_value
  , input  wire [31:0] ebp_leave_value

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

  // next 更新用の多重ワイヤを宣言/*{{{*/
  logic        end_write_flag[255:0];
  logic [31:0] end_write_addr[255:0];
  logic [31:0] end_write_value[255:0];
  logic [31:0] end_eax [255:0];
  logic [31:0] end_ecx [255:0];
  logic [31:0] end_edx [255:0];
  logic [31:0] end_ebx [255:0];
  logic [31:0] end_esp [255:0];
  logic [31:0] end_ebp [255:0];
  logic [31:0] end_esi [255:0];
  logic [31:0] end_edi [255:0];
  logic [31:0] end_eip [255:0];
  logic        end_cf  [255:0];
  logic        end_zf  [255:0];
  logic        end_sf  [255:0];
  logic        end_of  [255:0];/*}}}*/
  // 多重ワイヤのうち、opecodeに合致するものをnextに繋ぐ/*{{{*/
  assign write_flag  = end_write_flag[opecode];
  assign write_addr  = end_write_addr[opecode];
  assign write_value = end_write_value[opecode];
  assign next_eax    = end_eax[opecode];
  assign next_ecx    = end_ecx[opecode];
  assign next_edx    = end_edx[opecode];
  assign next_ebx    = end_ebx[opecode];
  assign next_esp    = end_esp[opecode];
  assign next_ebp    = end_ebp[opecode];
  assign next_esi    = end_esi[opecode];
  assign next_edi    = end_edi[opecode];
  assign next_eip    = end_eip[opecode];
  assign next_cf     = end_cf[opecode];
  assign next_zf     = end_zf[opecode];
  assign next_sf     = end_sf[opecode];
  assign next_of     = end_of[opecode];/*}}}*/

  // 01    : add [M+imm], R imm/*{{{*/
  inst_01_add_M_imm_R inst_01_add_M_imm_R_0( mod, m, r_reg, m_reg, m_reg_plus_imm8, m_reg_plus_imm32, memval_m_reg, memval_m_reg_plus_imm8, memval_m_reg_plus_imm32
    , end_write_flag[8'h01], end_write_addr[8'h01], end_write_value[8'h01]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h01], end_ecx[8'h01], end_edx[8'h01], end_ebx[8'h01]
    , end_esp[8'h01], end_ebp[8'h01], end_esi[8'h01], end_edi[8'h01]
    , end_eip[8'h01], end_cf[8'h01], end_zf[8'h01], end_sf[8'h01], end_of[8'h01]
  );/*}}}*/
  // 0f    : jcc imm32/*{{{*/
  inst_0f_jcc_imm32 inst_0f_jcc_imm32_0( imm8, modrm_imm32
    , end_write_flag[8'h0f], end_write_addr[8'h0f], end_write_value[8'h0f]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h0f], end_ecx[8'h0f], end_edx[8'h0f], end_ebx[8'h0f]
    , end_esp[8'h0f], end_ebp[8'h0f], end_esi[8'h0f], end_edi[8'h0f]
    , end_eip[8'h0f], end_cf[8'h0f], end_zf[8'h0f], end_sf[8'h0f], end_of[8'h0f]
  );/*}}}*/
  // 29    : sub [M+imm], R imm/*{{{*/
  inst_29_sub_M_imm_R inst_29_sub_M_imm_R_0( mod, m, r_reg, m_reg, m_reg_plus_imm8, m_reg_plus_imm32, memval_m_reg, memval_m_reg_plus_imm8, memval_m_reg_plus_imm32
    , end_write_flag[8'h29], end_write_addr[8'h29], end_write_value[8'h29]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h29], end_ecx[8'h29], end_edx[8'h29], end_ebx[8'h29]
    , end_esp[8'h29], end_ebp[8'h29], end_esi[8'h29], end_edi[8'h29]
    , end_eip[8'h29], end_cf[8'h29], end_zf[8'h29], end_sf[8'h29], end_of[8'h29]
  );/*}}}*/
  // 39    : cmp [M+imm], R imm/*{{{*/
  inst_39_cmp_M_imm_R inst_39_cmp_M_imm_R_0( mod, m, r_reg, m_reg, m_reg_plus_imm8, m_reg_plus_imm32, memval_m_reg, memval_m_reg_plus_imm8, memval_m_reg_plus_imm32
    , end_write_flag[8'h39], end_write_addr[8'h39], end_write_value[8'h39]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h39], end_ecx[8'h39], end_edx[8'h39], end_ebx[8'h39]
    , end_esp[8'h39], end_ebp[8'h39], end_esi[8'h39], end_edi[8'h39]
    , end_eip[8'h39], end_cf[8'h39], end_zf[8'h39], end_sf[8'h39], end_of[8'h39]
  );/*}}}*/
  // 50-57 : push exx/*{{{*/
  inst_50_push_eax inst_50_push_eax_0( end_write_flag[8'h50], end_write_addr[8'h50], end_write_value[8'h50]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h50], end_ecx[8'h50], end_edx[8'h50], end_ebx[8'h50]
    , end_esp[8'h50], end_ebp[8'h50], end_esi[8'h50], end_edi[8'h50]
    , end_eip[8'h50], end_cf[8'h50], end_zf[8'h50], end_sf[8'h50], end_of[8'h50]
  );
  inst_51_push_ecx inst_51_push_ecx_0( end_write_flag[8'h51], end_write_addr[8'h51], end_write_value[8'h51]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h51], end_ecx[8'h51], end_edx[8'h51], end_ebx[8'h51]
    , end_esp[8'h51], end_ebp[8'h51], end_esi[8'h51], end_edi[8'h51]
    , end_eip[8'h51], end_cf[8'h51], end_zf[8'h51], end_sf[8'h51], end_of[8'h51]
  );
  inst_52_push_edx inst_52_push_edx_0( end_write_flag[8'h52], end_write_addr[8'h52], end_write_value[8'h52]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h52], end_ecx[8'h52], end_edx[8'h52], end_ebx[8'h52]
    , end_esp[8'h52], end_ebp[8'h52], end_esi[8'h52], end_edi[8'h52]
    , end_eip[8'h52], end_cf[8'h52], end_zf[8'h52], end_sf[8'h52], end_of[8'h52]
  );
  inst_53_push_ebx inst_53_push_ebx_0( end_write_flag[8'h53], end_write_addr[8'h53], end_write_value[8'h53]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h53], end_ecx[8'h53], end_edx[8'h53], end_ebx[8'h53]
    , end_esp[8'h53], end_ebp[8'h53], end_esi[8'h53], end_edi[8'h53]
    , end_eip[8'h53], end_cf[8'h53], end_zf[8'h53], end_sf[8'h53], end_of[8'h53]
  );
  inst_54_push_esp inst_54_push_esp_0( end_write_flag[8'h54], end_write_addr[8'h54], end_write_value[8'h54]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h54], end_ecx[8'h54], end_edx[8'h54], end_ebx[8'h54]
    , end_esp[8'h54], end_ebp[8'h54], end_esi[8'h54], end_edi[8'h54]
    , end_eip[8'h54], end_cf[8'h54], end_zf[8'h54], end_sf[8'h54], end_of[8'h54]
  );
  inst_55_push_ebp inst_55_push_ebp_0( end_write_flag[8'h55], end_write_addr[8'h55], end_write_value[8'h55]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h55], end_ecx[8'h55], end_edx[8'h55], end_ebx[8'h55]
    , end_esp[8'h55], end_ebp[8'h55], end_esi[8'h55], end_edi[8'h55]
    , end_eip[8'h55], end_cf[8'h55], end_zf[8'h55], end_sf[8'h55], end_of[8'h55]
  );
  inst_56_push_esi inst_56_push_esi_0( end_write_flag[8'h56], end_write_addr[8'h56], end_write_value[8'h56]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h56], end_ecx[8'h56], end_edx[8'h56], end_ebx[8'h56]
    , end_esp[8'h56], end_ebp[8'h56], end_esi[8'h56], end_edi[8'h56]
    , end_eip[8'h56], end_cf[8'h56], end_zf[8'h56], end_sf[8'h56], end_of[8'h56]
  );
  inst_57_push_edi inst_57_push_edi_0( end_write_flag[8'h57], end_write_addr[8'h57], end_write_value[8'h57]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h57], end_ecx[8'h57], end_edx[8'h57], end_ebx[8'h57]
    , end_esp[8'h57], end_ebp[8'h57], end_esi[8'h57], end_edi[8'h57]
    , end_eip[8'h57], end_cf[8'h57], end_zf[8'h57], end_sf[8'h57], end_of[8'h57]
  );
  /*}}}*/
  // 58-5f : pop exx/*{{{*/
  inst_58_pop_eax inst_58_pop_eax_0( stack_value
    , end_write_flag[8'h58], end_write_addr[8'h58], end_write_value[8'h58]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h58], end_ecx[8'h58], end_edx[8'h58], end_ebx[8'h58]
    , end_esp[8'h58], end_ebp[8'h58], end_esi[8'h58], end_edi[8'h58]
    , end_eip[8'h58], end_cf[8'h58], end_zf[8'h58], end_sf[8'h58], end_of[8'h58]
  );
  inst_59_pop_ecx inst_59_pop_ecx_0( stack_value
    , end_write_flag[8'h59], end_write_addr[8'h59], end_write_value[8'h59]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h59], end_ecx[8'h59], end_edx[8'h59], end_ebx[8'h59]
    , end_esp[8'h59], end_ebp[8'h59], end_esi[8'h59], end_edi[8'h59]
    , end_eip[8'h59], end_cf[8'h59], end_zf[8'h59], end_sf[8'h59], end_of[8'h59]
  );
  inst_5a_pop_edx inst_5a_pop_edx_0( stack_value
    , end_write_flag[8'h5a], end_write_addr[8'h5a], end_write_value[8'h5a]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h5a], end_ecx[8'h5a], end_edx[8'h5a], end_ebx[8'h5a]
    , end_esp[8'h5a], end_ebp[8'h5a], end_esi[8'h5a], end_edi[8'h5a]
    , end_eip[8'h5a], end_cf[8'h5a], end_zf[8'h5a], end_sf[8'h5a], end_of[8'h5a]
  );
  inst_5b_pop_ebx inst_5b_pop_ebx_0( stack_value
    , end_write_flag[8'h5b], end_write_addr[8'h5b], end_write_value[8'h5b]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h5b], end_ecx[8'h5b], end_edx[8'h5b], end_ebx[8'h5b]
    , end_esp[8'h5b], end_ebp[8'h5b], end_esi[8'h5b], end_edi[8'h5b]
    , end_eip[8'h5b], end_cf[8'h5b], end_zf[8'h5b], end_sf[8'h5b], end_of[8'h5b]
  );
  inst_5c_pop_esp inst_5c_pop_esp_0( stack_value
    , end_write_flag[8'h5c], end_write_addr[8'h5c], end_write_value[8'h5c]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h5c], end_ecx[8'h5c], end_edx[8'h5c], end_ebx[8'h5c]
    , end_esp[8'h5c], end_ebp[8'h5c], end_esi[8'h5c], end_edi[8'h5c]
    , end_eip[8'h5c], end_cf[8'h5c], end_zf[8'h5c], end_sf[8'h5c], end_of[8'h5c]
  );
  inst_5d_pop_ebp inst_5d_pop_ebp_0( stack_value
    , end_write_flag[8'h5d], end_write_addr[8'h5d], end_write_value[8'h5d]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h5d], end_ecx[8'h5d], end_edx[8'h5d], end_ebx[8'h5d]
    , end_esp[8'h5d], end_ebp[8'h5d], end_esi[8'h5d], end_edi[8'h5d]
    , end_eip[8'h5d], end_cf[8'h5d], end_zf[8'h5d], end_sf[8'h5d], end_of[8'h5d]
  );
  inst_5e_pop_esi inst_5e_pop_esi_0( stack_value
    , end_write_flag[8'h5e], end_write_addr[8'h5e], end_write_value[8'h5e]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h5e], end_ecx[8'h5e], end_edx[8'h5e], end_ebx[8'h5e]
    , end_esp[8'h5e], end_ebp[8'h5e], end_esi[8'h5e], end_edi[8'h5e]
    , end_eip[8'h5e], end_cf[8'h5e], end_zf[8'h5e], end_sf[8'h5e], end_of[8'h5e]
  );
  inst_5f_pop_edi inst_5f_pop_edi_0( stack_value
    , end_write_flag[8'h5f], end_write_addr[8'h5f], end_write_value[8'h5f]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h5f], end_ecx[8'h5f], end_edx[8'h5f], end_ebx[8'h5f]
    , end_esp[8'h5f], end_ebp[8'h5f], end_esi[8'h5f], end_edi[8'h5f]
    , end_eip[8'h5f], end_cf[8'h5f], end_zf[8'h5f], end_sf[8'h5f], end_of[8'h5f]
  );
  /*}}}*/
  // 70-7f : jcc imm8/*{{{*/
  inst_70_jo_imm8 inst_70_jo_imm8_0( imm8
    , end_write_flag[8'h70], end_write_addr[8'h70], end_write_value[8'h70]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h70], end_ecx[8'h70], end_edx[8'h70], end_ebx[8'h70]
    , end_esp[8'h70], end_ebp[8'h70], end_esi[8'h70], end_edi[8'h70]
    , end_eip[8'h70], end_cf[8'h70], end_zf[8'h70], end_sf[8'h70], end_of[8'h70]
  );
  inst_71_jno_imm8 inst_71_jno_imm8_0( imm8
    , end_write_flag[8'h71], end_write_addr[8'h71], end_write_value[8'h71]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h71], end_ecx[8'h71], end_edx[8'h71], end_ebx[8'h71]
    , end_esp[8'h71], end_ebp[8'h71], end_esi[8'h71], end_edi[8'h71]
    , end_eip[8'h71], end_cf[8'h71], end_zf[8'h71], end_sf[8'h71], end_of[8'h71]
  );
  inst_72_jb_imm8 inst_72_jb_imm8_0( imm8
    , end_write_flag[8'h72], end_write_addr[8'h72], end_write_value[8'h72]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h72], end_ecx[8'h72], end_edx[8'h72], end_ebx[8'h72]
    , end_esp[8'h72], end_ebp[8'h72], end_esi[8'h72], end_edi[8'h72]
    , end_eip[8'h72], end_cf[8'h72], end_zf[8'h72], end_sf[8'h72], end_of[8'h72]
  );
  inst_73_jae_imm8 inst_73_jae_imm8_0( imm8
    , end_write_flag[8'h73], end_write_addr[8'h73], end_write_value[8'h73]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h73], end_ecx[8'h73], end_edx[8'h73], end_ebx[8'h73]
    , end_esp[8'h73], end_ebp[8'h73], end_esi[8'h73], end_edi[8'h73]
    , end_eip[8'h73], end_cf[8'h73], end_zf[8'h73], end_sf[8'h73], end_of[8'h73]
  );
  inst_74_je_imm8 inst_74_je_imm8_0( imm8
    , end_write_flag[8'h74], end_write_addr[8'h74], end_write_value[8'h74]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h74], end_ecx[8'h74], end_edx[8'h74], end_ebx[8'h74]
    , end_esp[8'h74], end_ebp[8'h74], end_esi[8'h74], end_edi[8'h74]
    , end_eip[8'h74], end_cf[8'h74], end_zf[8'h74], end_sf[8'h74], end_of[8'h74]
  );
  inst_75_jne_imm8 inst_75_jne_imm8_0( imm8
    , end_write_flag[8'h75], end_write_addr[8'h75], end_write_value[8'h75]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h75], end_ecx[8'h75], end_edx[8'h75], end_ebx[8'h75]
    , end_esp[8'h75], end_ebp[8'h75], end_esi[8'h75], end_edi[8'h75]
    , end_eip[8'h75], end_cf[8'h75], end_zf[8'h75], end_sf[8'h75], end_of[8'h75]
  );
  inst_76_jbe_imm8 inst_76_jbe_imm8_0( imm8
    , end_write_flag[8'h76], end_write_addr[8'h76], end_write_value[8'h76]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h76], end_ecx[8'h76], end_edx[8'h76], end_ebx[8'h76]
    , end_esp[8'h76], end_ebp[8'h76], end_esi[8'h76], end_edi[8'h76]
    , end_eip[8'h76], end_cf[8'h76], end_zf[8'h76], end_sf[8'h76], end_of[8'h76]
  );
  inst_77_ja_imm8 inst_77_ja_imm8_0( imm8
    , end_write_flag[8'h77], end_write_addr[8'h77], end_write_value[8'h77]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h77], end_ecx[8'h77], end_edx[8'h77], end_ebx[8'h77]
    , end_esp[8'h77], end_ebp[8'h77], end_esi[8'h77], end_edi[8'h77]
    , end_eip[8'h77], end_cf[8'h77], end_zf[8'h77], end_sf[8'h77], end_of[8'h77]
  );
  inst_78_js_imm8 inst_78_js_imm8_0( imm8
    , end_write_flag[8'h78], end_write_addr[8'h78], end_write_value[8'h78]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h78], end_ecx[8'h78], end_edx[8'h78], end_ebx[8'h78]
    , end_esp[8'h78], end_ebp[8'h78], end_esi[8'h78], end_edi[8'h78]
    , end_eip[8'h78], end_cf[8'h78], end_zf[8'h78], end_sf[8'h78], end_of[8'h78]
  );
  inst_79_jns_imm8 inst_79_jns_imm8_0( imm8
    , end_write_flag[8'h79], end_write_addr[8'h79], end_write_value[8'h79]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h79], end_ecx[8'h79], end_edx[8'h79], end_ebx[8'h79]
    , end_esp[8'h79], end_ebp[8'h79], end_esi[8'h79], end_edi[8'h79]
    , end_eip[8'h79], end_cf[8'h79], end_zf[8'h79], end_sf[8'h79], end_of[8'h79]
  );
  inst_7c_jl_imm8 inst_7c_jl_imm8_0( imm8
    , end_write_flag[8'h7c], end_write_addr[8'h7c], end_write_value[8'h7c]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h7c], end_ecx[8'h7c], end_edx[8'h7c], end_ebx[8'h7c]
    , end_esp[8'h7c], end_ebp[8'h7c], end_esi[8'h7c], end_edi[8'h7c]
    , end_eip[8'h7c], end_cf[8'h7c], end_zf[8'h7c], end_sf[8'h7c], end_of[8'h7c]
  );
  inst_7d_jge_imm8 inst_7d_jge_imm8_0( imm8
    , end_write_flag[8'h7d], end_write_addr[8'h7d], end_write_value[8'h7d]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h7d], end_ecx[8'h7d], end_edx[8'h7d], end_ebx[8'h7d]
    , end_esp[8'h7d], end_ebp[8'h7d], end_esi[8'h7d], end_edi[8'h7d]
    , end_eip[8'h7d], end_cf[8'h7d], end_zf[8'h7d], end_sf[8'h7d], end_of[8'h7d]
  );
  inst_7e_jle_imm8 inst_7e_jle_imm8_0( imm8
    , end_write_flag[8'h7e], end_write_addr[8'h7e], end_write_value[8'h7e]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h7e], end_ecx[8'h7e], end_edx[8'h7e], end_ebx[8'h7e]
    , end_esp[8'h7e], end_ebp[8'h7e], end_esi[8'h7e], end_edi[8'h7e]
    , end_eip[8'h7e], end_cf[8'h7e], end_zf[8'h7e], end_sf[8'h7e], end_of[8'h7e]
  );
  inst_7f_jg_imm8 inst_7f_jg_imm8_0( imm8
    , end_write_flag[8'h7f], end_write_addr[8'h7f], end_write_value[8'h7f]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h7f], end_ecx[8'h7f], end_edx[8'h7f], end_ebx[8'h7f]
    , end_esp[8'h7f], end_ebp[8'h7f], end_esi[8'h7f], end_edi[8'h7f]
    , end_eip[8'h7f], end_cf[8'h7f], end_zf[8'h7f], end_sf[8'h7f], end_of[8'h7f]
  );/*}}}*/
  // 83    : calc(R) M, imm8/*{{{*/
  inst_83_calcR_M_imm8 inst_83_calcR_M_imm8_0( mod, r, m, m_reg, modrm_imm8
    , end_write_flag[8'h83], end_write_addr[8'h83], end_write_value[8'h83]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h83], end_ecx[8'h83], end_edx[8'h83], end_ebx[8'h83]
    , end_esp[8'h83], end_ebp[8'h83], end_esi[8'h83], end_edi[8'h83]
    , end_eip[8'h83], end_cf[8'h83], end_zf[8'h83], end_sf[8'h83], end_of[8'h83]
  );/*}}}*/
  // 89    : mov [M+imm], R imm/*{{{*/
  inst_89_mov_M_imm_R inst_89_mov_M_imm_R_0( mod, m, r_reg, m_reg, m_reg_plus_imm8, m_reg_plus_imm32
    , end_write_flag[8'h89], end_write_addr[8'h89], end_write_value[8'h89]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h89], end_ecx[8'h89], end_edx[8'h89], end_ebx[8'h89]
    , end_esp[8'h89], end_ebp[8'h89], end_esi[8'h89], end_edi[8'h89]
    , end_eip[8'h89], end_cf[8'h89], end_zf[8'h89], end_sf[8'h89], end_of[8'h89]
  );/*}}}*/
  // 8b    : mov R, [M+imm] imm/*{{{*/
  inst_8b_mov_R_M_imm inst_8b_mov_R_M_imm_0( mod, r, r_reg, m_reg, memval_m_reg, memval_m_reg_plus_imm8, memval_m_reg_plus_imm32
    , end_write_flag[8'h8b], end_write_addr[8'h8b], end_write_value[8'h8b]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'h8b], end_ecx[8'h8b], end_edx[8'h8b], end_ebx[8'h8b]
    , end_esp[8'h8b], end_ebp[8'h8b], end_esi[8'h8b], end_edi[8'h8b]
    , end_eip[8'h8b], end_cf[8'h8b], end_zf[8'h8b], end_sf[8'h8b], end_of[8'h8b]
  );/*}}}*/
  // b8-bf : mov exx, imm32/*{{{*/
  inst_b8_mov_eax_imm32 inst_b8_mov_eax_imm32_0( imm32
    , end_write_flag[8'hb8], end_write_addr[8'hb8], end_write_value[8'hb8]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hb8], end_ecx[8'hb8], end_edx[8'hb8], end_ebx[8'hb8]
    , end_esp[8'hb8], end_ebp[8'hb8], end_esi[8'hb8], end_edi[8'hb8]
    , end_eip[8'hb8], end_cf[8'hb8], end_zf[8'hb8], end_sf[8'hb8], end_of[8'hb8]
  );
  inst_b9_mov_ecx_imm32 inst_b9_mov_ecx_imm32_0( imm32
    , end_write_flag[8'hb9], end_write_addr[8'hb9], end_write_value[8'hb9]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hb9], end_ecx[8'hb9], end_edx[8'hb9], end_ebx[8'hb9]
    , end_esp[8'hb9], end_ebp[8'hb9], end_esi[8'hb9], end_edi[8'hb9]
    , end_eip[8'hb9], end_cf[8'hb9], end_zf[8'hb9], end_sf[8'hb9], end_of[8'hb9]
  );
  inst_ba_mov_edx_imm32 inst_ba_mov_edx_imm32_0( imm32
    , end_write_flag[8'hba], end_write_addr[8'hba], end_write_value[8'hba]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hba], end_ecx[8'hba], end_edx[8'hba], end_ebx[8'hba]
    , end_esp[8'hba], end_ebp[8'hba], end_esi[8'hba], end_edi[8'hba]
    , end_eip[8'hba], end_cf[8'hba], end_zf[8'hba], end_sf[8'hba], end_of[8'hba]
  );
  inst_bb_mov_ebx_imm32 inst_bb_mov_ebx_imm32_0( imm32
    , end_write_flag[8'hbb], end_write_addr[8'hbb], end_write_value[8'hbb]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hbb], end_ecx[8'hbb], end_edx[8'hbb], end_ebx[8'hbb]
    , end_esp[8'hbb], end_ebp[8'hbb], end_esi[8'hbb], end_edi[8'hbb]
    , end_eip[8'hbb], end_cf[8'hbb], end_zf[8'hbb], end_sf[8'hbb], end_of[8'hbb]
  );
  inst_bc_mov_esp_imm32 inst_bc_mov_esp_imm32_0( imm32
    , end_write_flag[8'hbc], end_write_addr[8'hbc], end_write_value[8'hbc]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hbc], end_ecx[8'hbc], end_edx[8'hbc], end_ebx[8'hbc]
    , end_esp[8'hbc], end_ebp[8'hbc], end_esi[8'hbc], end_edi[8'hbc]
    , end_eip[8'hbc], end_cf[8'hbc], end_zf[8'hbc], end_sf[8'hbc], end_of[8'hbc]
  );
  inst_bd_mov_ebp_imm32 inst_bd_mov_ebp_imm32_0( imm32
    , end_write_flag[8'hbd], end_write_addr[8'hbd], end_write_value[8'hbd]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hbd], end_ecx[8'hbd], end_edx[8'hbd], end_ebx[8'hbd]
    , end_esp[8'hbd], end_ebp[8'hbd], end_esi[8'hbd], end_edi[8'hbd]
    , end_eip[8'hbd], end_cf[8'hbd], end_zf[8'hbd], end_sf[8'hbd], end_of[8'hbd]
  );
  inst_be_mov_esi_imm32 inst_be_mov_esi_imm32_0( imm32
    , end_write_flag[8'hbe], end_write_addr[8'hbe], end_write_value[8'hbe]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hbe], end_ecx[8'hbe], end_edx[8'hbe], end_ebx[8'hbe]
    , end_esp[8'hbe], end_ebp[8'hbe], end_esi[8'hbe], end_edi[8'hbe]
    , end_eip[8'hbe], end_cf[8'hbe], end_zf[8'hbe], end_sf[8'hbe], end_of[8'hbe]
  );
  inst_bf_mov_edi_imm32 inst_bf_mov_edi_imm32_0( imm32
    , end_write_flag[8'hbf], end_write_addr[8'hbf], end_write_value[8'hbf]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hbf], end_ecx[8'hbf], end_edx[8'hbf], end_ebx[8'hbf]
    , end_esp[8'hbf], end_ebp[8'hbf], end_esi[8'hbf], end_edi[8'hbf]
    , end_eip[8'hbf], end_cf[8'hbf], end_zf[8'hbf], end_sf[8'hbf], end_of[8'hbf]
  );/*}}}*/
  // c3    : ret/*{{{*/
  inst_c3_ret inst_c3_ret_0( stack_value
    , end_write_flag[8'hc3], end_write_addr[8'hc3], end_write_value[8'hc3]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hc3], end_ecx[8'hc3], end_edx[8'hc3], end_ebx[8'hc3]
    , end_esp[8'hc3], end_ebp[8'hc3], end_esi[8'hc3], end_edi[8'hc3]
    , end_eip[8'hc3], end_cf[8'hc3], end_zf[8'hc3], end_sf[8'hc3], end_of[8'hc3]
  );/*}}}*/
  // c9    : leave/*{{{*/
  inst_c9_leave inst_c9_leave_0( stack_value, ebp_leave_value
    , end_write_flag[8'hc9], end_write_addr[8'hc9], end_write_value[8'hc9]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hc9], end_ecx[8'hc9], end_edx[8'hc9], end_ebx[8'hc9]
    , end_esp[8'hc9], end_ebp[8'hc9], end_esi[8'hc9], end_edi[8'hc9]
    , end_eip[8'hc9], end_cf[8'hc9], end_zf[8'hc9], end_sf[8'hc9], end_of[8'hc9]
  );/*}}}*/
  // e8    : call/*{{{*/
  inst_e8_call inst_e8_call_0( imm32
    , end_write_flag[8'he8], end_write_addr[8'he8], end_write_value[8'he8]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'he8], end_ecx[8'he8], end_edx[8'he8], end_ebx[8'he8]
    , end_esp[8'he8], end_ebp[8'he8], end_esi[8'he8], end_edi[8'he8]
    , end_eip[8'he8], end_cf[8'he8], end_zf[8'he8], end_sf[8'he8], end_of[8'he8]
  );/*}}}*/
  // e9    : jmp imm32/*{{{*/
  inst_e9_jmp_imm32 inst_e9_jmp_imm32_0( imm32
    , end_write_flag[8'he9], end_write_addr[8'he9], end_write_value[8'he9]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'he9], end_ecx[8'he9], end_edx[8'he9], end_ebx[8'he9]
    , end_esp[8'he9], end_ebp[8'he9], end_esi[8'he9], end_edi[8'he9]
    , end_eip[8'he9], end_cf[8'he9], end_zf[8'he9], end_sf[8'he9], end_of[8'he9]
  );
  /*}}}*/
  // eb    : jmp imm8/*{{{*/
  inst_eb_jmp_imm8 inst_eb_jmp_imm8_0( imm8
    , end_write_flag[8'heb], end_write_addr[8'heb], end_write_value[8'heb]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'heb], end_ecx[8'heb], end_edx[8'heb], end_ebx[8'heb]
    , end_esp[8'heb], end_ebp[8'heb], end_esi[8'heb], end_edi[8'heb]
    , end_eip[8'heb], end_cf[8'heb], end_zf[8'heb], end_sf[8'heb], end_of[8'heb]
  );
  /*}}}*/
  // f4    : hlt/*{{{*/
  inst_f4_hlt inst_f4_hlt_0( end_write_flag[8'hf4], end_write_addr[8'hf4], end_write_value[8'hf4]
    , eax, ecx, edx, ebx
    , esp, ebp, esi, edi
    , eip, cf,  zf,  sf, of
    , end_eax[8'hf4], end_ecx[8'hf4], end_edx[8'hf4], end_ebx[8'hf4]
    , end_esp[8'hf4], end_ebp[8'hf4], end_esi[8'hf4], end_edi[8'hf4]
    , end_eip[8'hf4], end_cf[8'hf4], end_zf[8'hf4], end_sf[8'hf4], end_of[8'hf4]
  );/*}}}*/
endmodule
