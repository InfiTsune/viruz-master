package source;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

using StringTools;

class PlayerSelect extends MusicBeatState 
{
    var player:Boyfriend;

    var thePlayers:Array<String> = [
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

        player = new Boyfriend(0, 0, thePlayers[curPlayer][curStyle]);
        add(player);

        Conductor.changeBPM(102);

        var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

        selector = FlxTypedGroup<FlxSprite>();
        add(selector);

        var leftArrow = new FlxSprite(player.x - player.height - 30);
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
        leftArrow.ID = 0;
		selectors.add(leftArrow);

		var rightArrow = new FlxSprite(player.x + player.height + 30);
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
        rightArrow.ID = 1;
		selectors.add(rightArrow);

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
                    PlayState.boyfriend = thePlayers[curPlayer][curStyle];
                    LoadingState.loadAndSwitchState(new PlayState());
                });
            }

            if (controls.LEFT_P)
            {
                player.playAnim('singLEFT', true);
            }
            if (controls.DOWN_P)
            {
                player.playAnim('singDOWN', true);
            }
            if (controls.UP_P)
            {
                player.playAnim('singUP', true);
            }
            if (controls.RIGHT_P)
            {
                player.playAnim('singRIGHT', true);
            }
        }

        player.screenCenter(X);

        selector.forEach(function(s:FlxSprite)
        {
            if (s.ID = 0)
            {
                s.x = player.x - player.height - 30;
            }
            else
            {
                s.x = player.x + player.height + 30;
            }
        });
    }

    override function beatHit()
    {
        super.beatHit();

        if (!boyfriend.animation.curAnim.name.startsWith("sing") && curBeat % 4 = 0)
        {
            boyfriend.playAnim('idle');
        }
    }

    function changePlayer(PLAYER_SELECTED:Int = 0):Void
    {
        curPlayer += PLAYER_SELECTED;

        if (curPlayer >= thePlayers.length - 1)
        {
            curPlayer = 0;
        }
        if (curPlayer < 0)
        {
            curPlayer = thePlayers.length - 1;
        }

        changeStyle();
    }

    function changeStyle(STYLE:Int = 0):Void
    {
        curStyle += STYLE;

        if (curStyle >= thePlayers[curPlayer].length - 1)
        {
            curStyle = 0;
        }
        if (curStyle < 0)
        {
            curStyle = thePlayers[curPlayer].length - 1;
        }

        changeSprite();
    }

    function changeSprite():Void
    {
        remove(player);

        player = new Boyfriend(0, 0, thePlayers[curPlayer][curStyle]);
        player.alpha = 0;
        player.y = FlxG.height * 0.75;

        add(player);

        FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

        FlxTween.tween(player, {y: FlxG.height * 0.45, alpha: 1}, 0.4, {ease: FlxEase.quartInOut});
    }
}