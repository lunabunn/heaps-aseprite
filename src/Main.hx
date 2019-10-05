import h2d.Bitmap;
import hxd.PixelFormat;
import haxe.io.Bytes;
import hxd.Pixels;
import h2d.Tile;
import aseprite.Aseprite;
import aseprite.Parser;
import h2d.Object;
import hxd.res.Resource;
import hxd.Res;
import h2d.Anim;

using haxe.EnumTools.EnumValueTools;

class Main extends hxd.App {
    public var anim: AseAnim;

    override function init() {
        Res.initEmbed();
        anim = AseAnim.fromFile(Res.sprites.player_walk, s2d);
        anim.scaleX = 5;
        anim.scaleY = 5;
        anim.play();
    }

    override function update(dt: Float) {
        anim.update(dt);
    }

    static function main() {
        new Main();
    }
}