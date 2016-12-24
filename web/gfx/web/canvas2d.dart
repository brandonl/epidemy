part of gfx;

typedef void CanvasAction(CanvasRenderingContext2D);

abstract class CanvasRenderer<T> extends Renderer<T> {
  final html.CanvasRenderingContext2D _context;

  CanvasRenderer(this._context);

  html.CanvasRenderingContext2D get context => _context;
}