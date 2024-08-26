import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tuple/tuple.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> sjf(List<Process> processList) {
  Aux aux = Aux();

  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  List<int> executionOrder = [];
  List<int> executionList = [];

  List<int> sortedProcessTtfList = [];
  for (Process p in sortedProcessList) {
    sortedProcessTtfList.add(p.getTtf());
  }

  int n = sortedProcessList.length;
  int time = sortedProcessTtfList.reduce(min);
  while (executionOrder.length != n) {
    List<Process> l = sortedProcessList
        .where((p) =>
            p.getTimeInit() <= time && !executionOrder.contains(p.getId()))
        .toList();
    if (l.isEmpty) {
      time++;
    } else {
      print(l);
      Tuple2<Process, int> shortestJob = aux.getMinTtf(l);
      print(shortestJob.item1.getId());

      executionOrder.add(shortestJob.item1.getId());
      sortedProcessList
          .removeWhere((p) => p.getId() == shortestJob.item1.getId());

      for (int i = 0; i < shortestJob.item2; i++) {
        executionList.add(shortestJob.item1.getId());
      }
      time += shortestJob.item2;
    }
  }
  return executionList;
}
