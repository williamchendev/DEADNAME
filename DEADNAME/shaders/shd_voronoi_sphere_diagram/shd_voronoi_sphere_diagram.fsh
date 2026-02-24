//
// Voronoi Sphere Diagram fragment shader that Inno made for her Projects
//

// Precision Settings
precision highp float;

// Interpolated UV
varying vec2 v_vTexcoord;

// Uniform Voronoi Cell Settings
uniform float u_CellCount;

// Constants
const float Pi = 3.14159265359;

const float color_range = 256.0;

// Trigonometry Functions
// returns the angle in the plane (in radians) between the positive x-axis and the ray from (0, 0) to the point (x, y)
float atan2(float y, float x)
{
	float t0, t1, t2, t3, t4;
	
	t3 = abs(x);
	t1 = abs(y);
	t0 = max(t3, t1);
	t1 = min(t3, t1);
	t3 = 1.0 / t0;
	t3 = t1 * t3;
	
	t4 = t3 * t3;
	t0 =         - 0.013480470;
	t0 = t0 * t4 + 0.057477314;
	t0 = t0 * t4 - 0.121239071;
	t0 = t0 * t4 + 0.195635925;
	t0 = t0 * t4 - 0.332994597;
	t0 = t0 * t4 + 0.999995630;
	t3 = t0 * t3;
	
	t3 = (abs(y) > abs(x)) ? 1.570796327 - t3 : t3;
	t3 = (x < 0.0) ?  3.14159265359 - t3 : t3;
	t3 = (y < 0.0) ? -t3 : t3;
	
	return t3;
}

// Pseudo-Random Functions
vec2 random(vec2 value)
{
	vec2 value_dot_product = vec2(dot(value, vec2(11.9898, 28.2334)), dot(value, vec2(12.3459, 67.8983)));
	vec2 value_trig = vec2(cos(value_dot_product.x), sin(value_dot_product.y));
	vec2 value_mod = (mod(197.0 * value_trig, 1.0) + value_trig) * 0.5453;
	return fract(value_mod * 43758.5453123);
}

// Haversine Distance Formula Function
float haversine(float first_longitude, float first_latitude, float second_longitude, float second_latitude)
{
	float distance_longitude = second_longitude - first_longitude;
	float distance_latitude = second_latitude - first_latitude;
	
	float s_lon = sin(distance_longitude * 0.5);
	float s_lat = sin(distance_latitude * 0.5);
	
	float d = s_lat * s_lat + cos(first_latitude) * cos(second_latitude) * s_lon * s_lon;
	
	return 2.0 * atan2(sqrt(d), sqrt(1.0 - d));
}


vec3 voronoiSphereColor(vec2 uv)
{
	// Convert UV Coordinates to Longitude and Latitude Coordinates
	vec2 uv_longitude_latitude_coordinates = vec2((uv.x * 2.0 - 1.0) * Pi, (uv.y - 0.5) * Pi);
	
	// Find Cell's Grid Position
	vec2 grid = uv * u_CellCount;
	vec2 cell = floor(grid);
	
	// Establish Default Cell & Minimum Distance Values for Neighboring Cell Comparison
	vec2 nearest_cell = cell;
	float min_distance = 10000.0;
	
	// Iterate through Neighboring Cells to find Nearest Cell from Neighboring Cell's Randomized Center
	for (int w_h = -1; w_h <= 1; w_h++)
	{
		for (int w_w = -1; w_w <= 1; w_w++)
		{
			// Find Neighboring Cell's Grid Position & Wrap Horizontally for Sphere's Seamless Cylindrical Projection
			vec2 neighbor_cell = cell + vec2(float(w_w), float(w_h));
			neighbor_cell = vec2(mod(mod(neighbor_cell.x, u_CellCount) + u_CellCount, u_CellCount), clamp(neighbor_cell.y, 0.0, u_CellCount));
			
			// Generate Neighboring Cell's Random Center Offset from Cell Grid Position
			vec2 neighbor_cell_random_center_offset = random(neighbor_cell);
			
			// Calculate Neighboring Cell's Center Position's UV Coordinates
			vec2 neighbor_cell_center_position_uv = (neighbor_cell + neighbor_cell_random_center_offset) / u_CellCount;
			neighbor_cell_center_position_uv.y = clamp(neighbor_cell_center_position_uv.y, 0.0, 1.0);
			
			// Convert Neighboring Cell's UV Coordinates to Longitude and Latitude Coordinates
			vec2 neighbor_longitude_latitude_coordinates = vec2((neighbor_cell_center_position_uv.x * 2.0 - 1.0) * Pi, (neighbor_cell_center_position_uv.y - 0.5) * Pi);
			
			// Calculate Haversine Distance between UV's Longitude and Latitude Coordinates and the Neighboring Cell's Longitude and Latitude Coordinates
			float d = haversine(uv_longitude_latitude_coordinates.x, uv_longitude_latitude_coordinates.y, neighbor_longitude_latitude_coordinates.x, neighbor_longitude_latitude_coordinates.y);
			
			// Update Nearest Cell & Nearest Cell Minimum Distance
			nearest_cell = d < min_distance ? neighbor_cell : nearest_cell;
			min_distance = d < min_distance ? d : min_distance;
		}
	}
	
	// Convert Nearest Cell's Grid Position into a Linear Value
	float linear = nearest_cell.y * u_CellCount + nearest_cell.x;
	
	// Convert Linear Value into Color Range Indexes Vector
	float index_x = floor(linear / (color_range * color_range));
	float index_y = mod(floor(linear / color_range), color_range);
	float index_z = mod(linear, color_range);
	
	// Return Converted Unique Color ID Value from Nearest Cell's Color Range Indexes Vector
	return vec3(index_x, index_y, index_z) / color_range;
}

// Fragment Shader
void main() 
{
	// Return Voronoi Sphere Diagram RGB Color Value
	gl_FragColor = vec4(voronoiSphereColor(v_vTexcoord), 1.0);
}
