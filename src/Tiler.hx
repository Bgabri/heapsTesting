class Tiler {
    public var worldData(default, null):Array<Array<Dynamic<Int>>> = [[]];
    var scale:Int = 1;
    var tileSize:Int = 16;
    
    var tilesGrid:Array<Array<h2d.Tile>>;
    var tileGroup:h2d.TileGroup;

    public function new(tile:h2d.Tile, parent:h2d.Scene, ?tileSize:Int, ?scale:Int) {
        this.scale = scale;
        this.tileSize = tileSize;

        this.tilesGrid = tile.grid(tileSize);
        this.tileGroup = new h2d.TileGroup(tile, parent);
        this.tileGroup.scaleX = this.tileGroup.scaleY = scale;
        loadData();
        for (y => line in worldData) {
            for (x => v in line) {
                if (v.x + v.y != 0) this.tileGroup.add(x*tileSize, y*tileSize, tilesGrid[v.x][v.y]);
            }
        }
    }

    public function add(xI:Int, yI:Int) {
        this.worldData[xI][yI] = {x:4, y:2};
        this.tileGroup.add(xI*this.tileSize, yI*this.tileSize, this.tilesGrid[4][3]);
    }

    public function removeTile(xI:Int, yI:Int) {
        
    }

    function loadData(){
        var resReader = hxd.fs.EmbedFileSystem.create("res");
        var text:String = resReader.get("world.dat").getText();

        var lines:Array<String> = text.split("\n");
        worldData = [[]];
        for (y => line in lines) {
            var str = line.split(" ");
            for (s in str) {
                worldData[y].push({x: Std.parseInt(s.charAt(0)), y: Std.parseInt(s.charAt(1))});
            }
            worldData.push([]);
        }
        resReader.dispose();
    }
}