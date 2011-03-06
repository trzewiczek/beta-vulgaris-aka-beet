# Copyright (c) 2011, Krzysztof Trzewiczek
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification,are permitted provided that the following conditions are met:
#
#   * Redistributions of source code must retain the above copyright notice,
#     this list of conditions and the following disclaimer.
#   * Redistributions in binary form must reproduce the above copyright notice,
#     this list of conditions and the following disclaimer in the documentation
#     and/or other materials provided with the distribution.
#   * Neither the name of the Centrum Cyfrowe nor the names of its contributors
#     may be used to endorse or promote products derived from this software
#     without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
# THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#

import pypm
import liblo
import sys

def osc_init():
    if len( sys.argv ) == 2:
        port = int( sys.argv[1] )
    else:
        port = 5600

    try:
        osc_target = liblo.Address( port )
    except liblo.AddressError, err:
        print str( err )
        sys.exit()

    midi_input_loop( osc_target )

def print_midi_devices():
    for device in range( pypm.CountDevices() ):
        interface, name, i, o, opened = pypm.GetDeviceInfo( device )
        print '[', device, '] ', name, " ",
        if (i == 1):
            print "(input) ",
        else:
            print "(output) ",
        print

def midi_input_loop( osc_target ):
    print_midi_devices()
    device = int( raw_input( "Type input number: " ))
    midi_in = pypm.Input( device )

    while True:
        while not midi_in.Poll():
            pass

        midi_data = midi_in.Read( 1 )
        control = midi_data[0][0][1]
        value = midi_data[0][0][2]
        print control, ': ', value

        liblo.send( osc_target, "/midi/"+str(control), value )

    del midi_in


if __name__ == '__main__':
    pypm.Initialize()
    osc_init()
    pypm.Terminate()
