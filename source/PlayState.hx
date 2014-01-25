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
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
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
	
	public  var MODE_J:Int = 0;
	public  var MODE_H:Int = 1;
	private var _mode:Int = 0;
	
	private var _level:FlxOgmoLoader;
	private var _tmBackground:FlxTilemap;
	private var _tmpWalls:FlxTilemap;
	private var _tmpObjects:FlxGroup;
	private var _tmpForeground:FlxTilemap;
	
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
		
		_level = new FlxOgmoLoader("assets/maps/level001.oel");
		_tmBackground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Backgrounds");
		//_tmpWalls = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Walls");
		//_level.loadEntities(loadObject, "Objects");
		_tmpForeground = _level.loadTilemap("assets/images/tilemap-1.png", 16, 16, "Foregrounds");
		
		add(_tmBackground);
		_tmpObjects = new FlxGroup();
		
		add(_tmpObjects);
		
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		_tmpObjects.add(new Folk(FlxRandom.intRanged(10, Std.int(FlxG.width - 10)), FlxRandom.intRanged(10, Std.int(FlxG.height - 10))));
		
		_grpPlayer = new FlxGroup();
		
		_jeckyl = cast new FlxSprite(0, 0).makeGraphic(16, 16, 0xff0000ff);
		_hyde = cast new FlxSprite(0, 0).makeGraphic(32, 32, 0xffff0000);
		_currentSpr = _jeckyl;
		
		_burst = new FlxEmitterExt();
		_burst.setRotation(0, 0);
		_burst.setMotion(0,.1, 1, 360, 60, 1);
		_burst.makeParticles("assets/images/particles.png", 100, 0, true, 0);
		//_burst.blend = BlendMode.SCREEN;
		
		
		add(_jeckyl);
		add(_burst);
		add(_hyde);
		_hyde.visible = false;
		_mode = MODE_J;
		
		add(_tmpForeground);
		
		
		_playerPos = new FlxSprite().makeGraphic(1, 1, 0x0);
		add(_playerPos);
		FlxSpriteUtil.screenCenter(_playerPos);
		
		FlxG.camera.follow(_playerPos, FlxCamera.STYLE_LOCKON);
		
		_meter = new BalanceMeter();
		add(_meter);
		
		_barHealth = new FlxBar(FlxG.width - 100, 4, FlxBar.FILL_LEFT_TO_RIGHT, 96, 8, this, "playerHealth", 0, 100, true);
		_barHealth.scrollFactor.x = _barHealth.scrollFactor.y = 0;
		
		add(_barHealth);
		
		FlxG.camera.fade(0xff000000, .33, true, finishLoad);
		
		super.create();
	}
	
	private function loadObject(ObjName:String, ObjXML:Xml):Void
	{
		
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
		
		if (_loading)
		{
			super.update();
			return;
		}
		
		if (_transforming)
		{
			_playerPos.velocity.y = _playerPos.velocity.x = 0;
			
			if (_mode == MODE_J)
			{
				if (_hyde.alpha > 0)
				{
					_hyde.alpha -= FlxG.elapsed * 3;
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
		}
		else
		{
			if (FlxG.keys.anyJustReleased(["X"]))
			{
				if (_mode == MODE_J)
				{
					_mode = MODE_H;
					_currentSpr = _hyde;
					//_jeckyl.visible = false;
					_hyde.visible = true;
					_hyde.alpha = 0;
					_transforming = true;
					_playerPos.velocity.x = 0;
					_playerPos.velocity.y = 0;
					FlxG.camera.flash(0xffffffff, FlxG.elapsed * 6);
					_burst.x = _playerPos.x;
					_burst.y = _playerPos.y;
					_burst.start(true, 0, 0, 100, FlxG.elapsed * 20);
				}
				else if (_mode == MODE_H)
				{
					_mode = MODE_J;
					_currentSpr = _jeckyl;
					_jeckyl.visible = true;
					//_hyde.visible = false;
					_transforming = true;
					_playerPos.velocity.x = 0;
					_playerPos.velocity.y = 0;
					FlxG.camera.flash(0xffffffff, FlxG.elapsed * 6);
					_burst.x = _playerPos.x;
					_burst.y = _playerPos.y;
					_burst.start(true, 0, 0, 100, FlxG.elapsed * 20);
				}
			}
			else
			{
				if (FlxG.keys.anyPressed(["UP"]))
				{
					_playerPos.velocity.y = -(_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else if (FlxG.keys.anyPressed(["DOWN"]))
				{
					_playerPos.velocity.y = (_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else
					_playerPos.velocity.y = 0;
				
				if (FlxG.keys.anyPressed(["LEFT"]))
				{
					_playerPos.velocity.x = -(_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else if (FlxG.keys.anyPressed(["RIGHT"]))
				{
					_playerPos.velocity.x = (_mode == MODE_J ? SPEED_J : SPEED_H);
				}
				else
					_playerPos.velocity.x = 0;
			}
			
			
			_currentSpr.x = _playerPos.x - (_currentSpr.width / 2);
			_currentSpr.y = _playerPos.y - (_currentSpr.height / 2);
			if (_currentSpr.x < FlxG.worldBounds.left) 
			{
				_currentSpr.x = FlxG.worldBounds.left;
				_playerPos.x = _currentSpr.x + (_currentSpr.width / 2);
				_playerPos.velocity.x = 0;
			}
			if (_currentSpr.x + _currentSpr.width > FlxG.worldBounds.right) 
			{
				_currentSpr.x = FlxG.worldBounds.right - _currentSpr.width;
				_playerPos.x = _currentSpr.x + (_currentSpr.width / 2);
				_playerPos.velocity.x = 0;
			}
			if (_currentSpr.y < FlxG.worldBounds.top)
			{
				_currentSpr.y = FlxG.worldBounds.top;
				_playerPos.y = _currentSpr.y + (_currentSpr.height / 2);
				_playerPos.velocity.y = 0;
			}
			if (_currentSpr.y + _currentSpr.height > FlxG.worldBounds.bottom)
			{
				_currentSpr.y = FlxG.worldBounds.bottom - _currentSpr.height;
				_playerPos.y = _currentSpr.y + (_currentSpr.height / 2);
				_playerPos.velocity.y = 0;
				
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
		
		FlxG.collide(_tmpObjects, _tmpObjects);
		
		super.update();
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
}