package window.windowMod;
#if windows
import flixel.FlxG;
import flixel.util.FlxColor;
import lime.ui.Window;
import lime.ui.WindowAttributes;
import openfl.Lib;
import openfl.display.Sprite;
import openfl.geom.Matrix;

class FlxWindowModifier 
{

    public static var popupwindow:Window;
    public static var windowSprite:Sprite;

    public static function changeWinPos(X:Int, Y:Int, type:String)
    {
        // basically, run this function of changeWinPos() with the desired change in X and Y to the main window
        switch (type)
        {
            case "ADD" | "PLUS":
                FlxG.stage.application.window.x += X;
                FlxG.stage.application.window.y += Y;
            case "SUBTRACT" | "SUB" | "MINUS":
                FlxG.stage.application.window.x -= X;
                FlxG.stage.application.window.y -= Y;
        }
    }

    public static function setWinPos(X:Int, Y:Int)
    {
        // Run this function of setWinPos() to SET the window position, not add to it
        FlxG.stage.application.window.x = X;
        FlxG.stage.application.window.y = Y;
    }

    public static function changeWinDimension(Width:Int, Height:Int)
    {
        // Run the function of changeWinDimension() to set the width and height of the window!
        FlxG.stage.application.window.width = Width;
        FlxG.stage.application.window.height = Height;
    }

    public static function popUpWindow(attributes:WindowAttributes, color:FlxColor, X:Int, Y:Int, spritePath:String)
    {
        popupwindow = Lib.application.createWindow(attributes);
        popupwindow.stage.color = color;
        popupwindow.x = X;
        popupwindow.y = Y;

        var image = Paths.image(spritePath).bitmap;
        var m = new Matrix();

        var spr = new Sprite();
        spr.graphics.beginBitmapFill(image, m);
        spr.graphics.drawRect(0, 0, image.width, image.height);
        spr.graphics.endFill();
        popupwindow.stage.addChild(spr);
    }

    public static function getWinTrans()
    {
        #if windows
        /**
        * The function is defined in the `TransparencyFunc` class below
        * This function toggles it on or off every time you use it
        * But, if you want the window to go transparent, first you have to make a sprite below.
        * `var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(1, 1, 1));`
        * Then, add the FlxSprite `add(bg);`
        * Finally, run the function. `FlxWindowModifier.getWinTrans();`
        * MAKE SURE that the sprite of `bg` is the bottom layer in your state. Otherwise, it will just make a layer on top of the game transparent, basically doing nothing
	    */
        TransparencyFunc.getWindowsTransparent();
        #else
        trace("getWinTrans() only supports Windows!");
        #end
    }
}

#if windows
@:cppFileCode('#include <windows.h>\n#include <dwmapi.h>\n\n#pragma comment(lib, "Dwmapi")')
class TransparencyFunc
{
    // Most of this code was written by KadeDev, props to him!! ^-^
	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) | WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(24, 24, 24), 0, LWA_COLORKEY);
        }
    ')
	public static function getWindowsTransparent(res:Int = 0)
	{
		return res;
	}

	@:functionCode('
        HWND hWnd = GetActiveWindow();
        res = SetWindowLong(hWnd, GWL_EXSTYLE, GetWindowLong(hWnd, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        if (res)
        {
            SetLayeredWindowAttributes(hWnd, RGB(24, 24, 24), 1, LWA_COLORKEY);
        }
    ')
	public static function getWindowsbackward(res:Int = 0)
	{
		return res;
	}
}
#end
#end