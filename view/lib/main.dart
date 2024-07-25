import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:input_quantity/input_quantity.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'card.dart';

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
  int quantum = 0;
  int overload = 0;

  final CarouselController _controller = CarouselController();

  Map data = {};

  Future<void> conn(int methodId) async {
    String url = 'tlmm00.pythonanywhere.com';
    String methodExtension = "";
    if (methodId == 0) {
      // FIFO
      methodExtension = '/FIFO';
    } else if (methodId == 1) {
      // EDF
      methodExtension = '/EDF';
    } else if (methodId == 2) {
      // FF
      methodExtension = '/RR';
    } else {
      // SJF
      methodExtension = '/SJF';
    }

    Map<String, dynamic> processes = {};
    for (int i=0; i < cardList.length; i++) {
      ProcessCard c = cardList[i];
      processes[i.toString()] = 
        json.encode({
          "initTime": c.getInitTime(),
          "timeToFinish": c.getTtf(),
          "deadline": c.getDeadline()
        });
      }

    var queryParameters = {
      "overload": overload.toString(),
      "quantum": quantum.toString(),
      // "processes": processes
    };

    print(processes);
    final uri = Uri.http(url, methodExtension, processes);
    final response = await http.get(uri, headers: queryParameters);

    if (response.statusCode == 200) {
      print("200");
      setState(() {
        data = json.decode(response.body);
      });
    } else {
      print('Err code: ' + response.statusCode.toString());
    }
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
            body: Expanded(
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
                                  InputQty(
                                    minVal: 0,
                                    initVal: 0,
                                    onQtyChanged: (value) => {
                                      setState(() {
                                        quantum = value;
                                      })
                                    },
                                  )
                                ]),
                                Row(children: [
                                  Text("Overload: "),
                                  InputQty(
                                    minVal: 0,
                                    initVal: 0,
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
                            onPressed: () => {print("RESET")},
                            backgroundColor: Colors.red,
                            child: Text("RESET"))
                      ],
                    ),
                  ]),
            )));
  }
}
