package funkin.editors;

import sys.io.File;
import haxe.Json;

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

class MenuEditor extends UIState {

	var menuJSON:MenuData;
	var menuItems:FlxTypedGroup<FlxSprite>;

	var up:UIButton;
	var down:UIButton;

	var curSelected:Int = 1;
	var curMenuText:UIText;

	public override function create() {
		super.create();

		menuJSON = Json.parse(File.getContent(Paths.json("config/menuItems")));

		FlxG.mouse.useSystemCursor = FlxG.mouse.visible = true;
		var bg = new FlxSprite().makeSolid(FlxG.width, FlxG.height, 0xFF444444);
		bg.updateHitbox();
		bg.scrollFactor.set();
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (option in menuJSON.objects)
			{
				var menuItem:FlxSprite = new FlxSprite(option.x, option.y);
				menuItem.frames = Paths.getFrames('menus/mainmenu/${option.tag}');
				menuItem.animation.addByPrefix('idle', option.tag + " basic", 24);
				menuItem.animation.play('idle');
				menuItems.add(menuItem);
				menuItem.antialiasing = true;
		
				menuItem.scale.set(option.scaleX, option.scaleY);
			
				if (option.screenCenter.toLowerCase().contains('x'))
						menuItem.screenCenter(X);
				if (option.screenCenter.toLowerCase().contains('y'))
					menuItem.screenCenter(Y);
			}

		var spliceSprite:UISliceSprite = new UISliceSprite(30, 300, 300, 150, "editors/ui/context-bg");
		add(spliceSprite);

		var spliceSprite2:UISliceSprite = new UISliceSprite(FlxG.width - 360, 100, 350, 500, "editors/ui/context-bg");
		add(spliceSprite2);

		up = new UIButton(50, 360, "<-", function() {
			trace("Hello, World!");
		}, 32, 32);
		add(up);

		down = new UIButton(270, 360, "->", function() {
			trace("Hello, World!");
		}, 32, 32);
		add(down);

		curMenuText = new UIText(0,0,0,"",25);
		add(curMenuText);
	}

	override function update(elapsed:Float)
		{
			//curMenuText.text = menuJSON.objects.tag;

			super.update(elapsed);
		}
}