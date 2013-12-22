<<< "Testing Stammer class" >>>;

<<< "Loading class" >>>;
Stammer stm => dac;
2.0 => stm.set_freq;
spork ~ stm.local_loop();

<<< "Loading audio files" >>>;
SndBuf buf_1;
SndBuf buf_2;
me.dir() + "/../sounds/test_sound_01.wav" => buf_1.read;
me.dir() + "/../sounds/test_sound_02.wav" => buf_2.read;

<<< "Running test" >>>;
buf_2 => stm;
10::second => now;

buf_2 =< stm;
buf_1 => stm;
10::second => now;

buf_2 => stm;
10::second => now;
