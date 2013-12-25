Beet - Beta Vulgaris
====================
This is an alpha release of Beta Vulgaris aka Beet, a ChucK framework and
live electronics software.

It has been successfully tested on Fedora 13-14 GNU/Linux with default alsa
audio driver during two live performances.

Dependencies
------------
  python 2.x  
  pyportmidi
  pyliblo
  invoke (optional)


To use it as a live electronic software
---------------------------------------
  1. in terminal:
        $ python loader_generator.py <audio_files_path> <output_path>
     to create a loader class fullfilled with your audio samples

  2. in terminal:
        $ ./run.sh
     it works with a MIDI controller only at the moment, but soon it will 
     change providing keyboard, MIDI and OCS interfaces

To use it as a ChucK mini-framework
-----------------------------------
  1. read source files starting with Beet.ck 
  2. start building your own software
  3. let me know ;)


To contact me
-------------
krzysztof [at] trzewiczek info
