part of gfx;

class ArcRenderer extends CanvasRenderer<ArcRenderable> {
  ArcRenderer(ctx) : super(ctx);

  @override
  void draw(ArcRenderable r) {
    withContext(context, drawCircle(r.position, r.radius, borderWidth: 2, borderColor: r.borderColor));
  }
}

class QuadRenderer extends CanvasRenderer<QuadRenderable> {
  QuadRenderer(ctx) : super(ctx);

  @override
  void draw(QuadRenderable r) {
    context..strokeStyle = r.borderColor.toString()
      ..fillStyle = r.fillColor.toString()
      ..fillRect(r.position.x, r.position.y, r.width, r.height)
      ..strokeRect(r.position.x, r.position.y, r.width, r.height);
  }
}