package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxSound;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Tile Isle
 */
class GameOverState extends FlxState
{

	private var _btnPlay:FlxButton;
	private var _btnMenu:FlxButton;
	private var _going:Bool = false;
	
	public override function create() 
	{
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		add(new FlxSprite(0, 0, "assets/images/game_over.png"));
		
		_btnPlay = new FlxButton(0, 0, "Play Again", goPlay);
		_btnPlay.onUp.sound = new FlxSound().loadEmbedded(SndAssets.SND_BUTTON,false);
		_btnPlay.x = (FlxG.width / 2) - _btnPlay.width - 10;
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		add(_btnPlay);
		
		_btnMenu = new FlxButton(0, 0, "Menu", goMenu);
		_btnMenu.onUp.sound = new FlxSound().loadEmbedded(SndAssets.SND_BUTTON,false);
		_btnMenu.x = (FlxG.width / 2) + 10;
		_btnMenu.y = FlxG.height - _btnMenu.height - 10;
		add(_btnMenu);
		
		
		super.create();
	}
	
	private function goMenu():Void
	{
		if (_going)
			return;
		_going = true;
		FlxG.camera.fade(0xff000000, .2, false, goMenuDone);
	}
	
	private function goPlay():Void
	{
		if (_going)
			return;
		_going = true;
		FlxG.camera.fade(0xff000000, .2, false, goPlayDone);
	}
	
	private function goMenuDone():Void
	{
		Reg.levelX = 0;
		Reg.levelY = 0;
		FlxG.switchState(new MenuState());
		
	}
	
	private function goPlayDone():Void
	{
		Reg.levelX = 0;
		Reg.levelY = 0;
		FlxG.switchState(new PlayState());
		
	}
	
}