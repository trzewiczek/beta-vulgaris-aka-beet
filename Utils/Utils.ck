public class Utils {
    // stupid, but effective way of clearing the console screen
    fun static void clear_screen() {
        for(0 => int i; i < 100; ++i) {
            <<< "", "" >>>;
        }
    }

    // maps any given number in some value range into new float range
    fun static float map(float value, float in_min, float in_max, float out_min, float out_max) {
        return out_min + ((out_max - out_min) * ((value - in_min) / (in_max - in_min))); 
    }

    // maps 0-127 to 0.0-1.0
    fun static float map_midi(int cc_value) {
        return cc_value / 127.0;
    }

    // maps 0-127 to given float range
    fun static float map_midi(int cc_value, float out_min, float out_max) {
        return out_min + ((out_max - out_min) * (cc_value / 127.0)); 
    }
}
