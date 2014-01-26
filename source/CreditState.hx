package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.tweens.FlxTween;
import flixel.ui.FlxButton;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Tile Isle
 */
class CreditState extends FlxState
{

	private var _texts:FlxBitmapFont;
	private var _btnClose:FlxButton;
	
	
	override public function create():Void
	{
		
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		add(new FlxSprite(0, 0, "assets/images/blur_image.png"));
		
		_texts = new FlxBitmapFont("assets/images/font.png", 8, 8, FlxBitmapFont.TEXT_SET1, 16);
		_texts.setText("This Game was made in St Louis, Mo\nduring the 2014 Global Game Jam!\n\nT I Hely - Programming / Design Lead\nJevion White - Design / Art / Misc\nStephanie Ponevilai - Level Design\nJulie Stone - Level Design\nCam Vo - Art\nVicky Hedgecock - Art\nIsaac Benrubi - Music / Sound FX\nJordan Covert - Art\n\nJens Fischer - HaxeFlixel Support Guru!\n\n\nThank you for playing!", true, 0, 4, FlxBitmapFont.ALIGN_CENTER, true);
		add(_texts);
		FlxSpriteUtil.screenCenter(_texts, true, false);
		_texts.y = 10;
		
		_btnClose = new FlxButton(0, 0, "Back", goBack);
		_btnClose.x = FlxG.width - _btnClose.width - 10;
		_btnClose.y = FlxG.height - _btnClose.height -10;
		add(_btnClose);
		
		FlxG.camera.fade(0xff000000, .2, true);
		
		super.create();
	}
	
	private function goBack():Void
	{
		FlxG.camera.fade(0xff000000, .2, false, doneFadeOut);
	}
	
	
	private function doneFadeOut():Void
	{
		FlxG.switchState(new MenuState());
	}
	
}