// due to the mono nature of the Gain UGen
// never connect Panner to Gain based UGens
// or Beets. Panner works best as a last
// UGen in the effects line
public class Panner extends Chubgraph {
  Pan2 panner;
  OscEvent osc_event;

  // Constructor
  {
    inlet => panner => outlet;
  }

  fun void osc_event(OscEvent e) {
    e @=> osc_event;
  }

  // private timeloop
  fun void on() {
    while(true) {
      osc_event => now;

      while(osc_event.nextMsg() != 0) {
        osc_event.getFloat() => float p;
        p => panner.pan;
      }

      100::ms => now;
    }
  }
}
