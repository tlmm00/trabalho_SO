import 'package:flutter/material.dart';
import 'dart:math';
import 'package:tuple/tuple.dart';

import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

List<int> sjf(List<Process> processList) {
  Aux aux = Aux();

  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  List<int> executionOrder = [];

  List<int> sortedProcessTtfList = [];
  for (Process p in sortedProcessList) {
    sortedProcessTtfList.add(p.getTtf());
  }

  int time = sortedProcessTtfList.reduce(min);
  for (Process p in sortedProcessList) {
    List<Process> l = sortedProcessList
        .where((p) =>
            p.getTimeInit() <= time && !executionOrder.contains(p.getId()))
        .toList();

    // print(l.last.getId());

    Tuple2<Process, int> shortestJob = aux.getMinTtf(l);

    executionOrder.add(shortestJob.item1.getId());

    time += shortestJob.item2;
  }
  return executionOrder;
}
