/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements single JK flip-flop (submodule for other modules)
 */

module JK_FF(
    input clk,      // Clock
    input J,        // J input (active low)
    input K,        // K input (active low)
    output reg Q,   // Q output
    output Qn       // Qn output
);

    // Qn is simply the complement of Q
    assign Qn = ~Q;

    // Always block triggered on the positive edge of the clock
    always @(posedge clk) begin
        if (~J && K) begin
            Q <= 1;            // Set Q when J=0 and K=1
        end else if (J && ~K) begin
            Q <= 0;            // Reset Q when J=1 and K=0
        end else if (~J && ~K) begin
            Q <= ~Q;           // Toggle Q when J=0 and K=0
        end
        // No action when J=1 and K=1, retains the current state of Q
    end

endmodule