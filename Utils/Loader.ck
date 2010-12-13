/**
 *  This class encapsulates the sound files
 *  loading. The only two purposes of it are:
 *
 *  1. to keep main.ck file clean
 *  2. to provide an easy way of generating this file
 *     with command-line tools (bash or python scripts)
 *
 *  See Loader_example.ck file for documentation
 *  how to use it with grace and wit.
 */

public class Loader
{
    // load my samples into a looper
    fun static void load_sound_files( Looper looper )
    {
        "/my/samples/repository/" => string path;

        <<< "Loading", "sound files" >>>;
        
        path + "my_file_001.wav"         => looper.add_file;
        path + "my_file_002.wav"         => looper.add_file;
        path + "my_file_003.wav"         => looper.add_file;
        path + "my_file_004.wav"         => looper.add_file;
        path + "my_file_005.wav"         => looper.add_file;
        path + "my_file_006.wav"         => looper.add_file;

        <<< "Sound files", "loaded!" >>>;
    }
}
