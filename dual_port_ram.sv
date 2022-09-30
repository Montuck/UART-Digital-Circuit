module dual_port_ram #(
    parameter ADDR_WIDTH=10,
    parameter DATA_WIDTH=32
)(
    input wire logic clk_a,
    input wire logic clk_b,
    input wire logic en_a,
    input wire logic en_b,
    input wire logic we_a,
    input wire logic we_b,
    input wire logic    [ADDR_WIDTH-1:0]    addr_a,
    input wire logic    [ADDR_WIDTH-1:0]    addr_b,
    input wire logic    [DATA_WIDTH-1:0]    data_in_a,
    input wire logic    [DATA_WIDTH-1:0]    data_in_b,
    output logic        [DATA_WIDTH-1:0]    data_out_a,
    output logic        [DATA_WIDTH-1:0]    data_out_b
);

logic   [DATA_WIDTH-1:0]    ram [(2**ADDR_WIDTH)-1:0];

always_ff @(posedge clk_a) begin
    if (en_a) begin
        if (we_a)
            ram[addr_a] <= data_in_a;
        data_out_a <= ram[addr_a];
    end
end

always @(posedge clk_b) begin
    if (en_b) begin
        if (we_b)
            ram[addr_b] <= data_in_b;
        data_out_b <= ram[addr_b];
    end
end
endmodule
