public class Threshold extends Chubgraph {
  Envelope envelope;

  float threshold;
  float noise;


  // Constructor
  {
    5::ms => envelope.duration;

    0.0 => threshold;

    inlet => envelope => outlet;
  }


  fun void set_threshold(float thresh) {
    thresh => threshold;

    if(threshold > 1.0) {
      1.0 => threshold;
    }

    if(threshold < 0.0) {
      0.0 => threshold;
    }
  }


  // private timeloop
  fun void on() {
    while(true) {
      noise + Std.rand2f(-0.1, 0.1) => noise;

      if(noise <  0.1) 0.1 => noise;
      if(noise >  0.9) 0.9 => noise;

      if(noise > threshold + 0.1 && envelope.value() == 0) {
        envelope.keyOn();
      }

      if(noise < threshold - 0.1 && envelope.value() == 1) {
        envelope.keyOff();
      }

      envelope.duration() * 2 => now;
    }
  }  
}
