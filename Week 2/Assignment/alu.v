// Week 2 — 8-bit ALU
// op: 000=ADD 001=SUB 010=AND 011=OR 100=XOR 101=SHIFTL 110=SHIFTR
// Run: iverilog -o sim ../testbenches/tb_alu.v alu.v && vvp sim

module alu(
    input  [7:0]     a, b,
    input  [2:0]     op,
    output reg [7:0] result,
    output           zero,
    output reg       carry,
    output reg       overflow
);
    // 9-bit working values so we can grab the carry-out of bit 7
    reg [8:0] add_res;
    reg [8:0] sub_res;

    always @(*) begin
        // Defaults — every path below either keeps or overrides these
        result   = 8'h00;
        carry    = 1'b0;
        overflow = 1'b0;

        add_res = {1'b0, a} + {1'b0, b};
        sub_res = {1'b0, a} - {1'b0, b};

        case (op)
            3'b000: begin                                   // ADD
                result   = add_res[7:0];
                carry    = add_res[8];                      // unsigned carry-out
                overflow = (a[7] == b[7]) && (result[7] != a[7]);
            end
            3'b001: begin                                   // SUB (a - b)
                result   = sub_res[7:0];
                carry    = sub_res[8];                      // borrow-out
                overflow = (a[7] != b[7]) && (result[7] != a[7]);
            end
            3'b010: result = a & b;                         // AND
            3'b011: result = a | b;                         // OR
            3'b100: result = a ^ b;                         // XOR
            3'b101: begin                                   // SHIFTL by 1
                result = a << 1;
                carry  = a[7];                              // bit shifted out
            end
            3'b110: begin                                   // SHIFTR by 1
                result = a >> 1;
                carry  = a[0];                              // bit shifted out
            end
            default: result = 8'h00;
        endcase
    end

    assign zero = (result == 8'h00);
endmodule