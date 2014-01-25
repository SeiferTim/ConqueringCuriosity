package ;

import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.util.FlxGradient;

/**
 * ...
 * @author Tile Isle
 */
class BalanceMeter extends FlxGroup
{

	private var _border:FlxSprite;
	private var _back:FlxSprite;
	private var _indicator:FlxSprite;
	private var _value:Float;
	
	public function new() 
	{
		super(0);
		
		_border = FlxGradient.createGradientFlxSprite(96, 8, [0xffE2E2E2, 0xffdbdbdb, 0xffd1d1d1, 0xfffefefe]);
		_border.x = 4;
		_border.y = 4;
		_border.scrollFactor.x = _border.scrollFactor.y = 0;
		add(_border);
		
		_back = FlxGradient.createGradientFlxSprite(94, 6, [0xffff0000,  0xffffffff, 0xff0000ff],1,180);
		_back.x = 5;
		_back.y = 5;
		_back.scrollFactor.x = _back.scrollFactor.y = 0;
		add(_back);
		
		_indicator = new FlxSprite(0, 3).makeGraphic(3, 10, 0xff000000);
		_indicator.scrollFactor.x = _indicator.scrollFactor.y = 0;
		add(_indicator);
		
		_value = 50;
		
		updateIndicator();
	}
	
	private function updateIndicator():Void
	{
		var pos:Float;
		pos = _back.width * (_value * 0.01);
		_indicator.x = _back.x + pos - (_indicator.width / 2);
	}
	
	function get_value():Float 
	{
		return _value;
	}
	
	function set_value(value:Float):Float 
	{
		_value = value;
		if (_value < 0)
			_value = 0;
		if (_value > 100)
			_value = 100;
		updateIndicator();
		return _value;
	}
	
	public var value(get_value, set_value):Float;
	
}