/*
 * Copyright (c) 2024 WAT.ai Chip Team
 * SPDX-License-Identifier: Apache-2.0
 * Implements SN74LS107 Dual J-K flip flops
 */

module dual_JK (
    input wire [1:0] clk, 
    input wire [1:0] clr_n,
    input wire [1:0] J,
    input wire [1:0] K,
    output reg [1:0] Q,
    output reg [1:0] Q_n
);

    always @(posedge clk[0]) begin
        if (~clr_n[0]) begin                    // Clear
            Q[0] <= 0;
            Q_n[0] <= 1;
        end else begin
            if (J[0] && K[0]) begin             // Toggle
                Q[0] <= ~Q[0];
                Q_n[0] <= ~Q_n[0];
            end else if (~J[0] && K[0]) begin   // Reset
                Q[0] <= 0;
                Q_n[0] <= 1;
            end else if (J[0] && ~K[0]) begin   // Set
                Q[0] <= 1;
                Q_n[0] <= 0;
            end else if (~J[0] && ~K[0]) begin  // No change
                Q[0] <= Q[0];
                Q_n[0] <= Q_n[0];
            end
        end
    end

    always @(posedge clk[1]) begin
        if (~clr_n[1]) begin                    // Clear
            Q[1] <= 0;
            Q_n[1] <= 1;
        end else begin
            if (J[1] && K[1]) begin             // Toggle
                Q[1] <= ~Q[1];
                Q_n[1] <= ~Q_n[1];
            end else if (~J[1] && K[1]) begin   // Reset
                Q[1] <= 0;
                Q_n[1] <= 1;
            end else if (J[1] && ~K[1]) begin   // Set
                Q[1] <= 1;
                Q_n[1] <= 0;
            end else if (~J[1] && ~K[1]) begin  // No change
                Q[1] <= Q[1];
                Q_n[1] <= Q_n[1];
            end
        end
    end

endmodule