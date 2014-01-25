package;

import flash.Lib;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var _player:Player;
	private var _back:FlxSprite;
	
	static var LEVEL_MIN_X;
	static var LEVEL_MAX_X;
	static var LEVEL_MIN_Y;
	static var LEVEL_MAX_Y;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		
		
				
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		_back = FlxGridOverlay.create(24, 24, FlxG.width * 2, FlxG.height * 2, false, true, 0xff339933, 0xff33cc33);
		add(_back);
		
		_player = new Player();
		FlxSpriteUtil.screenCenter(_player);
		add(_player);
		
		trace(FlxG.camera.width + " " + FlxG.camera.height);
		//FlxG.camera.zoom = 2;
		FlxG.camera.setBounds(0,0,FlxG.width*2, FlxG.height*2);
		//FlxG.camera.bounds = new FlxRect(0, 0, FlxG.width, FlxG.height);
		FlxG.camera.follow(_player, FlxCamera.STYLE_TOPDOWN);
		//FlxG.camera.focusOn(_player.getMidpoint()) ;
		
		super.create();
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