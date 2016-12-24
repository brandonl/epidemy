import 'dart:html';
import 'dart:math';

import '../gfx/gfx.dart';

class RoomRenderer extends CanvasRenderer<QuadRenderable> {
  RoomRenderer(CanvasRenderingContext2D context) : super(context);

  @override
  void draw(QuadRenderable t) {
    _drawCell(t.position, t.width, t.borderColor);
  }

  void _drawCell(Point topLeft, num size, Color borderColor, {num lineWidth = 1}) {
    final sideLen = size / 2.5;

    final x = topLeft.x;
    final y = topLeft.y;
    final coords = [topLeft, new Point(x + size, y), new Point(x + size, y + size), new Point(x, y + size)];

    return coords.forEach((coord) {
          var cx = coord.x;
          var cy = coord.y;
          var xMove = cx == x + size ? -sideLen : sideLen;
          var yMove = cy == y + size ? -sideLen : sideLen;
          context..strokeStyle = borderColor.toString()
            ..lineWidth = lineWidth
            ..beginPath()
            ..moveTo(cx, cy)
            ..lineTo(cx + xMove, cy)
            ..closePath()
            ..stroke()
            ..beginPath()
            ..moveTo(cx, cy)
            ..lineTo(cx, cy + yMove)
            ..closePath()
            ..stroke();
        });
  }
}