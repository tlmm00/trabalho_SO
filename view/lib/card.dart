
import 'package:input_quantity/input_quantity.dart';
import 'package:flutter/material.dart';

class ProcessCard extends StatefulWidget {
  ProcessCard({
    super.key,
    required this.processId,
  });

  final int processId;
  num _initTime = 0;
  num _ttf = 0;
  num _deadline = 0;

  num getInitTime() {
    return _initTime;
  }

  num getTtf() {
    return _ttf;
  }

  num getDeadline() {
    return _deadline;
  }

  void setInitTime(num newInitTime) {
    _initTime = newInitTime;
  }

  void setTtf(num newTtf) {
    _ttf = newTtf;
  }

  void setDeadline(num newDeadline) {
    _deadline = newDeadline;
  }

  @override
  State<ProcessCard> createState() => _ProcessCard();
}

class _ProcessCard extends State<ProcessCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 350,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              color: Colors.blue,
              child: Column(
                children: [
                  Text("#" + widget.processId.toString()),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("init time: "),
                      InputQty(
                        minVal: 0,
                        initVal: widget.getInitTime(),
                        onQtyChanged: (value) => {setState(() => widget.setInitTime(value))},
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("deadline: "),
                      InputQty(
                        minVal: 0,
                        initVal: widget.getDeadline(),
                        onQtyChanged: (value) => {setState(() => widget.setDeadline(value))},
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("time to finish: "),
                      InputQty(
                        minVal: 0,
                        initVal: widget.getTtf(),
                        onQtyChanged: (value) => {setState(() => widget.setTtf(value))},
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}