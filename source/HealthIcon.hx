package;

import flixel.FlxSprite;
import openfl.utils.Assets as OpenFlAssets;

class HealthIcon extends FlxSprite
{
	/**
	 * Used for FreeplayState! If you use it elsewhere(credit)
	 */
	public var sprTracker:FlxSprite;
	public var oneFrame:Bool;

	public function new(char:String = 'bf', isPlayer:Bool = false, oneFrame:Bool = false, pixel:Bool = false)
	{
		super();

		this.oneFrame = oneFrame;

		// por mientras
		if (sprTracker != null && char == 'gf')
		{
			oneFrame = true;
		}
		if (sprTracker != null && (char == 'bf-pixel' || char == 'senpai' || char == 'senpai-angry' || char == 'spirit'))
		{
			pixel = true;
		}

		var _sourceIcon:String;
		_sourceIcon = 'icons/$char-icon';

		if (pixel)
		{
			_sourceIcon = 'icons/$char-pixel-icon';
		}
		if (oneFrame)
		{
			_sourceIcon = 'icons/$char-one-icon';
		}

		loadGraphic(Paths.image(_sourceIcon), true, 150, 150);

		if (OpenFlAssets.exists(_sourceIcon + '.png', IMAGE))
		{
			if (!oneFrame) 
			{
				animation.add('default', [0], 0, false, isPlayer);
				animation.add('lose', [1], 0, false, isPlayer);
			}
		}
		else
		{
			loadGraphic(Paths.image(_sourceIcon), true, 150, 150);
			animation.add('default', [0], 0, false, isPlayer);
			animation.add('lose', [1], 0, false, isPlayer);
		}

		if (!oneFrame)
			animation.play('default');
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (sprTracker != null)
			setPosition(sprTracker.x + sprTracker.width + 15, sprTracker.y - 30);
	}

	public function playAnim(CUR_ANIM:String) {
		if (!oneFrame)
		{
			animation.play(CUR_ANIM);
		}
		else
		{
			animation.play('default');
		}
	}

	// oldSystem
	// loadGraphic(Paths.image('iconGrid', 'preload'), true, 150, 150);

	// antialiasing = true;
	// animation.add('bf', [0, 1], 0, false, isPlayer);
	// animation.add('bf-car', [0, 1], 0, false, isPlayer);
	// animation.add('bf-christmas', [0, 1], 0, false, isPlayer);
	// animation.add('bf-pixel', [21, 21], 0, false, isPlayer);
	// animation.add('spooky', [2, 3], 0, false, isPlayer);
	// animation.add('pico', [4, 5], 0, false, isPlayer);
	// animation.add('mom', [6, 7], 0, false, isPlayer);
	// animation.add('mom-car', [6, 7], 0, false, isPlayer);
	// animation.add('tankman', [8, 9], 0, false, isPlayer);
	// animation.add('face', [10, 11], 0, false, isPlayer);
	// animation.add('dad', [12, 13], 0, false, isPlayer);
	// animation.add('senpai', [22, 22], 0, false, isPlayer);
	// animation.add('senpai-angry', [22, 22], 0, false, isPlayer);
	// animation.add('spirit', [23, 23], 0, false, isPlayer);
	// animation.add('rogelio', [24, 25], 0, false, isPlayer);
	// animation.add('rogelio-happy', [24, 25], 0, false, isPlayer);
	// animation.add('bf-old', [14, 15], 0, false, isPlayer);
	// animation.add('gf', [16], 0, false, isPlayer);
	// animation.add('parents-christmas', [17], 0, false, isPlayer);
	// animation.add('monster', [19, 20], 0, false, isPlayer);
	// animation.add('monster-christmas', [19, 20], 0, false, isPlayer);
	// animation.play(char);
	// scrollFactor.set();
}
