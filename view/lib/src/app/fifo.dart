import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

Map<int, List<int>> fifo(List<Process> processList) {
  Aux aux = Aux();
  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);

  List<int> listDone = [];
  List<int> executionList = [];
  int n = sortedProcessList.length;

  int time = 0;
  while (listDone.length != n) {
    List<Process> l = sortedProcessList
        .where((p) => p.getTimeInit() <= time && !listDone.contains(p.getId()))
        .toList();

    if (l.isNotEmpty) {
      Process p = l.first;
      for (int i = 0; i < p.getTtf(); i++) {
        executionList.add(p.getId());
      }
      time += p.getTtf();
      listDone.add(p.getId());
    } else {
      time++;
      executionList.add(-3);
    }
  }

  // print("executionList: $executionList");
  return aux.listToMatrix(executionList);
}
