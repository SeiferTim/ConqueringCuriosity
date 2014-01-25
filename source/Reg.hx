package;

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
	
	static public function initGame():Void
	{
		if (GameInitialized) return;
		//save = new FlxSave();
		//save.bind("flixel");
		
		//if (save.data.volume != null)
		//{
		//	FlxG.sound.volume = save.data.volume;
		//}
		//else
		//	FlxG.sound.volume = 0.5;
		
		#if desktop
		//IsFullscreen = (save.data.fullscreen != null) ? save.data.fullscreen : true;
		#end
		
		
		
		GameInitialized = true;
	}
}