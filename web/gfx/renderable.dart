part of gfx;

class Renderable {
  final Point<num> position;
  final Color borderColor;
  final Color fillColor;

  Renderable(this.position, this.borderColor, this.fillColor);
}

class QuadRenderable extends Renderable {
  final num width;
  final num height;

  QuadRenderable(Point<num> position, this.width, this.height,
      {Color borderColor = Colors.white, Color fillColor = Colors.white})
    : super(position, borderColor, fillColor);
}

class ArcRenderable extends Renderable {
  final num radius;

  ArcRenderable(Point<num> position, this.radius,
      {Color borderColor = Colors.white, Color fillColor = Colors.white})
      : super(position, borderColor, fillColor);
}