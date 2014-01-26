package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxGradient;
import flixel.util.FlxSpriteUtil;

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
	private var _fadingOut:Bool = false;
	private var _fadingIn:Bool = false;
	private var _twn:FlxTween;
	private var _alpha:Float = 1;
	
	public function new() 
	{
		super(0);
		
		_border = FlxGradient.createGradientFlxSprite(60, 6, [0xffE2E2E2, 0xffdbdbdb, 0xffd1d1d1, 0xfffefefe]);
		FlxSpriteUtil.screenCenter(_border, true, false);
		_border.y = 16;
		_border.x = 16;
		_border.scrollFactor.x = _border.scrollFactor.y = 0;
		add(_border);
		
		_back = FlxGradient.createGradientFlxSprite(Std.int(_border.width - 2), Std.int(_border.height - 2), [0xffff0000,  0xffffffff, 0xff0000ff],1,180);
		_back.x = _border.x + 1;
		_back.y = _border.y +1;
		_back.scrollFactor.x = _back.scrollFactor.y = 0;
		add(_back);
		
		_indicator = new FlxSprite(0, 3).makeGraphic(3, Std.int(_border.height + 2), 0xff000000);
		_indicator.y = _border.y -1;
		_indicator.scrollFactor.x = _indicator.scrollFactor.y = 0;
		add(_indicator);
		
		_value = 0;
		
		updateIndicator();
	}
	
	private function updateIndicator():Void
	{
		var pos:Float;
		pos = _back.width * (_value * 0.01);
		_indicator.x = _back.x + pos - (_indicator.width / 2);
	
	}
	
	public function fadeOut():Void
	{
		if (_fadingOut)
			return;
		_fadingOut = true;
		if (_fadingIn)
			_twn.cancel();
		_fadingIn = false;
		_twn = FlxTween.multiVar(this, { _alpha: .2 }, .2, { type: FlxTween.ONESHOT, ease: FlxEase.quadInOut, complete: finishFadeOut} );
		
	}
	
	private function finishFadeOut(T:FlxTween ):Void
	{
		_fadingOut = false;
	}
	
	private function finishFadeIn(T:FlxTween):Void
	{
		_fadingIn = false;
	}
	
	public function fadeIn():Void
	{
		if (_fadingIn)
			return;
		_fadingIn = true;
		if (_fadingOut)
			_twn.cancel();
		_fadingOut = false;
		_twn = FlxTween.multiVar(this, { _alpha: 1 }, .2, { type: FlxTween.ONESHOT, ease: FlxEase.quadInOut, complete: finishFadeIn} );
		
	}
	
	override public function update():Void 
	{
		_border.alpha = _back.alpha = _indicator.alpha = _alpha;
		
		super.update();
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
	
	function get_alpha():Float 
	{
		return _alpha;
	}
	
	public var alpha(get_alpha, null):Float;
	
}