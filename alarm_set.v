
module alarm_set(count,reset_in,enable_input,set_alarm,
						set_h,set_m,input_hours,input_minutes,
						start_ring,ring_stop);
input count, reset_in, set_alarm, enable_input,ring_stop;
input [5:0]input_hours,input_minutes;
input [5:0]set_h,set_m;
output reg start_ring;
reg alarm_h,alarm_m;


wire [11:0]input_set_time,input_time;
assign input_set_time = {set_h,set_m};
assign input_time = {input_hours,input_minutes};
reg [11:0]alarm_time;
reg en;

always @(posedge count or posedge reset_in) begin
	if(reset_in)
		alarm_time = 12'd8191;
	else
		alarm_time = set_alarm? input_set_time : 12'd8191;
	
end

always @(posedge count or posedge reset_in) begin
	if (reset_in)
		start_ring <= 1'b0;
	else begin
		if (en)
			start_ring <= (start_ring? (~ring_stop) : (alarm_time == input_time)) & (~alarm_time[11]);
		else
			start_ring <= 1'b0;
	end
end

always @(posedge count ) begin
	if (alarm_time == input_time)
		en <= ring_stop ? 1'b0: en;
	else
		en <= enable_input;
end
endmodule
