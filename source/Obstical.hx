package ;

import flixel.FlxSprite;

/**
 * ...
 * @author Tile Isle
 */
class Obstical extends FlxSprite
{

	private var _obsticalType:String;
	private var _open:Bool = false;
	
	public function new(X:Float=0, Y:Float=0, ObsticalType:String) 
	{
		super(X, Y);
		_obsticalType = ObsticalType;
		trace(_obsticalType);
		switch(_obsticalType)
		{
			case "door":
				loadGraphic("assets/images/door.png", true);
		}
		animation.add("closed", [0]);
		animation.add("open", [1]);
		animation.play("closed");
	}
	
	function get_open():Bool 
	{
		return _open;
	}
	
	function set_open(value:Bool):Bool 
	{
		_open =  value;
		if (_open)
			animation.play("open");
		else
			animation.play("close");
		return _open;
	}
	
	public var open(get_open, set_open):Bool;
	
	function get_obsticalType():String 
	{
		return _obsticalType;
	}
	
	public var obsticalType(get_obsticalType, null):String;
	
	
	
}