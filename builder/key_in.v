`ifndef _key_in
`define _key_in

`include "posedge_detector.v"

module key_in (
  input wire clk, i_sclr, i_en,
  // key0, key1, key2, key3, key4
  input wire i_key_right_n, i_key_down_n, i_key_left_n, i_key_char_n, i_key_backspace_n,
  output wire o_type,
  output wire [7:0] o_asciiex,
  output wire o_asciiex_en
);

  wire s_char_en, s_backspace_en;
  wire s_right_en, s_down_en, s_left_en;

  parameter BITS = 3;
  parameter TRIGGER = 3'b011;

  // arrow key
  posedge_detector #(BITS, TRIGGER) posedge_right(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_right_n),
    .o_posedge(s_right_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_down(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_down_n),
    .o_posedge(s_down_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_left(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_left_n),
    .o_posedge(s_left_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_char(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_char_n),
    .o_posedge(s_char_en)
  );

  posedge_detector #(BITS, TRIGGER) posedge_backspace(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en), .i_dat(~i_key_backspace_n),
    .o_posedge(s_backspace_en)
  );

  // BS or 'a'
  assign o_asciiex = asciiex(s_char_en, s_backspace_en, s_right_en, s_down_en, s_left_en);
  assign o_type = s_char_en | s_backspace_en;
  assign o_asciiex_en = s_char_en | s_backspace_en | s_right_en | s_down_en | s_left_en;

  function [7:0] asciiex;
    input char_en;
    input backspace_en;
    input right_en;
    input down_en;
    input left_en;
    begin
      if (backspace_en) begin
        asciiex = 8'h08;
      end else if (s_char_en) begin
        asciiex = 8'h41;
      end else if (s_right_en) begin
        asciiex = 8'h02;
      end else if (s_down_en) begin
        asciiex = 8'h03;
      end else if (s_left_en) begin
        asciiex = 8'h04;
      end
    end
  endfunction

endmodule

`endif
