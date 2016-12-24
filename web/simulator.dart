class WorkItem {
  final int time;
  final Action action;

  WorkItem(this.time, this.action);
}

typedef void Action();

abstract class Simulator {
  final List<WorkItem> log = [];

  List<WorkItem> agenda;
  int currentTime = 0;

  Simulator(this.agenda);

  WorkItem afterDelay(int delay, Action action) {
    final item = new WorkItem(currentTime + delay, action);
    final head = agenda.takeWhile((wi) => wi.time <= item.time).toList();
    final tail = agenda.skipWhile((wi) => wi.time <= item.time).toList();
    head.add(item);
    head.addAll(tail);
    agenda = head;
    return item;
  }

  void init();

  void before();

  void after();

  _getWorkitem() {
    if (agenda.isNotEmpty) return agenda.first;
    else return null;
  }

  void step() {
    before();
    var wi = _getWorkitem();
    while (agenda.isNotEmpty && wi.time == currentTime) {
      agenda = agenda.sublist(1);
      wi.action();
      log.add(wi);
      wi = _getWorkitem();
    }
    currentTime++;
    after();
  }
}