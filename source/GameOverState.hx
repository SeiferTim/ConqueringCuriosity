package ;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Tile Isle
 */
class GameOverState extends FlxState
{

	private var _btnPlay:FlxButton;
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
		_btnPlay.x = (FlxG.width / 2) - (_btnPlay.width / 2);
		_btnPlay.y = FlxG.height - _btnPlay.height - 10;
		add(_btnPlay);
		
		super.create();
	}
	
	private function goPlay():Void
	{
		if (_going)
			return;
		_going = true;
		FlxG.camera.fade(0xff000000, .2, false, goPlayDone);
	}
	
	private function goPlayDone():Void
	{
		Reg.levelX = 0;
		Reg.levelY = 0;
		FlxG.switchState(new PlayState());
		
	}
	
}