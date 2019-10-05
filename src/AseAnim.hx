import h2d.Bitmap;
import h2d.Tile;
import h2d.Object;
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

typedef AseFrame = {
    var tiles: Tile;
    var x: Int;
    var y: Int;
    var duration: Float;
}

class AseAnim extends Object {
    private var bitmaps: Array<Array<Bitmap>>;
    private var durations: Array<Float>;
    private var timer: Float;
    private var playing: Bool = false;
    private var frame(default, set): Int = 0;

    public static function fromFile(file: Resource, parent: Object): AseAnim {
        var ase: Aseprite<Tile> = Parser.parse(file.entry.getBytes(), createTile);
        var frameBitmaps = new Array<Array<Bitmap>>();
        var durations = new Array<Float>();
        for (frame in ase.frames) {
            var celBitmaps = new Array<Bitmap>();
            for (cel in frame.cels) {
                var dataParam = cel.data.getParameters();
                var tile = cast(dataParam[2], Tile);
                var bitmap = new Bitmap(tile.sub(0, 0, Math.min(ase.width - cel.x, tile.width), Math.min(ase.height - cel.y, tile.height)));
                bitmap.x = cel.x;
                bitmap.y = cel.y;
                celBitmaps.push(bitmap);
            }
            frameBitmaps.push(celBitmaps);
            durations.push(frame.duration);
        }
        return new AseAnim(frameBitmaps, durations, parent);
    }

    private static function createTile(bytes: Bytes, width: Int, height: Int, colorDepth: ColorDepth): Tile {
        var pixels = new Pixels(width, height, bytes, PixelFormat.RGBA);
        return Tile.fromPixels(pixels);
    }

    public function new(bitmaps: Array<Array<Bitmap>>, durations: Array<Float>, parent: Object) {
        super(parent);
        this.bitmaps = bitmaps;
        this.durations = durations;
        frame = 0;
        for (bitmap in bitmaps[frame]) {
            addChild(bitmap);
        }
    }

    public function play(frame: Int=0) {
        this.frame = frame;
        playing = true;
        timer = 0;
    }

    public function stop() {
        playing = false;
    }

    public function update(dt: Float) {
        if (playing) {
            if (timer > durations[frame]) {
                frame = (frame + 1) % bitmaps.length;
                timer = 0;
            }
            timer += dt;
        }
    }

    private function set_frame(frame: Int) {
        this.frame = frame;
        removeChildren();
        for (bitmap in bitmaps[frame]) {
            addChild(bitmap);
        }
        return frame;
    }
}