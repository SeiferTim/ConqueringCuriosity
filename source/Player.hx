package ;

import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Tile Isle
 */
class Player extends FlxSprite
{

	private inline static var SPEED:Int = 200;
	
	public function new(X:Float=0, Y:Float=0, ?SimpleGraphic:Dynamic) 
	{
		super(X, Y);
		
		makeGraphic(16, 16, 0xffff0000);
		
	}
	
	override public function update():Void 
	{
		if (FlxG.keys.anyPressed(["UP"]))
		{
			velocity.y = -SPEED;
		}
		else if (FlxG.keys.anyPressed(["DOWN"]))
		{
			velocity.y = SPEED;
		}
		else
			velocity.y = 0;
		
		if (FlxG.keys.anyPressed(["LEFT"]))
		{
			velocity.x = -SPEED;
		}
		else if (FlxG.keys.anyPressed(["RIGHT"]))
		{
			velocity.x = SPEED;
		}
		else
			velocity.x = 0;
		
		if (x < FlxG.worldBounds.left) x += 4;
		if (x + width > FlxG.worldBounds.right) x -= 4;
		if (y < FlxG.worldBounds.top) y += 4;
		if (y + height > FlxG.worldBounds.bottom) y -= 4;
		
		super.update();
	}
	
}