3 axis Interface board for Beaglebone Black tenatively called StepOneCNC 

Info:
Designed to support a 3 axis machine with a spindle or engraving head.


Features:
-Designed to play well with Machinekit (that is the hope anyway)
-uses standard ATX power supply with 24 pin connector
-Polulu DRV8825 based stepper drivers (jumpers to set microstep)
-3 digital inputs for homing prox switches (NC sinking)
-1 digital input (cycle start push button)
-1 digital input / stepper driver enable by NC locking push button (estop push button)
-1 transistor output for spindle/laser/relay/solenoid voltage selectable by jumper (5vdc or 12vdc)
-1 12vdc connection for lcd screen or fan

Board was designed in Eagle Lite 6.4.0 and meets OSH Park rule set.

Screen:
7" Capacitive multi-touch screen http://www.chalk-elec.com/?page_id=1280#!/~/product/category=3094861&id=21750201
Mini-HDMI to Micro-HDMI http://www.ebay.com/itm/6FT-1-8m-Mini-HDMI-to-Micro-HDMI-Cable-Cord-Full-HD-1080P-Adapter-Connector-/330909549723?pt=US_Video_Cables_Adapters&hash=item4d0bbf049b
Mini-USB to USB included with Beaglebone to connect Touch