import haxe.io.Output;
import h3d.impl.TextureCache;

class Tiler {
    public var worldData(default, null):Array<Dynamic<Int>> = [];
    var scale:Int = 1;
    var tileSize:Int = 16;
    
    var tilesGrid:Array<Array<h2d.Tile>>;
    var tileGroup:h2d.TileGroup;
    var N = 10000;

    public function new(tile:h2d.Tile, parent:h2d.Scene, ?tileSize:Int=16, ?scale:Int=1) {
        this.scale = scale;
        this.tileSize = tileSize;

        this.tilesGrid = tile.grid(tileSize);
        this.tileGroup = new h2d.TileGroup(tile, parent);
        this.tileGroup.scaleX = this.tileGroup.scaleY = scale;
        loadData();
        populate();
    }

    public function add(xI:Int, yI:Int) {

        var i = biInsert(xI+yI*this.N, 0, this.worldData.length-1);
        if (i < 0) this.worldData.insert(-i-1, {x:xI, y:yI, dx:4, dy:3});
        
        for (y in -1...2){
            for (x in -1...2){
                var i = biInsert(xI+x+(yI+y)*this.N, 0, this.worldData.length-1);
                if (i >= 0) updatePattern(xI+x, yI+y);
            }
        }
        populate();
    }

    public function remove(xI:Int, yI:Int) {
        var i = biInsert(xI+yI*this.N, 0, this.worldData.length-1);
        if (i >= 0) {
            
            this.worldData.splice(i,1);}

        for (y in -1...2) {
            for (x in -1...2) {
                var i = biInsert(xI+x+(yI+y)*this.N, 0, this.worldData.length-1);
                if (i >= 0) updatePattern(xI+x, yI+y);
            }
        }
        populate();
    }

    public function updatePattern(xI:Int, yI:Int) {
        
        var pattern:Array<Int> = [];
        /*order
            "01234567"
            012
            3x4
            567
        */

        var bit = 1;
        for (y in -1...2){
            for (x in -1...2){
                if (!(y == 0 && x == 0)) {
                    var i = biInsert(xI+x+(yI+y)*this.N, 0, this.worldData.length-1);
                    if (i < 0) pattern.push(0);
                    else pattern.push(1);
                }
            }
        }

        var dx = 4;
        var dy = 3;

        switch pattern {
            case [0,1,0,1,1,0,1,0]: dx = 1; dy = 0;
            case [_,1,1,0,1,_,1,0]: dx = 2; dy = 0;
            case [1,1,_,1,0,0,1,_]: dx = 3; dy = 0;
            case [_,0,_,0,0,_,1,_]: dx = 4; dy = 0;
            case [_,0,_,0,1,_,1,1]: dx = 5; dy = 0;
            case [_,0,_,1,1,1,1,1]: dx = 6; dy = 0;
            case [_,0,_,1,0,1,1,_]: dx = 7; dy = 0;
            
            case [1,1,0,1,1,0,1,1]: dx = 0; dy = 1;
            case [0,1,1,1,1,1,1,0]: dx = 1; dy = 1;
            case [_,1,0,0,1,_,1,1]: dx = 2; dy = 1;
            case [0,1,_,1,0,1,1,_]: dx = 3; dy = 1;
            case [_,1,_,0,0,_,1,_]: dx = 4; dy = 1;
            case [_,1,1,0,1,_,1,1]: dx = 5; dy = 1;
            case [1,1,1,1,1,1,1,1]: dx = 6; dy = 1;
            case [1,1,_,1,0,1,1,_]: dx = 7; dy = 1;
            
            case [0,1,0,1,1,0,1,1]: dx = 0; dy = 2;
            case [0,1,0,1,1,1,1,0]: dx = 1; dy = 2;
            case [_,0,_,1,1,1,1,0]: dx = 2; dy = 2;
            case [_,0,_,1,1,0,1,1]: dx = 3; dy = 2;
            case [_,1,_,0,0,_,0,_]: dx = 4; dy = 2;
            case [_,1,1,0,1,_,0,_]: dx = 5; dy = 2;
            case [1,1,1,1,1,_,0,_]: dx = 6; dy = 2;
            case [1,1,_,1,0,_,0,_]: dx = 7; dy = 2;
            
            case [0,1,1,1,1,0,1,0]: dx = 0; dy = 3;
            case [1,1,0,1,1,0,1,0]: dx = 1; dy = 3;
            case [1,1,0,1,1,_,0,_]: dx = 2; dy = 3;
            case [0,1,1,1,1,_,0,_]: dx = 3; dy = 3;
            case [_,0,_,0,0,_,0,_]: dx = 4; dy = 3;
            case [_,0,_,0,1,_,0,_]: dx = 5; dy = 3;
            case [_,0,_,1,1,_,0,_]: dx = 6; dy = 3;
            case [_,0,_,1,0,_,0,_]: dx = 7; dy = 3;
            
            case [0,1,1,1,1,0,1,1]: dx = 0; dy = 4;
            case [0,1,0,1,1,1,1,1]: dx = 1; dy = 4;
            case [_,1,0,0,1,_,1,0]: dx = 2; dy = 4;
            case [_,0,_,1,1,0,1,0]: dx = 3; dy = 4;
            case [_,0,_,0,1,_,1,0]: dx = 4; dy = 4;
            case [_,0,_,1,0,0,1,_]: dx = 5; dy = 4;
            case [1,1,1,1,1,1,1,0]: dx = 6; dy = 4;
            case [1,1,1,1,1,0,1,1]: dx = 7; dy = 4;
            
            case [1,1,1,1,1,0,1,0]: dx = 0; dy = 5;
            case [1,1,0,1,1,1,1,0]: dx = 1; dy = 5;
            case [0,1,0,1,1,_,0,_]: dx = 2; dy = 5;
            case [0,1,_,1,0,0,1,_]: dx = 3; dy = 5;
            case [_,1,0,0,1,_,0,_]: dx = 4; dy = 5;
            case [0,1,_,1,0,_,0,_]: dx = 5; dy = 5;
            case [1,1,0,1,1,1,1,1]: dx = 6; dy = 5;
            case [0,1,1,1,1,1,1,1]: dx = 7; dy = 5;
            case _: null;
        }

        var i = biInsert(xI+yI*this.N, 0, this.worldData.length-1);

        if (i >= 0) this.worldData[i] = {x:xI, y:yI, dx:dx, dy:dy};

    }

    function populate() {
        this.tileGroup.clear();
        for (t in this.worldData) {
            this.tileGroup.add(t.x*tileSize, t.y*tileSize, this.tilesGrid[t.dx][t.dy]);
        }
        this.tileGroup.invalidate();
    }

    public function biInsert(x:Int, lowI:Int, highI:Int):Int {
        // nums smaller than 0 are not in array, to get index -(i+1)
        if (highI < lowI) return -lowI-1;
        
        var midI:Int = Math.floor((lowI + highI)/2);
        var t = this.worldData[midI];
        if (t.x+t.y*this.N == x) {
            return midI;
        }
        if (t.x+t.y*this.N > x) return biInsert(x, lowI, midI-1);

        return biInsert(x, midI+1, highI);
    }

    function collision(x:Int, y:Int, w:Int, h:Int) {
        for (tile in this.worldData) {
            var tx:Int = tile.x;
            var ty:Int = tile.y;
            var th:Int = this.tileSize*this.scale;
            if (rectVsRect(x, y, w, h, tx, ty, th, th)) return true;
        }
        return false;
    }

    function rectVsRect(x, y, w, h, x2, y2, w2, h2) {
        if (x > x2 + w2 || x2 > x + w) return false;
        if (y > y2 + h2 || y2 > y + h) return false;
        return true;
    }

    function loadData(){
        var resReader = hxd.fs.EmbedFileSystem.create("res");
        var text:String = resReader.get("world.dat").getText();

        var lines:Array<String> = text.split("\n");
        for (y => line in lines) {
            var str = line.split(" ");
            for (x => s in str) {
                var dat = {x:x, y:y, dx: Std.parseInt(s.charAt(0)), dy: Std.parseInt(s.charAt(1))};
                if (dat.dx+dat.dy != 0) {
                    worldData.push(dat);
                }
            }
        }
        resReader.dispose();
    }
}