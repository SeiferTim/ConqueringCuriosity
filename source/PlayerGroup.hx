package ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxPoint;

/**
 * ...
 * @author Tile Isle
 */
class PlayerGroup extends FlxGroup
{

	private inline static var SPEED:Int = 200;
	private var _jeckyl:FlxSprite;
	private var _hyde:FlxSprite;
	
	private var _pos:FlxPoint;
	
	public function new(?X:Int = 0, ?Y:Int = 0) 
	{
		super(0);
		_pos = new FlxPoint(X, Y);
		
		
		
		
	}
	
	function get_x():FlxPoint 
	{
		return _pos.x;
	}
	
	function set_x(value:FlxPoint):FlxPoint 
	{
		return _pos.x = value;
	}
	
	public var x(get_x, set_x):FlxPoint;
	
	
	function get_y():FlxPoint 
	{
		return _pos.y;
	}
	
	function set_y(value:FlxPoint):FlxPoint 
	{
		return _pos.y = value;
	}
	
	public var y(get_y, set_y):FlxPoint;
	
}