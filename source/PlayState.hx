package;

import flash.Lib;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
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
	
	private var _level:FlxOgmoLoader;
	private var _tmBackground:FlxTilemap;
	
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
		
		
		
		_level = new FlxOgmoLoader("assets/maps/level001.oel");
		_tmBackground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds");

		
		add(_tmBackground);
		
		_player = new Player();
		FlxSpriteUtil.screenCenter(_player);
		add(_player);
		
		FlxG.camera.follow(_player, FlxCamera.STYLE_LOCKON);
		/*
		FlxG.camera.zoom = 2;
		var offsetX:Float = 0;
		var offsetY:Float = 0;
		if (FlxG.camera.zoom > 1) 
		{
			offsetX = (FlxG.width / FlxG.camera.zoom);
			offsetY = (FlxG.height / FlxG.camera.zoom);
		}
		FlxG.camera.setBounds(0 - (offsetX / 2), 0 - (offsetY / 2), FlxG.width + offsetX, FlxG.height + offsetY, false);
	   
		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);
	   
		*/
		
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