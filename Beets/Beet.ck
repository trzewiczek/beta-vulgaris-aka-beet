/**
 * Base class for all beta vulgaris classes.
 * 
 * It provides the common interface for
 * audio interclass connections and some common
 * error messages and others.
 */

public class Beet
{
    // _connect is a reference to the UGen outside a class
    // to which the audio stream will be sent from _output
    UGen _connect;
    
    // _output is a reference to the last UGen 
    // inside an internal UGens chain in the class
    // Audio is sent from _output into _connect
    UGen _output;
    
    // _input is a reference to the first UGen
    // inside an internal UGens chain in the class
    // Audio comes from other classes into _input
    UGen _input;
    
    
    int _loop_id;
    Event @ key_event;
    
    // Constructor
    {
        Globals.NONE => _loop_id;
        
        blackhole @=> _input;
        blackhole @=> _output;
        dac       @=> _connect;
        
        _output => _connect;
    }
    
    // getter for _connect UGen
    fun UGen connect()
    {
        return _connect;
    }
    
    // reconnect audio with UGen
    fun UGen connect( UGen new_connect )
    {
        _output =< _connect;
        _output => new_connect;
        
        new_connect @=> _connect;

        return _connect;
    }
    
    // reconnect audio with Beet
    fun UGen connect( Beet beet )
    {
        beet.input() => connect;
                
        return _connect;
    }

    
    // getter for _input UGen
    fun UGen input()
    {
        return _input;
    }

    
    // getter for _output UGen
    fun UGen output()
    {
        return _output;
    }

    
    // useful for testing purposes
    fun void addListener( Event e )
    {
        e @=> key_event;
    }

    
    // forking a local time loop
    fun void play()
    {
        ( spork ~ local_loop() ).id() => _loop_id;
    }
    
    // stop a local time loop 
    fun void stop()
    {
        Machine.remove( _loop_id );
        Globals.NONE => _loop_id;
    }
    
    // local time loop it an actual activity of a class
    fun void local_loop()
    {
        while( true )
        {
            1::samp => now;
        }
    }
}
