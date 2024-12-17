/// @function		interp(a, b, amount, ease, [bx1, by1, bx2, by2], [curve]);
/// @param			{real}			a
/// @param			{real}			b
/// @param			{real}			amount
/// @param			{integer|macro}	ease
/// @param			{real}			[bx1
/// @param			{real}			by1
/// @param			{real}			bx2
/// @param			{real}			by2]
/// @param			{curve}			[curve]
/// @description	Returns a value interpolated between the two input values with optional
///					easing methods to create a smooth start and/or end to animations. 
///				
///					The first input value should equal the original state of the value and 
///					the second input the target state of the value. For example, to move an
///					object from `x = 0` to `x = 50`, 0 and 50 would be the two input values 
///					here.
///
///					The third input value can be thought of as a percentage of completion. 
///					Using the same example, an input amount of 0.5 would return `x = 25`.
///				
///					In order to create animations with this script, the interpolation amount
///					must be input as a variable which is incremented externally.
///				
///					The fourth and final value is an integer or macro specifying the easing 
///					method used during interpolation. Simple `true` or `false` values can be 
///					used here for sine or linear interpolation, respectively, but in addition 
///					to these basic modes there are 30 built-in easing techniques, plus other
///					custom techniques, featured below.
///
///					Built-in easing techniques are ordered from shallowest to deepest curve.
///				
///					If the bezier ease mode is selected, 4 more arguments can be supplied to
///					act as control points for a custom interpolation curve. These values range
///					from 0-1, but Y values can be less or greater to create a rubber-banding
///					effect. See https://cubic-bezier.com/ for an interactive visual example.
///
///					Other types of curves can be created visually in GameMaker 2.3 and newer.
///					To use these curves with `interp`, specify `ease_curve` as the mode and
///					then supply an additional argument pointing to the animation curve asset
///					desired. Note that only the first channel in an animation curve asset will
///					be used.
///
/// @example		duration = 5;
///					time += delta_time/1000000;
///			  
///					x = interp(0, 50, time/duration, ease_quart);
///					y = interp(0, 50, time/duration, ease_bezier, 0.66, -0.33, 0.33, 1.33);		
///					z = interp(0, 50, time/duration, ease_curve, my_curve);
///
/// @author			Lucas Chasteen <lucas.chasteen@xgasoft.com>
/// @copyright		XGASOFT 2020, All Rights Reserved

//Initialize ease mode macros
#macro ease_none -4
#macro ease_sin 1
#macro ease_sin_in 2
#macro ease_sin_out 3
#macro ease_quad 4
#macro ease_quad_in 5
#macro ease_quad_out 6
#macro ease_cubic 7
#macro ease_cubic_in 8
#macro ease_cubic_out 9
#macro ease_quart 10
#macro ease_quart_in 11
#macro ease_quart_out 12
#macro ease_quint 13
#macro ease_quint_in 14
#macro ease_quint_out 15
#macro ease_expo 16
#macro ease_expo_in 17
#macro ease_expo_out 18
#macro ease_circ 19
#macro ease_circ_in 20
#macro ease_circ_out 21
#macro ease_rubber 22
#macro ease_rubber_in 23
#macro ease_rubber_out 24
#macro ease_elastic 25
#macro ease_elastic_in 26
#macro ease_elastic_out 27
#macro ease_bounce 28
#macro ease_bounce_in 29
#macro ease_bounce_out 30
#macro ease_bezier 31
#macro ease_curve 32

function interp() {
	// Get values to interpolate
	var _a = argument[0],
		_b = argument[1],
		_amt = argument[2],
		_ease = argument[3],
		val = _b - _a;
		
	// Perform ease modes
	switch (_ease) {
		// Linear (None)
		case ease_none: {
			return _a + (val*_amt);
		}
			
		// Sine in-out
		case ease_sin: {
			return _a + (val*((cos(pi*_amt) - 1)*-0.5));	
		}
			
		// Sine in
		case ease_sin_in: {
			return _a + (val*((cos((pi*0.5)*_amt)*-1) + 1));	
		}
			
		// Sine out
		case ease_sin_out: {
			return _a + (val*(sin((pi*0.5)*_amt)));			
		}
			
		// Quadratic in-out
		case ease_quad: {
			if (_amt < 0.5) {
			    return _a + (val*((_amt*_amt)*2));
			} else {
			    return _a + (val*(((4 - (_amt*2))*_amt) - 1));
			}			
		}
			
		// Quadratic in
		case ease_quad_in: {
			return _a + (val*(_amt*_amt));	
		}
			
		// Quadratic out
		case ease_quad_out: {
			return _a + (val*(_amt*(2 - _amt)));		
		}
			
		// Cubic in-out
		case ease_cubic: {
			if (_amt < 0.5) {
			    return _a + (val*(((4*_amt)*_amt)*_amt));
			} else {
			    return _a + (val*((_amt - 1)*((2*_amt) - 2)*((2*_amt) - 2) + 1));
			}		
		}
			
		// Cubic in
		case ease_cubic_in: {
			return _a + (val*((_amt*_amt)*_amt));		
		}
			
		// Cubic out
		case ease_cubic_out: {
			_amt = _amt - 1;
			return _a + (val*(((_amt*_amt)*_amt) + 1));	
		}
			
		// Quartic in-out 
		case ease_quart: {
			if (_amt < 0.5) {
			    return _a + (val*((((8*_amt)*_amt)*_amt)*_amt));
			} else {
				_amt = _amt - 1;
			    return _a + (val*(1 - ((((8*_amt)*_amt)*_amt)*_amt)));
			}	
		}
			
		// Quartic in 
		case ease_quart_in: {
			return _a + (val*(((_amt*_amt)*_amt)*_amt));	
		}
			
		// Quartic out 
		case ease_quart_out: {
			_amt = _amt - 1;
			return _a + (val*(1 - (((_amt*_amt)*_amt)*_amt)));		
		}
			
		// Quintic in-out
		case ease_quint: {
			if (_amt < 0.5) {
			    return _a + (val*(((((16*_amt)*_amt)*_amt)*_amt)*_amt));
			} else {
				_amt = _amt - 1;
			    return _a + (val*(1 + (((((16*_amt)*_amt)*_amt)*_amt)*_amt)));
			}	
		}
			
		// Quintic in 
		case ease_quint_in: {
			return _a + (val*((((_amt*_amt)*_amt)*_amt)*_amt));
		}
			
		// Quintic out 
		case ease_quint_out: {
			_amt = _amt - 1;
			return _a + (val*(1 + ((((_amt*_amt)*_amt)*_amt)*_amt)));		
		}
			
		// Exponential in-out 
		case ease_expo: {
			if (_amt == 0) or (_amt == 1) {
			    return _a + (val*_amt);
			} else {
			    _amt = _amt*2;

			    if (_amt < 1) {
			        return _a + (val*(power(2, 10*(_amt - 1))*0.5));
			    } else {
			        return _a + (val*(((power(2, -10*(_amt - 1))*-1) + 2)*0.5));
			    }
			}	
		}
			
		// Exponential in 
		case ease_expo_in: {
			if (_amt == 0) {
			    return _a;
			} else {
			    _amt = _amt - 1;
			    return _a + (val*(power(2, 10*(_amt))));
			}
		}
			
		// Exponential out 
		case ease_expo_out: {
			if (_amt == 1) {
			    return _a + val;
			} else {
			    return _a + (val*((power(2, (-10*_amt))*-1) + 1));
			}
		}
			
		// Circular in-out 
		case ease_circ: {
			_amt = _amt*2;

			if (_amt < 1) {
			    return _a + (val*((sqrt(max(0, 1 - (_amt*_amt))) - 1)*-0.5));
			} else {
			    return _a + (val*((sqrt(max(0, 1 - ((_amt - 2)*(_amt - 2)))) + 1)*0.5));
			}	
		}
			
		// Circular in 
		case ease_circ_in: {
			return _a + (val*((sqrt(max(0, 1 - (_amt*_amt))) - 1)*-1));		
		}
			
		// Circular out 
		case ease_circ_out: {
			_amt = _amt - 1;
			return _a + (val*(sqrt(max(0, 1 - (_amt*_amt)))));			
		}
			
		// Rubber in-out 
		case ease_rubber: {
			_amt = _amt*2;
   
			if (_amt < 1) {
			    return _a + (val*(((0.5*_amt)*_amt)*((2.6*_amt) - 1.6)));
			} else {
			    _amt = _amt - 2;
			    return _a + (val*(0.5*(((_amt*_amt)*((2.6*_amt) + 1.6)) + 2)));
			}			
		}
			
		// Rubber in 
		case ease_rubber_in: {
			return _a + (val*((_amt*_amt)*((_amt*2) - 1)));		
		}
			
		// Rubber out 
		case ease_rubber_out: {
			_amt = _amt - 1;
			return _a + (val*(((_amt*_amt)*((_amt*2) + 1)) + 1));		
		}
			
		// Elastic in-out 
		case ease_elastic: {
			if (_amt == 0) or (_amt == 1) {
			    return _a + (val*_amt);
			} else {
			    _amt = (_amt*2) - 1;

			    if ((_amt + 1) < 1) {
			        return _a + (val*(-0.5*(power(2, 10*_amt)*sin(((_amt - 0.125)*(2*pi))/0.5))));
			    } else {
			        return _a + (val*(((power(2, -10*_amt)*sin((_amt - 0.125)*(2*pi)/0.5))*0.5) + 1));
			    }
			}		
		}
			
		// Elastic in 
		case ease_elastic_in: {
			if (_amt == 0) or (_amt == 1) {
			    return _a + (val*_amt);
			} else {
			    _amt = _amt - 1;
			    return _a + (val*((power(2, 10*_amt)*sin(((_amt - 0.125)*(2*pi))/0.5))*-1));
			}			
		}
			
		// Elastic out 
		case ease_elastic_out: {
			if (_amt == 0) or (_amt == 1) {
			    return _a + (val*_amt);
			} else {
			    return _a + (val*((power(2, -10*_amt)*sin(((_amt - 0.125)*(2*pi))/0.5)) + 1));
			}		
		}
			
		// Bounce in-out 
		case ease_bounce: {
			if (_amt < 0.5) {   
			    if ((1 - (_amt*2)) < 0.36) {
			        return _a + (val*((1 - ((7.56*(1 - (_amt*2)))*(1 - (_amt*2))))*0.5));
			    } 
    
			    if ((1 - (_amt*2)) < 0.72) {
			        _amt = (1 - (_amt*2)) - 0.54;
			        return _a + (val*((1 - (((7.56*_amt)*_amt) + 0.76))*0.5));
			    } 
    
			    if ((1 - (_amt*2)) < 0.91) {
			        _amt = (1 - (_amt*2)) - 0.81;
			        return _a + (val*((1 - (((7.56*_amt)*_amt) + 0.94))*0.5));
			    }
    
			    _amt = (1 - (_amt*2)) - 0.96;
			    return _a + (val*((1 - (((7.56*_amt)*_amt) + 0.99))*0.5));
			} else {
			    if (((_amt*2) - 1) < 0.36) {
			        return _a + (val*((((7.56*((_amt*2) - 1))*((_amt*2) - 1))*0.5) + 0.5));
			    } 
    
			    if (((_amt*2) - 1) < 0.72) {
			        _amt = ((_amt*2) - 1) - 0.54;
			        return _a + (val*(((((7.56*_amt)*_amt) + 0.76)*0.5) + 0.5));
			    } 
    
			    if (((_amt*2) - 1) < 0.91) {
			        _amt = ((_amt*2) - 1) - 0.81;
			        return _a + (val*(((((7.56*_amt)*_amt) + 0.94)*0.5) + 0.5));
			    }
    
			    _amt = ((_amt*2) - 1) - 0.96;
			    return _a + (val*((((((7.56*_amt)*_amt) + 0.99)*0.5) + 0.5)));
			}	
		}
			
		// Bounce in 
		case ease_bounce_in: {
			if ((1 - _amt) < 0.36) {
			    return _a + (val*(1 - ((7.56*(1 - _amt))*(1 - _amt))));
			} 
    
			if ((1 - _amt) < 0.72) {
			    _amt = (1 - _amt) - 0.54;
			    return _a + (val*(1 - (((7.56*_amt)*_amt) + 0.76)));
			} 
    
			if ((1 - _amt) < 0.91) {
			    _amt = (1 - _amt) - 0.81;
			    return _a + (val*(1 - (((7.56*_amt)*_amt) + 0.94)));
			}
    
			_amt = (1 - _amt) - 0.96;
			return _a + (val*(1 - (((7.56*_amt)*_amt) + 0.99)));	
		}
			
		// Bounce out 
		case ease_bounce_out: {
			if (_amt < 0.36) {
			    return _a + (val*((7.56*_amt)*_amt));
			} 
    
			if (_amt < 0.72) {
			    _amt = _amt - 0.54;
			    return _a + (val*(((7.56*_amt)*_amt) + 0.76));
			} 
    
			if (_amt < 0.91) {
			    _amt = _amt - 0.81;
			    return _a + (val*(((7.56*_amt)*_amt) + 0.94));
			}
    
			_amt = _amt - 0.96;
			return _a + (val*(((7.56*_amt)*_amt) + 0.99));
		}
			
		// Cubic Bezier 
		case ease_bezier: {
			// Use input control point values, if supplied
			if (argument_count > 4) {
				var _bx1 = clamp(argument[4], 0, 1),
					_by1 = argument[5],
					_bx2 = clamp(argument[6], 0, 1),
					_by2 = argument[7];	
			} else {
				// Otherwise default to ease
				var _bx1 = 0.25,
					_by1 = 0.10,
					_bx2 = 0.25,
					_by2 = 1.00;
			}
	
			// Calculate control points on bezier curve
			var bx_c = (_bx1*3);
			var bx_b = ((_bx2 - _bx1)*3) - bx_c;
			var bx_a = 1 - bx_c - bx_b;

			var by_c = (_by1*3);
			var by_b = ((_by2 - _by1)*3) - by_c;
			var by_a = 1 - by_c - by_b;
	
			// Perform iterations (Newton's method) to roughly find X for Y
			var xamt, yamt, newton;
			xamt = _amt;

			for (newton = 0; newton < 16; newton++) {
				yamt = (xamt*(bx_c + (xamt*(bx_b + (xamt*bx_a))))) - _amt;

				if (abs(yamt) < 0.001) {
					break;
				}

				xamt = xamt - (yamt/(bx_c + xamt*((bx_b*2) + ((bx_a*3)*xamt))));
			}

			// Get final interpolation amount (Y) from bezier curve
			_amt = xamt*(by_c + (xamt*(by_b + (xamt*by_a))));

			return _a + (_amt*val);	
		}
			
		// Animation Curve 
		case ease_curve: {
			// Use input animation curve, if supplied
			if (argument_count > 4) {
				var _curve = argument[4];
			} else { 
				// Otherwise create default curve
				var _curve = animcurve_create();
				_curve.name = "crv_interp";
				
				// Create curve channel
				var _channels = array_create(1);
				_channels[0] = animcurve_channel_new();
				_channels[0].name = "default";
				_channels[0].type = animcurvetype_catmullrom;
				_channels[0].iterations = 16;
				
				// Create curve points
				var _points = array_create(3);
				_points[0] = animcurve_point_new();
				_points[0].posx = 0;
				_points[0].value = 0;
				_points[1] = animcurve_point_new();
				_points[1].posx = 0.16;
				_points[1].value = 0.08;
				_points[2] = animcurve_point_new();
				_points[2].posx = 0.32;
				_points[2].value = 0.24;
				_points[3] = animcurve_point_new();
				_points[3].posx = 0.5;
				_points[3].value = 0.5;
				_points[4] = animcurve_point_new();
				_points[4].posx = 0.68;
				_points[4].value = 0.76;
				_points[5] = animcurve_point_new();
				_points[5].posx = 0.84;
				_points[5].value = 0.92;
				_points[6] = animcurve_point_new();
				_points[6].posx = 1;
				_points[6].value = 1;
				
				// Assign curve points to channel
				_channels[0].points = _points;
				
				// Assign channel to curve
				_curve.channels = _channels;
			}
			
			// Get first channel animation curve data
			_curve = animcurve_get_channel(_curve, 0);
		
			// Get final interpolation amount (Y) from curve asset
			_amt = animcurve_channel_evaluate(_curve, _amt);
		
			return _a + (_amt*val);	
		}
		
		// Linear (Other)
		default: {
			return _a + (val*_amt);
		}
	}
}
