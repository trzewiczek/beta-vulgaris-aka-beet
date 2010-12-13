public class Gainer extends Beet
{
    Gain _gainer;
    OscEvent _osc_event;
    
    // Constructor
    {
        _gainer @=> _input;
        _gainer @=> _output;
         dac    @=> _connect;
         
        _output  => _connect;
    }


    fun void osc_event( OscEvent e )
    {
        e @=> _osc_event;
    }

    
    // private timeloop
    fun void local_loop()
    {
        while( true )
        {
            _osc_event => now;

            while( _osc_event.nextMsg() != 0 )
            {
                _osc_event.getFloat() => _gainer.gain;
            }
            
            10::ms => now;
        }
    }  
}










