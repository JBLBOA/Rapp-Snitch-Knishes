package funkin.menus.credits;

import haxe.Json;
import funkin.backend.FunkinText;
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
import funkin.backend.FunkinText;

class MFcredits extends MusicBeatState
{
	var bg:FlxSprite;

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

	var creditsCosos:Array<String> = [
		'Menu Song',
		'BG and some credits shit',
		'Composer',
		'MFDOOM and MRFANTASTIK sprites',
		'menu and credits',
		'director and coding',
		'mfdoom sprite animation',
		'chart'
	];

	var links:Array<String> = [
		'https://awesamdudevr.carrd.co/',
		'https://www.youtube.com/channel/UCAL3sIl4Vwo3bpoTCjyHF6Q',
		'https://twitter.com/Ally_ThiefEJ',
		'https://twitter.com/redisoff1',
		'https://twitter.com/Robert0050_',
		'https://twitter.com/RobertoTheCoder',
		'https://twitter.com/simonuniverse2',
		'https://twitter.com/TelmexCedric'
	];

	var grpCredits:Array<FlxSprite> = [];

	var curSelected:Int = 0;

	var creditsText:FunkinText;

	override function create()
		{
			bg = new FlxSprite(-80).loadGraphic(Paths.image('menus/menuBGBlue'));
			// bg.scrollFactor.set();
			bg.scale.set(1.15, 1.15);
			bg.updateHitbox();
			bg.screenCenter();
			bg.scrollFactor.set();
			bg.antialiasing = true;
			add(bg);

			for (i in 0...creditsShit.length)
				{
					var itemwea:FlxSprite = new FlxSprite(950, 1000).loadGraphic(Paths.image('credits/'+creditsShit[i]));
					itemwea.offset.x = i*950;
					//itemwea.scale.set(3.5,3.5);
					itemwea.screenCenter();
					itemwea.y = itemwea.y + 30;
					
					if (i == 0)
						{
							itemwea.y = itemwea.y + 45;
							itemwea.scale.set(1.9,1.9);
						}
					if (i == 2)
						{
							itemwea.y = itemwea.y + 40;
							itemwea.scale.set(1.9,1.9);
						}
					if (i == 3)
						{
							itemwea.scale.set(1.9,1.9);
						}

					itemwea.ID = i;
					grpCredits.push(itemwea);
					add(itemwea);
				}

			var descBG:FlxSprite = new FlxSprite(0, FlxG.height - 170).makeSolid(FlxG.width - 100, 160, FlxColor.BLACK);
			descBG.alpha = 0.7;
			descBG.screenCenter(X);
			//add(descBG);

			creditsText = new FunkinText(200, 0, 0, '', 45);
			creditsText.alignment = CENTER;
			add(creditsText);

			changeShit(0);
		}
	override function update(elapsed:Float)
		{
			if (controls.BACK) {
				FlxG.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
				{
					CoolUtil.openURL(links[curSelected]);
				}

			if (controls.LEFT_P) {
				changeShit(-1);
			}
		
			if (controls.RIGHT_P) {
				changeShit(1);
			}

			for (i in grpCredits) {
				i.offset.x = FlxMath.lerp(i.offset.x, ((curSelected - i.ID)*950), FlxMath.bound(elapsed*8, 0, 1));
			}

			super.update(elapsed);
		}
	function changeShit(mierda:Int)
		{
			curSelected = FlxMath.wrap(curSelected+mierda, 0, creditsShit.length-1);

			creditsText.text = creditsCosos[curSelected];
		}
}