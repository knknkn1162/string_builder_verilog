`ifndef _key_in
`define _key_in

`include "posedge_detector.v"

module key_in (
  input wire clk, i_sclr, i_en,
  // key0, key1, key2, key3, key4
  input wire i_key_right_n, i_key_down_n, i_key_left_n, i_key_char_n, i_key_backspace_n,
  output wire [7:0] o_ascii,
  output wire o_ascii_en,
  output wire o_right_en, o_down_en, o_left_en
);

  wire s_key_char_en, s_key_backspace_en;

  parameter BITS = 3;
  parameter TRIGGER = 3'b011;

  // arrow key
  posedge_detector #(BITS, TRIGGER) posedge_right(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_right_n),
    .o_posedge(o_right_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_down(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_down_n),
    .o_posedge(o_down_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_left(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_left_n),
    .o_posedge(o_left_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_char(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_char_n),
    .o_posedge(s_key_char_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_backspace(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_backspace_n),
    .o_posedge(s_key_backspace_en)
  );

  // BS or 'a'
  assign o_ascii = (s_key_backspace_en) ? 8'h08 : 8'h41;
  assign o_ascii_en = s_key_char_en | s_key_backspace_en;

endmodule

`endif
