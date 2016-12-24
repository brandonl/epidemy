import 'dart:async';
import 'dart:html';
import 'dart:math';

import 'epidemy.dart';
import 'render/epidemy_scene.dart';

void main() {
  const num numCellsX = 8;
  const num numCellsY = 8;
  const num numSubjectsPerRoom = 16;
  const num population = 300;

  const int waitTime = 200;
  const int maxDays = 100;

  final int numSubjectWidth = sqrt(numSubjectsPerRoom).toInt();
  final int numSubjectHeight = sqrt(numSubjectsPerRoom).toInt();

  CanvasElement canvas = querySelector('#container');
  CanvasRenderingContext2D ctx = canvas.getContext('2d');

  final sim = new EpidemySimulator(numCellsX, numCellsY, population, numSubjectsPerRoom)
    ..init();

  void run(int step) {
    if (step < maxDays) {
      sim.step();
      var sick = sim.history.last.numSickOrDead;
      var immune = sim.history.last.numImmune;
      var healthy = sim.history.last.numHealthy;
      print("On day $step, $healthy healthy, $sick sick, $immune immune");
      new Timer(const Duration(milliseconds: waitTime), () {
        new EpidemyScene(ctx, canvas.width, canvas.height, sim.population, sim.history, numCellsX, numCellsY, numSubjectWidth, numSubjectHeight)
          .draw();
        run(step + 1);
      });
    }
  }

  run(0);
}
