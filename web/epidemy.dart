import 'dart:math';

import 'simulator.dart';

enum State {
  sick,
  dead,
  healthy,
  immune,
  none
}

class Subject {
  bool infected = false;
  State state;
  int row;
  int col;

  Subject(this.state, this.row, this.col);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Subject &&
        this.state == other.state &&
        this.row == other.row &&
        this.col == other.col;
  }

  @override
  int get hashCode {
    return state.hashCode ^ row.hashCode ^ col.hashCode;
  }

  @override
  String toString() {
    return 'Subject{state: $state, row: $row, col: $col}';
  }
}

class Situation {
  final int numHealthy;
  final int numSickOrDead;
  final int numImmune;

  Situation(this.numHealthy, this.numSickOrDead, this.numImmune);

  @override
  String toString() {
    return 'Situation{numHealthy: $numHealthy, numSickOrDead: $numSickOrDead, numImmune: $numImmune}';
  }
}

class EpidemySimulator extends Simulator {
  static final Random _rand = new Random();

  static const num _prevalenceRate = 0.1;
  static const num _incubationTime = 6;
  static const num _dieTime = 14;
  static const num _immuneTime = 16;
  static const num _healTime = 18;
  static const num _transRate = 0.40;
  static const num _dieRate = 0.25;

  final List<Situation> _history = [];
  final List<Subject> _population = [];
  final num _width;
  final num _height;
  final num _populationSize;
  final num _maxOccupantsPerRoom;

  EpidemySimulator(this._width, this._height, this._populationSize, this._maxOccupantsPerRoom)
      : super([]);

  int _randBelow(num val) => (_rand.nextDouble() * val).toInt();

  List<Situation> get history => _history;

  List<Subject> get population => _population;

  bool _isAlive(Subject s) => s.state != State.dead;

  void _tryKill(Subject s) {
    print("Try kill $s");
    s.state = (_isAlive(s) && _rand.nextDouble() <= _dieRate) ? State.dead : s.state;
    print("Results: $s");
  }

  void _heal(Subject s) {
    print("Try heal $s");
    s.state = _isAlive(s) ? State.healthy : s.state;
    s.infected = false;
  }

  void _immunize(Subject s) {
    print("Try immunize $s");
    s.state = _isAlive(s) ? State.immune : s.state;
  }

  void _infect(Subject subject) {
    subject.infected = true;
    afterDelay(_incubationTime, () => subject.state = State.sick);
    afterDelay(_dieTime, () => _tryKill(subject));
    afterDelay(_immuneTime, () => _immunize(subject));
    afterDelay(_healTime, () => _heal(subject));
  }

  bool _isContagious(int row, int col) => _population
      .where((s) => s.row == row && s.col == col)
      .any((s) => s.infected);

  bool _hasVacancy(int row, int col) => _population
      .where((s) => s.row == row && s.col == col)
      .length < _maxOccupantsPerRoom;

  void _move(Subject subject) {
    _do() {
      final row = subject.row;
      final col = subject.col;

      final neighbors = new List.unmodifiable([
        [(row - 1 + _width) % _width, col],
        [(row + 1) % _width, col],
        [row, (col - 1 + _height) % _height],
        [row, (col + 1) % _height]
      ]);

      final candidates = neighbors.where((i) => !_isContagious(i.first, i.last) && _hasVacancy(i.first, i.last));

      if (candidates.isNotEmpty) {
        final cl = candidates.elementAt(_randBelow(candidates.length));
        subject.row = cl.first;
        subject.col = cl.last;
      }

      if (!subject.infected && subject.state != State.immune && _rand.nextDouble() <= _transRate) {
        if (_isContagious(subject.row, subject.col)) {
          print("infecting dude $subject");
          _infect(subject);
        }
      }

      _progress(subject);
    }
    if (_isAlive(subject)) _do();
  }

  void _progress(Subject subject) {
    afterDelay(_randBelow(5) + 1, () => _move(subject));
  }

  @override
  void init() {
    for (int i = 0; i < _populationSize; i++) {
      int r = _randBelow(_width);
      int c = _randBelow(_height);

      final subject = new Subject(State.healthy, r, c);
      _population.add(subject);

      if (i <= _populationSize * _prevalenceRate)
        _infect(subject);
      _progress(subject);
    }
  }

  @override
  void before() {
  }

  @override
  void after() {
    int numHealthy = 0;
    int numSickOrDead = 0;
    int numImmune = 0;
    int x = 0;

    numHealthy += _population.where((s) => s.state == State.healthy).length;
    numSickOrDead += _population.where((s) => s.state == State.sick || s.state == State.dead).length;
    numImmune += _population.where((s) => s.state == State.immune).length;
    x += _population.where((s) => s.infected == true).length;

    print("$x");

    history.add(new Situation(numHealthy, numSickOrDead, numImmune));
  }
}