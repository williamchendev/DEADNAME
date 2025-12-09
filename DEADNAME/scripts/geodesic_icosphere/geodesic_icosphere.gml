/// @function geodesic_icosphere_create(resolution);
/// @description Generates a struct that contains the geometric data for rendering a Geodesic Icosphere by unwrapping Five Rhombuses, uses a linear model for increasing resolution
/// @param {real} resolution Resolution of the Geodesic Icosphere (determines triangle density)
/// @return {struct} Struct containing the geometric data for rendering a Geodesic Icosphere: Vertices, Triangles, and Vertex_UVs
function geodesic_icosphere_create(resolution) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Initialize Icosphere Strip Data
	var strips = [ geodesic_icosphere_create_strip(0), geodesic_icosphere_create_strip(1), geodesic_icosphere_create_strip(2), geodesic_icosphere_create_strip(3), geodesic_icosphere_create_strip(4) ];
	
	// Establish Icosphere Creation Parameters
	var iterations = 5 * resolution;
	var resolution_v = 2 * resolution;
	
	var vertex_count = 5 * resolution_v * resolution + 2;
	var triangle_count = 2 * 5 * resolution_v * resolution;
	
	var edge_rotation_angle = arccos(geodesic_icosphere_vec3_dot([0, 1, 0], geodesic_icosphere_get_corner(0, 1)));
	
	// Initialize Icosphere's Vertex and Triangle Arrays
	var vertices = array_create(vertex_count);
	var triangles = array_create(triangle_count);
	
	// Initialize Icosphere's Render Data Arrays
	var vertex_uvs = array_create(vertex_count);
	
	// Set Icosphere Vertices Array with Top Pole's Vertex and Bottom Pole's Vertex
	vertices[0] = [ 0, -1, 0 ];
	vertices[1] = [ 0, 1, 0 ];
	
	vertex_uvs[0] = [ 0.5, 0 ];
	vertex_uvs[1] = [ 0.5, 1 ];
	
	// Icosphere Creation Iterator
	var i = 0;
	
	repeat (iterations)
	{
		// Establish Count of Iterations through all Strips
		var u = i div 5;
		
		// Establish Strip Variables
		var strip_id = i - 5 * u;
		var strip = strips[strip_id];
		
		// Establish Vertex and Triangle Indexes
		var v = 1;
		var vi = resolution_v * (resolution * strip_id + u) + 2;
		var ti = 2 * resolution_v * (resolution * strip_id + u);
		var first_column = (u == 0);
		
		// Establish Quad Vertex Indexes
		var quad_a = vi;
		var quad_b = first_column ? 0 : vi - resolution_v;
		var quad_c = first_column ? (strip_id == 0 ? 4 * resolution_v * resolution + 2 : vi - resolution_v * (resolution + u)) : vi - resolution_v + 1;
		var quad_d = vi + 1;
		
		// Increment Strip
		u += 1;
		
		// Calculate First Vertex's Position in the Column
		var pos = geodesic_icosphere_quaternion_mul_vec3(geodesic_icosphere_quaternion_axis_angle(strip.bottom_right_axis, edge_rotation_angle * u / resolution), [0, -1, 0]);
		
		// Index First Vertex's Position in the Column
		vertices[vi] = pos;
		
		// Index First Vertex's UV in the Column
		vertex_uvs[vi] = [ 0.5 - arctan2(-pos[0], -pos[2]) / (2 * pi), 0.5 - arcsin(-pos[1]) / pi ];
		
		// Increment Vertex Index
		vi++;
		
		// Increment through Column
		repeat (resolution_v - 1)
		{
			// Establish Orientation Variables
			var h = u + v;
			var left_axis, right_axis, left_start, right_start;
			var edge_angle_scale, face_angle_scale;
			
			// Find Orientation of Vertex based on their position within the Rhombus's Shape
			if (v <= resolution - u) 
			{
				left_axis = strip.bottom_left_axis;
				right_axis = strip.bottom_right_axis;
				left_start = [0, -1, 0];
				right_start = [0, -1, 0];
				edge_angle_scale = h / resolution;
				face_angle_scale = v / h;
			}
			else if (v < resolution) 
			{
				left_axis = strip.mid_center_axis;
				right_axis = strip.mid_right_axis;
				left_start = strip.low_left_corner;
				right_start = strip.low_right_corner;
				edge_angle_scale = h / resolution - 1.0;
				face_angle_scale = (resolution - u) / (resolution_v - h);
			}
			else if (v <= resolution_v - u) 
			{
				left_axis = strip.mid_left_axis;
				right_axis = strip.mid_center_axis;
				left_start = strip.low_left_corner;
				right_start = strip.low_left_corner;
				edge_angle_scale = h / resolution - 1.0;
				face_angle_scale = (v - resolution) / (h - resolution);
			}
			else 
			{
				left_axis = strip.top_left_axis;
				right_axis = strip.top_right_axis;
				left_start = strip.high_left_corner;
				right_start = strip.high_right_corner;
				edge_angle_scale = h / resolution - 2.0;
				face_angle_scale = (resolution - u) / (3.0 * resolution - h);
			}
			
			// Calculate Vertex Position
			var p_left = geodesic_icosphere_quaternion_mul_vec3(geodesic_icosphere_quaternion_axis_angle(left_axis, edge_rotation_angle * edge_angle_scale), left_start);
			var p_right = geodesic_icosphere_quaternion_mul_vec3(geodesic_icosphere_quaternion_axis_angle(right_axis, edge_rotation_angle * edge_angle_scale), right_start);
			
			var axis = geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(p_right, p_left));
			var angle = arccos(geodesic_icosphere_vec3_dot(p_right, p_left)) * face_angle_scale;
			
			pos = geodesic_icosphere_quaternion_mul_vec3(geodesic_icosphere_quaternion_axis_angle(axis, angle), p_right);
			
			// Index Vertex's Position
			vertices[vi] = pos;
			
			// Index Vertex's UV
			vertex_uvs[vi] = [ 0.5 - arctan2(-pos[0], -pos[2]) / (2 * pi), 0.5 - arcsin(-pos[1]) / pi ];
			
			// Index Quad's Triangles into Triangle Array
			triangles[ti + 0] = [ quad_a, quad_d, quad_b ];
			triangles[ti + 1] = [ quad_d, quad_b, quad_c ];
			
			// Increment Quad's Triangle Vertex Indexes
			quad_b = quad_c;
			quad_a += 1;
			quad_c += (first_column and v <= resolution - u) ? resolution_v : 1;
			quad_d += 1;
			
			// Increment Vertex and Triangle Indexes
			v++;
			vi += 1;
			ti += 2;
        }
		
		// Find last Triangle in Column
		if (!first_column) 
		{
			quad_c = resolution_v * resolution * (strip_id == 0 ? 5 : strip_id) - resolution + u + 1;
		}
		
		quad_d = (u < resolution) ? quad_c + 1 : 1;
		
		// Index last Quad's Triangles into Triangle Array
		triangles[ti + 0] = [ quad_a, quad_d, quad_b ];
		triangles[ti + 1] = [ quad_d, quad_b, quad_c ];
		
		// Increment Column
		i++;
    }
    
    // Return Icosphere Struct Data
    return 
    {
		vertices: vertices,
		triangles: triangles,
		vertex_uvs: vertex_uvs
    };
}

function geodesic_icosphere_create_strip(id) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Creates the Orientation of one of the Five Rhombuses used to create the Icosphere
    var low_left = geodesic_icosphere_get_corner(2 * id, -1);
    var low_right = geodesic_icosphere_get_corner(id == 4 ? 0 : 2 * id + 2, -1);
    var high_left = geodesic_icosphere_get_corner(id == 0 ? 9 : 2 * id - 1, 1);
    var high_right = geodesic_icosphere_get_corner(2 * id + 1, 1);
    
    var down_vec = [0, -1, 0];
    var up_vec = [0, 1, 0];
    
    // Calculate the Rhombus Corner and Axis Orientation and package them into a struct to return
    return 
    {
        low_left_corner: low_left,
        low_right_corner: low_right,
        high_left_corner: high_left,
        high_right_corner: high_right,
        bottom_left_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(down_vec, low_left)),
        bottom_right_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(down_vec, low_right)),
        mid_left_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(low_left, high_left)),
        mid_center_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(low_left, high_right)),
        mid_right_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(low_right, high_right)),
        top_left_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(high_left, up_vec)),
        top_right_axis: geodesic_icosphere_vec3_normalize(geodesic_icosphere_vec3_cross(high_right, up_vec))
    };
}

function geodesic_icosphere_get_corner(id, y_sign) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Obtains the Orientation of one of the Five Rhombuses used to create the Icosphere
    var sqrt5 = sqrt(5.0);
    
    // Return Corner Orientation
    return 
    [
        0.4 * sqrt5 * sin(0.2 * pi * id),
        y_sign * 0.2 * sqrt5,
        -0.4 * sqrt5 * cos(0.2 * pi * id)
    ];
}

// Geodesic Icosphere Vector Math Functions
function geodesic_icosphere_vec3_dot(a, b) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Return Dot Product
    return a[0] * b[0] + a[1] * b[1] + a[2] * b[2];
}

function geodesic_icosphere_vec3_cross(a, b) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Return Cross Product
    return 
    [
        a[1] * b[2] - a[2] * b[1],
        a[2] * b[0] - a[0] * b[2],
        a[0] * b[1] - a[1] * b[0]
    ];
}

function geodesic_icosphere_vec3_length(v) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Return Vector's Length
	return sqrt(v[0] * v[0] + v[1] * v[1] + v[2] * v[2]);
}

function geodesic_icosphere_vec3_normalize(v) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Return Normalized Vector
	var len = geodesic_icosphere_vec3_length(v);
	return len == 0 ? [0, 0, 0] : [v[0] / len, v[1] / len, v[2] / len];
}

// Geodesic Icosphere Quaternion Math Functions
function geodesic_icosphere_quaternion_axis_angle(axis, angle) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Calculate Axis Angle
	var half_angle = angle * 0.5;
	var s = sin(half_angle);
	
	return 
	[
		axis[0] * s,
		axis[1] * s,
		axis[2] * s,
		cos(half_angle)
	];
}

function geodesic_icosphere_quaternion_mul_vec3(q, v) 
{
	// Add Code to Compiler
	gml_pragma("forceinline");
	
	// Extract quaternion components (x, y, z, w)
	var qx = q[0], qy = q[1], qz = q[2], qw = q[3];
	var vx = v[0], vy = v[1], vz = v[2];
	
	// Calculate quat * vec
	var ix = qw * vx + qy * vz - qz * vy;
	var iy = qw * vy + qz * vx - qx * vz;
	var iz = qw * vz + qx * vy - qy * vx;
	var iw = -qx * vx - qy * vy - qz * vz;
	
	// Calculate result * quat_conjugate
	return 
	[
		ix * qw + iw * -qx + iy * -qz - iz * -qy,
		iy * qw + iw * -qy + iz * -qx - ix * -qz,
		iz * qw + iw * -qz + ix * -qy - iy * -qx
	];
}
