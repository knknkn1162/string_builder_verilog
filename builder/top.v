`ifndef _top
`define _top

`include "key_in.v"
`include "hex_decoder.v"

module top (
  input wire clk, i_sclr,
  // key0, key1, key2, key3, key4
  input wire i_key_right_n, i_key_down_n, i_key_left_n, i_key_char_n, i_key_backspace_n,
  output wire [6:0] o_hex0, o_hex1,
  output wire [3:0] o_ledr
);

  wire [7:0] s_ascii;

  key_in key_in0 (
    .clk(clk), .i_sclr(i_sclr), .i_en(1'b1),
    .i_key_right_n(i_key_right_n), .i_key_down_n(i_key_down_n), .i_key_left_n(i_key_left_n), .i_key_char_n(i_key_char_n), .i_key_backspace_n(i_key_backspace_n),
    .o_ascii(s_ascii),
    .o_ascii_en(o_ledr[0]),
    .o_right_en(o_ledr[1]),
    .o_down_en(o_ledr[2]),
    .o_left_en(o_ledr[3])
  );

  hex_decoder hex_decoder0 (
    .i_num(s_ascii[3:0]),
    .o_seg7(o_hex0)
  );

  hex_decoder hex_decoder1 (
    .i_num(s_ascii[7:4]),
    .o_seg7(o_hex1)
  );

endmodule


`endif
