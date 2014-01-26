package;

import flash.display.BlendMode;
import flash.Lib;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.animation.FlxBaseAnimation;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxRect;
import flixel.util.FlxSpriteUtil;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	private inline static var SPEED_J:Int = 100;
	private inline static var SPEED_H:Int = 80;
	private inline static var TRANSFORM_SPEED:Float = .3;
	
	public  var MODE_J:Int = 0;
	public  var MODE_H:Int = 1;
	private var _mode:Int = 0;
	
	private var _level:FlxOgmoLoader;
	private var _tmBackground:FlxTilemap;
	private var _tmBackground2:FlxTilemap;
	private var _tmWalls:FlxTilemap;
	private var _grpObjects:FlxGroup;
	private var _tmForeground:FlxTilemap;
	
	private var _grpPlayer:FlxGroup;
	
	private var _currentSpr:FlxSprite;
	private var _jeckyl:FlxSprite;
	private var _hyde:FlxSprite;
	private var _playerPos:FlxSprite;
	private var _transforming:Bool = false;
	
	private var _burst:FlxEmitterExt;
	private var _meter:BalanceMeter;
	private var _loading:Bool = true;
	
	private var _playerHealth:Int = 100;
	//private var _barHealth:FlxBar;
	private var _twnAlphaTrans:FlxTween;
	private var _twnScaleTrans:FlxTween;
	private var _changingRoom:Bool = false;
	
	private var _destX:Int = -1;
	private var _destY:Int = -1;
	
	private var _twnRoom:FlxTween;
	
	private var _offsetX:Float = 0;
	private var _offsetY:Float = 0;
	private var _gameOvering:Bool = false;
	
	private var _shownFirstDiag:Bool = false;
	
	
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		Reg.playState = this;
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = false;
		#end
		
		Reg.levelX = 2;
		Reg.levelY = 2;
		
		_level = new FlxOgmoLoader(Reg.levels[Reg.levelY][Reg.levelX]);
		_grpObjects = new FlxGroup();
		_tmBackground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds");
		_tmBackground2 = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds2");
		_tmWalls = _level.loadTilemap("assets/images/walls.png", 16, 16, "Walls");
		_tmForeground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Foregrounds");
		add(_tmBackground2);
		add(_tmBackground);
		
		_grpObjects = new FlxGroup();
		add(_grpObjects);
		//add(_tmWalls);
		
		
		
		_grpPlayer = new FlxGroup();
		
		_jeckyl = new FlxSprite(0, 0).loadGraphic("assets/images/dr Jayfinal.png", true, true, 24, 24); //.makeGraphic(16, 16, 0xff0000ff);
		_jeckyl.animation.add("walk-down", [0, 1, 2, 1], 6, true);
		_jeckyl.animation.add("idle-down", [1], 6, false);
		_jeckyl.animation.add("walk-up", [3,4,5,4], 6, true);
		_jeckyl.animation.add("idle-up", [4], 6, false);
		_jeckyl.animation.add("walk-side", [6,7,8,7], 6, true);
		_jeckyl.animation.add("idle-side", [7], 6, false);
		_jeckyl.facing = FlxObject.DOWN;
		_jeckyl.animation.play("idle-down");
		_jeckyl.width = 12;
		_jeckyl.offset.x = 6;
		_jeckyl.height = 14;
		_jeckyl.offset.y = 8;
		
		_hyde = new FlxSprite(0, 0).makeGraphic(32, 32, 0xffff0000);
		_currentSpr = _jeckyl;
		
		_burst = new FlxEmitterExt();
		_burst.setRotation(0, 0);
		_burst.setMotion(0,.1, 1, 360, 60, 1);
		_burst.makeParticles("assets/images/particles.png", 100, 0, true, 0);
		//_burst.blend = BlendMode.SCREEN;
		
		_jeckyl.x = 100;
		_jeckyl.y = 100;

		_hyde.x = _jeckyl.x + (_jeckyl.width / 2) - (_hyde.width / 2);
		_hyde.y = _jeckyl.y + (_jeckyl.height / 2) - (_hyde.height / 2);
		
		add(_jeckyl);
		add(_burst);
		add(_hyde);
		_hyde.visible = false;
		_mode = MODE_J;
		
		add(_tmForeground);
		
		_meter = new BalanceMeter();
		add(_meter);
		
		//_barHealth = new FlxBar(FlxG.width - 100, 4, FlxBar.FILL_LEFT_TO_RIGHT, 96, 8, this, "playerHealth", 0, 100, true);
		//_barHealth.scrollFactor.x = _barHealth.scrollFactor.y = 0;
		
		//add(_barHealth);
		
		FlxG.camera.follow(_jeckyl, FlxCamera.STYLE_LOCKON);
		
				
		FlxG.camera.fade(0xff000000, .33, true, finishLoad);
		
		super.create();
	}
	
	private function changeRoomsStart():Void
	{
		if (_changingRoom)
			return;
		_changingRoom = true;
		FlxG.camera.fade(0xff000000, .2, false, changeRoomsStartDone,true);
		
	}
	
	private function changeRoomsStartDone():Void
	{
		
		_tmBackground.kill();
		_tmBackground2.kill();
		_tmForeground.kill();
		_tmWalls.kill();
		_tmBackground.destroy();
		_tmBackground2.destroy();
		_tmForeground.destroy();
		_tmWalls.destroy();
		
		_level = new FlxOgmoLoader(Reg.levels[Reg.levelY][Reg.levelX]);
		
		var _tmpBackground:FlxTilemap = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds"); 
		var _tmpBackground2:FlxTilemap = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds2"); 
		var _tmpWalls:FlxTilemap = _level.loadTilemap("assets/images/walls.png", 16, 16, "Walls");
		var _tmpForeground:FlxTilemap = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Foregrounds");
		
		while (_grpObjects.members.length > 0)
		{
			_grpObjects.members[0].kill();
			_grpObjects.remove(_grpObjects._members[0], true);
		}
		
		replace(_tmBackground, _tmpBackground);
		replace(_tmBackground2, _tmpBackground2);
		replace(_tmWalls, _tmpWalls);
		_level.loadEntities(loadObject, "Objects");
		replace(_tmForeground , _tmpForeground);
		
		
		
		_tmBackground  = _tmpBackground;
		_tmBackground2  = _tmpBackground2;
		_tmWalls = _tmpWalls;
		_tmForeground = _tmpForeground;
		
		_currentSpr.x = _destX;
		_currentSpr.y = _destY;
	
		FlxG.camera.fade(0xff000000, .2, true, changeRoomsFinish, true);
		
		
	}
	
	
	private function changeRoomsFinish():Void
	{
		_changingRoom = false;
	}
	
	
	private function loadObject(ObjName:String, ObjXML:Xml):Void
	{
		// use offsetX and offsetY!!!!
		trace(ObjXML);
		switch (ObjName)
		{
			case "villager":
				_grpObjects.add(new Folk(Std.parseFloat(ObjXML.get("x")), Std.parseFloat(ObjXML.get("y"))));
				
			case "animal":
				_grpObjects.add(new Animal(Std.parseFloat(ObjXML.get("x")), Std.parseFloat(ObjXML.get("y")), ObjXML.get("type")));
				
			case "police":
				_grpObjects.add(new Policeman(Std.parseFloat(ObjXML.get("x")), Std.parseFloat(ObjXML.get("y"))));
				
			case "clue":
				_grpObjects.add(new Clue(Std.parseFloat(ObjXML.get("x")), Std.parseFloat(ObjXML.get("y"))));
				
			case "obstical":
				
				
		}
	}
	
	private function finishLoad():Void
	{
		_loading = false;
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
		
		
		
		if (_loading || _changingRoom || _gameOvering)
		{
			super.update();
			return;
		}
		
		if (!_shownFirstDiag)
		{
			_shownFirstDiag = true;
			add(new DialogBox("This is some kind of test or something..."));
		}
		if (Reg.DiagShown)
		{
			Reg.CurDiag.update();
			return;
		}
		
		if (_transforming)
		{
			_currentSpr.velocity.y = _currentSpr.velocity.x = 0;
		}
		else
		{
			if (FlxG.keys.anyJustReleased(["X"]))
			{
				if (_mode == MODE_J)
				{
					switchToH();
					
					
				}
				else if (_mode == MODE_H)
				{
					
					switchToJ();
					
				}
			}
			else
			{
				if (FlxG.keys.anyPressed(["W", "UP"]))
				{
					_currentSpr.velocity.y = -(_mode == MODE_J ? SPEED_J : SPEED_H);
					_jeckyl.animation.play("walk-up");
					_jeckyl.facing = FlxObject.UP;
				}
				else if (FlxG.keys.anyPressed(["S", "DOWN"]))
				{
					_currentSpr.velocity.y = (_mode == MODE_J ? SPEED_J : SPEED_H);
					_jeckyl.animation.play("walk-down");
					_jeckyl.facing = FlxObject.DOWN;
				}
				else
				{
					_currentSpr.velocity.y = 0;
					if (_jeckyl.facing == FlxObject.UP)
					{
						_jeckyl.animation.play("idle-up");
					}
					else if (_jeckyl.facing == FlxObject.DOWN)
					{
						_jeckyl.animation.play("idle-down");
					}
					
				}
				
				if (FlxG.keys.anyPressed(["A","LEFT"]))
				{
					_currentSpr.velocity.x = -(_mode == MODE_J ? SPEED_J : SPEED_H);
					_jeckyl.facing = FlxObject.LEFT;
					_jeckyl.animation.play("walk-side");
				}
				else if (FlxG.keys.anyPressed(["D","RIGHT"]))
				{
					_currentSpr.velocity.x = (_mode == MODE_J ? SPEED_J : SPEED_H);
					_jeckyl.facing = FlxObject.RIGHT;
					_jeckyl.animation.play("walk-side");
				}
				else
				{
					_currentSpr.velocity.x = 0;
					if (_jeckyl.facing == FlxObject.LEFT || _jeckyl.facing == FlxObject.RIGHT)
						_jeckyl.animation.play("idle-side");
				}
			}

			if (_currentSpr.x <= FlxG.worldBounds.left && !_changingRoom) 
			{
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelX--;
				_destX = Std.int(_tmBackground.width - _currentSpr.width - 4);
				_destY = Std.int(_currentSpr.y);
				changeRoomsStart();
				
			}
			if (_currentSpr.x + _currentSpr.width >= FlxG.worldBounds.right && !_changingRoom) 
			{
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelX++;
				_destX =  Std.int(4);
				_destY = Std.int(_currentSpr.y);
				changeRoomsStart();
			}
			if (_currentSpr.y <= FlxG.worldBounds.top && !_changingRoom)
			{
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelY--;
				_destX = Std.int(_currentSpr.x);
				_destY = Std.int(_tmBackground.height - _currentSpr.height - 4);
				changeRoomsStart();
			}
			if (_currentSpr.y + _currentSpr.height >= FlxG.worldBounds.bottom && !_changingRoom)
			{
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelY++;
				_destX = Std.int(_currentSpr.x);
				_destY =  Std.int(4);
				changeRoomsStart();
				
			}
			
			if (_mode == MODE_J)
			{
				_meter.value -= FlxG.elapsed*.25;
			}
			else if (_mode == MODE_H)
			{
				_meter.value += FlxG.elapsed*7;
			}
			
			if ( _meter.value >= 100)
			{
				_gameOvering = true;
				FlxG.camera.fade(0xff000000, .2, false, goGameOver);
			}
			
			
		}
		
		super.update();
		
		FlxG.collide(_grpObjects, _grpObjects);
		FlxG.collide(_grpObjects, _tmWalls);
		
		if (!_transforming)
		{
			FlxG.collide(_currentSpr, _tmWalls, playerHitsWall);
			FlxG.overlap(_currentSpr, _grpObjects, null,playerHitsEntity);
		}
		else
		{
			FlxG.collide(_jeckyl, _tmWalls, playerHitsWall);
			FlxG.collide(_hyde, _tmWalls, playerHitsWall);
		}
	}	
	
	private function playerHitsEntity(P:Dynamic, E:Dynamic):Bool
	{
		switch (Type.getClassName(Type.getClass(E)))
		{
			case "Folk":
			
				if (_mode == MODE_H)
				{
					E.kill();
					_meter.value += 10;
					return true;
				}
				return false;
				
			case "Animal":
				
				E.kill();
				//trace(E.animalType);
				
				switch (cast(E, Animal).animalType)
				{
					case "dog":
						if (_mode == MODE_H)
							_meter.value += 5;
						else
							_meter.value += 10;
					case "squ":
						if (_mode == MODE_H)
							_meter.value += 2;
						else
							_meter.value += 6;
					case "cow":
						if (_mode == MODE_H)
							_meter.value += 10;
						else
							_meter.value += 20;
					
				}
				return true;
			case "Policeman":
				
				if (_mode == MODE_H)
				{
					E.kill();
					_meter.value += 30;
					return true;
				}
				return false;
			case "Obstical":
				
			case "Clue":
				Reg.CollectedClues += E._whichClue;
				E.kill();
		}
		
		return false;
	}
	
	private function goGameOver():Void
	{
		FlxG.switchState(new GameOverState());
	}
	
	private function switchToH():Void
	{
		_mode = MODE_H;
		_currentSpr = _hyde;
		_hyde.scale.x = _hyde.scale.y = .5;
		//_jeckyl.visible = false;
		
		_hyde.x = _jeckyl.x + (_jeckyl.width / 2) - (_hyde.width / 2);
		_hyde.y = _jeckyl.y + (_jeckyl.height / 2) - (_hyde.height / 2);
		FlxG.camera.follow(_hyde, FlxCamera.STYLE_LOCKON);
		_twnAlphaTrans  = FlxTween.multiVar(_hyde, {alpha: 1 }, TRANSFORM_SPEED, { type: FlxTween.ONESHOT, ease:FlxEase.bounceOut, complete:DoneTransform } );
		_twnScaleTrans  = FlxTween.multiVar(_hyde.scale, {x: 1, y:1 }, TRANSFORM_SPEED, { type: FlxTween.ONESHOT, ease:FlxEase.bounceOut } );
		
		_hyde.visible = true;
		_hyde.alpha = 0;
		_transforming = true;
		_hyde.velocity.x = _hyde.velocity.y = 0;
		_jeckyl.velocity.x = _jeckyl.velocity.y = 0;
		FlxG.camera.flash(0xffffffff, FlxG.elapsed * 6);
		_burst.x = _currentSpr.x + (_currentSpr.width/2);
		_burst.y = _currentSpr.y + (_currentSpr.height/2);
		_burst.start(true, 0, 0, 100, FlxG.elapsed * 20);
	}
	
	private function switchToJ():Void
	{
		_mode = MODE_J;
		_currentSpr = _jeckyl;
		
		
		_jeckyl.x = _hyde.x + (_hyde.width / 2) - (_jeckyl.width / 2);
		_jeckyl.y = _hyde.y + (_hyde.height / 2) - (_jeckyl.height / 2);
		FlxG.camera.follow(_jeckyl, FlxCamera.STYLE_LOCKON);
		_twnAlphaTrans  = FlxTween.multiVar(_hyde, {alpha: 0 }, TRANSFORM_SPEED, { type: FlxTween.ONESHOT, ease:FlxEase.bounceIn, complete:DoneTransform } );
		_twnScaleTrans  = FlxTween.multiVar(_hyde.scale, {x: .5, y: .5 }, TRANSFORM_SPEED, { type: FlxTween.ONESHOT, ease:FlxEase.bounceIn } );
		
		
		_jeckyl.visible = true;
		//_hyde.visible = false;
		_transforming = true;
		_hyde.velocity.x = _hyde.velocity.y = 0;
		_jeckyl.velocity.x = _jeckyl.velocity.y = 0;
		FlxG.camera.flash(0xffffffff, FlxG.elapsed * 6);
		_burst.x = _currentSpr.x + (_currentSpr.width/2);
		_burst.y = _currentSpr.y + (_currentSpr.height/2);
		_burst.start(true, 0, 0, 100, FlxG.elapsed * 20);
	}
	
	private function DoneTransform(T:FlxTween):Void
	{	
		_twnAlphaTrans.cancel();
		_twnScaleTrans.cancel();
		_transforming = false;
		if (_mode == MODE_H)
		{
			_jeckyl.visible = false;
			if (_hyde.overlaps(_tmWalls))
			{
				switchToJ();
			}
		}
		
	}
	
	private function playerHitsWall(Spr:Dynamic, Walls:Dynamic):Void
	{
		//trace('!!');
		//var m:FlxPoint = _currentSpr.getMidpoint();
		//_playerPos.x = m.x;
		//_playerPos.y = m.y;
	}
	
	function get_playerHealth():Int 
	{
		return _playerHealth;
	}
	
	function set_playerHealth(value:Int):Int 
	{
		return _playerHealth = value;
	}
	
	public var playerHealth(get_playerHealth, set_playerHealth):Int;
	
	function get_mode():Int 
	{
		return _mode;
	}
	
	public var mode(get_mode, null):Int;
	
	function get_playerPos():FlxSprite 
	{
		return _playerPos;
	}
	
	public var playerPos(get_playerPos, null):FlxSprite;
	
	function get_currentSpr():FlxSprite 
	{
		return _currentSpr;
	}
	
	public var currentSpr(get_currentSpr, null):FlxSprite;
}