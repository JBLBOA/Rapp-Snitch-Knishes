package funkin.menus;

import haxe.Json;
import funkin.backend.FunkinText;
import funkin.menus.credits.MFcredits;
import flixel.FlxState;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.text.FlxText;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import funkin.backend.scripting.events.*;
import flixel.addons.display.FlxBackdrop;

import funkin.options.OptionsMenu;

import sys.io.File;

using StringTools;


typedef MenuData = 
{
	objects:Array<MenuData2>
}

typedef MenuData2 = 
{
    tag:String,
	id:Int,
    x:Float,
    y:Float,
    scaleX:Float,
    scaleY:Float,
    screenCenter:String
}

class MainMenuState extends MusicBeatState
{
	var curSelected:Int = 0;

	var menuJSON:MenuData;

	var menuItems:FlxTypedGroup<FlxSprite>;

	var optionShit:Array<String> = CoolUtil.coolTextFile(Paths.txt("config/menuItems"));

	var menucharacters:Array<String> = [
		'MFDOOM',
		'mrfantastico',
		'slenderman',
		'slenderman'
	];

	var creditsShit:Array<String> = [
		'awe',
		'mateoshady',
		'ally',
		'redis',
		'credit icon example',
		'robertominovio',
		'simon',
		'telmex'
	];

	var magenta:FlxSprite;
	var camFollow:FlxObject;

	public var canAccessDebugMenus:Bool = true;

	var characterSelecting:Bool = false;
	var curCharacter:Int = 1;

	var blackBG:FlxSprite;
	var selectText:FunkinText;

	var characters:FlxSprite;

	var mfdoom:FlxSprite;
	var mrfantastik:FlxSprite;

	override function create()
	{
		super.create();

		DiscordUtil.changePresence("In the Menus", null);

		CoolUtil.playMenuSong();

		menuJSON = Json.parse(File.getContent(Paths.json("config/menuItems")));

		var bg:FlxSprite = new FlxSprite(-80).makeSolid(FlxG.width, FlxG.height, FlxColor.fromRGB(124, 133, 98));
		bg.scrollFactor.set();
		bg.updateHitbox();
		bg.screenCenter();
		bg.antialiasing = true;
		add(bg);

		var backdrop:FlxBackdrop = new FlxBackdrop(Paths.image("menus/mainmenu/mfmenu/checkwea"));
		backdrop.scrollFactor.set();
        backdrop.velocity.set(-10, -10);
        backdrop.velocity.x = -120;
		backdrop.alpha = 0.3;
		add(backdrop);

		//fromRGB(124, 133, 98)
		
		camFollow = new FlxObject(0, 0, 1, 1);
		add(camFollow);

		magenta = new FlxSprite(-80).loadAnimatedGraphic(Paths.image('menus/menuDesat'));
		magenta.visible = false;
		magenta.color = 0xFFfd719b;
		//add(magenta);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		#if ALLOW_CUSTOMENU
			trace(menuJSON.objects);

			for (option in menuJSON.objects)
				{
					var menuItem:FlxSprite = new FlxSprite(option.x, option.y);
					menuItem.frames = Paths.getFrames('menus/mainmenu/mfmenu/menu');
					menuItem.animation.addByPrefix('idle', option.tag + " unselected", 24);
					menuItem.animation.addByPrefix('selected', option.tag + " selected", 24);
					menuItem.animation.play('idle');
					menuItem.ID = option.id;
					menuItems.add(menuItem);
					menuItem.scrollFactor.set();
					menuItem.antialiasing = true;
			
					menuItem.scale.set(option.scaleX, option.scaleY);
				
					if (option.screenCenter.toLowerCase().contains('x'))
							menuItem.screenCenter(X);
					if (option.screenCenter.toLowerCase().contains('y'))
						menuItem.screenCenter(Y);
				
						trace("MenuData: "+option.tag+"X: "+option.x+" Y: "+option.y+" scaleX: "+option.scaleX+" scaleY: "+option.scaleY+" ScreenCenter: "+option.screenCenter);
					}
		#else
			for (i=>option in optionShit)
				{
					var menuItem:FlxSprite = new FlxSprite(0, 60 + (i * 160));
					menuItem.frames = Paths.getFrames('menus/mainmenu/mfmenu/menu');
					menuItem.animation.addByPrefix('idle', option + " unselected", 24);
					menuItem.animation.addByPrefix('selected', option + " selected", 24);
					menuItem.animation.play('idle');
					menuItem.ID = i;
					menuItem.scale.set(0.7,0.7);
					menuItem.screenCenter(X);
					menuItems.add(menuItem);
					menuItem.scrollFactor.set();
					menuItem.antialiasing = true;

					if (option == "story mode")
						{
							menuItem.x = 750;
							menuItem.y = 50;
						}
					else if (option == "options")
						{
							menuItem.x = 950;
							menuItem.y = 230;
						}
					else if (option == "merch")
						{
							menuItem.x = 720;
							menuItem.y = 300;
						}
					else if (option == "credits")
						{
							menuItem.x = 800;
							menuItem.y = 500;
						}
				}
		#end

		FlxG.camera.follow(camFollow, null, 0.06);
		
		characters = new FlxSprite();
		characters.scrollFactor.set();
		add(characters);

		var line:FlxSprite = new FlxSprite().loadAnimatedGraphic(Paths.image('menus/mainmenu/mfmenu/barra'));
		line.screenCenter();
		line.scrollFactor.set();
		add(line);

		var versionShit:FunkinText = new FunkinText(5, FlxG.height - 2, 0, 'Codename Engine v${Application.current.meta.get('version')}\nCommit ${funkin.backend.system.macros.GitCommitMacro.commitNumber} (${funkin.backend.system.macros.GitCommitMacro.commitHash})\n[TAB] Open Mods menu\n');
		versionShit.y -= versionShit.height;
		versionShit.scrollFactor.set();
		//add(versionShit);

		blackBG = new FlxSprite(0,0).makeSolid(FlxG.width, FlxG.height, FlxColor.BLACK);
		blackBG.alpha = 0.0;
		blackBG.scrollFactor.set();
		add(blackBG);

		mfdoom = new FlxSprite(300,100);
		mfdoom.frames = Paths.getFrames('characters/mfdoom');
		mfdoom.animation.addByPrefix('idle', "Idle", 24);
		mfdoom.animation.play('idle');
		mfdoom.scrollFactor.set();
		mfdoom.scale.set(0.7,0.7);
		mfdoom.alpha = 0;
		add(mfdoom);

		mrfantastik = new FlxSprite(600,100);
		mrfantastik.frames = Paths.getFrames('characters/mrfan');
		mrfantastik.animation.addByPrefix('idle', "idl instancia", 24);
		mrfantastik.animation.play('idle');
		mrfantastik.scrollFactor.set();
		mrfantastik.scale.set(0.7,0.7);
		mrfantastik.alpha = 0;
		add(mrfantastik);

		selectText = new FunkinText(300,100,0, "", 36);
		selectText.scrollFactor.set();
		selectText.alpha = 0.0;
		add(selectText);

		changeItem();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
			FlxG.sound.music.volume += 0.5 * elapsed;

		if (characterSelecting)
			{
				if (FlxG.keys.justPressed.LEFT)
					{
						CoolUtil.playMenuSFX(SCROLL, 0.7);
		
						if (curCharacter > 1)
							{
								curCharacter -= 1;
								trace("curCharacter: "+curCharacter);
							}
					}
		
				if (FlxG.keys.justPressed.RIGHT)
					{
						CoolUtil.playMenuSFX(SCROLL, 0.7);
		
						if (curCharacter < 2)
							{
								curCharacter += 1;
								trace("curCharacter: "+curCharacter);
							}
					}
			}
			
		if (!selectedSomethin)
		{
			if (canAccessDebugMenus) {
				if (FlxG.keys.justPressed.SEVEN) {
					persistentUpdate = false;
					persistentDraw = true;
					openSubState(new funkin.editors.EditorPicker());
				}
			}

			if (controls.UP_P)
				changeItem(-1);
		
			if (controls.DOWN_P)
				changeItem(1);
		}

		if (controls.BACK)
			if (!characterSelecting)
				Sys.exit(0);
			else
				{
					selectedSomethin = false;
					characterSelecting = false;
					FlxTween.tween(mfdoom, {alpha: 0}, 0.5);
					FlxTween.tween(mrfantastik, {alpha: 0}, 0.5);
					FlxTween.tween(blackBG, {alpha: 0}, 0.5);
					FlxTween.tween(selectText, {alpha: 0}, 0.5);								
				}

		if (controls.ACCEPT)
			{
				if (!characterSelecting)
					selectItem();
				else
					{

						if (curCharacter == 1)
							{
								PlayState.loadSong("rapp-snitch-knishes", "Normal", true, false);
								FlxG.switchState(new PlayState());
							}
						if (curCharacter == 2)
							{
								PlayState.loadSong("rapp-snitch-knishes", "Normal", false, false);
								FlxG.switchState(new PlayState());
							}
					}
			}

		if (curCharacter == 1)
			{
				selectText.text = "¿Do you want to rap like "+"Mfdoom?";
				if (characterSelecting)
					{
						mfdoom.alpha = 1;
						mrfantastik.alpha = 0.5;
					}
			}

		if (curCharacter == 2)
			{
				selectText.text = "¿Do you want to rap like "+"MrFantastik?";
				if (characterSelecting)
					{
						mfdoom.alpha = 0.5;
						mrfantastik.alpha = 1;
					}
			}

		super.update(elapsed);
	}

	public override function switchTo(nextState:FlxState):Bool {
		try {
			menuItems.forEach(function(spr:FlxSprite) {
				FlxTween.tween(spr, {alpha: 0}, 0.5, {ease: FlxEase.quintOut});
			});
		}
		return super.switchTo(nextState);
	}

	function selectItem() {
		selectedSomethin = true;
		CoolUtil.playMenuSFX(CONFIRM);

		FlxFlicker.flicker(menuItems.members[curSelected], 1, 1.0, true, false, function(flick:FlxFlicker)
		{
			var daChoice:String = optionShit[curSelected];

			var event = event("onSelectItem", EventManager.get(NameEvent).recycle(daChoice));
			if (event.cancelled) return;
			switch (daChoice)
			{
				case 'story mode':
					characterSelecting = true;
					FlxTween.tween(blackBG, {alpha: 0.5}, 0.5);
					FlxTween.tween(selectText, {alpha: 1.0}, 0.5);
				case 'credits': FlxG.switchState(new MFcredits());
				case 'options': FlxG.switchState(new OptionsMenu());
				case 'merch': CoolUtil.openURL("https://gasdrawls.com/");
				selectedSomethin = false;
			}
		});
	}

	var charactersTween:FlxTween;

	function changeItem(huh:Int = 0)
	{
		var event = event("onChangeItem", EventManager.get(MenuChangeEvent).recycle(curSelected, FlxMath.wrap(curSelected + huh, 0, menuItems.length-1), huh, huh != 0));
		if (event.cancelled) return;

		curSelected = event.value;

		characters.y = 1000;

		charactersTween = FlxTween.tween(characters, { y: 0 }, 0.2, {ease: FlxEase.circOut});

		if (curSelected != 3)
			characters.loadAnimatedGraphic(Paths.image('menus/mainmenu/mfmenu/'+menucharacters[curSelected]));
		else
			characters.loadAnimatedGraphic(Paths.image('credits/robertominovio'));

		if (event.playMenuSFX)
			CoolUtil.playMenuSFX(SCROLL, 0.7);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var mid = spr.getGraphicMidpoint();
				camFollow.setPosition(mid.x, mid.y);
				mid.put();
			}

			spr.updateHitbox();
			spr.centerOffsets();
		});
	}
}
