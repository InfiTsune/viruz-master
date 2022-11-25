package state;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class PlayerSelect extends MusicBeatState 
{
    var player:Boyfriend;

    var playersOpt:Array<String> = 
    [
        ["bf", "bf-pixel"],
        ['pico']
    ];

    private static var curPlayer:Int;
    private static var curStyle:Int;

    var bg:FlxSprite;

    var selectors:FlxTypedGroup<FlxSprite>;

    var textAlphabet:Alphabet;
    public function new() 
    {
        super();

        bg = new FlxSprite(0, 0).loadGraphic(Paths.image('menuBG'));
        bg.setGraphicSize(Std.int(bg.width * 1.2));
        add(bg);

        player = new Boyfriend(0, 0, playersOpt[curPlayer][curStyle]);
        add(player);

        Conductor.changeBPM(102);

        var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

        selector = FlxTypedGroup<FlxSprite>();
        add(selector);

        // var leftArrow = new FlxSprite(player.x - player.height - 30);
		// leftArrow.frames = ui_tex;
		// leftArrow.animation.addByPrefix('idle', "arrow left");
		// leftArrow.animation.addByPrefix('press', "arrow push left");
		// leftArrow.animation.play('idle');
        // leftArrow.ID = 0;
		// selectors.add(leftArrow);

		// var rightArrow = new FlxSprite(player.x + player.height + 30);
		// rightArrow.frames = ui_tex;
		// rightArrow.animation.addByPrefix('idle', 'arrow right');
		// rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		// rightArrow.animation.play('idle');
        // rightArrow.ID = 1;
		// selectors.add(rightArrow);

        textAlphabet = new Alphabet(-20, 20, "Select Player" + "\npress left or right to change player" + "\npress up or down to change player style", true);
        textAlphabet.setGraphicSize(Std.int(textAlphabet.width * 0.8));
        textAlphabet.screenSize(X);
        add(textAlphabet);

        changePlayer();
    }

    var chose:Bool = true;

    override function update(count:Float)
    {
        super.update(count);

        if (FlxG.sound.music != null)
			Conductor.songPosition = FlxG.sound.music.time;

        if (chose)
        {
            if (FlxG.keys.justPressed.RIGHT)
            {
                changePlayer(1);
            }
            if (FlxG.keys.justPressed.LEFT)
            {
                changePlayer(-1);
            }

            if (FlxG.keys.justPressed.DOWN)
            {
                changeStyle(1);
            }
            if (FlxG.keys.justPressed.UP)
            {
                changeStyle(-1);
            }

            if (controls.ACCEPT)
            {
                chose = false;
                player.playAnim('singLEFT');

                if (player.animOffsets.exists('hey')) {
                    player.playAnim('hey', true);
                }

                FlxG.sound.play(Paths.sound('confirmMenu'));

                new FlxTimer().start(1, function(tmr:FlxTimer)
                {
                    state.PlayState.boyfriend = playersOpt[curPlayer][curStyle];
                    LoadingState.loadAndSwitchState(new state.PlayState());
                });
            }

            KeyS();
        }

        player.screenCenter(X);

        // selector.forEach(function(sprite:FlxSprite)
        // {
        //     if (sprite.ID = 0)
        //     {
        //         sprite.x = player.x - player.height - 30;
        //     }
        //     else
        //     {
        //         sprite.x = player.x + player.height + 30;
        //     }
        // });
    }

    private function KeyS()
    {
        left = controls.LEFT_P;
        down = controls.DOWN_P;
        up = controls.UP_P;
        right = controls.RIGHT_P;

        if (left)
        {
            player.playAnim('singLEFT', true);
        }
        if (down)
        {
            player.playAnim('singDOWN', true);
        }
        if (up)
        {
            player.playAnim('singUP', true);
        }
        if (right)
        {
            player.playAnim('singRIGHT', true);
        }

        if (boyfriend.holdTimer > Conductor.stepCrochet * 4 * 0.001 && !up && !down && !right && !left)
        {
            if (boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
            {
                boyfriend.playAnim('idle');
            }
        }
    }

    override function beatHit()
    {
        super.beatHit();

        // if (!boyfriend.animation.curAnim.name.startsWith("sing") && curBeat % 4 == 0)
        // {
        //     boyfriend.playAnim('idle');
        // }
    }

    function changePlayer(PLAYER_SELECTED:Int = 0):Void
    {
        curPlayer += PLAYER_SELECTED;

        if (curPlayer >= playersOpt.length - 1)
        {
            curPlayer = 0;
        }
        if (curPlayer < 0)
        {
            curPlayer = playersOpt.length - 1;
        }

        changeStyle();
    }

    function changeStyle(STYLE:Int = 0):Void
    {
        curStyle += STYLE;

        if (curStyle >= playersOpt[curPlayer].length - 1)
        {
            curStyle = 0;
        }
        if (curStyle < 0)
        {
            curStyle = playersOpt[curPlayer].length - 1;
        }

        changeSprite();
    }

    function changeSprite():Void
    {
        remove(player);

        player = new Boyfriend(0, 0, playersOpt[curPlayer][curStyle]);
        player.alpha = 0;
        player.y = FlxG.height * 0.75;

        add(player);

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        FlxTween.tween(player, {y: FlxG.height * 0.45, alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
    }
}