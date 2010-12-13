public class Threshold extends Beet
{
    Envelope _envelope;
    
    float _threshold;
    float _noise;

       
    // Constructor
    {
        5::ms => _envelope.duration;
        
        0.0 => _threshold;
        
        _envelope @=> _input;
        _envelope @=> _output;
         dac      @=> _connect;
         
        _output    => _connect;
    }


    fun void set_threshold( float thresh )
    {
        thresh => _threshold;

        if( _threshold > 1.0 )
        {
            1.0 => _threshold;
        }
        if( _threshold < 0.0 )
        {
            0.0 => _threshold;
        }
    }

    
    // private timeloop
    fun void local_loop()
    {
        while( true )
        {
            _noise + Std.rand2f( -0.1, 0.1 ) => _noise;

            if( _noise <  0.1 ) 0.1 => _noise;
            if( _noise >  0.9 ) 0.9 => _noise;
            
            if( _noise > _threshold + 0.1 && _envelope.value() == 0 )
            {
                _envelope.keyOn();
            }
            
            if( _noise < _threshold - 0.1 && _envelope.value() == 1 )
            {
                _envelope.keyOff();
            }
            
            _envelope.duration() * 2 => now;
        }
    }  
}















