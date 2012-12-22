import pypm
import liblo
import sys

import Tkinter
import threading


class MyTkApp(threading.Thread):
    def __init__(self):
        threading.Thread.__init__(self)
        self.start()

    def run(self):
        self.root = Tkinter.Tk()
        self.root.mainloop()

    def handle_midi(self, channel, control, value):
        print channel, control, value

def print_midi_devices():
    for device in range(pypm.CountDevices()):
        interface, name, i, o, opened = pypm.GetDeviceInfo(device)

        print '[%s] %s (%s)' % (device, name, 'input' if i else 'output')


def midi_input_loop(gui, osc_target):
    pypm.Initialize()
    print_midi_devices()
    device = int(raw_input("Type input number: "))
    midi_in = pypm.Input(device)

    while True:
        while not midi_in.Poll():
            pass

        midi_data = midi_in.Read(1)
        channel   = midi_data[0][0][0]
        control   = midi_data[0][0][1]
        value     = midi_data[0][0][2]

        liblo.send(osc_target, "/midi/%s/%s" % (channel, control), value)
        gui.handle_midi(channel, control, value)

    del midi_in


def init_osc():
    port = int(sys.argv[1]) if len(sys.argv) == 2 else 5600

    try:
        osc_target = liblo.Address(port)
    except liblo.AddressError, err:
        print str(err)
        sys.exit()

    return osc_target


if __name__ == '__main__':

    midi_input_loop(MyTkApp(), init_osc())

