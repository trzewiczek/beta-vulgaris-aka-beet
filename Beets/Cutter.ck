/*
 * This beet cuts the sound
 * with repetiting envelopes
 */

public class Cutter extends Beet
{
    Envelope _envelope;

    float _cut_freq;
    dur   _cut_duration;
    float _env_shape;


    // Constructor
    {
        0.5  => _env_shape;
        11.0 => _cut_freq;
        second / _cut_freq => _cut_duration;


        _envelope @=> _input;
        _envelope @=> _output;
         dac      @=> _connect;
         
        _output    => _connect;
    }


    fun void increase_freq()
    {
        if ( _cut_freq < 1.0 )
        {
            0.1 +=> _cut_freq;
        }
        else if( _cut_freq >= 1.0 && _cut_freq < 25.0 )
        {
            1.0 +=> _cut_freq;
        }
        1::second / _cut_freq => _cut_duration;        
    }        


    fun void decrease_freq()
    {
        if( _cut_freq >= 2.0 )
        {
            1.0 -=> _cut_freq;
        }
        else if ( _cut_freq >= 0.2 )
        {
            0.1 -=> _cut_freq;
        }
        1::second / _cut_freq => _cut_duration;     
    }        


    // set cuting freq to arbitrary value in range ( 2.0, 25.0 )
    fun float set_freq( float new_freq )
    {
        new_freq => _cut_freq;
        
        if( _cut_freq > 25.0 )
        {
            2.0 => _cut_freq;
        }
        else if ( _cut_freq < 2 )
        {
            2 => _cut_freq;
        }
        1::second / _cut_freq => _cut_duration;     
    }                

    // make attack smoother
    fun void increase_shape()
    {
        0.05 +=> _env_shape;
        if( _env_shape >= 1.0 )
        {
            0.99 => _env_shape;
        }
    }
        

    // sharpen attack
    fun void decrease_shape()
    {
        0.05 -=> _env_shape;
        if( _env_shape <= 0.0 )
        {
            0.01 => _env_shape;
        }
    }


    fun void show_current_state()
    {
        <<< "Cut freq:", _cut_freq >>>;
        <<< "Env shape:", _env_shape >>>;
    }        

    
    // private timeloop
    fun void local_loop()
    {
        while( true )
        {
            _cut_duration * _env_shape => dur on;
            _cut_duration - on => dur off;
            
            on => _envelope.duration;

            _envelope.keyOn();
            _envelope.duration() => now;

            off => _envelope.duration;
            
            _envelope.keyOff();
            _envelope.duration() => now;
        }
    }    
}

    
    
