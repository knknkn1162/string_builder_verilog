`ifndef _top
`define _top

`include "key_in.v"
`include "hex_decoder.v"
// for debug
`include "flopr_en.v"
`include "toggle.v"

module top (
  input wire clk, i_sclr,
  // key0, key1, key2, key3, key4
  input wire i_key_right_n, i_key_down_n, i_key_left_n, i_key_char_n, i_key_backspace_n,
  output wire [6:0] o_hex0, o_hex1,
  output wire [3:0] o_ledr
);

  wire [7:0] s_ascii0, s_ascii1;
  wire [4:0] s_ledr_en;

  key_in key_in0 (
    .clk(clk), .i_sclr(i_sclr), .i_en(1'b1),
    .i_key_right_n(i_key_right_n), .i_key_down_n(i_key_down_n), .i_key_left_n(i_key_left_n), .i_key_char_n(i_key_char_n), .i_key_backspace_n(i_key_backspace_n),
    .o_ascii(s_ascii0), .o_ascii_en(s_ledr_en[0]),
    .o_right_en(s_ledr_en[1]),
    .o_down_en(s_ledr_en[2]),
    .o_left_en(s_ledr_en[3])
  );

  // for debug
  genvar i;
  generate
    for(i = 0; i < 3; i=i+1) begin: gen_ledr
      toggle #(1'b0) toggle0 (
        .clk(clk), .i_sclr(i_sclr), .i_en(s_ledr_en[i]),
        .o_sw(o_ledr[i])
      );
    end
  endgenerate

  flopr_en #(8) flopr_ascii (
    .clk(clk), .i_sclr(i_sclr), .i_en(s_ledr_en[0]),
    .i_a(s_ascii0),
    .o_y(s_ascii1)
  );
  hex_decoder hex_decoder0 (
    .i_num(s_ascii1[3:0]),
    .o_seg7(o_hex0)
  );
  hex_decoder hex_decoder1 (
    .i_num(s_ascii1[7:4]),
    .o_seg7(o_hex1)
  );

endmodule


`endif
