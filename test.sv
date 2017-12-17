`define MEMSIZE 768

module top;
  logic CLOCK;
  logic RESET;
  logic [15:0] OUT;

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
        $readmemh("test.hex", memory);/*}}}*/
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

//  // テスト/*{{{*/
//  initial begin
//    CLOCK = 1'b0;
//    forever begin
//      #5;
//      CLOCK = ~ CLOCK;
//    end
//  end
//
//  initial begin
//
//    RESET = 1'b1;
//    # 5;
//    # 1;
//    RESET = 1'b0;
//
//    #8;
//
//    #10;$display("---------- TEST 0001 mov eax, 0x12345678 ; mem[5:2] = 12345678");
//    assert(eax           === 32'h12345678);
//    assert(memory[ 4: 1] === 32'h12345678);
//
//    #10;$display("---------- TEST 0002 mov ecx, 0x12345432 ; mem[b:8] = 12345432");
//    assert(ecx           === 32'h12345432);
//    assert(memory[ 9: 6] === 32'h12345432);
//
//    #10;$display("---------- TEST 0003 mov edx, 0x1        ; edx=1");
//    assert(edx           === 32'h1);
//    assert(memory[14:11] === 32'h1);
//
//    #10;$display("---------- TEST 0004 mov ebx, 0x6        ; ebx=6");
//    assert(ebx           === 32'h6);
//    assert(memory[19:16] === 32'h6);
//
//
//
//    #10;$display("---------- TEST 0005 mov esi, [edx]      ; esi=12345678 mod=00");
//    assert(esi           === 32'h12345678);
//
//    #10;$display("---------- TEST 0006 mov esi, [edx+5]    ; esi=12345432 mod=01");
//    assert(esi           === 32'h12345432);
//
//    #10;$display("---------- TEST 0007 mov esi, [ebx-5]    ; esi=12345678 mod=01");
//    assert(esi           === 32'h12345678);
//
//
//
//    #10;$display("---------- TEST 0008 mov [edx  ], ecx    ; mem[4:1]=12345432 mod=00");
//    assert(memory[ 4: 1] === 32'h12345432);
//
//    #10;$display("---------- TEST 0009 mov [edx+5], eax    ; mem[9:6]=12345678 mod=01");
//    assert(memory[ 9: 6] === 32'h12345678);
//
//    #10;$display("---------- TEST 0010 mov [ebx-5], eax    ; mem[4:1]=12345678 mod=01");
//    assert(memory[ 4: 1] === 32'h12345678);
//
//    #10;$display("---------- TEST 0011 mov esi, edx        ; esi=1             mod=11");
//    assert(esi === edx);
//    assert(esi === 1);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    #10;$display("---------- TEST 0012 add [edx], ebx      ; mem[4:1]=mem[4:1]+esi ; mem[4:1] = 1234567E");
//    assert(memory[ 4: 1] === 32'h1234567E);
//
//    #10;$display("---------- TEST 0013 add [edx+5], edx    ; mem[9:6]=mem[9:6]+edx ; mem[9:6] = 12345679");
//    assert(memory[ 9: 6] === 32'h12345679);
//
//    #10;$display("---------- TEST 0014 add [ebx-5], edx    ; mem[4:1]=mem[4:1]+edx ; mem[4:1] = 1234567F");
//    assert(memory[ 4: 1] === 32'h1234567F);
//
//    #10;$display("---------- TEST 0015 add esi, edx        ; esi=esi+edx ; esi=2");
//    assert(esi === 2);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    #10;$display("---------- TEST 0016 sub [edx], ebx      ; mem[4:1]=mem[4:1]-ebx ; mem[4:1] = 12345679");
//    assert(memory[ 4: 1] === 32'h12345679);
//
//    #10;$display("---------- TEST 0017 sub [edx+5], edx    ; mem[9:6]=mem[9:6]-edx ; mem[9:6] = 12345678");
//    assert(memory[ 9: 6] === 32'h12345678);
//
//    #10;$display("---------- TEST 0018 sub [ebx-5], edx    ; mem[4:1]=mem[4:1]-edx ; mem[4:1] = 12345678");
//    assert(memory[ 4: 1] === 32'h12345678);
//
//    #10;$display("---------- TEST 0019 sub esi, edx        ; esi=esi-edx ; esi=1");
//    assert(esi === 1);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    #10;
//    #10;
//    #10;$display("---------- TEST 0020 cmp esi, edi        ; cf=0 zf=0 sf=0 of=0");
//    // 2-1
//    assert(cf === 0);
//    assert(zf === 0);
//    assert(sf === 0);
//    assert(of === 0);
//
//    #10;
//    #10;$display("---------- TEST 0021 cmp esi, edi        ; cf=0 zf=1 sf=0 of=0");
//    // 2-2
//    assert(cf === 0);
//    assert(zf === 1);
//    assert(sf === 0);
//    assert(of === 0);
//
//    #10;
//    #10;$display("---------- TEST 0022 cmp esi, edi        ; cf=1 zf=0 sf=1 of=0");
//    // 2-3
//    assert(cf === 1);
//    assert(zf === 0);
//    assert(sf === 1);
//    assert(of === 0);
//
//    #10;
//    #10;$display("---------- TEST 0023 cmp esi, edi        ; cf=0 zf=0 sf=0 of=1");
//    // -7fffffff - 3
//    assert(cf === 0);
//    assert(zf === 0);
//    assert(sf === 0);
//    assert(of === 1);
//
//    //#10;
//    //#10;
//    // ----------------------------------------------------------------------------------------------------
//
//    #10;$display("---------- TEST 0024 push eax            ; mem[MEMSIZE- 1:MEMSIZE- 4]=12345678  , esp=MEMSIZE-4");
//    assert(memory[`MEMSIZE-1:`MEMSIZE-4] === 32'h12345678);
//    assert(esp === `MEMSIZE-4);
//
//    #10;$display("---------- TEST 0025 push ecx            ; mem[MEMSIZE- 5:MEMSIZE- 8]=12345432  , esp=MEMSIZE-8");
//    assert(memory[`MEMSIZE- 5:`MEMSIZE- 8] === 32'h12345432);
//    assert(esp === `MEMSIZE-8);
//
//    #10;$display("---------- TEST 0026 push edx            ; mem[MEMSIZE- 9:MEMSIZE-12]=1         , esp=MEMSIZE-12");
//    assert(memory[`MEMSIZE- 9:`MEMSIZE-12] === 32'h1);
//    assert(esp === `MEMSIZE-12);
//
//    #10;$display("---------- TEST 0027 push ebx            ; mem[MEMSIZE-13:MEMSIZE-16]=6         , esp=MEMSIZE-16");
//    assert(memory[`MEMSIZE-13:`MEMSIZE-16] === 32'h6);
//    assert(esp === `MEMSIZE-16);
//
//    #10;$display("---------- TEST 0028 push esp            ; mem[MEMSIZE-17:MEMSIZE-20]=MEMSIZE-16, esp=MEMSIZE-20");
//    assert(memory[`MEMSIZE-17:`MEMSIZE-20] === `MEMSIZE-16);
//    assert(esp === `MEMSIZE-20);
//
//    #10;$display("---------- TEST 0029 push ebp            ; mem[MEMSIZE-21:MEMSIZE-24]=0         , esp=MEMSIZE-24");
//    assert(memory[`MEMSIZE-21:`MEMSIZE-24] === 32'h0);
//    assert(esp === `MEMSIZE-24);
//
//    #10;$display("---------- TEST 0030 push esi            ; mem[MEMSIZE-25:MEMSIZE-28]=0x80000001, esp=MEMSIZE-28");
//    assert(memory[`MEMSIZE-25:`MEMSIZE-28] === 32'h80000001);
//    assert(esp === `MEMSIZE-28);
//
//    #10;$display("---------- TEST 0031 push edi            ; mem[MEMSIZE-29:MEMSIZE-32]=3         , esp=MEMSIZE-32");
//    assert(memory[`MEMSIZE-29:`MEMSIZE-32] === 32'h3);
//    assert(esp === `MEMSIZE-32);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    #10;$display("---------- TEST 0032 pop eax             ; eax=3,         esp=MEMSIZE-28");
//    assert(eax === 32'h3);
//    assert(esp === `MEMSIZE-28);
//
//    #10;$display("---------- TEST 0033 pop ecx             ; ecx=0x80000001,esp=MEMSIZE-24");
//    assert(ecx === 32'h80000001);
//    assert(esp === `MEMSIZE-24);
//
//    #10;$display("---------- TEST 0034 pop edx             ; edx=0,         esp=MEMSIZE-20");
//    assert(edx === 0);
//    assert(esp === `MEMSIZE-20);
//
//    #10;$display("---------- TEST 0035 pop ebx             ; ebx=16,        esp=MEMSIZE-16");
//    assert(ebx === `MEMSIZE-16);
//    assert(esp === `MEMSIZE-16);
//
//    // skip esp
//
//    #10;$display("---------- TEST 0036 pop ebp             ; ebp=6,         esp=MEMSIZE-12");
//    assert(ebp === 6);
//    assert(esp === `MEMSIZE-12);
//
//    #10;$display("---------- TEST 0037 pop esi             ; esi=1,         esp=MEMSIZE-8");
//    assert(esi === 1);
//    assert(esp === `MEMSIZE-8);
//
//    #10;$display("---------- TEST 0038 pop edi             ; edi=12345432,  esp=MEMSIZE-4");
//    assert(edi === 32'h12345432);
//    assert(esp === `MEMSIZE-4);
//
//
//    #10;$display("---------- TEST 0039 mov edi, esp        ; edi=MEMSIZE-4");
//    assert(edi === `MEMSIZE-4);
//
//    #10;$display("---------- TEST 0040 pop esp             ; esp=12345678");
//    assert(esp === 32'h12345678);
//
//    #10;$display("---------- TEST 0041 mov esp, edi        ; esp=MEMSIZE-4");
//    assert(esp === `MEMSIZE-4);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    // $display("eax %h", eax);
//    #10;
//    #10;$display("---------- TEST 0042 add eax, 0x2        ; eax=eax+0x2,  eax=2;");
//    assert(eax === 2);
//    // $display("eax %h", eax);
//
//    #10;$display("---------- TEST 0043 sub eax, 0x2        ; eax=eax-0x2,  eax=0;");
//    assert(eax === 0);
//    // $display("eax %h", eax);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    #10;
//    #10;$display("---------- TEST 0044 cmp esi, edi        ; cf=0 zf=0 sf=0 of=0");
//    // 2-1
//    assert(cf === 0);
//    assert(zf === 0);
//    assert(sf === 0);
//    assert(of === 0);
//
//    #10;
//    // 2-2
//    assert(cf === 0);
//    assert(zf === 1);
//    assert(sf === 0);
//    assert(of === 0);
//
//    #10;
//    // 2-3
//    assert(cf === 1);
//    assert(zf === 0);
//    assert(sf === 1);
//    assert(of === 0);
//
//    #10;$display("---------- TEST 0045 mov esi, -0x7fffffff; esi=-0x7fffffff = b100..001 = 0x80000001");
//    assert(esi === -32'h7fffffff);
//    assert(esi ===  32'h80000001);
//
//    #10;$display("---------- TEST 0046 cmp esi, edi        ; cf=0 zf=0 sf=0 of=1");
//    // -7fffffff - 3
//    assert(cf === 0);
//    assert(zf === 0);
//    assert(sf === 0);
//    assert(of === 1);
//
//    // ----------------------------------------------------------------------------------------------------
//    // jmp
//
//    #10;$display("---------- TEST 0047 jmp imm8            ; eb 05");
//    #10;$display("---------- TEST 0048 jmp imm32           ; e9 82 00 00 00");
//    assert(eax === 0);
//    #10;$display("---------- TEST 0049 mov eax, 0x87654321 ; eax=0x87654321");
//    assert(eax === 32'h87654321);
//
//    // ----------------------------------------------------------------------------------------------------
//
//    // je  imm8
//    #50;$display("---------- TEST 0050 je  imm8            ; cmp 2,2");
//    assert(eax === 32'h87654321);
//
//    #40;$display("---------- TEST 0051 je  imm8            ; cmp 2,3");
//    assert(eax === 2);
//
//    #50;$display("---------- TEST 0052 je  imm8            ; cmp 3,2");
//    assert(eax === 3);
//
//
//    // jg  imm8
//    #50;$display("---------- TEST 0050 jg  imm8            ; cmp 2,2");
//    assert(eax === 4);
//
//    #50;$display("---------- TEST 0051 jg  imm8            ; cmp 2,3");
//    assert(eax === 5);
//
//    #40;$display("---------- TEST 0052 jg  imm8            ; cmp 3,2");
//    assert(eax === 5);
//
//
//    // jl  imm8
//    #50;$display("---------- TEST 0050 jl  imm8            ; cmp 2,2");
//    assert(eax === 7);
//
//    #40;$display("---------- TEST 0051 jl  imm8            ; cmp 2,3");
//    assert(eax === 7);
//
//    #50;$display("---------- TEST 0052 jl  imm8            ; cmp 3,2");
//    assert(eax === 9);
//
//    $stop;
//  end/*}}}*/

  // フィボナッチ/*{{{*/
  initial begin
    CLOCK = 1'b0;
    forever begin
      #5;
      CLOCK = ~ CLOCK;
    end
  end

  initial begin

    RESET = 1'b1;
    # 5;
    # 1;
    RESET = 1'b0;

    #8;

    for (int i=0; i<50000; i++) begin
      #10;
      $display("TIME:%09d: eip:%h eax:%h ecx:%h esp:%h ebp:%h", i, eip, eax, ecx, esp, ebp);
    end

    $stop;
  end/*}}}*/
endmodule
