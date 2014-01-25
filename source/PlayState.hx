package;

import flash.display.BlendMode;
import flash.Lib;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.editors.ogmo.FlxOgmoLoader;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitterExt;
import flixel.effects.particles.FlxParticle;
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
	private var _tmWalls:FlxTilemap;
	private var _grpObjects:FlxGroup;
	private var _tmForeground:FlxTilemap;
	
	private var _newlevel:FlxOgmoLoader;
	private var _newtmBackground:FlxTilemap;
	private var _newtmWalls:FlxTilemap;
	private var _newgrpObjects:FlxGroup;
	private var _newtmForeground:FlxTilemap;
	
	
	
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
	private var _barHealth:FlxBar;
	private var _twnAlphaTrans:FlxTween;
	private var _twnScaleTrans:FlxTween;
	private var _changingRoom:Bool = false;
	
	private var _destX:Int = -1;
	private var _destY:Int = -1;
	
	private var _twnRoom:FlxTween;
	
	private var _offsetX:Float = 0;
	private var _offsetY:Float = 0;
	
	
	
	
	
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
		trace(Reg.levels[Reg.levelX][Reg.levelY]);
		_level = new FlxOgmoLoader(Reg.levels[Reg.levelX][Reg.levelY]);
		_grpObjects = new FlxGroup();
		_tmBackground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds");
		_newtmBackground = new FlxTilemap();
		_newtmBackground.kill();
		_tmWalls = _level.loadTilemap("assets/images/walls.png", 16, 16, "Walls");
		_newtmWalls = new FlxTilemap();
		_newtmWalls.kill();
		//_level.loadEntities(loadObject, "Objects");
		_tmForeground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Foregrounds");
		_newtmForeground = new FlxTilemap();
		
		add(_tmBackground);
		add(_newtmBackground);
		_grpObjects = new FlxGroup();
		
		add(_grpObjects);
		add(_tmWalls);
		add(_newtmWalls);
		
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_grpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		
		_grpPlayer = new FlxGroup();
		
		_jeckyl = cast new FlxSprite(0, 0).makeGraphic(16, 16, 0xff0000ff);
		_hyde = cast new FlxSprite(0, 0).makeGraphic(32, 32, 0xffff0000);
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
		add(_newtmForeground);
		_newtmForeground.kill();
		
		//_playerPos = new FlxSprite().makeGraphic(1, 1, 0x0);
		//add(_playerPos);
		
		//FlxSpriteUtil.screenCenter(_playerPos);
		
		
		_meter = new BalanceMeter();
		add(_meter);
		
		_barHealth = new FlxBar(FlxG.width - 100, 4, FlxBar.FILL_LEFT_TO_RIGHT, 96, 8, this, "playerHealth", 0, 100, true);
		_barHealth.scrollFactor.x = _barHealth.scrollFactor.y = 0;
		
		add(_barHealth);
		
		FlxG.camera.follow(_jeckyl, FlxCamera.STYLE_LOCKON);
		
				
		FlxG.camera.fade(0xff000000, .33, true, finishLoad);
		
		super.create();
	}
	
	private function changeRoomsStart():Void
	{
		if (_changingRoom)
			return;
		_changingRoom = true;
		//_twnRoom = FlxTween.multiVar(_sprBlack, { alpha:1 }, .33, { type: FlxTween.ONESHOT, ease:FlxEase.quartIn, callback: changeRoomsStartDone } );
		_level = new FlxOgmoLoader(Reg.levels[Reg.levelX][Reg.levelY]);
		
		
		//_level = new _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds");
		replace(_newtmBackground, _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds"));
		replace(_newtmWalls, _level.loadTilemap("assets/images/walls.png", 16, 16, "Walls"));
		_level.loadEntities(loadObject, "Objects");
		replace(_newtmForeground , _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Foregrounds"));
		_newtmWalls.x = _newtmForeground.x = _newtmBackground.x = _offsetX;
		_newtmWalls.y = _newtmForeground.y = _newtmBackground.y = _offsetY;
		
		_twnRoom = FlxTween.multiVar(_currentSpr, { x: _destX, y: _destY }, 1, {type:FlxTween.ONESHOT, ease:FlxEase.quartInOut, complete:changeRoomsStartDone } );
		
		
	}
	
	private function changeRoomsStartDone(T:FlxTween):Void
	{
		
		_tmBackground.kill();
		_tmForeground.kill();
		_tmWalls.kill();
		//_grpObjects.kill();
		_tmBackground.destroy();
		_tmForeground.destroy();
		_tmWalls.destroy();
		//_grpObjects.destroy();
		for (i in _grpObjects.members)
		{
			if (cast(i, FlxSprite).x < _newtmBackground.x || cast(i, FlxSprite).x > _newtmBackground.x + _newtmBackground.width || cast(i, FlxSprite).y < _newtmBackground.y || cast(i, FlxSprite).y > _newtmBackground.y + _newtmBackground.height)
			{
				cast(i, FlxSprite).kill();
				cast(i, FlxSprite).destroy();	
			}
		}
		//_tmBackground = _newtmBackground;
		//_tmForeground = _newtmForeground;
		//_tmWalls = _newtmWalls;
		//_newtmWalls = null;
		//_newtmBackground = null;
		//_newtmForeground = null;
		
		replace(_tmBackground, _newtmBackground);
		replace(_tmForeground, _newtmForeground);
		replace(_tmWalls, _newtmWalls);
		_changingRoom = false;
		
		
	}
	
	
	private function loadObject(ObjName:String, ObjXML:Xml):Void
	{
		// use offsetX and offsetY!!!!
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
		
		if (_loading || _changingRoom)
		{
			super.update();
			return;
		}
		
		if (_transforming)
		{
			_currentSpr.velocity.y = _currentSpr.velocity.x = 0;
			//_currentSpr.updateHitbox();
			//FlxObject.separate(_currentSpr, _tmWalls);
			/*
			if (_mode == MODE_J)
			{
				if (_hyde.alpha > 0)
				{
					_hyde.alpha -= FlxG.elapsed * 3;
					_hyde.scale.x = _hyde.scale.y = .5;
				}
				else
				{
					_hyde.visible = false;
					_transforming = false;
				}
			}
			else if (_mode == MODE_H)
			{
				if (_hyde.alpha < 1)
					_hyde.alpha += FlxG.elapsed * 3;
				else
				{
					_jeckyl.visible = false;
					_transforming = false;
				}
			}
			*/
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
				if (FlxG.keys.anyPressed(["UP"]))
				{
					_currentSpr.velocity.y = -(_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else if (FlxG.keys.anyPressed(["DOWN"]))
				{
					_currentSpr.velocity.y = (_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else
					_currentSpr.velocity.y = 0;
				
				if (FlxG.keys.anyPressed(["LEFT"]))
				{
					_currentSpr.velocity.x = -(_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else if (FlxG.keys.anyPressed(["RIGHT"]))
				{
					_currentSpr.velocity.x = (_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else
					_currentSpr.velocity.x = 0;
			}
			
			
			//_playerPos.width = _currentSpr.width;
			//_playerPos.height = _currentSpr.height;
			
			//_playerPos.offset.x = -(_currentSpr.width / 2);
			//_playerPos.offset.y = -(_currentSpr.height / 2);
			//_currentSpr.x = _playerPos.x - (_currentSpr.width / 2);
			//_currentSpr.y = _playerPos.y - (_currentSpr.height / 2);
			
			
			if (_currentSpr.x < FlxG.worldBounds.left && !_changingRoom) 
			{
				_currentSpr.x = FlxG.worldBounds.left;
				//_playerPos.x = _currentSpr.x + (_currentSpr.width / 2);
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelX--;
				_destX = 4;
				_destY = Std.int(_currentSpr.y);
				_offsetX = _tmBackground.x + _tmBackground.width;
				_offsetY = _tmBackground.y;
				changeRoomsStart();
				
			}
			if (_currentSpr.x + _currentSpr.width > FlxG.worldBounds.right && !_changingRoom) 
			{
				_currentSpr.x = FlxG.worldBounds.right - _currentSpr.width;
				//_playerPos.x = _currentSpr.x + (_currentSpr.width / 2);
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelX++;
				_destX =  Std.int(FlxG.width - _currentSpr.width - 4);
				_destY = Std.int(_currentSpr.y);
				_offsetX = _tmBackground.x - _tmBackground.width;
				_offsetY = _tmBackground.y;
				changeRoomsStart();
			}
			if (_currentSpr.y < FlxG.worldBounds.top && !_changingRoom)
			{
				_currentSpr.y = FlxG.worldBounds.top;
				//_playerPos.y = _currentSpr.y + (_currentSpr.height / 2);
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelY--;
				_destX = Std.int(_currentSpr.x);
				_destY = 4;
				_offsetX = _tmBackground.x;
				_offsetY = _tmBackground.y - _tmBackground.height;
				changeRoomsStart();
			}
			if (_currentSpr.y + _currentSpr.height > FlxG.worldBounds.bottom && !_changingRoom)
			{
				_currentSpr.y = FlxG.worldBounds.bottom - _currentSpr.height;
				//_playerPos.y = _currentSpr.y + (_currentSpr.height / 2);
				_currentSpr.velocity.x = _currentSpr.velocity.y = 0;
				Reg.levelY++;
				_destX = Std.int(_currentSpr.x);
				_destY = Std.int(FlxG.height - _currentSpr.height - 4);
				_offsetX = _tmBackground.x;
				_offsetY = _tmBackground.y + _tmBackground.height;
				changeRoomsStart();
				
			}
			
			if (_mode == MODE_J)
			{
				_meter.value -= FlxG.elapsed;
			}
			else if (_mode == MODE_H)
			{
				_meter.value += FlxG.elapsed;
			}
		}
		
		super.update();
		
		FlxG.collide(_grpObjects, _grpObjects);
		FlxG.collide(_grpObjects, _tmWalls);
		
		if (!_transforming)
			FlxG.collide(_currentSpr, _tmWalls, playerHitsWall);
		else
		{
			FlxG.collide(_jeckyl, _tmWalls, playerHitsWall);
			FlxG.collide(_hyde, _tmWalls, playerHitsWall);
		}
		
		
		
		
		
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
		trace('!!');
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