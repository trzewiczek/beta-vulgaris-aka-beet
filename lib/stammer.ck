public class Stammer extends Chubgraph {
  Envelope envelope;
  Delay delay_line;
  
  float cut_freq;
  dur   cut_duration;

  // Constructor
  {
    5.0 => cut_freq;
    second / cut_freq => cut_duration;

    1::second => delay_line.max;
    5::ms => envelope.duration;
    
    inlet => delay_line => envelope => outlet;
  }

  fun void set_freq(float f) {
    f => cut_freq;

    if(cut_freq > 9) {
      9 => cut_freq;
    }
    else if(cut_freq < 2) {
      2 => cut_freq;
    }

    1::second / cut_freq => cut_duration;
  }

  fun void increase_freq() {
    if(cut_freq < 1.0) {
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


  fun void on() {
    int i;
    while(true) {
      envelope.keyOff();
      envelope.duration() => now;

      Std.rand2f(10.0, delay_line.max()/ms)::ms => delay_line.delay;
      
      envelope.keyOn();
      envelope.duration() => now;

      cut_duration => now;
    }
  }    
}
