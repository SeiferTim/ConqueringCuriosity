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

	private var _box:FlxSprite;
	private var _arrow:FlxSprite;
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
		//_border = new FlxSprite(2, (FlxG.height / 2) + 10).makeGraphic(FlxG.width - 4, Std.int((FlxG.height / 2) - 12), 0xff333333);
		//_back = new FlxSprite(4, _border.y + 2).makeGraphic(FlxG.width - 6, Std.int(_border.height - 2), 0xffccccff);
		
		_box = new FlxSprite(2, 0, "assets/images/box.png");
		_box.y = FlxG.height - _box.height - 2;
		_dialog = new FlxBitmapFont("assets/images/font.png", 8, 8, FlxBitmapFont.TEXT_SET1, 95);
		_dialog.x = _box.x + 10;
		_dialog.y = _box.y + 10;
		_dialog.setText(DialogText, true, 0, 2, "left", true);
		
		_arrow = new FlxSprite(0, 0).loadGraphic("assets/images/arrow.png", true);
		_arrow.animation.add("bounce", [0, 1], 6, true);
		_arrow.animation.play("bounce");
		_arrow.x = _box.x + _box.width - _arrow.width - 2;
		_arrow.y = _box.y + _box.height - _arrow.height - 2;
		
		_dialog.scrollFactor.x = _dialog.scrollFactor.y = _box.scrollFactor.x = _box.scrollFactor.y = _arrow.scrollFactor.x = _arrow.scrollFactor.y  = 0;
		//_border.alpha = _back.alpha = _dialog.alpha = 0;
		//add(_border);
		//add(_back);
		add(_box);
		add(_dialog);
		add(_arrow);
		
		_box.alpha = _dialog.alpha = _arrow.alpha = 0;
		
		_twn = FlxTween.multiVar(this, { _alpha:1 }, .33, { type:FlxTween.ONESHOT, ease:FlxEase.quartInOut, complete:fadeInDone } );
		
	}
	
	private function fadeInDone(T:FlxTween):Void
	{
		FlxG.sound.play(SndAssets.SND_DIALOG1, .2);
	}
	
	override public function update():Void
	{
		_box.alpha = _arrow.alpha = _dialog.alpha = _alpha;
		if (_in && _alpha >= 1)
		{
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
		FlxG.sound.play(SndAssets.SND_DIALOG2, .2);
		Reg.DiagShown = false;
		Reg.CurDiag = null;
		kill();
		destroy();
	}
	
}