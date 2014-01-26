package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.system.resolution.FillResolutionPolicy;
import flixel.system.resolution.FixedResolutionPolicy;
import flixel.system.resolution.RatioResolutionPolicy;
import flixel.system.resolution.RelativeResolutionPolicy;
import flixel.system.resolution.StageSizeResolutionPolicy;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{
	
	private var _btnPlay:FlxButton;
	private var _btnOptions:FlxButton;
	private var _leaving:Bool = false;
	private var _loading:Bool = true;
	private var _btnCredits:FlxButton;
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		FlxG.resolutionPolicy = new RatioResolutionPolicy();
		Reg.PlayMusic(SndAssets.MUS_TITLE);
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		add(new FlxSprite(0, 0, "assets/images/start_screen_logo.png"));
		
		_btnPlay = new FlxButton(0,0, "Play", goPlay);
		_btnOptions = new FlxButton(0, 0, "Options", goOptions);
		_btnPlay.x = 10;
		FlxSpriteUtil.screenCenter(_btnOptions, true, false);
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		_btnOptions.y = FlxG.height - _btnOptions.height - 10;
		
		
		
		_btnCredits = new FlxButton(0, 0, "Credits", goCredits);
		_btnCredits.x = FlxG.width - _btnCredits.width - 10;
		_btnCredits.y = FlxG.height - _btnCredits.height - 10;
		
		_btnPlay.onUp.sound  = new FlxSound().loadEmbedded(SndAssets.SND_BUTTON,false);
		_btnOptions.onUp.sound = new FlxSound().loadEmbedded(SndAssets.SND_BUTTON,false);
		_btnCredits.onUp.sound = new FlxSound().loadEmbedded(SndAssets.SND_BUTTON,false);
		
		add(_btnPlay);
		add(_btnOptions);
		add(_btnCredits);
		
		FlxG.camera.fade(0xff000000, .33, true, finishLoading);
		
		//Reg.PlayMusic("music/Depressing as Hell.ogg");
		
		super.create();
	}
	
	private function goCredits():Void
	{
		if (_loading || _leaving)
			return;
		_leaving = true;
		FlxG.camera.fade(0xff000000, .33, false, finishGoCredits, false);
	}
	
	private function finishGoCredits():Void
	{
		FlxG.switchState(new CreditState());
	}
	
	private function finishLoading():Void
	{
		_loading = false;
	}
	
	private function goPlay():Void 
	{
		if (_loading || _leaving)
			return;
		_leaving = true;
		FlxG.camera.fade(0xff000000, .33, false, finishGoPlay, false);
	}
	
	private function finishGoPlay():Void
	{
		FlxG.switchState(new PlayState());
		
	}
	
	private function goOptions():Void
	{
		if (_loading || _leaving)
			return;
		_leaving = true;
		FlxG.camera.fade(0xff000000, .33, false, finishGoOptions, false);
	}
	
	private function finishGoOptions():Void
	{
		FlxG.switchState(new OptionsState());
	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		
		
		
		super.update();
	}	
}