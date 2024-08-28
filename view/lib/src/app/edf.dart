import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

Map<int, List<int>> edf(List<Process> processList, num quantum, num overload) {
  Aux aux = Aux();
  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  List<Process> listDone = [];

  int n = sortedProcessList.length;

  List<int> executionOrderProcessId = [];

  int time = 0;
  while (listDone.length != n) {
    List<Process> l =
        sortedProcessList.where((p) => p.getTimeInit() <= time).toList();

    // print("n: $n, listDone.length: ${listDone.length}");

    if (l.isEmpty) {
      // print("time++");
      time++;
      executionOrderProcessId.add(-3);
    } else {
      Tuple2 res = aux.getMinDeadline(l);
      Process minDeadlineProcess = res.item1;

      int pId = minDeadlineProcess.getId();
      int pTtf = minDeadlineProcess.getTtf();

      // print(minDeadlineProcess.getId());

      if (pTtf > quantum) {
        for (int i = 0; i < quantum; i++) {
          executionOrderProcessId.add(pId);
        }
        for (int j = 0; j < overload; j++) {
          executionOrderProcessId.add(-1);
        }
        time += (quantum + overload).toInt();

        sortedProcessList
            .where((p) => p.getId() == pId)
            .toList()
            .first
            .updateTtf(quantum.toInt());
      } else {
        int e;
        for (e = 0; e < pTtf; e++) {
          executionOrderProcessId.add(pId);
        }

        time += e;
        sortedProcessList.removeWhere((p) => p.getId() == pId);
        listDone.add(minDeadlineProcess);
      }
    }
  }

  return aux.listToMatrix(executionOrderProcessId);
}
