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
      int pDeadline = p.getDeadline();
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
      if (minTtf == -1 || pTtf < minTtf) {
        minTtf = pTtf;
        minTtfProcess = p;
      }
    }

    return Tuple2(minTtfProcess, minTtf);
  }
}
