package ;

import flash.display.Bitmap;
import flixel.addons.api.FlxKongregate;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Tile Isle
 */
class EndSceneState extends FlxState
{

	private var _whichScene:Int = 0;
	private var _img01:FlxSprite;
	private var _img02:FlxSprite;
	private var _img03:FlxSprite;
	private var _glasses:FlxSprite;
	private var _twn:FlxTween;
	private var _sTwn:FlxTween;
	
	
	override public function create():Void
	{
		
		Reg.PlayMusic(SndAssets.MUS_END);
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_img01 = new FlxSprite(0, 0, "assets/images/end-scene-01.png");
		_img02 = new FlxSprite(0, 0, "assets/images/end-scene-02.png");
		_img03 = new FlxSprite(0, 0, "assets/images/end-scene-03.png");
		_img02.y = FlxG.height - _img02.height;
		_img03.y = FlxG.height - _img03.height;
		add(_img01);
		add(_img02);
		add(_img03);
		
		_img02.visible = false;
		_img03.visible = false;
		
		_glasses = new FlxSprite(0, 0, "assets/images/glasses_use.png");
		add(_glasses);
		//FlxSpriteUtil.screenCenter(_glasses, true, false);
		_glasses.x = 87;
		_glasses.y = -200;
		
		if (Reg.HasKong)
		{
			FlxKongregate.submitStats("finished_game", 1);
		}
		FlxG.camera.fade(0xff000000, .2, true, finishFadeIn);
		
		super.create();
	}
	
	private function finishedGlasses(T:FlxTween):Void
	{
		var _dwi:FlxSprite = new FlxSprite(0, 8, "assets/images/deal-text.png");
		var avatar:FlxSprite = new FlxSprite(0, 0, "assets/images/dealwithit.png");
		//_dwi.setFormat(null, 18, 0x000000, "center", FlxText.BORDER_OUTLINE, 0xffffff);
		FlxSpriteUtil.screenCenter(_dwi, true,false);
		add(_dwi);
		if (Reg.HasKong)
		{
			FlxKongregate.submitStats("dealt_with_it", 1);
			var a:Bitmap = new Bitmap(avatar.pixels);
			FlxKongregate.submitAvatar(a, DoneSubmitAvatar);
			
		}
		
	}
	
	private function DoneSubmitAvatar():Void
	{
		
	}
	
	private function finishFadeIn():Void
	{
		add( new DialogBox("What is this place?\nA makeshift laboratory?\n\nI feel as if I've been led here...\n             ...but for what purpose?"));
		//_sTwn = FlxTween.multiVar(_img01, { y:FlxG.height - _img01.height }, 5, { type:FlxTween.PINGPONG } );
		_whichScene = 1;
	}

	private function doneFlash():Void
	{
		if (_whichScene == 2)
		{
			add(new DialogBox("'Hello, Henry.'\n\n'Hyde!'\n\n'Nice of you to join me... did you\nlike what I've done with your serum?'\n\n'What!?'"));
			_img01.visible = false;
			_img02.visible = true;
			//_sTwn.cancel();
			//_sTwn = FlxTween.multiVar(_img02, { y:FlxG.height - _img02.height }, 20, { type:FlxTween.PINGPONG } );
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
			//_sTwn.cancel();
			_img02.visible = false;
			_img03.visible = true;
			add(new DialogBox("'...I AM IN CONTROL!\n\n\n          MWAHA HAHA HAHAAAA!'\n\n\n\n                               -END-"));
			//_sTwn = FlxTween.multiVar(_img03, { y: FlxG.height - _img03.height } 10, { type:FlxTween.PINGPONG } );
			_twn = FlxTween.multiVar(_glasses, { y: 85 }, 30, { type:FlxTween.ONESHOT, complete:finishedGlasses } );
		
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
			//FlxG.camera.flash(0xff000000, .2, doneFlash);
			_whichScene++;
			doneFlash();
		}
		if (_whichScene == 9 && !Reg.DiagShown)
		{
			FlxG.camera.fade(0xff000000, .2, false, doneFadeOut);
		}
		
		super.update();
	}
		
	
}