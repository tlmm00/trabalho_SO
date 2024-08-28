import 'package:view/src/model/process.dart';
import 'package:view/src/app/aux.dart' show Aux;

Map<int, List<int>> rr(List<Process> processList, num quantum, num overload) {
  Aux aux = Aux();

  List<Process> sortedProcessList = aux.quickSortProcessByInitTime(processList);
  int n = sortedProcessList.length;
  List<int> executionOrderProcessId = [];
  List<Process> listDone = [];

  num time = 0;

  while (listDone.length != n) {
    List<Process> l =
        sortedProcessList.where((p) => p.getTimeInit() <= time).toList();

    if (l.isEmpty) {
      time++;
      executionOrderProcessId.add(-3);
    } else {
      Process p = l.first;
      sortedProcessList.remove(p);

      int pTtf = p.getTtf();
      if (pTtf <= quantum) {
        int i;
        for (i = 0; i < pTtf; i++) {
          executionOrderProcessId.add(p.getId());
        }
        listDone.add(p);
        // sortedProcessList.remove(p);
        time += i;
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
        sortedProcessList.add(p);
      }
    }
  }

  return aux.listToMatrix(executionOrderProcessId);
}
