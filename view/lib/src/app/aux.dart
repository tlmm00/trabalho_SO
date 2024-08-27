import '../model/process.dart';
import 'package:tuple/tuple.dart';

class Aux {
  List<Process> quickSortProcessByInitTime(List<Process> processList) {
    if (processList.length <= 1) {
      return processList;
    } else {
      int middleIndex = processList.length ~/ 2; // Integer division in Dart
      int pivotTime = processList[middleIndex].getTimeInit();

      List<Process> left =
          processList.where((p) => p.getTimeInit() < pivotTime).toList();
      List<Process> middle =
          processList.where((p) => p.getTimeInit() == pivotTime).toList();
      List<Process> right =
          processList.where((p) => p.getTimeInit() > pivotTime).toList();

      return quickSortProcessByInitTime(left) +
          middle +
          quickSortProcessByInitTime(right);
    }
  }

  Tuple2<Process, int> getMinDeadline(List<Process> processList) {
    int minDeadline = -1;
    Process minDeadlineProcess = Process(-2, -2, -2, -2);

    for (var p in processList) {
      int pDeadline = p.getTimeInit() + p.getDeadline();
      if (minDeadline == -1 || pDeadline < minDeadline) {
        minDeadline = pDeadline;
        minDeadlineProcess = p;
      }
    }

    return Tuple2(minDeadlineProcess, minDeadline);
  }

  Tuple2<Process, int> getMinTtf(List<Process> processList) {
    int minTtf = -1;
    Process minTtfProcess = Process(-2, -2, -2, -2);

    for (Process p in processList) {
      int pTtf = p.getTtf();
      print("AUX: " + pTtf.toString());
      if (minTtf == -1 || pTtf < minTtf) {
        minTtf = pTtf;
        minTtfProcess = p;
      }
    }

    return Tuple2(minTtfProcess, minTtf);
  }

  Map<int, List<int>> listToMatrix(List<int> processIdList) {
    Map<int, List<int>> finalMap = {};
    finalMap[-1] = [];
    for (int n in processIdList.toSet()) {
      if (!([-1, -3].contains(n))) finalMap[n] = [];
    }

    for (int id in processIdList) {
      if (!([-1, -3].contains(id))) {
        finalMap[-1]?.add(0);
        for (int i = 0; i < processIdList.length; i++) {
          if (i == id) {
            finalMap[i]?.add(1);
          } else {
            finalMap[i]?.add(0);
          }
        }
      } else {
        if (id == -1) {
          finalMap[-1]?.add(1);
        } else if (id == -3) {
          finalMap[-1]?.add(0);
        }
        for (int i = 0; i < processIdList.length; i++) {
          finalMap[i]?.add(0);
        }
      }
    }
    return finalMap;
  }
}
