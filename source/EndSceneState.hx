package ;

import flixel.FlxG;
import flixel.FlxState;

/**
 * ...
 * @author Tile Isle
 */
class EndSceneState extends FlxState
{

	private var _whichScene:Int = 0;
	
	
	override public function create():Void
	{
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		FlxG.camera.fade(0xff000000, .2, true, finishFadeIn);
		
		super.create();
	}
	
	private function finishFadeIn():Void
	{
		add( new DialogBox("What is this place?\nA makeshift laboratory?\n\nI feel as if I've been led here...\n             ...but for what purpose?"));
		_whichScene = 1;
	}

	private function doneFlash():Void
	{
		if (_whichScene == 2)
		{
			add(new DialogBox("'Hello, Henry.'\n\n'Hyde!'\n\n'Nice of you to join me... did you\nlike what I've done with your serum?'\n\n'What!?'"));
			_whichScene = 3;
		}
		else if (_whichScene == 4)
		{
			add(new DialogBox("'That's right! You've been chasing\nafter ME this whole time -\nthat is to say - chasing yourself!'\n\n'Why? What do you stand to gain?'\n\n'Don't you see, Doctor?'"));
			_whichScene = 5;
		}
		else if (_whichScene == 6)
		{
			add(new DialogBox("'I've made you let go of some of\nyour humanity!'\n\n'No...'\n\n'YES! And now...'"));
			_whichScene = 7;
		}
		else if (_whichScene == 8)
		{
			add(new DialogBox("'...I AM IN CONTROL!\n\n\n          MWAHA HAHA HAHAAAA!'\n\n\n\n                               -END-"));
			_whichScene = 9;
		}
	}
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new MenuState());
	}
	
	override public function update():Void 
	{
		if ((_whichScene == 1 || _whichScene == 3 || _whichScene == 5 || _whichScene == 7 ) && !Reg.DiagShown)
		{
			FlxG.camera.flash(0xff000000, .2, doneFlash);
			_whichScene++;
		}
		if (_whichScene == 9 && !Reg.DiagShown)
		{
			FlxG.camera.fade(0xff000000, .2, false, doneFadeOut);
		}
		
		super.update();
	}
		
	
}