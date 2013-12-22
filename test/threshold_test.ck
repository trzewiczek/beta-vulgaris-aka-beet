<<< "Testing Threshold class" >>>;

<<< "Loading class" >>>;
Threshold thr => dac;
spork ~ thr.on();

<<< "Loading audio files" >>>;
SndBuf buf_1;
me.dir() + "/../sounds/test_sound_01.wav" => buf_1.read;

// TODO change parameters to test if it works
<<< "Running test" >>>;
buf_1 => thr;
10::second => now;
