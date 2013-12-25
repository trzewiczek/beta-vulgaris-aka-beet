<<< ">>> Testing Cutter class", "" >>>;

<<< ">>> Loading class", "">>>;
Cutter ctr => dac;
spork ~ ctr.on();

<<< ">>> Loading audio files", "">>>;
SndBuf buf;
me.dir() + "/../sounds/test_sound_01.wav" => buf.read;
1 => buf.loop;

<<< ">>> Running test", "">>>;
buf => ctr;

<<< "\n--- Current params:", "">>>;
<<< "--- Freq: ", "11">>>;
<<< "--- Shape:", "0.5">>>;
3::second => now;

<<< "\n--- Current params:", "">>>;
<<< "--- Freq: ", "4">>>;
<<< "--- Shape:", "0.9">>>;
0.9 => ctr.env_shape;
4.0 => ctr.set_freq;
3::second => now;

<<< "\n--- Current params:", "">>>;
<<< "--- Freq: ", "4">>>;
<<< "--- Shape:", "0.1">>>;
0.1 => ctr.env_shape;
3::second => now;

<<< "\n--- Current params:", "">>>;
<<< "--- Freq: ", "14">>>;
<<< "--- Shape:", "0.1">>>;
14.0 => ctr.set_freq;
3::second => now;

<<< "\n--- Current params:", "">>>;
<<< "--- Freq: ", "14">>>;
<<< "--- Shape:", "0.9">>>;
0.9 => ctr.env_shape;
3::second => now;
