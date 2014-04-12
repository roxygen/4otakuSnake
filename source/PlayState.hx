package ;

import flash.Lib;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.system.FlxAssets;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxPoint;
import flixel.util.FlxRandom;
import flixel.util.FlxSpriteUtil;
import flixel.util.FlxTimer;
import haxe.remoting.AMFConnection;
/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	// Game Data:
	private static var MIN_SPEED:Float = 7;
	private static var GAME_NAME:String = ".Orin's Ghost Snake.";
	private static var GAME_VERISON_MAJOR:Int = 0;
	private static var GAME_VERISON_MINOR:Int = 1;
	private static var GAME_VERISON_PATCH:Int = 2;
	
	private var _cellSize:Int = 40;
	private var _score:Int = 0;
	private var _orinPos:Array<FlxPoint>;
	private var _orinSpeed:Float = 8;
	private var _login:String = "";
	
	// Data score text sprite
	private var _scoreText:FlxText;
	
	// Orin
	private var _orin:FlxSprite;
	// Orin's Ghost Train
	private var _orinTrain:FlxSpriteGroup;
	
	// Single Ghost
	private var _ghost:FlxSprite;
	
	/**
	 * Function that is called up when to state is created to set it up.
	 */
	override public function create():Void
	{
		super.create();
			
		var posX:Int = FlxRandom.intRanged(0, Math.floor(FlxG.width / _cellSize) -1 ) * _cellSize;
		var posY:Int = FlxRandom.intRanged(0, Math.floor(FlxG.height / _cellSize) -1 ) * _cellSize;
		_orin = new FlxSprite(posX, posY);
		_orin.loadGraphic("assets/images/suika_sprite.png", true, false, 40, 40);
		_orin.animation.add("up", [0, 1, 2, 3], 10);
		_orin.animation.add("right", [4, 5, 6, 7], 10);
		_orin.animation.add("down", [8, 9, 10, 11], 10);
		_orin.animation.add("left", [12, 13, 14, 15], 10);
		_orin.animation.play("left");
		//_orin.scale.x = 1.2;
		//_orin.scale.y = 0.5;
		_orin.width = _cellSize;
		_orin.height = _cellSize;
		
		_orin.offset.set(1, 1);
		_orin.centerOffsets();

		
		_orin.facing = FlxObject.LEFT;
		
		_orinPos = [new FlxPoint(_orin.x, _orin.y)];
		
		_orinTrain = new FlxSpriteGroup();
		
		// Add _orinTrain group to renderer.
		this.add(_orinTrain);
		
		for (i in 0...3)
		{
			this.addGhostToOrin();
			this.moveOrin();
		}
		
		this.add(_orin);
		
		_ghost = new FlxSprite( -20, -20, "assets/images/beer.gif");
		_ghost.color = FlxColor.INDIGO;
		
		this.randomGhostPos();
		
		_ghost.offset.set(1, 1);
		_ghost.centerOffsets();
		
		this.add(_ghost);
		
		_scoreText = new FlxText(0, 0, 200, "");
		updateScoreText( "Score: " + _score );
		this.add(_scoreText);
		
		this.resetTimer();
		
		var url = "http://localhost/flashservices/index.php";
		var c = AMFConnection.urlConnect(url);
		c.setErrorHandler(onError);
		c.HelloWorld.say.call(["Test !"], displayResult);
		Lib.trace ("@@@ ");
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
		super.update();
		
		if (!_orin.alive)
		{
			if (FlxG.keys.anyJustReleased(["SPACE", "R"]))
			{
				FlxG.resetState();
			}
			return;
		}
		
		FlxG.overlap(_orin, _ghost, collectGhost);
		
		FlxG.overlap(_orin, _orinTrain, gameOver);
		
		if (FlxG.keys.anyPressed(["UP", "W"]) && _orin.facing != FlxObject.DOWN)
		{
			_orin.facing = FlxObject.UP;
		}
		else if (FlxG.keys.anyPressed(["DOWN", "S"]) && _orin.facing != FlxObject.UP)
		{
			_orin.facing = FlxObject.DOWN;
		}
		else if (FlxG.keys.anyPressed(["LEFT", "A"]) && _orin.facing != FlxObject.RIGHT)
		{
			_orin.facing = FlxObject.LEFT;
		}
		else if (FlxG.keys.anyPressed(["RIGHT", "D"]) && _orin.facing != FlxObject.LEFT)
		{
			_orin.facing = FlxObject.RIGHT;
		}
	}
	private function updateScoreText(str:String)
	{
		_scoreText.text = GAME_NAME +
			" v" + GAME_VERISON_MAJOR + '.' + GAME_VERISON_MINOR + '.' + GAME_VERISON_PATCH +
			'\n' + str;
	}
	private function collectGhost(?Object1:FlxObject, ?Object2:FlxObject):Void
	{
		_score += 10;
		this.updateScoreText("Score: " + _score);
		
		this.randomGhostPos();
		
		this.addGhostToOrin();
		
		//FlxG.sound.load("assets/sounds/ghostGotcha.wav", 1, false, true).play();
		FlxG.sound.play("assets/sounds/ghostGotcha.wav");
		
		if (_orinSpeed >= MIN_SPEED)
		{
			_orinSpeed -= 0.25;
		}
	}
	
	private function randomGhostPos(?Object1:FlxObject, ?Object2:FlxObject):Void
	{
		_ghost.x = FlxRandom.intRanged(0, Math.floor(FlxG.width / _cellSize) -1 ) * _cellSize;
		_ghost.y = FlxRandom.intRanged(0, Math.floor(FlxG.height / _cellSize) -1 ) * _cellSize;
		
		FlxG.overlap(_ghost, _orin, randomGhostPos);
		FlxG.overlap(_ghost, _orinTrain, randomGhostPos);
		Lib.trace ( "Set _ghost.x = " + _ghost.x + " _ghost.y = " + _ghost.y);
	}
	
	private function gameOver(?Object1:FlxObject, ?Object2:FlxObject):Void
	{
		_orin.alive = false;
		updateScoreText("GAME OVER! Press [Space] to restart! Score: " + _score);
		FlxG.sound.play("assets/sounds/smb_gameover.wav");
	}
	
	private function addGhostToOrin():Void
	{
		var ghost:FlxSprite = new FlxSprite( -40, -40, "assets/images/beer.gif");
		ghost.color = FlxColor.CRIMSON;
		ghost.offset.set(1, 1);
		ghost.centerOffsets();
		_orinTrain.add(ghost);
	}
	
	private function resetTimer(?Timer:FlxTimer):Void
	{
		if (!_orin.alive && Timer != null)
		{
			Timer.destroy();
			return;
		}
		
		FlxTimer.start(_orinSpeed / FlxG.updateFramerate, resetTimer);
		
		this.moveOrin();
	}
	private function moveOrin():Void
	{
		_orinPos.unshift(new FlxPoint(_orin.x, _orin.y));
		if (_orinPos.length >= _orinTrain.members.length)
		{
			_orinPos.pop();
		}
		
		switch (_orin.facing)
		{
			case FlxObject.LEFT:
				_orin.x -= _cellSize;
				_orin.animation.play("left");
			case FlxObject.RIGHT:
				_orin.x += _cellSize;
				_orin.animation.play("right");
			case FlxObject.UP:
				_orin.y -= _cellSize;
				_orin.animation.play("up");
			case FlxObject.DOWN:
				_orin.y += _cellSize;
				_orin.animation.play("down");
		}
		
		FlxSpriteUtil.screenWrap(_orin);
		
		for (i in 0..._orinPos.length)
		{
			var ghost:FlxObject = cast _orinTrain.members[i];
			if ( ghost != null)
			{
				ghost.setPosition(_orinPos[i].x, _orinPos[i].y);
			}
		}
		
		if (	_orin.x <0 || _orin.x > FlxG.width
			||  _orin.y <0 || _orin.y > FlxG.height)
		{
			gameOver(null, null);
		}
	}
	
	function displayResult( r : Dynamic ) {
		Lib.trace("@displayResult");
		Lib.trace("result : "+r);
	}

	function onError( e : Dynamic ) {
		Lib.trace("@onError");
		Lib.trace("error : "+Std.string(e));
	}
	
	
}