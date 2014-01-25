package;

import flixel.FlxG;
import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{
	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	static public var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	static public var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	static public var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	static public var score:Int = 0;
	/**
	 * Generic bucket for storing different <code>FlxSaves</code>.
	 * Especially useful for setting up multiple save slots.
	 */
	static public var saves:Array<FlxSave> = [];
	
	static public var GameInitialized:Bool = false;
	
	static public inline var GameWidth:Int = 640;
	static public inline var GameHeight:Int = 480;
	
	static public var playState:PlayState;
	
	static public var levelX:Int = 0;
	static public var levelY:Int = 0;
	
	static public function initGame():Void
	{
		if (GameInitialized) return;
		saves[0] = new FlxSave();
		saves[0].bind("flixel");
		trace('init');
		if (saves[0].data.volume != null)
		{
			FlxG.sound.volume = saves[0].data.volume;
		}
		else
			FlxG.sound.volume = 0.5;
		
		#if desktop
		IsFullscreen = (saves["flixel"].data.fullscreen != null) ? saves["flixel"].data.fullscreen : true;
		#end
		
		levels.push(new Array());
		levels.push(new Array());
		levels.push(new Array());
		levels[0].push("assets/maps/level001.oel");
		levels[0].push("assets/maps/level002.oel");
		levels[0].push("assets/maps/level003.oel");
		levels[1].push("assets/maps/level004.oel");
		levels[1].push("assets/maps/level005.oel");
		levels[1].push("assets/maps/level006.oel");
		levels[2].push("assets/maps/level007.oel");
		levels[2].push("assets/maps/level008.oel");
		levels[2].push("assets/maps/level009.oel");
		
		
		
		GameInitialized = true;
	}
}