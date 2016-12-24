import '../gfx/gfx.dart';
import 'dart:html';
import 'dart:math';

class PolyRenderable extends Renderable {
  List<Point<num>> verts = [];

  PolyRenderable(Point<num> position, {Color borderColor, Color fillColor}) : super(position, borderColor, fillColor);

  void add(Point<num> vert) => verts.add(vert);
}

class GraphRenderer extends CanvasRenderer<PolyRenderable> {

  GraphRenderer(CanvasRenderingContext2D context) : super(context);

  @override
  void draw(PolyRenderable t) {
    context
      ..beginPath()
      ..moveTo(t.position.x, t.position.y)
      ..fillStyle = t.fillColor.toString();

    t.verts.forEach((Point p) => context.lineTo(p.x, p.y));

    context
      ..lineTo(t.verts.last.x, t.position.y)
      ..lineTo(t.position.x, t.position.y)
      ..closePath()
      ..fill();

  }
}