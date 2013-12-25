/*
 * This beet cuts the sound
 * with repetiting envelopes
 */

public class Cutter extends Chubgraph {
    Envelope envelope;

    float cut_freq;
    dur   cut_duration;
    float env_shape;


    // Constructor
    {
        0.5  => env_shape;
        11.0 => cut_freq;
        second / cut_freq => cut_duration;

        inlet => envelope => outlet;
    }


    fun void increase_freq() {
        if (cut_freq < 1.0) {
            0.1 +=> cut_freq;
        }
        else if(cut_freq >= 1.0 && cut_freq < 25.0) {
            1.0 +=> cut_freq;
        }
        
        1::second / cut_freq => cut_duration;        
    }        


    fun void decrease_freq() {
        if(cut_freq >= 2.0) {
            1.0 -=> cut_freq;
        }
        else if (cut_freq >= 0.2) {
            0.1 -=> cut_freq;
        }
        1::second / cut_freq => cut_duration;     
    }        


    // set cuting freq to arbitrary value in range (2.0, 25.0)
    fun float set_freq(float _f) {
        _f => cut_freq;
        
        if(cut_freq > 25.0) {
            2.0 => cut_freq;
        }
        else if (cut_freq < 2) {
            2 => cut_freq;
        }

        1::second / cut_freq => cut_duration;     
    }                

    // make attack smoother
    fun void increase_shape() {
        0.05 +=> env_shape;

        if(env_shape >= 1.0) {
            0.99 => env_shape;
        }
    }
        

    // sharpen attack
    fun void decrease_shape() {
        0.05 -=> env_shape;

        if(env_shape <= 0.0) {
            0.01 => env_shape;
        }
    }


    fun void show_current_state() {
        <<< "Cut freq:", cut_freq >>>;
        <<< "Env shape:", env_shape >>>;
    }        

    
    // private timeloop
    fun void on() {
        while(true) {
            cut_duration * env_shape => dur on;
            cut_duration - on => dur off;
            
            on => envelope.duration;

            envelope.keyOn();
            envelope.duration() => now;

            off => envelope.duration;
            
            envelope.keyOff();
            envelope.duration() => now;
        }
    }    
}

