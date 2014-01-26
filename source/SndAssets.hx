package ;

/**
 * ...
 * @author Tile Isle
 */
class SndAssets
{

	inline static public var SND_TRANSFORM:String = "assets/sounds/transform.wav";
	inline static public var SND_WARN:String = "assets/sounds/Danger - Heart Beat2.wav";
	inline static public var SND_DIALOG1:String = "assets/sounds/dialog1.wav";
	inline static public var SND_DIALOG2:String = "assets/sounds/dialog2.wav";
	inline static public var SND_PICKUP:String = "assets/sounds/pickup.wav";
	inline static public var SND_HIT:String = "assets/sounds/hit.wav";
	inline static public var SND_BUTTON:String = "assets/sounds/button.wav";
	inline static public var SND_THUNDER:String = "assets/sounds/thunder.wav";
	
	#if flash
	inline static public var MUS_TITLE:String = "assets/music/Saddness Incarnate.mp3";
	inline static public var MUS_PLAY:String = "assets/music/Creepy 1.mp3";
	inline static public var MUS_END:String = "assets/music/Depressing as Hell.mp3";
	inline static public var MUS_MADEINSTL:String = "assets/music/madeinstl.mp3";
	#end
	#if !flash
	inline static public var MUS_TITLE:String = "assets/music/Saddness Incarnate.ogg";
	inline static public var MUS_PLAY:String = "assets/music/Creepy 1.ogg";
	inline static public var MUS_END:String = "assets/music/Depressing as Hell.ogg";
	inline static public var MUS_MUS_MADEINSTL:String = "assets/music/madeinstl.ogg";
	#end
	
}