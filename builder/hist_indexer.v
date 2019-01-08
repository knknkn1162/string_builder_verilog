`ifndef _history_indexer
`define _history_indexer

`include "constants.v"
`include "flopr_en.v"

module history_indexer (
  input wire clk, i_sclr, i_en,
  input wire i_type,
  input wire [7:0] i_asciiex,
  output wire [`HISTRAM_ADDR_WIDTH-1:0] o_idx
);

  localparam ADDR_WIDTH = `HISTRAM_ADDR_WIDTH;
  wire [ADDR_WIDTH-1:0] s_idx0, s_idx1;

  flopr_en #(ADDR_WIDTH) flopr_idx(
    .clk(clk), .i_sclr(i_sclr), .i_en(i_en),
    .i_a(s_idx0), .o_y(s_idx1)
  );

  assign s_idx0 = s_idx1 + 1'b1;

  assign o_idx = s_idx1;

endmodule

`endif
