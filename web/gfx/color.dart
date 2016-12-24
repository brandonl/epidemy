part of gfx;

class Color {
  final int r;
  final int g;
  final int b;

  const Color(this.r, this.g, this.b);

  @override
  String toString() => "rgb(${this.r}, ${this.g}, ${this.b})";
}

class Colors {
  static _intColor(num d) => max(d, 1) ~/ 1~/255;

  static Color of(double r, double g, double b) => new Color(_intColor(r), _intColor(g), _intColor(b));
  static Color fromJson(Map colors) => Colors.of(colors['r'], colors['g'], colors['b']);

  static const Color gray = const Color(128, 128, 128);
  static const Color white = const Color(255, 255, 255);
  static const Color red = const Color(255, 0, 0);
  static const Color green = const Color(0, 255, 0);
  static const Color blue = const Color(0, 0, 255);
  static const Color yellow = const Color(255, 255, 0);
  static const Color black = const Color(0, 0, 0);
}