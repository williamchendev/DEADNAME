class WeaponClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		
	}
	
	static _destructor = function() 
	{
		
	}
	
	// Init Methods
	static init_weapon = function(init_weapon_x = 0, init_weapon_y = 0)
	{
	    
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		
	}
}

class FirearmClass extends WeaponClass define
{
	// Init & Destroy Methods
	static _constructor = function()
	{
		super._constructor();
	}
	
	static _destructor = function() 
	{
		super._destructor();
	}
	
	// Update Methods
	static init_weapon = function(init_weapon_x = 0, init_weapon_y = 0)
	{
	    super.init_weapon(init_weapon_x, init_weapon_y);
	}
	
	// Render Methods
	static render_behaviour = function() 
	{
		super.render_behaviour();
	}
}