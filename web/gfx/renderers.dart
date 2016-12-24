part of gfx;

class Renderers<T> {
  factory Renderers.renderAll(Iterable<T> ts, Renderer<T> renderer) {
    var r = new Renderers._private();
    ts.forEach((t) => renderer.draw(t));
    return r;
  }

  factory Renderers.render(T t, Renderer<T> renderer) {
    var r = new Renderers._private();
    renderer.draw(t);
    return r;
  }

  Renderers._private();
}

