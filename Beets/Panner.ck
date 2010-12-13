public class Panner extends Beet
{
    Pan2 _panner;
    OscEvent _osc_event;
    
    // Constructor
    {
        _panner @=> _input;
        _panner @=> _output;
        dac    @=> _connect;
        
        _output  => _connect;
    }

    fun void osc_event( OscEvent e )
    {
        e @=> _osc_event;
    }


    // connect left and right surve as a way around
    // a bug that mixes panner stereo sound into
    // mono when connected into gain object
    fun UGen connect_left( UGen new_connect )
    {
        _output =< _connect;
        _panner.left => new_connect;
        
        new_connect @=> _connect;

        return _connect;
    }

    
    fun UGen connect_right( UGen new_connect )
    {
        _output =< _connect;
        _panner.right => new_connect;
        
        new_connect @=> _connect;

        return _connect;
    }

   
    // private timeloop
    fun void local_loop()
    {
        while( true )
        {
            _osc_event => now;

            while( _osc_event.nextMsg() != 0 )
            {
                _osc_event.getFloat() => float p;
                p => _panner.pan;
            }

            100::ms => now;
        }
        
    }  
}















