/*
*  --------------> WARNING <--------------
*  This is a sketch for the class implementing 
*  one dimentional perlin noise
*  it's a code taken from Processing source repo
*  and re-written to ChucK. Unfortunatelly
*  it doesn't work well, so needs some testing
*/

public class Ken
{

    4 => int PERLIN_YWRAPB;
    ( 1 << PERLIN_YWRAPB ) => int PERLIN_YWRAP;
    8 => int PERLIN_ZWRAPB;
    ( 1 << PERLIN_ZWRAPB ) => int PERLIN_ZWRAP;
    4095 => int PERLIN_SIZE;

    4 => int perlin_octaves; // default to medium smooth
    0.5 => float perlin_amp_falloff; // 50% reduction/octave

    0.5 => float SINCOS_PRECISION;
    ( 360 / SINCOS_PRECISION ) $ int => int SINCOS_LENGTH;

    SINCOS_LENGTH => int perlin_TWOPI => int perlin_PI;
    ( perlin_PI >> 1 ) => perlin_PI;
    float perlin_cosTable[ SINCOS_LENGTH ];
    float perlin[ PERLIN_SIZE + 1 ];


    { // CONSTRUCTOR
        for( 0 => int i; i < SINCOS_LENGTH; i++ ) 
        {
            Math.cos( i * ( Math.PI / 180.0 ) * SINCOS_PRECISION ) => perlin_cosTable[ i ];
        }
    }


    fun float noise( float x ) 
    {
        return noise( x, 0.0, 0.0 );
    }


    fun float noise( float x, float y ) 
    {
        return noise( x, y, 0.0 );
    }


    fun float noise( float x, float y, float z ) 
    {
        if( perlin == NULL ) 
        {
            for( 0 => int i; i < PERLIN_SIZE + 1; i++) 
            {
                Std.randf() => perlin[ i ]; 
            }
        }

        if( x < 0 ) 
        -x => x;
        if( y < 0 ) 
        -y => y;
        if( z < 0 ) 
        -z => z;

        x $ int => int xi; 
        y $ int => int yi; 
        z $ int => int zi;     

        ( x - xi ) $ float => float xf; 
        ( y - yi ) $ float => float yf; 
        ( z - zi ) $ float => float zf; 

        float rxf, ryf;

        0.0 => float r;
        0.5 => float ampl;

        float n1, n2, n3;

        for( 0 => int i; i < perlin_octaves; i++ ) 
        {
            xi + ( yi << PERLIN_YWRAPB ) + ( zi << PERLIN_ZWRAPB ) => int of;

            noise_fsc( xf ) => rxf;
            noise_fsc( yf ) => ryf;

            perlin[ of & PERLIN_SIZE ] => n1;
            rxf * ( perlin[ ( of + 1 ) & PERLIN_SIZE ] - n1 ) +=> n1;
            perlin[ ( of + PERLIN_YWRAP ) & PERLIN_SIZE ] => n2;
            rxf * ( perlin[ ( of + PERLIN_YWRAP + 1 ) & PERLIN_SIZE ] - n2) +=> n2;
            ryf*(n2-n1) +=> n1;

            PERLIN_ZWRAP +=> of;
            perlin[ of & PERLIN_SIZE ] => n2;
            rxf * ( perlin[ ( of + 1 ) & PERLIN_SIZE ] - n2 ) +=> n2;
            perlin[ ( of + PERLIN_YWRAP ) & PERLIN_SIZE ] => n3;
            rxf * ( perlin[ ( of + PERLIN_YWRAP + 1 ) & PERLIN_SIZE ] - n3 ) +=> n3;
            ryf * ( n3 - n2 ) +=> n2;

            noise_fsc( zf ) * ( n2 - n1 ) +=> n1;

            n1 * ampl +=> r;
            perlin_amp_falloff *=> ampl;
            xi << 1 => xi; 
            2 *=> xf;
            yi << 1 => yi; 
            2 *=> yf;
            zi << 1 => zi; 
            2 *=> zf;

            if( xf >= 1.0 ) 
            { 
                xi++; 
                1.0 -=> xf; 
            }
            if( yf >= 1.0 ) 
            { 
                yi++; 
                1.0 -=> yf; 
            }
            if( zf >= 1.0 ) 
            { 
                zi++; 
                1.0 -=> zf; 
            }
        }
        return r;
    }


    fun float noise_fsc(float i) 
    {
        // using bagel's cosine table instead
        return 0.5 * ( 1.0 - perlin_cosTable[ ( ( i * perlin_PI ) % perlin_TWOPI ) $ int ] );
    }

}