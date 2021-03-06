package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

/**
 * ...
 * @author Tile Isle
 */
class STLState extends FlxState
{

	private var _sprSTL:FlxSprite;
	private var _twn:FlxTween;
	private var _tmr:FlxTimer;
	private var _doneL:Bool = false;
	private var _doneM:Bool = false;
	
	override public function create() 
	{
		Reg.InitKong();
		FlxG.autoPause = false;
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_sprSTL = new FlxSprite(0, 0, "assets/images/made_in_stl.png");
		_sprSTL.alpha = 0;
		add(_sprSTL);
		
		_tmr  = FlxTimer.start(.4, startFadeIn, 1);
		startFlash();
		super.create();
	}
	
	override public function update():Void 
	{
		if (_doneL && _doneM)
		{
			_doneL = _doneM = false;
			donePause();
		}
		
		super.update();
	}
	
	private function startFadeIn(T:FlxTimer):Void
	{
		_twn = FlxTween.multiVar(_sprSTL, { alpha:1 }, .4, { type:FlxTween.ONESHOT, ease:FlxEase.bounceOut, complete:doneFadeIn } );
	}
	
	private function startFlash():Void
	{
		FlxG.camera.flash(0xffffff, .3, doneFlash);
	}
	
	private function doneFadeIn(T:FlxTween):Void
	{
		FlxG.sound.play(SndAssets.MUS_MADEINSTL, .6, false, true, doneMusic);
	}
	
	private function doneMusic():Void
	{
		_doneM = true;
	}
	
	private function doneFlash():Void
	{
		FlxG.sound.play(SndAssets.SND_THUNDER, .6,false,true,doneThunder);
		
	}
	
	private function doneThunder():Void
	{
		_doneL = true;
	}
	
	private function donePause():Void
	{
		FlxG.camera.fade(0xff000000, .2, false, doneFadeOut);
	}
	
	private function doneFadeOut():Void 
	{
		FlxG.switchState(new MenuState());
	}
	
	
	
	
}