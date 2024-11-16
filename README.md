# Digital-Clock
Synthesis of Digital Clock
Hello!
This project was implemented by me at my university and utilizes Verilog HDL as the language.
The main module contains the basic operation of clock i.e. setting up desired time, resetting time to 00:00, invoking the alarm etc.
There is a decoding module which is useful for interfacing with 7-segment LEDs.
The board on which it was implemented used a 50MHz clock and hence, the code was customized for that frequency. 
To customize the code for any other frequency, use this formula:\\
F = (freq/2) - 1
Put this value of F in the main file (digital_clock.v) at line 19, with temp == F in the if block
