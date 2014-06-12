#!/bin/bash
# Copyright 2013
# Charles Steinkuehler <charles@steinkuehler.net>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA

dtbo_err () {
	echo "Error loading device tree overlay file: $DTBO" >&2
	exit 1
}

pin_err () {
	echo "Error exporting pin:$PIN" >&2
	exit 1
}

dir_err () {
	echo "Error setting direction:$DIR on pin:$PIN" >&2
	exit 1
}

SLOTS=/sys/devices/bone_capemgr.*/slots

# Make sure required device tree overlay(s) are loaded
for DTBO in cape-universal cape-bone-iio ; do

	if grep -q $DTBO $SLOTS ; then
		echo $DTBO overlay found
	else
		echo Loading $DTBO overlay
		sudo -A su -c "echo $DTBO > $SLOTS" || dtbo_err
		sleep 1
	fi
done;

if [ ! -r /sys/devices/ocp.*/helper.*/AIN0 ] ; then
	echo Analog input files not found in /sys/devices/ocp.*/helper.* >&2
	exit 1;
fi

if [ ! -r /sys/class/uio/uio0 ] ; then
	echo PRU control files not found in /sys/class/uio/uio0 >&2
	exit 1;
fi

# Export GPIO pins:
# One pin needs to be exported to enable the low-level clocks for the GPIO
# modules (there is probably a better way to do this)
# 
# Any GPIO pins driven by the PRU need to have their direction set properly
# here.  The PRU does not do any setup of the GPIO, it just yanks on the
# pins and assumes you have the output enables configured already
# 
# Direct PRU inputs and outputs do not need to be configured here, the pin
# mux setup (which is handled by the device tree overlay) should be all
# the setup needed.
# 
# Any GPIO pins driven by the hal_bb_gpio driver do not need to be
# configured here.  The hal_bb_gpio module handles setting the output
# enable bits properly.  These pins _can_ however be set here without
# causing problems.  You may wish to do this for documentation or to make
# sure the pin starts with a known value as soon as possible.

sudo $(which config-pin) -f - <<- EOF

	P8.07	in+	# E-Stop
	P8.08	low	# Spindle
	P8.09	in+	# Cycle Start
	P8.10	high    # PWS_ON, active low
        P8.12   low     # Stepper Enable

	P9.23	in+	# X Home
	P9.24	low	# Z Dir
	P9.25	in+	# Y Home
	P9.26	low	# Z Step
	P9.27	in+	# Z Home
	P9.28	low	# Y Dir
	P9.29	low	# X Dir
	P9.30	low	# Y Step
	P9.31	low	# X Step

EOF

