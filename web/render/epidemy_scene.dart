import 'dart:html';
import 'dart:math' as math;

import '../epidemy.dart';
import '../gfx/gfx.dart';
import '../grid.dart';
import 'graph.dart';
import 'room.dart';
import 'package:quiver/iterables.dart';

class EpidemyScene extends Scene {
  static const num margin = 5;
  static const num padding = 5;
  static const num subjectPadding = 5;

  final CanvasRenderingContext2D ctx;
  final int width;
  final int height;

  EpidemyScene._private(this.ctx, this.width, this.height) : super();

  factory EpidemyScene(CanvasRenderingContext2D ctx, int canvasWidth, int canvasHeight, List<Subject> population, List<Situation> history, int numCellsX, int numCellsY, int numSubjectsWidth, int numSubjectsHeight) {
    final scene = new EpidemyScene._private(ctx, canvasWidth, canvasHeight);
    final subjectRenderer = new ArcRenderer(ctx);
    final roomRenderer = new RoomRenderer(ctx);
    final graphRenderer = new GraphRenderer(ctx);

    final cellSize = (canvasWidth - (margin * 2) - padding) / numCellsX - padding;
    final radius = ((cellSize - subjectPadding) / numSubjectsWidth - subjectPadding) / 2;

    final grid = new Grid<List<Subject>>.generate(numCellsX, numCellsY, (r, c) {
      final h = population.where((s) => s.row == r && s.col == c && (s.state == State.healthy)).length;
      final s = population.where((s) => s.row == r && s.col == c && (s.state == State.sick || s.state == State.dead)).length;
      final i = population.where((s) => s.row == r && s.col == c && s.state == State.immune).length;
      final rest = math.max(0, numSubjectsHeight * numSubjectsWidth - (h + s + i));
      return concat([
        new List<Subject>.generate(s, (_) => new Subject(State.sick, r, c)),
        new List<Subject>.generate(h, (_) => new Subject(State.healthy, r, c)),
        new List<Subject>.generate(i, (_) => new Subject(State.immune, r, c)),
        new List<Subject>.generate(rest, (_) => new Subject(State.none, r, c))
      ]).toList();
    });

    grid.forEach((Cell<List<Subject>> cell) {
      var roomPoint = new Point(padding + margin + cell.col * (cellSize + padding),
          padding + margin + cell.row * (cellSize + padding)
      );

      for (var i = 0; i < cell.t.length; i++) {
        final s = cell.t.elementAt(i);
        final row = i ~/ numSubjectsWidth;
        final col = i % numSubjectsHeight;
        final subjPoint = roomPoint + new Point(
            subjectPadding + radius + col * (radius * 2 + subjectPadding),
            subjectPadding + radius + row * (radius * 2 + subjectPadding));
        scene.add(new ArcRenderable(subjPoint, radius, borderColor: _getColor(s.state)), subjectRenderer);
      }

      scene.add(new QuadRenderable(roomPoint, cellSize, cellSize, borderColor: Colors.white), roomRenderer);
    });

    final graphWidth = canvasWidth - margin * 2 - padding * 2;
    final graphHeight = canvasHeight - canvasWidth - margin;
    final graphPos = new Point(margin + padding, canvasHeight - graphHeight - margin);
    final graphOffset = new Point(graphWidth, graphHeight);
    scene.add(new QuadRenderable(
      graphPos,
      graphWidth, graphHeight,
      borderColor: Colors.white, fillColor: Colors.green),
      new QuadRenderer(ctx)
    );

    final sickOrDead = new PolyRenderable(graphPos + graphOffset, fillColor: Colors.red);
    final immune = new PolyRenderable(graphPos + graphOffset, fillColor: Colors.yellow);

    enumerate(history.reversed).forEach((iv) {
      scale(int count) => graphPos.y + graphHeight - (graphHeight * (count / population.length));

      Situation sit = iv.value;
      var i = iv.index;

      sickOrDead.add(new Point(10 + graphWidth - (graphWidth / (history.length) * i), scale(sit.numSickOrDead)));
      immune.add(new Point(10 + graphWidth - (graphWidth / (history.length) * i), scale(sit.numImmune + sit.numSickOrDead)));
    });

    scene.add(immune, graphRenderer);
    scene.add(sickOrDead, graphRenderer);
    return scene;
  }

  @override
  void clear() {
    ctx..fillStyle = "black"
      ..fillRect(0, 0, width, height);
  }

  static _getColor(State state) {
    switch (state) {
      case State.healthy:
        return Colors.green;
      case State.sick:
      case State.dead:
        return Colors.red;
      case State.immune:
        return Colors.yellow;
      case State.none:
      default:
        return Colors.gray;
    }
  }
}