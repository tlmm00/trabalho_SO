import 'package:tuple/tuple.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

Map<int, List<int>> sjf(List<Process> processList) {
  Aux aux = Aux();

  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  List<int> listDone = [];
  List<int> executionList = [];

  List<int> sortedProcessTtfList = [];
  for (Process p in sortedProcessList) {
    sortedProcessTtfList.add(p.getTtf());
  }

  int n = sortedProcessList.length;
  int time = 0;
  while (listDone.length != n) {
    List<Process> l = sortedProcessList
        .where((p) => p.getTimeInit() <= time && !listDone.contains(p.getId()))
        .toList();

    if (l.isEmpty) {
      time++;
      executionList.add(-3);
    } else {
      Tuple2<Process, int> shortestJob = aux.getMinTtf(l);

      listDone.add(shortestJob.item1.getId());
      sortedProcessList
          .removeWhere((p) => p.getId() == shortestJob.item1.getId());

      for (int i = 0; i < shortestJob.item2; i++) {
        executionList.add(shortestJob.item1.getId());
      }
      time += shortestJob.item2;
    }
  }
  return aux.listToMatrix(executionList);
}
