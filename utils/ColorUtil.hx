package utils;

import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.system.macros.FlxMacroUtil;

/**
    * This does NOT work properly, for some reason.
    * If you use like, ColorUtil.RED, it will return white.
    * I have no idea how to fix this :(
**/

class ColorUtil {
    public static inline var TRANSPARENT:FlxColor = 0x00000000;
    public static inline var WHITE:FlxColor = 0xFFFFFFFF;
    public static inline var GRAY:FlxColor = 0xFF808080;
    public static inline var BLACK:FlxColor = 0xFF000000;
    public static inline var GREEN:FlxColor = 0xFF008000;
    public static inline var LIME:FlxColor = 0xFF00FF00;
    public static inline var YELLOW:FlxColor = 0xFFFFFF00;
    public static inline var ORANGE:FlxColor = 0xFFFFA500;
    public static inline var RED:FlxColor = 0xFFFF0000;
    public static inline var PURPLE:FlxColor = 0xFF800080;
    public static inline var BLUE:FlxColor = 0xFF0000FF;
    public static inline var BROWN:FlxColor = 0xFF8B4513;
    public static inline var PINK:FlxColor = 0xFFFFC0CB;
    public static inline var MAGENTA:FlxColor = 0xFFFF00FF;
    public static inline var CYAN:FlxColor = 0xFF00FFFF;

    public static var colorLookup(default, null):Map<String, Int> = FlxMacroUtil.buildMap("flixel.util.FlxColor");
    static var COLOR_REGEX = ~/^(0x|#)(([A-F0-9]{2}){3,4})$/i;

    public static inline function fromInt(value:Int):FlxColor {
        return new FlxColor(value);
    }

    public static inline function fromRGB(red:Int, green:Int, blue:Int, alpha:Int = 255):FlxColor
    {
        var color = new FlxColor();
        return color.setRGB(red, green, blue, alpha);
    }

    public static inline function fromRGBFloat(red:Float, green:Float, blue:Float, alpha:Float = 1):FlxColor {
        var color = new FlxColor();
        return color.setRGBFloat(red, green, blue, alpha);
    }

    public static inline function fromCMYK(cyan:Float, magenta:Float, yellow:Float, black:Float, alpha:Float = 1):FlxColor {
        var color = new FlxColor();
        return color.setCMYK(cyan, magenta, yellow, black, alpha);
    }

    public static inline function fromHSB(hue:Float, saturation:Float, brightness:Float, alpha:Float = 1):FlxColor {
        var color = new FlxColor();
        return color.setHSB(hue, saturation, brightness, alpha);
    }

    public static inline function fromHSL(hue:Float, saturation:Float, lightness:Float, alpha:Float = 1):FlxColor {
        var color = new FlxColor();
        return color.setHSL(hue, saturation, lightness, alpha);
    }

    public static function fromString(str:String):FlxColor {
        var result:Null<FlxColor> = null;
        str = StringTools.trim(str);

        if (COLOR_REGEX.match(str))
        {
            var hexColor:String = "0x" + COLOR_REGEX.matched(2);
            result = new FlxColor(Std.parseInt(hexColor));
            if (hexColor.length == 8)
            {
                result.alphaFloat = 1;
            }
          
        }
        else
        {
            str = str.toUpperCase();
            for (key in colorLookup.keys())
            {
                if (key.toUpperCase() == str)
                {
                    result = new FlxColor(colorLookup.get(key));
                    break;
                }
            }
        }

        return result;
    }
    public static function getHSBColorWheel(alpha:Int = 255):Array<FlxColor> {
        return [for (c in 0...360) fromHSB(c, 1.0, 1.0, alpha)];
    }

    public static inline function interpolate(Color1:FlxColor, Color2:FlxColor, Factor:Float = 0.5):FlxColor {
        var r:Int = Std.int((Color2.red - Color1.red) * Factor + Color1.red);
        var g:Int = Std.int((Color2.green - Color1.green) * Factor + Color1.green);
        var b:Int = Std.int((Color2.blue - Color1.blue) * Factor + Color1.blue);
        var a:Int = Std.int((Color2.alpha - Color1.alpha) * Factor + Color1.alpha);
        return fromRGB(r, g, b, a);
    }

    public static function gradient(Color1:FlxColor, Color2:FlxColor, Steps:Int, ?Ease:EaseFunction):Array<Int> {
        var output = new Array<FlxColor>();

        if (Ease == null)
        {
            Ease = FlxEase.linear;
        }

        for (step in 0...Steps)
        {
            output[step] = interpolate(Color1, Color2, Ease(step / (Steps - 1)));
        }

        return output;
    }
}