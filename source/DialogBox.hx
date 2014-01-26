package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

/**
 * ...
 * @author Tile Isle
 */
class DialogBox extends FlxGroup
{

	private var _border:FlxSprite;
	private var _back:FlxSprite;
	private var _dialog:FlxBitmapFont;
	private var _done:FlxSprite;
	private var _alpha:Float = 0;
	private var _in:Bool = true;
	private var _twn:FlxTween;
	 
	public function new(DialogText:String) 
	{
		super();
		Reg.CurDiag = this;
		Reg.DiagShown = true;
		_border = new FlxSprite(2, (FlxG.height / 2) + 10).makeGraphic(FlxG.width - 4, Std.int((FlxG.height / 2) - 12), 0xff333333);
		_back = new FlxSprite(4, _border.y + 2).makeGraphic(FlxG.width - 6, Std.int(_border.height - 2), 0xffccccff);
		_dialog = new FlxBitmapFont("assets/images/font.png", 8, 8, FlxBitmapFont.TEXT_SET1, 16);
		_dialog.x = _back.x + 2;
		_dialog.y = _back.y +2;
		_dialog.setText(DialogText, true, 0, 2, "left", true);
		_dialog.scrollFactor.x = _dialog.scrollFactor.y = _border.scrollFactor.x = _border.scrollFactor.y = _back.scrollFactor.x = _back.scrollFactor.y = 0;
		_border.alpha = _back.alpha = _dialog.alpha = 0;
		add(_border);
		add(_back);
		add(_dialog);
		
		_twn = FlxTween.multiVar(this, { _alpha:1 }, .33, { type:FlxTween.ONESHOT, ease:FlxEase.quartInOut, complete:fadeInDone } );
		
	}
	
	private function fadeInDone(T:FlxTween):Void
	{
		
	}
	
	override public function update():Void
	{
		_border.alpha = _back.alpha = _dialog.alpha = _alpha;
		trace(_in + " " + _alpha); 
		if (_in && _alpha >= 1)
		{
			trace('ready');
			if (FlxG.keys.anyJustReleased(["X"]))
			{
				_in = false;
				_twn = FlxTween.multiVar(this, { _alpha:0 }, .33, { type:FlxTween.ONESHOT, ease:FlxEase.quartInOut, complete:fadeOutDone } );
			}
		}
		super.update();
		
	}
	
	private function fadeOutDone(T:FlxTween):Void
	{
		Reg.DiagShown = false;
		Reg.CurDiag = null;
		kill();
		destroy();
	}
	
}