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
    String route = '';
    if (methodId == 0) {
      // FIFO
      route += '/FIFO';
    } else if (methodId == 1) {
      // EDF
      route += '/EDF';
    } else if (methodId == 2) {
      // FF
      route += '/RR';
    } else {
      // SJF
      route += '/SJF';
    }

    Map processes = {};
    for (int i = 0; i < cardList.length; i++) {
      ProcessCard c = cardList[i];
      processes[i] = {
        "initTime": c.getInitTime(),
        "timeToFinish": c.getTtf(),
        "deadline": c.getDeadline()
      };
    }

    Map params() => {"overload": overload, "quantum": quantum};

    final body = {
      "params": json.encode(params()),
      "processes": json.encode(processes.toString()),
    };

    print(body);
    final uri = Uri.https(url, route, body);
    print(uri);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      print("status 200: OK");
      setState(() {
        data = json.decode(response.body);
      });
      print(data);
    } else {
      print('Err code: ' + response.statusCode.toString());
      print(response.body);
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
            body: Flexible(
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
                                  const Text("Quantum: "),
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
                                  const Text("Overload: "),
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
                            child: const Text("START")),
                        FloatingActionButton(
                            onPressed: () => {
                                  print("RESET"),
                                  setState(() {
                                    cardList = [];
                                    quantum = 0;
                                    overload = 0;
                                  }),
                                },
                            backgroundColor: Colors.red,
                            child: const Text("RESET"))
                      ],
                    ),
                  ]),
            )));
  }
}
