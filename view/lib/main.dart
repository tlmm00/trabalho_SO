import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
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
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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

  Future<void> conn(int methodId) async {
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

    List<int> executionOrder;
    if (methodId == 0) {
      // FIFO
      executionOrder = fifo(processes);
    } else if (methodId == 1) {
      // EDF
      executionOrder = edf(processes, quantum, overload);
    } else if (methodId == 2) {
      // RR
      executionOrder = rr(processes, quantum, overload);
    } else {
      // SJF
      executionOrder = sjf(processes);
    }

    print("executionOrder:" + executionOrder.toString());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color.fromARGB(255, 58, 112, 183)),
          useMaterial3: true,
        ),
        home: Scaffold(
            appBar: AppBar(
              backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              title: const Text("Trabalho SO"),
            ),
            body: SingleChildScrollView(
              child: Flexible(
                flex: 1,
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
                                        setState(() => cardList.add(ProcessCard(
                                            processId: cardList.length)))
                                      },
                                  child: const Text("+")),
                              const Divider(),
                              ElevatedButton(
                                  onPressed: () =>
                                      {setState(() => cardList.removeLast())},
                                  child: const Text("-")),
                              Column(
                                children: [
                                  Row(children: [
                                    Text("Quantum: "),
                                    InputQty.int(
                                      minVal: 1,
                                      initVal: quantum,
                                      onQtyChanged: (value) => {
                                        setState(() {
                                          quantum = value;
                                        })
                                      },
                                    )
                                  ]),
                                  Row(children: [
                                    Text("Overload: "),
                                    InputQty.int(
                                      minVal: 0,
                                      initVal: overload,
                                      onQtyChanged: (value) => {
                                        setState(() {
                                          overload = value;
                                        })
                                      },
                                    )
                                  ]),
                                ],
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
                          Row(
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
                        ],
                      ),
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ToggleButtons(
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
                                ])
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FloatingActionButton(
                              onPressed: () => {
                                    print("START"),
                                    setState(() {
                                      selectedMethodId = _selectedList
                                          .indexWhere((value) => value == true);
                                    }),
                                    conn(selectedMethodId),
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
            )));
  }
}
