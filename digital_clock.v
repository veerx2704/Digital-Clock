module digital_clock(clk_50M,reset_all,set_time_button,hour_format,am_pm,
							SECONDS_DISP_0,MINUTES__DISP_0,HOURS_DISP_0,
							SECONDS_DISP_1,MINUTES__DISP_1,HOURS_DISP_1,
							enable_alarm,set_alarm_button,hour_alarm,minute_alarm,end_alarm,ring,trigger_out_alarm,trigger_out_time);
input clk_50M,reset_all,hour_format,enable_alarm,set_alarm_button,end_alarm,set_time_button;
reg [5:0]seconds,minutes,hours;
input [5:0]hour_alarm,minute_alarm;
reg reset_sec,reset_min,reset_hour;
wire x,y;
output am_pm,ring,trigger_out_alarm,trigger_out_time;
wire [3:0]s0,s1,m0,m1,h0,h1;
output [6:0]SECONDS_DISP_0,MINUTES__DISP_0,HOURS_DISP_0;
output [6:0]SECONDS_DISP_1,MINUTES__DISP_1,HOURS_DISP_1;
reg [24:0]temp;
reg count;
reg trigger_alarm,trigger_time;
always @(posedge clk_50M) begin  // Adjusting 50MHz clock to 1Hz clock
	if (reset_all==1) begin
		if (temp==25'd24999999) begin
			temp <= 25'd0;
			count <=count +1;
		end
		else begin
			temp <=temp + 1;
			count <= count;
		end
	end
	else if(reset_all==0) begin
		temp <= 0;
		count <=0;
	end
end
always @(posedge count or negedge reset_all) begin
	if (reset_all==0) begin
		trigger_alarm <= 0;
		trigger_time <= 0;
	end
	else begin
		if (~set_time_button) 
			trigger_time <= trigger_time +1;
		else
			trigger_time <= trigger_time;
		if(~set_alarm_button)
			trigger_alarm <= trigger_alarm + 1;
		else
			trigger_alarm <= trigger_alarm;
	end
end
always @(posedge count or negedge reset_all) begin
	if (reset_all==0) begin  // input reset
		reset_sec <= 1;
		reset_min <= 1;
		reset_hour <= 1;
		seconds <= 0;
		minutes <=0;
		hours <=0;
	end
	else begin
	if (trigger_time==1)begin  // SET TIME
		hours <= hour_alarm;
		minutes <= minute_alarm;
	end
	else begin   // Increment time
		if (seconds == 6'd59) // RESET SECONDS AFTER EVERY 60 CYCLES
			reset_sec = 1;
		else
			reset_sec = 0;
		if (reset_sec==0)
			seconds <= seconds + 1; // INCREMENT SECONDS UNTIL RESET
		else if(reset_sec == 1)
			seconds <= 0;


		if (minutes == 6'd59 && reset_sec ==1)  // RESET MINUTES AFTER EVERY 60 MINUTE CYCLES WHEN SECOND IS RESET 
			reset_min = 1;
		else
			reset_min = 0;
		if (reset_min == 0 && reset_sec == 1) 
			minutes <= minutes + 1;  // INCREMENT MINUTES UNTIL RESET
		else if(reset_min == 1)
			minutes <= 0;

		if (hours == 6'd23 && reset_min ==1)  // RESET HOURS AFTER EVERY 60 HOUR CYCLES WHEN MINUTE IS RESET
			reset_hour = 1;
		else 
			reset_hour = 0;
		if (reset_hour == 0 && reset_min == 1)  // INCREMENT WHEN MINUTE IS RESET, UNTIL HOUR IS RESET
			hours <= hours +1;
		else if(reset_hour == 1)
			hours <= 0;
	end
	end
end
assign trigger_out_time = trigger_time;
assign trigger_out_alarm = trigger_alarm;
am_pm_conv HOURS(hours,am_pm,hour_format,h0,h1);  	// CONVERTS THE BINARY CODE OF HOURS TO BCD CODES ACCORDING TO ADJUSTMENT OF HOUR FORMAT
am_pm_conv MINUTES(minutes,x,hours[5],m0,m1);	  	// CONVERTS THE BINARY CODE OF MINUTES TO BCD CODES
am_pm_conv SECONDS(seconds,y,hours[5],s0,s1);		// CONVERTS THE BINARY CODE OF SECONDS TO BCD CODES
binary_decLSB SEC0(s0,SECONDS_DISP_0);					// BCD TO 7 SEGMENT INTERFACING OF LOWER DIGIT OF SECOND
binary_decLSB SEC1(s1,SECONDS_DISP_1);					// BCD TO 7 SEGMENT INTERFACING OF UPPER DIGIT OF SECOND
binary_decLSB MIN0(m0,MINUTES__DISP_0);				// BCD TO 7 SEGMENT INTERFACING OF LOWER DIGIT OF MINUTE
binary_decLSB MIN1(m1,MINUTES__DISP_1);				// BCD TO 7 SEGMENT INTERFACING OF UPPER DIGIT OF MINUTE
binary_decLSB HOUR0(h0,HOURS_DISP_0);					// BCD TO 7 SEGMENT INTERFACING OF LOWER DIGIT OF HOUR
binary_decLSB HOUR1(h1,HOURS_DISP_1);					// BCD TO 7 SEGMENT INTERFACING OF UPPER DIGIT OF HOUR
alarm_set ALARM(count,~reset_all,enable_alarm,trigger_alarm,hour_alarm,minute_alarm,hours,minutes,ring,~end_alarm); // MODULE FOR SETTING ALARM
endmodule





