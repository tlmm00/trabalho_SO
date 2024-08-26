import 'package:flutter/material.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> rr(List<Process> processList, num quantum, num overload) {
  Aux aux = Aux();

  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  int n = sortedProcessList.length;
  List<int> executionOrderProcessId = [];
  List<Process> listDone = [];
  List<Process> removeList = [];

  num time = sortedProcessList[0].getTimeInit();
  // print(sortedProcessList.length);
  // print(n);
  while (listDone.length != n) {
    for (Process p in sortedProcessList) {
      int pTtf = p.getTtf();
      if (pTtf <= quantum) {
        int i;
        for (i = 0; i < pTtf; i++) {
          executionOrderProcessId.add(p.getId());
        }
        listDone.add(p);
        // sortedProcessList.remove(p);
        time += i;
        removeList.add(p);
      } else {
        for (int i = 0; i < quantum; i++) {
          executionOrderProcessId.add(p.getId());
        }
        for (int j = 0; j < overload; j++) {
          // -1 = overload time
          executionOrderProcessId.add(-1);
        }

        time += (quantum + overload);
        p.updateTtf(quantum.toInt());
      }
    }
    for (Process p in removeList) {
      sortedProcessList.remove(p);
    }
  }

  return executionOrderProcessId;
}
