public class Stammer extends Beet
{
    Envelope _envelope;
    Delay _delay_line;
    
    float _cut_freq;
    dur   _cut_duration;


    // Constructor
    {
        5.0 => _cut_freq;
        second / _cut_freq => _cut_duration;

        1::second => _delay_line.max;
        5::ms => _envelope.duration;
        
        _delay_line @=> _input;
        _envelope  @=> _output;
         dac       @=> _connect;

        _input  => _output;
        _output => _connect;
    }


    fun void set_freq( float f )
    {
        f => _cut_freq;

        if( _cut_freq > 9 )
        {
            9 => _cut_freq;
        }
        else if( _cut_freq < 2 )
        {
            2 => _cut_freq;
        }
        1::second / _cut_freq => _cut_duration;
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

    
    // private timeloop
    fun void local_loop()
    {
        int i;
        while( true )
        {
            _envelope.keyOff();
            _envelope.duration() => now;

            Std.rand2f( 10.0, _delay_line.max()/ms )::ms => _delay_line.delay;
            
            _envelope.keyOn();
            _envelope.duration() => now;

            _cut_duration => now;
        }
    }    
}

    
    
