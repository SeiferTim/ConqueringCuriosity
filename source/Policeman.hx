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
class Policeman extends FlxSprite
{
	private var _brain:FSM;
	private var _speed:Int;
	private var _runTimer:Float;
	private var _dir:Int;
	private var _scareRange:Int = 300;
	
	public function new(X:Float=0, Y:Float=0) 
	{
		super(X, Y);
		_speed = 100;
		loadGraphic("assets/images/policepix.png", true, true);
		animation.add("walk-side", [0, 1, 0, 2], 6, true);
		animation.add("idle-side", [0]);
		animation.add("walk-down", [3, 4, 3, 5], 6, true);
		animation.add("idle-down", [3]);
		animation.add("walk-up", [6, 7, 6, 8], 6, true);
		animation.add("idle-up", [6]);
		animation.play("idle-down");
		facing = FlxObject.DOWN;
		
		_brain = new FSM();
		_brain.setState(idle);
	}
	
	private function idle():Void
	{
		velocity.x = 0;
		velocity.y = 0;
		
		if (Reg.playState.mode == Reg.playState.MODE_H && FlxMath.distanceBetween(this, Reg.playState.currentSpr) < _scareRange)
		{
			_brain.setState(runTowards);
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
		var v = FlxAngle.rotatePoint(_speed * .2, 0, 0, 0, _dir);
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
			_brain.setState(runTowards);
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
	
	private function runTowards():Void
	{
		var a:Float = FlxAngle.angleBetween(this, Reg.playState.currentSpr, true);
		var v:FlxPoint = FlxAngle.rotatePoint(_speed, 0, 0, 0, a);
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