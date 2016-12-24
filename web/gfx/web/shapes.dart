part of gfx;

CanvasAction drawCircle(Point center, num radius, {
    num borderWidth = 1,
    Color borderColor = Colors.white,
    Color fillColor
  }) {
  return (html.CanvasRenderingContext2D ctx) =>
  ctx..strokeStyle = borderColor.toString()
    ..lineWidth = borderWidth
    ..fillStyle = fillColor.toString()
    ..beginPath()
    ..arc(center.x, center.y, radius, 0, 2 * PI, false)
    ..closePath()
    ..fill()
    ..stroke();
}