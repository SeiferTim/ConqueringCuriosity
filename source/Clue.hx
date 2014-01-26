package ;

import flixel.FlxSprite;

/**
 * ...
 * @author Tile Isle
 */
class Clue extends FlxSprite
{
	private var _whichClue:Int;

	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		loadGraphic("assets/images/clue.png", true, false);
		_whichClue = 0x0001;
		
	}
	
	function get_whichClue():Int 
	{
		return _whichClue;
	}
	
	public var whichClue(get_whichClue, null):Int;
	
}