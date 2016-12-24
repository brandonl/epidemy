class Cell<T> {
  final int row;
  final int col;
  final T t;

  Cell(this.row, this.col, this.t);
}

class GridIndex {
  final int row;
  final int col;

  GridIndex(this.row, this.col);

  @override
  String toString() => "GridIndex [${row}, ${col}]";

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is GridIndex &&
        this.row == other.row &&
        this.col == other.col;
  }

  @override
  int get hashCode {
    return row.hashCode ^ col.hashCode;
  }
}

class Grid<T> extends Iterable<Cell<T>> {
  final int width;
  final int height;
  final List<Cell<T>> cells;

  Grid(this.cells, this.width, this.height);

  factory Grid.generate(int width, int height, T generator(int row, int col)) {
    int length = width * height;
    List<Cell<T>> result = new List(length);
    for (int i = 0; i < length; i++) {
      int row = i ~/ width;
      int col = i % height;
      result[i] = new Cell(row, col, generator(row, col));
    }
    return new Grid(result, width, height);
  }

  void update(int row, int col, T t) {
    cells[row % width * width + col % height] = new Cell<T>(row, col, t);
  }

  T getAt(int row, int col) => cells[row % width * width + col % height].t;

  get capacity => width * height;

  @override
  Iterator<Cell<T>> get iterator => cells.iterator;
}