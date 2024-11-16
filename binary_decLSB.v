module binary_decLSB(digit_s,decoded_bits);
input [3:0]digit_s;
output reg [6:0]decoded_bits;
always @(*) begin
case(digit_s)
4'b0000: decoded_bits=7'b0000001;
4'b0001: decoded_bits=7'b1001111;
4'b0010: decoded_bits=7'b0010010;
4'b0011: decoded_bits=7'b0000110;
4'b0100: decoded_bits=7'b1001100;
4'b0101: decoded_bits=7'b0100100;
4'b0110: decoded_bits=7'b0100000;
4'b0111: decoded_bits=7'b0001111;
4'b1000: decoded_bits=7'b0000000;
4'b1001: decoded_bits=7'b0000100;
default decoded_bits=7'b0000001;
endcase
end
endmodule
