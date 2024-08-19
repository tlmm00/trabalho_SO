import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> edf(List<Process> processList, num quantum, num overload) {
  Aux aux = Aux();
  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  List<Process> executionOrder = [];

  int time = 0;
  for (Process p in sortedProcessList) {
    List<Process> l = sortedProcessList
        .where((p) => (p.getTimeInit() <= time && !executionOrder.contains(p)))
        .toList();

    if (!l.isEmpty) {
      Tuple2<Process, int> earliestDeadlineJob = aux.getMinDeadline(l);
      executionOrder.add(earliestDeadlineJob.item1);

      time += earliestDeadlineJob.item1.getTtf();
    } else {
      executionOrder.add(p);
      time += p.getTtf();
    }
  }

  List<int> executionSequence = [];
  for (Process p in executionOrder) {
    int pTtf = p.getTtf();
    if (pTtf <= quantum) {
      for (int e = 0; e < pTtf; e++) {
        executionSequence.add(p.getId());
      }
    } else {
      int fullCicles = pTtf ~/ quantum;
      for (int e = 0; e < fullCicles; e++) {
        for (int i = 0; i < quantum; i++) {
          executionSequence.add(p.getId());
        }
        for (int j = 0; j < overload; j++) {
          executionSequence.add(-1);
        }
      }

      for (int e = 0; e < pTtf.remainder(quantum); e++) {
        executionSequence.add(p.getId());
      }
    }
  }

  return executionSequence;
}
