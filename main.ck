/**
 * This is an example main.ck file. It way produced
 * as a main file to play my concerts, so everything
 * is working and tested. The problem with it and
 * the rest of classes is that ChucK supports 
 * Mac OSX *much* better than other platforms
 * Linux is the least supported. This is why 
 * SndBuf was used instead of LiSa. 
 * Some bugs and strange "shortcuts" can be
 * the ffect of that situation. At the moment
 * the main problem with Beta Vulgaris is:
 *
 *   1. Lack of perlin noise in ChucK. I use simple
 *      applet written in Processing and sending
 *      perlin noise control signal via OSC
 *
 *   2. MIDI can't handle two MIDI events at one time
 *      It's horrible, so in future MIDI-to-OSC
 *      interface will be produced in Processing or sth. 
 *
 * Have fun!!
 */

// midi communication
MidiIn midi_in;
MidiMsg midi_msg;
// midi event
MidiEvent midi_event;

// keyboard communication
KBHit kb;
// keyboard event
KeyEvent e;

// osc receiver
// all osc events in this code come from Processing applet
// that produces 1Dimensional perlin noise
// Maybe in future it will provide an interface to
// malfunctioning MIDI control
OscRecv osc_receiver;
5601 => osc_receiver.port;
osc_receiver.listen();


Looper looper[ Globals.NUM_OF_TRACKS ];
Cutter cutter[ Globals.NUM_OF_TRACKS ];
Panner panner[ Globals.NUM_OF_TRACKS ];
Threshold threshold[ Globals.NUM_OF_TRACKS ];
Stammer stammer[ Globals.NUM_OF_TRACKS ];
Gainer gainer[ Globals.NUM_OF_TRACKS ];
Gain master[ Globals.NUM_OF_TRACKS ];

Gain left, right;

for( 0 => int i; i < Globals.NUM_OF_TRACKS; ++i )
{
    looper[ i ].play();
    looper[ i ] => Loader.load_sound_files;
    
    cutter[ i ].play();
    osc_receiver.event( "/f" + (i+1) + ",f" ) => panner[ i ].osc_event;
    panner[ i ].play();
    threshold[ i ].play();
    stammer[ i ].play();
    osc_receiver.event( "/f" + (i+21) + ",f" ) => gainer[ i ].osc_event;
    gainer[ i ].play();
}


{ // track 0
  // this code has to be reimplemented as a separate class!!    
    looper[ 0 ].connect( stammer[ 0 ] );
    stammer[ 0 ].connect( master[ 0 ] );
    master[ 0 ] => dac;
}
{ // track 1 
    looper[ 1 ].connect( master[ 1 ] );
    master[ 1 ] => dac;    
}
{ // track 2
    looper[ 2 ].connect( master[ 2 ] );
    master[ 2 ] => dac;    
}
{ // track 3
  // this code has to be reimplemented as a separate class!!    
    looper[ 3 ].connect( cutter[ 3 ] );
    cutter[ 3 ].connect( threshold[ 3 ] );
    threshold[ 3 ].connect( gainer[ 3 ] );
    gainer[ 3 ].connect( master[ 3 ] );
    master[ 3 ] => panner[ 3 ].input();
    panner[ 3 ].connect( dac );
}
{ // track 4
  // this code has to be reimplemented as a separate class!!    
    looper[ 4 ].connect( cutter[ 4 ] );
    cutter[ 4 ].connect( threshold[ 4 ] );
    threshold[ 4 ].connect( gainer[ 4 ] );
    gainer[ 4 ].connect( master[ 4 ] );
    master[ 4 ] => panner[ 4 ].input();
    panner[ 4 ].connect( dac );
}
{ // track 5
  // this code has to be reimplemented as a separate class!!
    Delay d1, d2, d3;

    15005::ms => d1.max => d2.max => d3.max;
    5::second => d1.delay;
    10::second => d2.delay;
    15::second => d3.delay;

    Cutter c1, c2, c3;
    4.0 => c1.set_freq;
    8.0 => c1.set_freq;
    15.0 => c1.set_freq;    
    c1.play();
    c2.play();
    c3.play();    

    Gainer g1, g2, g3;
    osc_receiver.event( "/f" + 11 + ",f" ) => g1.osc_event;
    osc_receiver.event( "/f" + 12 + ",f" ) => g2.osc_event;
    osc_receiver.event( "/f" + 13 + ",f" ) => g3.osc_event;    
    g1.play();
    g2.play();
    g3.play();    
    
    Panner p1, p2, p3;
    osc_receiver.event( "/f" + 14 + ",f" ) => p1.osc_event;
    osc_receiver.event( "/f" + 15 + ",f" ) => p2.osc_event;
    osc_receiver.event( "/f" + 16 + ",f" ) => p3.osc_event;    
    p1.play();
    p2.play();
    p3.play();    

    
    looper[ 5 ].connect( cutter[ 5 ] );
    looper[ 5 ]._output => d1;
    d1 => c1.input();
    looper[ 5 ]._output => d2;
    d2 => c2.input();    
    looper[ 5 ]._output => d3;
    d3 => c3.input();

    cutter[ 5 ].connect( gainer[ 5 ] );
    c1.connect( g1 );
    c2.connect( g2 );
    c3.connect( g3 );
    
    gainer[ 5 ].connect( panner[ 5 ] );
    g1.connect( p1 );
    g2.connect( p2 );
    g3.connect( p3 );

    // is it a bug that Pan2 goes mono
    // when connected to Gain?
    panner[ 5 ].connect_left( left );
    panner[ 5 ].connect_right( right );
    p1.connect_left( left );
    p1.connect_right( right );
    p2.connect_left( left );
    p2.connect_right( right );
    p3.connect_left( left );
    p3.connect_right( right );

    left  => dac.left;
    right => dac.right;
}


// midi listener
spork ~ midi_listener();
spork ~ midi_handler( midi_event );


// main time loop
while( true )
{    
    1::samp => now;
}



// these function are here, because they need
// an acces to Beets and UGens on tracks
// to be completely re-implemented
// with event handlers inside classes
// just like with OSC messages
// possible solution is to write external MIDI-to-OSC
// interface as ChucK handles MIDI really bad
fun void midi_handler( MidiEvent e )
{
    float first_track_gain_reminder;
    int first_track_mute;

    float last_track_gain_reminder;
    int last_track_mute;
    
    while( true )
    {
        show_state();

        // wait for the midi event to come
        e => now;

        ( e.cc_number / 10 ) - 1 => int track_num;
        e.cc_number % 10 => int control_num;

        
        // first four controls have the same function
        // for all the tracs, so are handled by control_num
        
        //  V O L U M E
        if( control_num == 1 )
        {
            if( track_num == 0 && first_track_mute == 1)
            {
                Utils.map_midi( e.cc_value ) => first_track_gain_reminder;
                continue;
            }
            if( track_num == 5 )
            {
                if( last_track_mute == 1 )
                {
                    Utils.map_midi( e.cc_value ) => last_track_gain_reminder;
                }
                else
                {
                    Utils.map_midi( e.cc_value ) => left.gain;
                    Utils.map_midi( e.cc_value ) => right.gain;
                }
                continue;
            }

            Utils.map_midi( e.cc_value ) => master[ track_num ].gain;
            continue;
        }
        //  M U T E
        if( control_num == 2 )
        {
            if( track_num == 0 )
            {
                if( e.cc_value == 127 )
                {
                    master[ track_num ].gain() => first_track_gain_reminder;
                    0.0 => master[ track_num ].gain;
                    1 => first_track_mute;
                }
                else
                {
                    first_track_gain_reminder => master[ track_num ].gain;
                    0 => first_track_mute;
                }
                continue;
            }
            if( track_num == 5 )
            {
                if( e.cc_value == 127 )
                {
                    left.gain() => last_track_gain_reminder;
                    0.0 => left.gain;
                    0.0 => right.gain;
                    
                    1 => last_track_mute;
                }
                else
                {
                    last_track_gain_reminder => left.gain;
                    last_track_gain_reminder => right.gain;
                    
                    0 => last_track_mute;
                }
                continue;
            }

            Utils.map_midi( e.cc_value ) $ int => int mute;
            if( mute == 0 )
            {
                looper[ track_num ].play();
            }
            else
            {
                looper[ track_num ].stop();
            }
            continue;
        }
        if( control_num == 3 )
        {
            // nothing going on there
            continue;
        }
        //  F I L E   S E L E C T I O N
        if( control_num == 4 )
        {
            Utils.map_midi( e.cc_value, 0.0, looper[ track_num ].length() - 1.01 ) => float index;
            index $ int => looper[ track_num ].current_file;
            continue;
        }
        //  P L A Y B A C K   R A T E 
        if( control_num == 5 )
        {
            Utils.map_midi( e.cc_value, -2.0, 2.0 ) => looper[ track_num ].set_speed;
            continue;
        }
        
        // the rest of controls have different functions
        // for each track, so they are handled by track_num
        //  T R A C K 1
        //  T R A C K 2
        //  T R A C K 3        
        if( track_num == 0 && control_num == 6 )
        {
            Utils.map_midi( e.cc_value, 2.0, 9.0 ) => stammer[ track_num ].set_freq;
            continue;
        }
        if( track_num == 3 || track_num == 4 )
        {
            if( control_num == 7 )
            {
                Utils.map_midi( e.cc_value, 0.0, 1.0 ) => threshold[ track_num ].set_threshold;
                continue;
            }
            if( control_num == 8 )
            {
                Utils.map_midi( e.cc_value, 2.0, 25.0 ) => cutter[ track_num ].set_freq;
                continue;
            }            
        }
    }
}



fun void midi_listener()
{        
    if( !midi_in.open( 1 ) )
    {
        <<< ">>>", "MIDI can't be open" >>>;
        me.exit();
    }

    while( true )
    {
        midi_in => now;

        while( midi_in.recv( midi_msg ) )
        {
            // get cc number
            midi_msg.data2 => midi_event.cc_number;
            // get cc value
            midi_msg.data3 => midi_event.cc_value;

            // uncomment it to see, what is actually going on with MIDI
            // <<< midi_event.cc_number, "::", midi_event.cc_value >>>; 

            // broadcast new data
            midi_event.broadcast();
        }
    }
}


fun void show_state()
{
    Utils.clear_screen();
    
    for( 0 => int i; i < Globals.NUM_OF_TRACKS; ++i )
    {
        <<< "Track", (i+1) >>>;
        <<< looper[ i ].show_current_state() >>>;
        <<< "-------------", "-----------" >>>;
    }
}
