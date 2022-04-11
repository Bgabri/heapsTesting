import hxd.Key;
import hxd.BitmapData;
import h2d.Bitmap;
import hxd.Timer;
import h2d.Graphics;
import h2d.TileGroup;
import hxd.Res;

import Tiler;

class Main extends hxd.App {
    var entities:Array<Int> = [];
    var components:Map<String, Array<Dynamic>> = [
        "health" => [],
        "static" => [],
        "shape" => [],
        "draw" => [],
        "tile" => [],
        "dynamic" => []
    ];
    var bmps:Array<h2d.Bitmap> = [];
    var tileSize = 16;
    var scale = 2;
    var txt:h2d.Text;
    var highlight:h2d.Graphics;
    var tiler:Tiler;

    override function init() {
        var font : h2d.Font = hxd.res.DefaultFont.get();
        txt = new h2d.Text(font, s2d);

        var tanjiroTile = Res.tanjirokamado.toTile();
        var tanBmp = new h2d.Bitmap(tanjiroTile, s2d);

        tanBmp.scaleX = tanBmp.scaleY = scale;

        tiler = new Tiler(Res.tiles.toTile(), s2d, 16, 2);

        bmps.push(tanBmp);
        tanBmp.scaleX = 2;
        tanBmp.scaleY = 2;

        entities.push(0);
        components["static"][0] = tanBmp;
        components["dynamic"][0] = {dx:5, dy:5, g:9.81};

        highlight = new h2d.Graphics(s2d);
    }
    var h = true;
    override function update(dt:Float) {
        var mx = s2d.mouseX;
        var my = s2d.mouseY;
        highlight.x = Math.floor(mx/(tileSize*scale))*tileSize*scale;
        highlight.y = Math.floor(my/(tileSize*scale))*tileSize*scale;

        for (id => e in components["dynamic"].keyValueIterator()) {
            components["static"][id].x += e.dx;
        }
        if (Key.isDown(Key.MOUSE_LEFT)){
            tiler.add(Math.floor(mx/(tileSize*scale)), Math.floor(my/(tileSize*scale)));
        }
        if (Key.isDown(Key.MOUSE_RIGHT)){
            tiler.remove(Math.floor(mx/(tileSize*scale)), Math.floor(my/(tileSize*scale)));
        }
        

        // components["static"][0].x = 300;

        // if (Key.isDown(Key.LEFT)) componets["static"][0].x -= 10*dt;
		// if (Key.isDown(Key.RIGHT)) componets["static"][0].x += 10*dt;
		// if (Key.isDown(Key.UP)) componets["static"][0].y -= 10*dt;
		// if (Key.isDown(Key.DOWN)) componets["static"][0].y += 10*dt;
        draw();
    }

    function draw() {
        highlight.clear();
        highlight.beginFill(0x00FF00, 0);
		highlight.lineStyle(1, 0xFF00FF);
        if (Key.isDown(Key.MOUSE_LEFT)) highlight.lineStyle(1, 0xAA0000);
        if (Key.isDown(Key.MOUSE_RIGHT)) highlight.lineStyle(1, 0x0000AA);
		highlight.drawRect(0,0,tileSize*scale,tileSize*scale);
		highlight.endFill();

        txt.text = Std.string(Timer.fps());
    }

    static function main() {
        hxd.Res.initEmbed();
        new Main();
    }

    static function loadFile():Array<Array<Dynamic<Int>>> {
        var resReader = hxd.fs.EmbedFileSystem.create("res");
        var text:String = resReader.get("world.dat").getText();

        var lines:Array<String> = text.split("\n");
        var input:Array<Array<Dynamic<Int>>> = [[]];
        for (y => line in lines) {
            var str = line.split(" ");
            for (s in str) {
                input[y].push({x: Std.parseInt(s.charAt(0)), y: Std.parseInt(s.charAt(1))});
            }
            input.push([]);
        }
        resReader.dispose();
        return input;
    }

    static function square(x:Int, y:Int, w:Int, h:Int, ?fill:Bool=true) {

    }

}