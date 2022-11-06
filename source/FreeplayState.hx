package;

import flixel.tweens.FlxTween;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;


#if desktop
import Discord.DiscordClient;
#end

// using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];
	var colors:Array<Dynamic> = [];

	private static var AGAIN_IN_FREEPLAY:Bool = false;

	var selector:FlxText;
	private static var curSelected:Int = 0;
	private static var curDifficulty:Int = 1;

	var bg:FlxSprite;

	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var intendedScore:Int = 0;

	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Freeplay", null);
		#end

		var isDebug:Bool = false;

		#if debug
		isDebug = true;
		#end

		addWeek(['Tutorial'], 1, ["gf"], [[255, 0, 85]]);

		addWeek(['Bopeebo', 'Fresh', 'Dadbattle'], 1, ['dad'], [[159, 24, 221]]);

		addWeek(['Spookeez', 'South', 'Monster'], 2, ['spooky', 'spooky', 'monster'], [[63, 42, 72]]);

		addWeek(['Pico', 'Philly', 'Blammed'], 3, ['pico'], [[92, 184, 116]]);

		addWeek(['Satin-Panties', 'High', 'Milf'], 4, ['mom'], [[249, 168, 203]]);

		addWeek(['Cocoa', 'Eggnog', 'Winter-Horrorland'], 5, ['parents-christmas', 'parents-christmas', 'monster-christmas'], [[120, 235, 243], [120, 235, 243], [46, 78, 81]]);

		addWeek(['Senpai', 'Roses', 'Thorns'], 6, ['senpai', 'senpai', 'spirit'], [[255, 173, 193]]);

		// LOAD MUSIC

		bg = new FlxSprite().loadGraphic(Paths.image('menuDesat'));
		bg.color = 0xFFFFFFFF;
		add(bg);

		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, (70 * i) + 30, songs[i].songName, true, false);
			songText.styleMenu('');
			songText.isMenuItem = true;
			songText.targetY = i;
			grpSongs.add(songText);

			songText.screenCenter(X);

			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			songText.x -= 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !! JAJAJA EL IMBECIL
			// songText.screenCenter(X);
		}

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		// scoreText.autoSize = false;
		scoreText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, RIGHT);
		// scoreText.alignment = RIGHT;

		var scoreBG:FlxSprite = new FlxSprite(scoreText.x - 6, 0).makeGraphic(Std.int(FlxG.width * 0.35), 66, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		add(diffText);

		add(scoreText);

		changeSelection();
		changeDiff();
		// FlxG.sound.playMusic(Paths.music('title'), 0);
		// FlxG.sound.music.fadeIn(2, 0, 0.8);
		selector = new FlxText();

		selector.size = 40;
		selector.text = ">";
		// add(selector);

		var swag:Alphabet = new Alphabet(1, 0, "swag");

		super.create();

		//  me when
		if (AGAIN_IN_FREEPLAY)
		{
			grpSongs.forEach(function (ALPHABET:Alphabet) 
			{
				ALPHABET.instantYPos();
			});
			bg.color = FlxColor.fromRGB(songs[curSelected].color[0], songs[curSelected].color[1], songs[curSelected].color[2], 255);
		}
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, colorRGB:Array<Dynamic>)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, colorRGB));
	}

	/**
		add song lol

		`songs` songs name "[Tutorial, Ugh]"

		`weekNum` week level "1"

		`songCharacter` iconPlayer "[dad]"

		`colorsRGB` colorBG (RGB) "[[57, 41, 33]]"
	**/

	public function addWeek(songs:Array<String>, weekNum:Int, ?songCharacters:Array<String>, colorsRGB:Array<Dynamic>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		var numC = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num], colorsRGB[numC]);

			if (songCharacters.length != 1)
				num++;

				if (colorsRGB.length - 1 != 0) 
				{
					numC++;
				}
		}
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, 0.6));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;

		scoreText.text = "PERSONAL BEST:" + lerpScore;

		var upP = controls.UP_P;
		var downP = controls.DOWN_P;
		var accepted = FlxG.keys.justPressed.ENTER;

		if (upP)
		{
			changeSelection(-1);
		}
		if (downP)
		{
			changeSelection(1);
		}

		if (controls.LEFT_P)
			changeDiff(-1);
		if (controls.RIGHT_P)
			changeDiff(1);

		if (controls.BACK)
		{
			AGAIN_IN_FREEPLAY = true;
			FlxG.switchState(new MainMenuState());
		}

		if (accepted)
		{
			AGAIN_IN_FREEPLAY = true;
			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase(), curDifficulty);

			trace(poop);

			PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase());
			PlayState.isStoryMode = false;
			PlayState.storyDifficulty = curDifficulty;

			PlayState.storyWeek = songs[curSelected].week;
			trace('CUR WEEK' + PlayState.storyWeek);
			LoadingState.loadAndSwitchState(new PlayState(), true);
		}
	}

	function changeDiff(change:Int = 0)
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = 2;
		if (curDifficulty > 2)
			curDifficulty = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		switch (curDifficulty)
		{
			case 0:
				diffText.text = "< EASY >";
			case 1:
				diffText.text = '< STANDAR >';
			case 2:
				diffText.text = "< HARD >";
		}
	}

	var BG_COLOR_TWEEN_YE:FlxTween;

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		#end

		#if PRELOAD_ALL
		FlxG.sound.playMusic(Paths.inst(songs[curSelected].songName), 0);
		#end

		if (BG_COLOR_TWEEN_YE != null)
		{
			BG_COLOR_TWEEN_YE.cancel();
		}

		BG_COLOR_TWEEN_YE = FlxTween.color(bg, 0.6, bg.color, FlxColor.fromRGB(songs[curSelected].color[0], songs[curSelected].color[1], songs[curSelected].color[2], 255), 
		{
			onComplete: function(twn:FlxTween) 
			{
				twn = null;
			}
		});

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;

			if (item.targetY == 0)
			{
				item.alpha = 1;
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var color:Array<Dynamic> = [];

	public function new(song:String, week:Int, songCharacter:String, colorRGB:Array<Dynamic>)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.color = colorRGB;
	}
}
