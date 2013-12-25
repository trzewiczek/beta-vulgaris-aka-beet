<<< ">>> Testing Threshold class", "" >>>;

<<< ">>> Loading class", "">>>;
Threshold thr => dac;
spork ~ thr.on();

<<< ">>> Loading audio files", "">>>;
SndBuf buf;
me.dir() + "/../sounds/test_sound_01.wav" => buf.read;
1 => buf.loop;

<<< ">>> Running test", "">>>;
buf => thr;

<<< "\n--- Current params:", "">>>;
<<< "--- Level: ", "0.75">>>;
0.75 => thr.set_threshold;
10::second => now;

<<< "\n--- Current params:", "">>>;
<<< "--- Level: ", "0.5">>>;
0.5 => thr.set_threshold;
10::second => now;
