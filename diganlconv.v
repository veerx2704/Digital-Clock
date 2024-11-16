module am_pm_conv(hours_input,am_pm_form,hour_format,h_digit_0,h_digit_1);
input [5:0]hours_input;
input hour_format;
output am_pm_form;
output [3:0]h_digit_0,h_digit_1;
wire [5:0]hour_12_form;
wire [5:0]hour_24_formsub;
assign hour_24_formsub = hours_input - 6'd12;
assign am_pm_form = (hour_format ? (hours_input >= 6'd12): 1'bz);
assign hour_12_form = hour_format ?(( hours_input == 6'd0 || hours_input== 6'd12 )? 6'd12 : ( ( am_pm_form )? hour_24_formsub : hours_input)) : hours_input;
assign h_digit_1 = hour_12_form/10;
assign h_digit_0 = hour_12_form-(h_digit_1*10);
endmodule
