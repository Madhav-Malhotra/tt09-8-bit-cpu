/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements control logic? Go see https://github.com/jhill0408/8bitcpu/blob/main/src/project.v
 */

module control_top (
  output wire hlt, mi_bar, ri, ro_bar, io_bar, ii_bar, ai_bar, ao_bar, eo_bar, su, bi_bar, oi, ce, co_bar, j_bar, fi_bar,
  input wire cf, zf, 
  input wire clr,
  output wire clr_bar, 
  input wire ir_4, ir_5, ir_6, ir_7, clk_bar
  
);
  
  wire mi, ro, io, ii, ai, ao, eo, bi, co, j, fi, a0, a1, a2, not_used;
  wire [7:0] y;
  
  assign mi_bar = ~mi;
  assign ro_bar = ~ro;
  assign io_bar = ~io;
  assign ii_bar = ~ii;
  assign ai_bar = ~ai;
  assign ao_bar = ~ao;
  assign eo_bar = ~eo;
  assign bi_bar = ~bi;
  assign co_bar = ~co;
  assign j_bar = ~j;
  assign fi_bar = ~fi;
  
  eeprom u_mem1 (
    .we_n(1'b1),
    .oe_n(1'b0),
    .ce_n(1'b0),
    .addr({1'b0,zf,cf,1'b0,ir_7,ir_6,ir_5,ir_4,a2,a1,a0}),
    .data({hlt, mi, ri, ro, io, ii, ai, ao})
    
  );
  
  eeprom u_mem2 (
    .we_n(1'b1),
    .oe_n(1'b0),
    .ce_n(1'b0),
    .addr({1'b0,zf,cf,1'b1,ir_7,ir_6,ir_5,ir_4,a2,a1,a0}),
    .data({eo, su, bi, oi, ce, co, j, fi})
  );
  
  counter_4b u_bc (
    .p_en(1'b1),
    .t_en(1'b1),
    .ld_n(1'b1),
    .clk(clk_bar),
    .clr_n(clr_bar && y[5] ),
    .data_out({not_used, a2,a1,a0})
    
  );
  
  decoder_3b u_138 (
    .a(a0),
    .b(a1),
    .c(a2),
    .g1(1'b1),
    .g2a(1'b0),
    .g2b(1'b0),
    .y(y)
  );
  
endmodule