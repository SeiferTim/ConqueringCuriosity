package ;

import flixel.FlxSprite;

/**
 * ...
 * @author Tile Isle
 */
class Clue extends FlxSprite
{
	private var _whichClue:Int;

	public function new(X:Float=0, Y:Float=0, WhichClue:Int) 
	{
		super(X, Y);
		switch (WhichClue)
		{
			case 0:
				_whichClue = 0x0001;
				loadGraphic("assets/images/empty_vial.png", true);
			case 1:
				_whichClue = 0x0010;
				loadGraphic("assets/images/notes.png", true);
			case 2:
				_whichClue = 0x0100;
				loadGraphic("assets/images/footprints.png", true);
			case 3:
				_whichClue = 0x1000;
				loadGraphic("assets/images/key.png", true);
				visible = false;
		}
		animation.add("clue", [0, 1], 6, true);
		animation.play("clue");
		
		
	}
	
	override public function update():Void 
	{
		if (_whichClue == 3)
		{
			if (Reg.CollectedClues == 0x0111)
				visible = true;
		}
		
		super.update();
	}
	
	function get_whichClue():Int 
	{
		return _whichClue;
	}
	
	public var whichClue(get_whichClue, null):Int;
	
}