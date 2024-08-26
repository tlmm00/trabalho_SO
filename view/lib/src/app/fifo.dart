import 'package:flutter/material.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> fifo(List<Process> processList) {
  Aux aux = Aux();
  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);

  List<int> executionList = [];

  int time = 0;
  for (Process p in sortedProcessList) {
    if (p.getTimeInit() >= time) {
      for (int i = 0; i < p.getTtf(); i++) {
        executionList.add(p.getId());
      }
    } else {
      time += 1;
      executionList.add(0);
    }
  }

  return executionList;
}
