import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:tuple/tuple.dart';
import 'package:view/src/app/aux.dart';
import 'package:view/src/model/process.dart';
import 'card.dart';
import 'src/app/fifo.dart';
import 'src/app/sjf.dart';
import 'src/app/edf.dart';
import 'src/app/rr.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MyAppHome());
  }
}

class MyAppHome extends StatefulWidget {
  const MyAppHome({Key? key}) : super(key: key);

  @override
  _MyAppHomeState createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  // 0 => FIFO
  // 1 => EDF
  // 2 => RR
  // 3 => SJF
  final List<bool> _selectedList = <bool>[true, false, false, false];
  int selectedMethodId = 1;

  List<ProcessCard> cardList = [];
  num quantum = 1;
  num overload = 0;

  final CarouselController _controller = CarouselController();

  Map data = {};
  Aux aux = Aux();

  Tuple3<List<Process>, Map<int, List<int>>, double> conn(int methodId) {
    List<Process> processes = [];
    try {
      for (int i = 0; i < cardList.length; i++) {
        ProcessCard c = cardList[i];
        processes.add(Process(i, c.getInitTime().toInt(), c.getTtf().toInt(),
            c.getDeadline().toInt()));
      }
    } catch (error) {
      print("error: " + error.toString());
    }

    Map<int, List<int>> listMatrix;
    if (methodId == 0) {
      // FIFO
      listMatrix = fifo(processes);
    } else if (methodId == 1) {
      // EDF
      listMatrix = edf(processes, quantum, overload);
    } else if (methodId == 2) {
      // RR
      listMatrix = rr(processes, quantum, overload);
    } else {
      // SJF
      listMatrix = sjf(processes);
    }

    print(listMatrix);
    double avgExecTime = 0;
    for (int id = 0; id < processes.length; id++) {
      int startTime = processes[id].getTimeInit();
      int endTime = listMatrix[id]!.lastIndexWhere((i) => i == 1) + 1;

      // print("$id: $startTime, $endTime");

      avgExecTime += (endTime - startTime).toDouble();
    }
    // print("n: ${processes.length}");
    avgExecTime /= processes.length;
    return Tuple3(processes, listMatrix, avgExecTime);
  }

  double _currentSliderValue = 0.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: const Text(
            "Process Scheduler",
            style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Flexible(
              flex: 1,
              child: Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                  onPressed: () => {
                                        setState(() => cardList.add(
                                              ProcessCard(
                                                  processId: cardList.length,
                                                  cardColor: (cardList.isEmpty)
                                                      ? Colors.blue
                                                      : (cardList.last
                                                                  .cardColor ==
                                                              Colors.blue)
                                                          ? Colors.red
                                                          : (cardList.last
                                                                      .cardColor ==
                                                                  Colors.red)
                                                              ? Colors.white70
                                                              : Colors.blue),
                                            ))
                                      },
                                  child: const Text("+")),
                              const Divider(),
                              ElevatedButton(
                                  onPressed: () =>
                                      {setState(() => cardList.removeLast())},
                                  child: const Text("-")),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                child: Column(
                                  children: [
                                    Row(children: [
                                      const Text("Quantum: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                        color: Colors.white60,
                                        child: InputQty.int(
                                          minVal: 1,
                                          initVal: quantum,
                                          onQtyChanged: (value) => {
                                            setState(() {
                                              quantum = value;
                                            })
                                          },
                                        ),
                                      )
                                    ]),
                                    Row(children: [
                                      const Text("Overload: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold)),
                                      Container(
                                        color: Colors.white60,
                                        child: InputQty.int(
                                          minVal: 0,
                                          initVal: overload,
                                          onQtyChanged: (value) => {
                                            setState(() {
                                              overload = value;
                                            })
                                          },
                                        ),
                                      )
                                    ]),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 500,
                            child: CarouselSlider(
                              options: CarouselOptions(),
                              carouselController: _controller,
                              items: cardList,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _controller.previousPage();
                                    },
                                    child: const Text('<'),
                                  ),
                                ),
                                Flexible(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      _controller.nextPage();
                                    },
                                    child: const Text('>'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                color: Colors.white,
                                child: ToggleButtons(
                                    isSelected: _selectedList,
                                    onPressed: (int index) {
                                      setState(() {
                                        for (int i = 0;
                                            i < _selectedList.length;
                                            i++) {
                                          _selectedList[i] = i == index;
                                        }
                                      });
                                    },
                                    children: const [
                                      Text("FIFO"),
                                      Text("EDF"),
                                      Text("RR"),
                                      Text("SJF")
                                    ]),
                              )
                            ]),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Speed: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          Slider(
                            min: 0.1,
                            max: 5,
                            value: _currentSliderValue,
                            onChanged: (double value) {
                              setState(() {
                                _currentSliderValue = value;
                              });
                            },
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                              onPressed: () {
                                showGridViewDialog(context);
                              },
                              backgroundColor: Colors.green,
                              child: Text("START")),
                          FloatingActionButton(
                              onPressed: () => {
                                    print("RESET"),
                                    setState(() {
                                      overload = 0;
                                      quantum = 0;
                                      cardList.clear();
                                    })
                                  },
                              backgroundColor: Colors.red,
                              child: Text("RESET"))
                        ],
                      ),
                    ]),
              ),
            ),
          ),
        ));
  }

  void showGridViewDialog(BuildContext context) {
    print("START");
    setState(() {
      selectedMethodId = _selectedList.indexWhere((value) => value == true);
    });
    Tuple3 res = conn(selectedMethodId);
    Map<int, List<int>> executionMatrix = res.item2;
    List<Process> pList = res.item1;
    double avgExecTime = res.item3;
    print("avgExecTime: $avgExecTime");

    int? executionLineId;
    int flagFinished = 0;

    int lineSize = executionMatrix[0]!.length + 1;
    int n = executionMatrix.length * lineSize;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: (_selectedList[0])
                  ? const Text("FIFO")
                  : (_selectedList[1])
                      ? const Text("EDF")
                      : (_selectedList[2])
                          ? const Text("Roud Robin")
                          : const Text("SJF"),
              content: SingleChildScrollView(
                child: SizedBox(
                  width: double.maxFinite,
                  child: Column(
                    children: [
                      GridView.builder(
                          itemCount: n,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: lineSize,
                          ),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            Text txt = const Text("");
                            Color boxColor = Colors.transparent;
                            int lineId = index ~/ lineSize;
                            int colId = index % lineSize - 1;
                            // int timeLineId = executionMatrix.length;

                            if (colId == -1) {
                              // célula de index de linha
                              if (index == 0) {
                                txt = const Text("0");
                              } else {
                                if (lineId != executionMatrix.length - 1)
                                  txt = Text(lineId.toString());
                              }
                            } else if (lineId == executionMatrix.length - 1) {
                              // célula de index de coluna
                              txt = Text(colId.toString());
                            } else {
                              // célula normal

                              Process p = pList[lineId];
                              int startTime = p.getTimeInit();

                              if (startTime >= colId) {
                                flagFinished = 0;
                              }

                              if (!executionMatrix[lineId]!
                                  .sublist(colId + 1)
                                  .contains(1)) {
                                flagFinished = 1;
                              }
                              if (executionMatrix[lineId]?[colId] == 1) {
                                boxColor = Colors.yellow;
                                executionLineId = lineId;
                                flagFinished = 0;

                                if ((p.getTimeInit() + p.getDeadline()) <=
                                    colId) {
                                  boxColor = Colors.purple;
                                }
                                if (colId > p.getTimeInit() &&
                                    startTime == p.getTimeInit()) {
                                  startTime = colId;
                                }
                              } else {
                                if (executionMatrix[-1]?[colId] == 1 &&
                                    executionLineId == lineId) {
                                  boxColor = Colors.red;
                                } else {
                                  executionLineId = null;
                                  boxColor = Colors.grey;

                                  if (startTime <= colId && flagFinished != 1) {
                                    boxColor = Colors.orange;
                                  }
                                }
                              }
                            }

                            return Padding(
                                    padding: const EdgeInsets.all(2),
                                    child: Container(
                                        height: 50,
                                        width: 50,
                                        color: boxColor,
                                        child: Center(child: txt)))
                                .animate()
                                .fadeIn(
                                    delay: Duration(
                                        microseconds: (500000 *
                                                (colId + 1) *
                                                _currentSliderValue)
                                            .toInt()));
                          }),
                      Text(
                          "Average Execution time: ${avgExecTime.toStringAsFixed(2)}")
                    ],
                  ),
                ),
              ), //Text(executionMatrix.toString()),
              actions: [
                TextButton(
                    child: const Text("Exit"),
                    onPressed: () => Navigator.pop(context))
              ]);
        });
    // Map executionMatrix = conn(selectedMethodId),
  }
}
