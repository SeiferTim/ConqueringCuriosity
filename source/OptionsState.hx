package ;

import flixel.addons.text.FlxBitmapFont;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.system.FlxAssets;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.ui.FlxSlider;
import flixel.util.FlxSpriteUtil;

/**
 * ...
 * @author Tile Isle
 */
class OptionsState extends FlxState
{

	private var _btnDone:FlxButton;
	private var _loading:Bool = true;
	private var _leaving:Bool = false;
	
	private var _txtHeading:FlxBitmapFont;
	
	private var _optVolume:CustomSlider;
	private var _txtVolume:FlxBitmapFont;
	
	override public function create():Void
	{
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
		
		add(new FlxSprite(0, 0, "assets/images/blur_image.png"));
		
		_btnDone = new FlxButton(0, 0, "Done", goDone);
		_btnDone.onUp.sound = new FlxSound().loadEmbedded(SndAssets.SND_BUTTON,false);
		_btnDone.x = (FlxG.width / 2)  + 10;
		_btnDone.y = FlxG.height - _btnDone.height - 10;
		add(_btnDone);
		
		//_txtHeading = new FlxText(0, 10, FlxG.width, "Options", 12);
		//_txtHeading.setFormat(null, 12, 0xffffff, "center");
		
		_txtHeading = new FlxBitmapFont("assets/images/font.png", 8, 8, FlxBitmapFont.TEXT_SET1, 95);
		_txtHeading.setText("Options", false, 0, 0, FlxBitmapFont.ALIGN_CENTER, true);
		_txtHeading.x = 0;
		_txtHeading.y = 10;
		FlxSpriteUtil.screenCenter(_txtHeading, true, false);
		add(_txtHeading);
		
	//	_txtVolume = new FlxText(10, _txtHeading.y + _txtHeading.height + 10, 60, "Volume:", 10);
//		_txtVolume.setFormat(null, 10, 0xffffff, "right");
		_txtVolume = new FlxBitmapFont("assets/images/font.png", 8, 8, FlxBitmapFont.TEXT_SET1, 95);
		_txtVolume.setText("Volume", false, 0, 0, FlxBitmapFont.ALIGN_RIGHT, true);
		_txtVolume.x = 10;
		_txtVolume.y = _txtHeading.y + _txtHeading.height + 20;
		add(_txtVolume);
		
		_optVolume = new CustomSlider(_txtVolume.x + _txtVolume.width + 10, _txtVolume.y-4, Std.int(FlxG.width - 30 - _txtVolume.width), 16, 8, 16, 0, 1, onVolClick, 0xff666666, 0xffffffff);
		_optVolume.decimals = 1;
		_optVolume.value = FlxG.sound.volume;
		
		add(_optVolume);
		
		FlxG.camera.fade(0xff000000, .33, true, finishLoad);
		
		super.create();
	}
	
	private function onVolClick(Value:Float):Void
	{
		FlxG.sound.volume = Value;
		Reg.saves[0].data.volume = FlxG.sound.volume;
		Reg.saves[0].flush();
		//FlxG.sound.play(SoundAssets.SND_BUTTONUP);
	}
	
	private function goDone():Void
	{
		if (_loading || _leaving)
			return;
		_leaving = true;
		FlxG.camera.fade(0xff000000, .33, false, finishGoDone);
	}
	
	private function finishGoDone():Void
	{
		FlxG.switchState(new MenuState());
	}
	
	private function finishLoad():Void 
	{
		_loading = false;
	}
	
	
	
}