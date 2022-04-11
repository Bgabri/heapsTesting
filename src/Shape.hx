class Shape {
    public var x:Int;
    public var y:Int;
    public function new(x:Int, y:Int) {
        this.x = x;
        this.y = y;
    }
    public function collision(shape:Shape) {
        
    }
}

class Circle extends Shape {
    public function new () {

    }
}

class Triangle extends Shape {
    
}

class Rect extends Shape {
    
}
