module div400(clk50M, rst, clk400);
    input               clk50M, rst;
    output  reg         clk400;

    reg         [22:0]  count;

    always @(posedge clk50M or negedge rst)begin
        if (!rst) begin
            count <= 23'd0;
            clk400 <= 1'd0;
        end
        else begin
            if (count == 23'd62_500)begin
                count <= 23'd0;
                clk400 <= ~clk400;
            end
            else begin
                count <= count + 1'd1;
            end
        end
    end
endmodule 