package funkin.menus;

import flixel.addons.transition.FlxTransitionableState;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import funkin.backend.FunkinText;

class BetaWarningState extends MusicBeatState {
	var titleAlphabet:Alphabet;
	var disclaimer:FunkinText;

	var transitioning:Bool = false;

	public override function create() {
		super.create();

		titleAlphabet = new Alphabet(0, 0, "WARNING", true);
		titleAlphabet.screenCenter(X);

		disclaimer = new FunkinText(16, titleAlphabet.y + titleAlphabet.height + 10, FlxG.width - 32, "", 32);
		disclaimer.alignment = CENTER;
		disclaimer.applyMarkup('This engine is still in a *${Main.releaseCycle}* state. That means *majority of the features* are either *buggy* or *non finished*. If you find any bugs, please report them to the Codename Engine GitHub.\n\nPress ENTER to continue',
			[
				new FlxTextFormatMarkerPair(new FlxTextFormat(0xFFFF4444), "*")
			]
		);

		var off = Std.int((FlxG.height - (disclaimer.y + disclaimer.height)) / 2);
		disclaimer.y += off;
		titleAlphabet.y += off;

		goToTitle();
	}

	private function goToTitle() {
		MusicBeatState.skipTransIn = MusicBeatState.skipTransOut = true;
		FlxG.switchState(new TitleState());
	}
}