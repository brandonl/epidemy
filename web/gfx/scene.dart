part of gfx;

class _Tuple<T, R> {
  final T _1;
  final R _2;

  _Tuple(this._1, this._2);
}

abstract class Scene {
  final List<List<_Tuple<Renderable, Renderer>>> scene;

  Scene() : scene = [];

  Scene.of(this.scene);

  void add(Renderable renderable, Renderer renderer) {
    scene.add(new List.unmodifiable([new _Tuple(renderable, renderer)]));
  }

  void clear();

  void draw() {
    clear();
    scene.forEach((rs) {
      rs.forEach((t) => t._2.draw(t._1));
    });
  }
}