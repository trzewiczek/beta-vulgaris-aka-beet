/*
*  One dimensional Perlin Noise implementation based on:
*  http://freespace.virgin.net/hugo.elias/models/m_perlin.htm
*
*  Usage: 
*    next()      --> get next perlin noise values
*
*  Getters and setters and provided for:
*    seed        --> where to start from
*    delta       --> how far the next value lies
*    octaves     --> how many noise functions to be used
*    persistence --> harshness of the amp/freq computation 
*/

public class Ken
{
    int _octaves;
    float _persistence;
    float _seed;
    float _delta;

    // constructor
    {
        5    => _octaves;
        0.25 => _persistence;

        ( 0.0, 200.0 ) => Std.rand2f => seed;
        0.01 => delta;
    }

    //  resturns next perlin noise value
    fun float next()
    {
        float result;

        _perlin_noise( seed ) => result;
        seed + delta => seed;
        
        return result;
    }

    //
    //  setters and getters section

    // delta setter
    fun float delta( float new_delta )
    {
        new_delta => _delta;

        return _delta;
    }

    // delta getter
    fun float delta()
    {
        return _delta;
    }

    // seed setter
    fun float seed( float new_seed )
    {
        new_seed => _seed;

        return _seed;
    }

    // seed getter
    fun float seed()
    {
        return _seed;
    }

    // octaves setter
    fun float octaves( float new_octaves )
    {
        new_octaves => _octaves;

        return _octaves;
    }

    // octaves getter
    fun float octaves()
    {
        return _octaves;
    }

    // persistence setter
    fun float persistence( float new_persistence )
    {
        new_persistence => _persistence;

        return _persistence;
    }

    // persostence getter
    fun float persistence()
    {
        return _persistence;
    }


    //
    // perlin noise implementation
    // this should be a private section

    // pseudo random number generator
    fun float _simple_noise( int x )
    {
        (( x << 13 ) ^ x ) => x;
        return ( 1.0 - ( (x * (x * x * 15731 + 789221) + 1376312589) & 0x7fffffff) / 1073741824.0);
    }

    // cosine interpolation
    fun float _cos_interpolation( float a, float b, float x )
    {
        float ft;
        float f;
        
        x * pi => ft;
        ( 1 - Math.cos( ft )) * 0.5 => f;

        return a * (1-f) + b * f;
    }

    // smooting the psude random noise
    fun float _smooth_noise( int x )
    {
        float result;
        
        _simple_noise( x ) / 2.0 => result;
        _simple_noise( x-1 ) / 4.0 +=> result;
        _simple_noise( x+1 ) / 4.0 +=> result;

        return result;
    }

    // noise cosine interpolation
    fun float _interpolated_noise( float x )
    {
        int integer;
        float fractorial;
        float v1, v2;
        
        x $ int => integer;
        x - integer => fractorial;

        _smooth_noise( integer ) => v1;
        _smooth_noise( integer+1 ) => v2;

        return _cos_interpolation( v1, v2, fractorial );
    }

    // actual perlin noise algorithm
    fun float _perlin_noise( float x )
    {
        float total;
        float persistence;
        float amp, freq;
        int octaves;

        0.0  => total;
        0.25 => persistence;
        5    => octaves;
        
        for( 0 => int i; i < octaves-1; i++ )
        {
            Math.pow( 2, i ) => freq;
            Math.pow( persistence, i ) => amp;

            _interpolated_noise( x * freq ) * amp +=> total;
        }

        return total;
    }
}