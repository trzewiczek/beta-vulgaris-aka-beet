#!/bin/sh

UTILS="Utils/Globals Utils/Utils"
EVENTS="Events/KeyEvent Events/MidiEvent"
BEETS="Beets/Beet Beets/Looper Beets/Cutter Beets/Gainer Beets/Panner Beets/Stammer Beets/Threshold"


## To be used when working with jackd
#chuck $UTILS $EVENTS $BEETS main

## To be used when working with alsa
chuck-alsa $UTILS $EVENTS $BEETS  Utils/Loader main


