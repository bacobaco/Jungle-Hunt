https://gswv.apple2.org.za/a2zine/GS.WorldView/Resources/ARTICLES/A2.to.PC.Joystick.Conversion.ht

Apple2-to-PC Joystick Conversion

by Jeff Hurlburt
EMail:rubywand@aol.com


Below are pin-outs and info for Apple II and PC joysticks. As you can see, there
are three major points of difference:

1. The Apple II stick uses a 9-pin plug vs. the PC's 15-pin plug. (Older Apple II
sticks may use a 16-pin plug which fits in an IC socket.)

2. The Apple II stick's X, Y controller potentiometers are a bit larger.

3. The buttons are wired differently.


You can use an Apple-to-PC adaptor (such as the one supplied with the Epyx A2/PC
joystick) to handle plug conversion; or, you can replace the entire cable with
one from an old PC stick.

The PC joystick interface will work with the Apple2 150k pots; but, in some
applications, you may notice a tendency to max out early in the stick swing. You
can correct this by connecting a 300k resistor across each pot (from the center
to the end with a wire going to it).

The difference in button wiring is the main reason an Apple-to-PC conversion
involves opening the joystick and making changes. (The Apple stick has a slightly
more complex, less flexible circuit. Apple-to-PC is not as easy as PC-to-Apple.)

Basically, you need to change the Apple stick's button wiring so that it looks
like the PC stick's button wiring.

The mods mentioned above are not difficult, especially if you swap in a PC cable.
If you want to be able to use the stick on an Apple II, then some kind of
switching will be required.


Apple II Joystick

(9-pin male connector) (Old 16-pin IC-style plug)

[2]--------------- +5V ------- 1
[7]--------------- Button 0 ------- 2
[5]--------------- X-axis ------- 6
[8]--------------- Y-axis ------- 10
[1]--------------- Button 1 ------- 3
[3]--------------- Ground ------ 8



PC Joystick

(15-pin female connector)

[1]--------------- +5V
[2] -------------- Button 0
[3] -------------- X-axis
[6] -------------- Y-axis
[7] -------------- Button 1
[4] and/or [5] Ground


Both sticks tie one end of each X, Y potentiometer to +5 and send the center
(wiper) to the an output. (Or the wiper may go to +5V and an end to the output;
it doesn't much matter.) The standard Apple II pot is 150K Ohms; most PC sticks
use 100k Ohm pots.

The buttons are wired differently.

On the Apple II stick (see below), each button switch goes to +5V. The other end
goes to GND through a resistor (one resistor for each button). A button's Output
is from the junction of the switch and its resistor. When the button switch is
not closed, its Output is near 0V (=logic 0). Pressing a button sends +5V to the
output (= logic 1).

+5V
|
|
X Button Switch
|
|_____Button output to Apple (Press => "1") |
Z
Z 680 Ohm resistor
Z
|
GND


As shown below, a PC stick button Output is normally an unconnected wire. Most
likely, inside the computer, a PC or compatible Game Port has this line tied to a
1k-3k resistor going to +5V. So, the line will normally be at something close to
+5V (= logic 1). Pressing the button grounds the line and pulls it down near to
0V (= logic 0).

_____Button output to PC (Press => "0")
|
|
X Button Switch
|
|
GND



Send EMail, corrections, comments and questions to:R/\/\/
