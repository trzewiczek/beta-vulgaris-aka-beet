public class Looper extends Beet
{
    int _num_files;
    int _current_file;
    SndBuf _looper[ Globals.MAX_BUFFERS ];
    string _files_names[ Globals.MAX_BUFFERS ];

    float _playback_speed;
    int _is_playing;
    
    Envelope _envelope;
    dur _env_duration;


    // Constructor
    { 
        5::ms => _env_duration;
        
        1.0 => _playback_speed;
        0   => _is_playing;
        
        _envelope @=> _output;
         dac      @=> _connect;
         
         _output   => _connect;
    }

    
    fun int add_file( string file_name )
    {
        file_name => _looper[ _num_files ].read;
        1 => _looper[ _num_files ].loop;
        
        file_name @=> _files_names[ _num_files ];
        1 +=> _num_files;

        return _num_files;
    }
    

    fun int length()
    {
        return _num_files;
    }
    
    
    fun int current_file( int file )
    {
        if( _is_playing == 1 )
        {
            // change the _attack and _release time to 1::ms
            1::ms => _envelope.duration;

            stop();
            
            _looper[ _current_file ] =< _envelope;
            file => _current_file;
            _looper[ _current_file ] => _envelope;            

            play();

            // bring back the previous _attack and _release values
            _env_duration => _envelope.duration;
        }
        else
        {
            _looper[ _current_file ] =< _envelope;
            file => _current_file;
            _looper[ _current_file ] => _envelope;            
        }

        return _current_file;
    }

    
    // increase _playback_speed by 0.005
    fun float increase_speed()
    {
        0.005 +=> _playback_speed;
        if( _playback_speed > 4.0 )
        {
            4 => _playback_speed;
        }

        _playback_speed => _looper[ _current_file ].rate;

        return _playback_speed;
    }

    
    // decrease _playback_speed by 0.005    
    fun float decrease_speed()
    {
        0.005 -=> _playback_speed;
        if( _playback_speed < -4.0 )
        {
            -4 => _playback_speed;
        }

        _playback_speed => _looper[ _current_file ].rate;

        return _playback_speed;
    }


    // set speed to an arbitrary value (no range defined!)
    fun void set_speed( float new_speed )
    {
        new_speed => _playback_speed;
        _playback_speed => _looper[ _current_file ].rate;
    }
    
    
    // change the output to which the sound is directed
    fun UGen connect( UGen new_connect )
    {
        // change the _attack and _release time to 1::ms
        5::ms => _envelope.duration;
        stop();

        _output =< _connect;
        _output => new_connect;
        
        play();
        // bring back the previous _attack and _release values
        _env_duration => _envelope.duration;

        new_connect @=> _connect;        
        
        return _connect;
    }

    
    // play the buffer with attack => rampUp
    fun void play()
    {
        _playback_speed => _looper[ _current_file ].rate;
        
        _envelope.keyOn();
        _envelope.duration() => now;
            
        ( spork ~ local_loop() ).id() => _loop_id;
        1 => _is_playing;
    }
    

    // stop the file with release => rampDown 
    fun void stop()
    {
        _envelope.keyOff();
        _envelope.duration() => now;

        Machine.remove( _loop_id );
        Globals.NONE => _loop_id;
        0 => _is_playing;        
    }


    fun void show_current_state()
    {
        <<< "File:", _files_names[ _current_file ] >>>;
        <<< "Playback speed:", _playback_speed >>>;
    }        
}
