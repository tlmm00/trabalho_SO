import 'package:flutter/material.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> fifo(List<Process> processList) {
  Aux aux = Aux();
  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  return sortedProcessList.map((p) => p.getId()).toList();
}
