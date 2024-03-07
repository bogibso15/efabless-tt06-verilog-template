`line 2 "top.tlv" 0
`line 31 "top.tlv" 1

//_\SV
   // Included URL: "https://raw.githubusercontent.com/efabless/chipcraft---mest-course/main/tlv_lib/calculator_shell_lib.tlv"
   // Include Tiny Tapeout Lab.
   // Included URL: "https://raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlv_lib/tiny_tapeout_lib.tlv"// Included URL: "https://raw.githubusercontent.com/os-fpga/Virtual-FPGA-Lab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlv_lib/fpga_includes.tlv"
`line 215 "top.tlv" 1

//_\SV

// ================================================
// A simple Makerchip Verilog test bench driving random stimulus.
// Modify the module contents to your needs.
// ================================================

module top(input logic clk, input logic reset, input logic [31:0] cyc_cnt, output logic passed, output logic failed);
   // Tiny tapeout I/O signals.
   logic [7:0] ui_in, uo_out;
   logic [7:0]uio_in,  uio_out, uio_oe;
   logic [31:0] r;
   always @(posedge clk) r <= 0;
   assign ui_in = 8'b10000000;
   assign uio_in = 8'b0;
   logic ena = 1'b0;
   logic rst_n = ! reset;

   // Instantiate the Tiny Tapeout module.
   my_design tt(.*);

   assign passed = top.cyc_cnt > 60;
   assign failed = 1'b0;
endmodule


// Provide a wrapper module to debounce input signals if requested.
// The Tiny Tapeout top-level module.
// This simply debounces and synchronizes inputs.
// Debouncing is based on a counter. A change to any input will only be recognized once ALL inputs
// are stable for a certain duration. This approach uses a single counter vs. a counter for each
// bit.
module tt_um_example (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
       // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
    
    // Synchronize.
    logic [17:0] inputs_ff, inputs_sync;
    always @(posedge clk) begin
        inputs_ff <= {ui_in, uio_in, ena, rst_n};
        inputs_sync <= inputs_ff;
    end

    // Debounce.
    `define DEBOUNCE_MAX_CNT 14'h3fff
    logic [17:0] inputs_candidate, inputs_captured;
    logic sync_rst_n = inputs_sync[0];
    logic [13:0] cnt;
    always @(posedge clk) begin
        if (!sync_rst_n)
           cnt <= `DEBOUNCE_MAX_CNT;
        else if (inputs_sync != inputs_candidate) begin
           // Inputs changed before stablizing.
           cnt <= `DEBOUNCE_MAX_CNT;
           inputs_candidate <= inputs_sync;
        end
        else if (cnt > 0)
           cnt <= cnt - 14'b1;
        else begin
           // Cnt == 0. Capture candidate inputs.
           inputs_captured <= inputs_candidate;
        end
    end
    logic [7:0] clean_ui_in, clean_uio_in;
    logic clean_ena, clean_rst_n;
    assign {clean_ui_in, clean_uio_in, clean_ena, clean_rst_n} = inputs_captured;

    my_design my_design (
        .ui_in(clean_ui_in),
        .uio_in(clean_uio_in),
        .ena(clean_ena),
        .rst_n(clean_rst_n),
        .*);
endmodule
//_\SV



// =======================
// The Tiny Tapeout module
// =======================

module my_design (
    input  wire [7:0] ui_in,    // Dedicated inputs - connected to the input switches
    output wire [7:0] uo_out,   // Dedicated outputs - connected to the 7 segment display
       // The FPGA is based on TinyTapeout 3 which has no bidirectional I/Os (vs. TT6 for the ASIC).
    input  wire [7:0] uio_in,   // IOs: Bidirectional Input path
    output wire [7:0] uio_out,  // IOs: Bidirectional Output path
    output wire [7:0] uio_oe,   // IOs: Bidirectional Enable path (active high: 0=input, 1=output)
    
    input  wire       ena,      // will go high when the design is enabled
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);
   wire reset = ! rst_n;

`include "top_gen.sv" //_\TLV
   /* verilator lint_off UNOPTFLAT */
   // Connect Tiny Tapeout I/Os to Virtual FPGA Lab.
   `line 77 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlvlib/tinytapeoutlib.tlv" 1
      assign L0_slideswitch_a0[7:0] = ui_in;
      assign L0_sseg_segment_n_a0[6:0] = ~ uo_out[6:0];
      assign L0_sseg_decimal_point_n_a0 = ~ uo_out[7];
      assign L0_sseg_digit_n_a0[7:0] = 8'b11111110;
   //_\end_source
   `line 325 "top.tlv" 2

   // Instantiate the Virtual FPGA Lab.
   `line 308 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
      
      `line 356 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         //_/thanks
            /* Viz omitted here */























      //_\end_source
      `line 310 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
      
   
      // Board VIZ.
   
      // Board Image.
      /* Viz omitted here */



















      //_/fpga_pins
         /* Viz omitted here */


         //_/fpga
            `line 135 "top.tlv" 1
               //_|encrypt
                  //_@0
                     assign FpgaPins_Fpga_ENCRYPT_sbox_vec_a0[2047:0] = 2048'h637c777bf26b6fc5_3001672bfed7ab76_ca82c97dfa5947f0_add4a2af9ca472c0_b7fd9326363ff7cc3_4a5e5f171d8311504_c723c31896059a07_1280e2eb27b27509_832c1a1b6e5aa052_3bd6b329e32f8453d_100ed20fcb15b6ac_bbe394a4c58cfd0e_faafb434d338545f9_027f503c9fa851a34_08f929d38f5bcb6da2_110fff3d2cd0c13e_c5f974417c4a77e3_d645d197360814fd_c222a908846eeb814_de5e0bdbe0323a0a_4906245cc2d3ac629_195e479e7c8376d8d_d54ea96c56f4ea65_7aae08ba78252e1c_a6b4c6e8dd741f4b_bd8b8a703eb56648_03f60e613557b986_c11d9ee1f8981169_d98e949b1e87e9ce_5528df8ca1890dbfe_6426841992d0fb05_4bb16;
                     //
                     //
            
                     assign FpgaPins_Fpga_ENCRYPT_ui_in_a0[7:0] = ui_in;   //Input to determine mode/keys
                     assign FpgaPins_Fpga_ENCRYPT_ofb_a0 = FpgaPins_Fpga_ENCRYPT_ui_in_a0[7];             //Switch to determine mode
                     assign FpgaPins_Fpga_ENCRYPT_blocks_to_run_a0[22:0] = 2000000;     //Blocks of AES to run if in OFB
            
                     //Initial State or IV
                     assign FpgaPins_Fpga_ENCRYPT_test_state_a0[127:0] =  128'h00112233445566778899aabbccddeeff;
            
                     //Initial Key
                     assign FpgaPins_Fpga_ENCRYPT_start_key_a0[127:0] =  FpgaPins_Fpga_ENCRYPT_ui_in_a0[0] ? 128'hffff_ffff_ffff_80000000000000000000 :
                                          FpgaPins_Fpga_ENCRYPT_ui_in_a0[1] ? 128'hffffffffffffc0000000000000000000 :
                                          FpgaPins_Fpga_ENCRYPT_ui_in_a0[2] ? 128'hffffffffffffe0000000000000000000 :
                                          FpgaPins_Fpga_ENCRYPT_ui_in_a0[3] ? 128'hfffffffffffff0000000000000000000 :
                                          128'h000102030405060708090a0b0c0d0e0f;
            
                     assign FpgaPins_Fpga_ENCRYPT_valid_blk_a0 = (FpgaPins_Fpga_ENCRYPT_ofb_a0 && (FpgaPins_Fpga_ENCRYPT_blk_counter_a0 <= FpgaPins_Fpga_ENCRYPT_blocks_to_run_a0)) || !FpgaPins_Fpga_ENCRYPT_ofb_a0;
                     //Counter to count the number of AES blocks performed
                     assign FpgaPins_Fpga_ENCRYPT_blk_counter_a0[22:0] = !FpgaPins_Fpga_ENCRYPT_reset_a0 && FpgaPins_Fpga_ENCRYPT_reset_a1 ? 0 :
                                          !FpgaPins_Fpga_ENCRYPT_ld_key_a0 && FpgaPins_Fpga_ENCRYPT_ld_key_a1 ? FpgaPins_Fpga_ENCRYPT_blk_counter_a1+1 :
                                          FpgaPins_Fpga_ENCRYPT_blk_counter_a1;
            
                     //Reset if *reset or if the ofb_count reaches 12 when in OFB
                     assign FpgaPins_Fpga_ENCRYPT_reset_a0 = reset;
                     assign FpgaPins_Fpga_ENCRYPT_valid_check_a0 = FpgaPins_Fpga_ENCRYPT_valid_a0 && !FpgaPins_Fpga_ENCRYPT_ofb_a0;
                     assign FpgaPins_Fpga_ENCRYPT_valid_a0 = FpgaPins_Fpga_ENCRYPT_r_counter_a0==11;
                     //_?$valid_blk
            
            
                        //If in ECB, this checks to see if the AES block if completed
            
            
                        assign FpgaPins_Fpga_ENCRYPT_ld_key_a0 = ((!FpgaPins_Fpga_ENCRYPT_reset_a0 && FpgaPins_Fpga_ENCRYPT_reset_a1) || FpgaPins_Fpga_ENCRYPT_r_counter_a1 == 10) ? 1 : 0;
            
                        assign FpgaPins_Fpga_ENCRYPT_run_key_a0 = (!FpgaPins_Fpga_ENCRYPT_ld_key_a0 && FpgaPins_Fpga_ENCRYPT_ld_key_a1) ? 1 :
                                   (FpgaPins_Fpga_ENCRYPT_run_key_a1 && FpgaPins_Fpga_ENCRYPT_ofb_a0 && FpgaPins_Fpga_ENCRYPT_blk_counter_a1 <= FpgaPins_Fpga_ENCRYPT_blocks_to_run_a0 ) ? 1 :
                                   (!FpgaPins_Fpga_ENCRYPT_ofb_a0 && FpgaPins_Fpga_ENCRYPT_r_counter_a1 < 11) ? 1 :
                                   0;
            
                        assign FpgaPins_Fpga_ENCRYPT_ld_init_a0 = !FpgaPins_Fpga_ENCRYPT_reset_a0 && FpgaPins_Fpga_ENCRYPT_reset_a1 ? 1 : 0;
                        //round counter
                        assign FpgaPins_Fpga_ENCRYPT_r_counter_a0[4:0] = FpgaPins_Fpga_ENCRYPT_reset_a0 ? 0 :
                                          !FpgaPins_Fpga_ENCRYPT_ld_key_a0 && FpgaPins_Fpga_ENCRYPT_ld_key_a1 ? 0 :
                                          (FpgaPins_Fpga_ENCRYPT_ofb_a0 && FpgaPins_Fpga_ENCRYPT_r_counter_a1 > 10) ? 0 :
                                          FpgaPins_Fpga_ENCRYPT_run_key_a0 ? FpgaPins_Fpga_ENCRYPT_r_counter_a1+1 :
                                          FpgaPins_Fpga_ENCRYPT_r_counter_a1;
            
                        //Perform the key schedule subroutine
                        `line 106 "top.tlv" 1
                           //_/keyschedule
                        
                              //KEY is the exposed output to main. The current key to use will be displayed.
                              //After ARK is done on main, it should pulse the keyschedule which will cause
                              //it to calculate the next key and have it ready for use.
                              assign FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0[127:0] = FpgaPins_Fpga_ENCRYPT_reset_a0 ?  '0 : //resets key (loads dummy for testing)
                                            FpgaPins_Fpga_ENCRYPT_ld_key_a0 ? FpgaPins_Fpga_ENCRYPT_start_key_a0 :  //pulls in initial key
                                            FpgaPins_Fpga_ENCRYPT_Keyschedule_next_key_a1; //loads next key
                        
                              assign FpgaPins_Fpga_ENCRYPT_Keyschedule_next_key_a0[127:0] = FpgaPins_Fpga_ENCRYPT_ld_key_a0 ? FpgaPins_Fpga_ENCRYPT_start_key_a0 : //full key for next clock
                                                 FpgaPins_Fpga_ENCRYPT_run_key_a0 ? {FpgaPins_Fpga_ENCRYPT_Keyschedule_next_worda_a0, FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordb_a0, FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordc_a0, FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordd_a0} :
                                                 FpgaPins_Fpga_ENCRYPT_Keyschedule_next_key_a1;
                              assign FpgaPins_Fpga_ENCRYPT_Keyschedule_run_key_a0 = FpgaPins_Fpga_ENCRYPT_run_key_a0;
                              //_?$run_key
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_temp_a0[31:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0[31:0];                //w[i+3]
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_rot_a0[31:0] = {FpgaPins_Fpga_ENCRYPT_Keyschedule_temp_a0[23:0],FpgaPins_Fpga_ENCRYPT_Keyschedule_temp_a0[31:24]}; // rotate word
                        
                                 `line 54 "top.tlv" 1
                                    for (sbox_k = 0; sbox_k <= 3; sbox_k++) begin : L1_FpgaPins_Fpga_ENCRYPT_Keyschedule_SboxK logic [10:0] L1_sb_idx_a0; logic [7:0] L1_sb_intermed_a0; logic [7:0] L1_word_idx_a0; //_/sbox_k
                                 
                                       assign L1_sb_idx_a0[10:0] = 2040-8*L1_word_idx_a0;
                                       assign L1_word_idx_a0[7:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_rot_a0[32-(8 * (sbox_k+1)) +: 8];
                                       assign L1_sb_intermed_a0[7:0] = FpgaPins_Fpga_ENCRYPT_sbox_vec_a0[L1_sb_idx_a0 +: 8]; end
                                    assign FpgaPins_Fpga_ENCRYPT_Keyschedule_sb_out_a0[31:0] = {L1_FpgaPins_Fpga_ENCRYPT_Keyschedule_SboxK[0].L1_sb_intermed_a0, L1_FpgaPins_Fpga_ENCRYPT_Keyschedule_SboxK[1].L1_sb_intermed_a0, L1_FpgaPins_Fpga_ENCRYPT_Keyschedule_SboxK[2].L1_sb_intermed_a0, L1_FpgaPins_Fpga_ENCRYPT_Keyschedule_SboxK[3].L1_sb_intermed_a0};
                                 //_\end_source
                                 `line 124 "top.tlv" 2
                        
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_rcon_a0[7:0] = FpgaPins_Fpga_ENCRYPT_r_counter_a0 == 0 ? 8'h01 : //round constant
                                              FpgaPins_Fpga_ENCRYPT_Keyschedule_rcon_a1 <  8'h80 ? (2 * FpgaPins_Fpga_ENCRYPT_Keyschedule_rcon_a1) :
                                                         ((2 * FpgaPins_Fpga_ENCRYPT_Keyschedule_rcon_a1) ^ 8'h1B);
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_xor_con_a0[31:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_sb_out_a0[31:0] ^ {FpgaPins_Fpga_ENCRYPT_Keyschedule_rcon_a0, 24'b0}; // xor with the round constant
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_next_worda_a0[31:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_xor_con_a0 ^ FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0[127:96];  // ripple solve for next words
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordb_a0[31:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_next_worda_a0 ^ FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0[95:64];
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordc_a0[31:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordb_a0 ^ FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0[63:32];
                                 assign FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordd_a0[31:0] = FpgaPins_Fpga_ENCRYPT_Keyschedule_next_wordc_a0 ^ FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0[31:0];
                        //_\end_source
                        `line 188 "top.tlv" 2
            
                        //set the initial state
                        assign FpgaPins_Fpga_ENCRYPT_state_i_a0[127:0] = FpgaPins_Fpga_ENCRYPT_reset_a0 ? '0:
                                          !FpgaPins_Fpga_ENCRYPT_ld_init_a0 && FpgaPins_Fpga_ENCRYPT_ld_init_a1 ? FpgaPins_Fpga_ENCRYPT_test_state_a0 :
                                          (FpgaPins_Fpga_ENCRYPT_run_key_a0 && FpgaPins_Fpga_ENCRYPT_r_counter_a1<11) ? FpgaPins_Fpga_ENCRYPT_state_ark_a1 :
                                          FpgaPins_Fpga_ENCRYPT_state_i_a1;
            
                        //Perform the subbytes and shift row subroutines
                        `line 43 "top.tlv" 1
                           //_/subbytes
                              for (sub_word = 0; sub_word <= 3; sub_word++) begin : L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord logic [31:0] L1_sb_out_a0; logic [31:0] L1_word_a0; //_/sub_word
                                 assign L1_word_a0[31:0] = FpgaPins_Fpga_ENCRYPT_state_i_a0[128-(32*(sub_word+1))+:32];
                                 `line 54 "top.tlv" 1
                                    for (sbox_subword = 0; sbox_subword <= 3; sbox_subword++) begin : L2_SboxSubword logic [10:0] L2_sb_idx_a0; logic [7:0] L2_sb_intermed_a0; logic [7:0] L2_word_idx_a0; //_/sbox_subword
                                 
                                       assign L2_sb_idx_a0[10:0] = 2040-8*L2_word_idx_a0;
                                       assign L2_word_idx_a0[7:0] = L1_word_a0[32-(8 * (sbox_subword+1)) +: 8];
                                       assign L2_sb_intermed_a0[7:0] = FpgaPins_Fpga_ENCRYPT_sbox_vec_a0[L2_sb_idx_a0 +: 8]; end
                                    assign L1_sb_out_a0[31:0] = {L2_SboxSubword[0].L2_sb_intermed_a0, L2_SboxSubword[1].L2_sb_intermed_a0, L2_SboxSubword[2].L2_sb_intermed_a0, L2_SboxSubword[3].L2_sb_intermed_a0};
                                 end //_\end_source
                                 `line 47 "top.tlv" 2
                        
                              assign FpgaPins_Fpga_ENCRYPT_Subbytes_ssr_out_a0[127:0] = {L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[0].L1_sb_out_a0[31:24], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[1].L1_sb_out_a0[23:16], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[2].L1_sb_out_a0[15:8], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[3].L1_sb_out_a0[7:0],
                                                 L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[1].L1_sb_out_a0[31:24], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[2].L1_sb_out_a0[23:16], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[3].L1_sb_out_a0[15:8], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[0].L1_sb_out_a0[7:0],
                                                 L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[2].L1_sb_out_a0[31:24], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[3].L1_sb_out_a0[23:16], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[0].L1_sb_out_a0[15:8], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[1].L1_sb_out_a0[7:0],
                                                 L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[3].L1_sb_out_a0[31:24], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[0].L1_sb_out_a0[23:16], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[1].L1_sb_out_a0[15:8], L1_FpgaPins_Fpga_ENCRYPT_Subbytes_SubWord[2].L1_sb_out_a0[7:0]};
                        //_\end_source
                        `line 197 "top.tlv" 2
                        assign FpgaPins_Fpga_ENCRYPT_state_ssr_a0[127:0] = FpgaPins_Fpga_ENCRYPT_r_counter_a0 ==0 ? FpgaPins_Fpga_ENCRYPT_state_i_a0 : FpgaPins_Fpga_ENCRYPT_Subbytes_ssr_out_a0;
            
                        //Perform the mixcolumn subroutine
                        `line 80 "top.tlv" 1
                           //_/mixcolumn
                        
                              assign FpgaPins_Fpga_ENCRYPT_Mixcolumn_const_matrix_a0[127:0] = 128'h02030101010203010101020303010102; //constant matrix for column multiplicaiton in the form of a vector
                              for (xx = 0; xx <= 3; xx++) begin : L1_FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx logic [3:0] [7:0] L1_Yy_oo_a0; //_/xx
                                 for (yy = 0; yy <= 3; yy++) begin : L2_Yy //_/yy
                                    assign FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_ss_a0[xx][yy][7:0] = FpgaPins_Fpga_ENCRYPT_state_ssr_a0[(yy * 8 + xx * 32) + 7 : (yy * 8 + xx * 32)];     //breaks the input vector and
                                    assign FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_cc_a0[xx][yy][7:0] = FpgaPins_Fpga_ENCRYPT_Mixcolumn_const_matrix_a0[(yy * 32 + xx * 8) + 7 : (yy * 32 + xx * 8)]; //constant matrix into matrices
                                    for (exp = 0; exp <= 3; exp++) begin : L3_Exp logic [7:0] L3_op_a0; logic [7:0] L3_reduce_check_a0; logic [7:0] L3_three_check_a0; //_/exp
                        
                                       assign L3_reduce_check_a0[7:0] = (FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_ss_a0[xx][exp][7] == 1) && (FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_cc_a0[exp][yy] != 8'h01) ? 8'h1b : 8'h00; //check if a reduction by the irreducibly polynomial is necessary
                                       assign L3_three_check_a0[7:0] = FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_cc_a0[exp][yy] == 8'h03 ? FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_ss_a0[xx][exp] : 8'h00; //check if a multiplication by 3 is being done
                                       assign L3_op_a0[7:0] = FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_cc_a0[exp][yy] == 8'h01 ? FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_ss_a0[xx][exp] : ((FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_Yy_ss_a0[xx][exp] << 1) ^ L3_three_check_a0 ^ L3_reduce_check_a0); end //if 1, identity. otherwise, bitshift & other operations.
                                    assign L1_Yy_oo_a0[yy][7:0] = L3_Exp[0].L3_op_a0 ^ L3_Exp[1].L3_op_a0 ^ L3_Exp[2].L3_op_a0 ^ L3_Exp[3].L3_op_a0; //xor the bytes together
                                    /* Viz omitted here */




                                    end
                                 assign FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_out_matrix_a0[xx][31:0] = L1_Yy_oo_a0; end //concat matrix rows
                              assign FpgaPins_Fpga_ENCRYPT_Mixcolumn_block_out_a0[127:0] = FpgaPins_Fpga_ENCRYPT_Mixcolumn_Xx_out_matrix_a0; //concat matrix columns
                        //_\end_source
                        `line 201 "top.tlv" 2
                        assign FpgaPins_Fpga_ENCRYPT_state_mc_a0[127:0] = (FpgaPins_Fpga_ENCRYPT_r_counter_a0 ==0 || FpgaPins_Fpga_ENCRYPT_r_counter_a0 == 10) ? FpgaPins_Fpga_ENCRYPT_state_ssr_a0 : FpgaPins_Fpga_ENCRYPT_Mixcolumn_block_out_a0;
            
                        //Perform the add round key subroutine
                        assign FpgaPins_Fpga_ENCRYPT_state_ark_a0[127:0] = FpgaPins_Fpga_ENCRYPT_state_mc_a0 ^ FpgaPins_Fpga_ENCRYPT_Keyschedule_key_a0;
            
                        //If in ECB, check for a correct encryption
            
                     //_?$valid_check
                        `line 64 "top.tlv" 1
                        
                           //_/check
                        
                              assign FpgaPins_Fpga_ENCRYPT_Check_pass_a0[0:0] = FpgaPins_Fpga_ENCRYPT_ui_in_a0 == 1 ? (FpgaPins_Fpga_ENCRYPT_state_i_a0 == 128'hb6768473ce9843ea66a81405dd50b345) :
                                           FpgaPins_Fpga_ENCRYPT_ui_in_a0 == 2 ? (FpgaPins_Fpga_ENCRYPT_state_i_a0 == 128'hcb2f430383f9084e03a653571e065de6) :
                                           FpgaPins_Fpga_ENCRYPT_ui_in_a0 == 4 ? (FpgaPins_Fpga_ENCRYPT_state_i_a0 == 128'hff4e66c07bae3e79fb7d210847a3b0ba) :
                                           FpgaPins_Fpga_ENCRYPT_ui_in_a0 == 8 ? (FpgaPins_Fpga_ENCRYPT_state_i_a0 == 128'h7b90785125505fad59b13c186dd66ce3) :
                                           (FpgaPins_Fpga_ENCRYPT_state_i_a0 == 128'h8b527a6aebdaec9eaef8eda2cb7783e5);
                        
                              assign uo_out = FpgaPins_Fpga_ENCRYPT_Check_pass_a0 ? 8'b00111111 :
                                        8'b01110110;
                        //_\end_source
                        `line 210 "top.tlv" 2
            
               // Connect Tiny Tapeout outputs. Note that uio_ outputs are not available in the Tiny-Tapeout-3-based FPGA boards.
               //*uo_out = 8'b0;
               assign uio_out = 8'b0;
               assign uio_oe = 8'b0;
            //_\end_source
            `line 341 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // LEDs.
      
   
      // 7-Segment
      `line 396 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         for (digit = 0; digit <= 0; digit++) begin : L1_Digit //_/digit
            /* Viz omitted here */



















            for (leds = 0; leds <= 7; leds++) begin : L2_Leds logic L2_viz_lit_a0; //_/leds
               assign L2_viz_lit_a0 = (! L0_sseg_digit_n_a0[digit]) && ! ((leds == 7) ? L0_sseg_decimal_point_n_a0 : L0_sseg_segment_n_a0[leds % 7]);
               /* Viz omitted here */
































               end end
      //_\end_source
      `line 347 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // slideswitches
      `line 455 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 1
         for (switch = 0; switch <= 7; switch++) begin : L1_Switch logic L1_viz_switch_a0; //_/switch
            assign L1_viz_switch_a0 = L0_slideswitch_a0[switch];
            /* Viz omitted here */










































            end
      //_\end_source
      `line 350 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/a069f1e4e19adc829b53237b3e0b5d6763dc3194/tlvlib/fpgaincludes.tlv" 2
   
      // pushbuttons
      
   //_\end_source
   `line 328 "top.tlv" 2
   // Label the switch inputs [0..7] (1..8 on the physical switch panel) (top-to-bottom).
   `line 83 "/raw.githubusercontent.com/osfpga/VirtualFPGALab/35e36bd144fddd75495d4cbc01c4fc50ac5bde6f/tlvlib/tinytapeoutlib.tlv" 1
      for (input_label = 0; input_label <= 7; input_label++) begin : L1_InputLabel //_/input_label
         /* Viz omitted here */















         end
   //_\end_source
   `line 330 "top.tlv" 2

//_\SV
endmodule



// Undefine macros defined by SandPiper (in "top_gen.sv").
`undef BOGUS_USE
