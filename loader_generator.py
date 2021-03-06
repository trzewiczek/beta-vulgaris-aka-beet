import os, sys

def header():
    return """/**
 *  This file has been generated by the Loader Generator script
 *  To use it in beet call the static
 *
 *      load_sound_files( Looper looper )
 *
 *  passing a looper responsible for handling this sound files.
 *
 *  Example:
 *      my_looper => Loader.load_sound_files;
 */

public class Loader
{
    // load my smaples into the Looper
    fun static void load_sound_files( Looper looper )
    {
        <<< "Loading", "sound files - relax!" >>>;

"""


def footer():
    return """
        <<< "Superb!!", "Sound files loaded!" >>>;
    }
}
"""


if __name__ == '__main__':

    if len( sys.argv ) < 3:
        print "python loader_generator.py <audio_files_path> <output_path>"
        sys.exit(-1)

    # audio files dir
    in_path = sys.argv[1]

    # create an output file
    if 'Loader.ck' in sys.argv[2]:
        out_path = sys.argv[2]
    else:
        out_path = os.path.join( sys.argv[2], 'Loader.ck' )

    out_file = open( out_path, 'w' )

    # write file header
    out_file.write( header() )

    # load file names and sort them alphabeticaly
    files = os.listdir( in_path )
    files.sort()

    # add files with a <<< >>> debug string
    indent = '        '
    for f in files:
        if '.wav' in f or '.aiff' in f:
            file_path = in_path + f
            out_file.write( indent + '<<< "Loading", "' + f + '" >>>;\n' )
            out_file.write( indent + '"' + file_path + '" => looper.add_file;' )
            out_file.write( '\n\n' )

    # add footer and close file
    out_file.write( footer() )
    out_file.close()
