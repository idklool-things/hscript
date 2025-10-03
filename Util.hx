package;

#if openfl
import openfl.utils.Assets;
#end
#if sys
import sys.io.File;
import sys.FileSystem;
#end

using StringTools;

/**
 * ...
 * @author Idklool (idklel01)
 */
// Removi algumas funções porque sim lol
class Util
{
    public static function getContent(id:String):String
    {
        #if sys
        return File.getContent(id);
        #elseif openfl
        return Assets.getText(id);
        #else
        return '';
        #end
    }

    public static function exists(id:String):Bool
    {
        #if sys
        return FileSystem.exists(id);
        #elseif openfl
        return Assets.exists(id);
        #else
        return false;
        #end
    }

    public static function getBytes(id:String)
    {
        #if sys
        return File.getBytes(id);
        #elseif openfl
        return Assets.getBytes(id);
        #else
        return null;
        #end
    }

    public static function readDirectory(library:String):Array<String>
    {
        #if sys
        return FileSystem.readDirectory(library);
        #elseif openfl
        return Assets.list().filter(text -> text.indexOf(library) != -1);
        #else
        return [];
        #end
    }
}