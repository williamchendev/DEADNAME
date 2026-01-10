function haversine_distance_uv(u, v, sphere_radius, distance) 
{
	
}

function haversine_distance_uv_offset(u, v, bearing, distance, sphere_radius)
{
	//
	var temp_lat = lerp(-pi * 0.5, pi * 0.5, v);
	var temp_lon = lerp(-pi, pi, u);
	
	//
	var temp_angular_distance = distance / sphere_radius;
    var temp_bearing = (bearing / 360) * pi * 2;
    
    //
	var temp_sin_lat = sin(temp_lat);
	var temp_cos_lat = cos(temp_lat);
	var temp_sin_angular_distance = sin(temp_angular_distance);
	var temp_cos_angular_distance = cos(temp_angular_distance);
	
	var temp_random_lat = arcsin(temp_sin_lat * temp_cos_angular_distance + temp_cos_lat * temp_sin_angular_distance * cos(temp_bearing));
	var temp_random_lon = temp_lon + arctan2(sin(temp_bearing) * temp_sin_angular_distance * temp_cos_lat, temp_cos_angular_distance - temp_sin_lat * sin(temp_random_lat));
	
	//
	temp_random_lon = (temp_random_lon + pi mod pi * 2) - pi;
	
	//
	var temp_random_offset_u = inverse_lerp(-pi, pi, temp_random_lon, false);
	var temp_random_offset_v = inverse_lerp(-pi * 0.5, pi * 0.5, temp_random_lat, false);
	
	//temp_random_offset_u = temp_random_offset_u < 0 ? (temp_random_offset_u + (temp_random_offset_u div 1 + 1)) mod 1 : temp_random_offset_u;
	//temp_random_offset_v = temp_random_offset_v < 0 ? (temp_random_offset_v + (temp_random_offset_v div 1 + 1)) mod 1 : temp_random_offset_v;
	
	//
	return [ temp_random_offset_u - u, temp_random_offset_v - v ];
}

function haversine_distance_random_uv_offset(u, v, sphere_radius, distance_min, distance_max)
{
	//
	var temp_lat = lerp(-pi * 0.5, pi * 0.5, v);
	var temp_lon = lerp(-pi, pi, u);
	
	//
	var temp_distance = random_range(distance_min, distance_max);
	var temp_angular_distance = temp_distance / sphere_radius;
    var temp_bearing = random(1.0) * pi * 2;
    
    //
	var temp_sin_lat = sin(temp_lat);
	var temp_cos_lat = cos(temp_lat);
	var temp_sin_angular_distance = sin(temp_angular_distance);
	var temp_cos_angular_distance = cos(temp_angular_distance);
	
	var temp_random_lat = arcsin(temp_sin_lat * temp_cos_angular_distance + temp_cos_lat * temp_sin_angular_distance * cos(temp_bearing));
	var temp_random_lon = temp_lon + arctan2(sin(temp_bearing) * temp_sin_angular_distance * temp_cos_lat, temp_cos_angular_distance - temp_sin_lat * sin(temp_random_lat));
	
	//
	temp_random_lon = (temp_random_lon + pi mod pi * 2) - pi;
	
	//
	var temp_random_offset_u = inverse_lerp(-pi, pi, temp_random_lon, false);
	var temp_random_offset_v = inverse_lerp(-pi * 0.5, pi * 0.5, temp_random_lat, false);
	
	//temp_random_offset_u = temp_random_offset_u < 0 ? (temp_random_offset_u + (temp_random_offset_u div 1 + 1)) mod 1 : temp_random_offset_u;
	//temp_random_offset_v = temp_random_offset_v < 0 ? (temp_random_offset_v + (temp_random_offset_v div 1 + 1)) mod 1 : temp_random_offset_v;
	
	//
	return [ temp_random_offset_u - u, temp_random_offset_v - v ];
}

/*
public static Vector2 RandomOffsetUV(Vector2 uv, float radiusMeters)
    {
        // 1. Convert UV to latitude & longitude (radians)
        float lat = Mathf.Lerp(-Mathf.PI / 2f, Mathf.PI / 2f, uv.y);
        float lon = Mathf.Lerp(-Mathf.PI, Mathf.PI, uv.x);

        // 2. Random distance and bearing
        // sqrt ensures uniform distribution over the circle
        float distance = radiusMeters * Mathf.Sqrt(Random.value);
        float angularDistance = distance / SphereRadius;
        float bearing = Random.value * Mathf.PI * 2f;

        // 3. Great-circle destination formula
        float sinLat1 = Mathf.Sin(lat);
        float cosLat1 = Mathf.Cos(lat);
        float sinAd = Mathf.Sin(angularDistance);
        float cosAd = Mathf.Cos(angularDistance);

        float lat2 = Mathf.Asin(
            sinLat1 * cosAd +
            cosLat1 * sinAd * Mathf.Cos(bearing)
        );

        float lon2 = lon + Mathf.Atan2(
            Mathf.Sin(bearing) * sinAd * cosLat1,
            cosAd - sinLat1 * Mathf.Sin(lat2)
        );

        // Normalize longitude to [-π, π]
        lon2 = Mathf.Repeat(lon2 + Mathf.PI, Mathf.PI * 2f) - Mathf.PI;
        
        Repeat(float t, float length); 
        Mathf.Clamp(t - Mathf.Floor(t / length) * length, 0.0f, length);

        // 4. Convert back to UV
        Vector2 newUV;
        newUV.x = Mathf.InverseLerp(-Mathf.PI, Mathf.PI, lon2);
        newUV.y = Mathf.InverseLerp(-Mathf.PI / 2f, Mathf.PI / 2f, lat2);

        // 5. Return offset
        return newUV - uv;
    }
*/