package ;

import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.util.FlxAngle;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;

/**
 * ...
 * @author Tile Isle
 */
class Folk extends FlxSprite
{

	
	private var _brain:FSM;
	private var _scareRange:Int = 100;
	private static inline var SPEED:Int = 120;
	private var _runTimer:Float;
	private var _dir:Int;
	
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		
		var sprs:Array<String> = [];
		sprs.push("assets/images/vill girl1.png");
		sprs.push("assets/images/girl 2.png");
		
		loadGraphic(FlxRandom.getObject(sprs), true, true, 24, 24);
		animation.add("walk-down", [0, 1, 2, 1], 6, true);
		animation.add("idle-down", [1], 6, false);
		animation.add("walk-up", [3,4,5,4], 6, true);
		animation.add("idle-up", [4], 6, false);
		animation.add("walk-side", [6,7,8,7], 6, true);
		animation.add("idle-side", [7], 6, false);
		facing = FlxObject.DOWN;
		animation.play("idle-down");
		width = 12;
		offset.x = 6;
		height = 14;
		offset.y = 8;
		
		_brain = new FSM();
		_brain.setState(idle);
		
		
		
	}
	
	private function idle():Void
	{
		velocity.x = 0;
		velocity.y = 0;
		
		if (Reg.playState.mode == Reg.playState.MODE_H && FlxMath.distanceBetween(this, Reg.playState.currentSpr) < _scareRange)
		{
			_brain.setState(runAway);
		}
		else
		{
			if (FlxRandom.chanceRoll(2))
			{
				_runTimer = 0;
				_dir = FlxRandom.intRanged(0, 3) * 90;
				_brain.setState(wander);
			}
		}
	}
	
	private function wander():Void
	{
		var v = FlxAngle.rotatePoint(SPEED * .2, 0, 0, 0, _dir);
		velocity.x = v.x;
		velocity.y = v.y;
		
		if (velocity.x > 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
			facing = FlxObject.RIGHT;
		else if (velocity.x < 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
			facing = FlxObject.LEFT;
		else if (velocity.y > 0)
			facing = FlxObject.DOWN;
		else if (velocity.y < 0)
			facing = FlxObject.UP;
		if (Reg.playState.mode == Reg.playState.MODE_H && FlxMath.distanceBetween(this, Reg.playState.currentSpr) < _scareRange)
		{
			_brain.setState(runAway);
		}
		else
		{
			if (_runTimer > 3)
				_brain.setState(idle);
			else
			{
				_runTimer += FlxG.elapsed * FlxRandom.intRanged(1,5);
			}
		}
	}
	
	private function runAway():Void
	{
		var a:Float = FlxAngle.angleBetween(Reg.playState.currentSpr, this, true);
		var v:FlxPoint = FlxAngle.rotatePoint(SPEED, 0, 0, 0, a);
		velocity.x = v.x;
		velocity.y = v.y;
		if (velocity.x > 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
			facing = FlxObject.RIGHT;
		else if (velocity.x < 0 && Math.abs(velocity.x) > Math.abs(velocity.y))
			facing = FlxObject.LEFT;
		else if (velocity.y > 0)
			facing = FlxObject.DOWN;
		else if (velocity.y < 0)
			facing = FlxObject.UP;
		
		if (Reg.playState.mode != Reg.playState.MODE_H || FlxMath.distanceBetween(this, Reg.playState.currentSpr) >= _scareRange)
		{
			if (_runTimer > 3)
				_brain.setState(idle);
			else
			{
				_runTimer += FlxG.elapsed * FlxRandom.intRanged(2,4);
			}
			
		}
		else
		{
			_runTimer = 0;
		}
		
	}
	
	override public function update():Void 
	{
		_brain.update();
		
		switch (facing)
		{
			case FlxObject.UP:
				if (velocity.y < 0)
					animation.play("walk-up");
				else
					animation.play("idle-up");
			case FlxObject.DOWN:
				if (velocity.y > 0)
					animation.play("walk-down");
				else
					animation.play("idle-down");
			case FlxObject.RIGHT:
				if (velocity.x > 0)
					animation.play("walk-side");
				else
					animation.play("idle-side");
			case FlxObject.LEFT:
				if (velocity.x < 0)
					animation.play("walk-side");
				else
					animation.play("idle-side");
		}
		
		
		super.update();
	}
	
}