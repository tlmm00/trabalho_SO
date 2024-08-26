import 'package:flutter/material.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> fifo(List<Process> processList) {
  Aux aux = Aux();
  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);

  List<int> executionList = [];

  for (Process p in sortedProcessList) {
    for (int i = 0; i < p.getTtf(); i++) {
      executionList.add(p.getId());
    }
  }

  return executionList;
}
