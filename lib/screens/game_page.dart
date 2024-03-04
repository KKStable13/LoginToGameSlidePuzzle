import 'dart:async';
import 'package:flutter/material.dart';
import 'package:slide_puzzle/models/model.dart';

class GamePage extends StatefulWidget {
  final String username; // เพิ่ม field สำหรับเก็บข้อมูล username
  const GamePage({Key? key, required this.username}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  var board = SlideBoard()..shuffle();
  int moves = 0;
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_stopwatch.isRunning) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _stopwatch.stop();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 96, 194, 240),
        title: Text('Slide Puzzle'), 
        centerTitle: true),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                  onPressed: () {
                    setState(() {
                      _stopwatch.reset();
                      _stopwatch.start();
                      moves = 0;
                      board = SlideBoard()..shuffle();
                    });
                  },
                  child: Text('สุ่มใหม่'))
            ],
          ),
          Spacer(),
          Text(
            'เวลา: ${_stopwatch.elapsed.inSeconds} วินาที',
            style: TextStyle(fontSize: 20),
          ),
          Text(
            'จำนวนการเคลื่อนไหว: $moves',
            style: TextStyle(fontSize: 20),
          ),
          Spacer(),
          Container(
            width: MediaQuery.of(context).size.width * 0.8, // กำหนดความกว้างของ container
            height: MediaQuery.of(context).size.width * 0.8, // กำหนดความสูงของ container
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black), // เส้นขอบสีดำ
            ),
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                color: const Color.fromARGB(255, 255, 255, 255),
                child: Stack(
                  children: board.tiles
                      .map((t) => Tile(
                            t.row,
                            t.col,
                            t.number,
                            onTap: () {
                              if (board.isSolved()) return;
                              setState(() {
                                board.slide(t.row, t.col);
                                moves++;
                              });
                              if (board.isSolved()) {
                                _stopwatch.stop();
                                _showMyDialog();
                              }
                            },
                          ))
                      .toList(),
                ),
              ),
            ),
          ),
          Spacer(),
        ],
      ),
    );
  }
  
  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('คุณชนะ!!!'),
          content: Text('Username: ${widget.username}\nจำนวนการเคลื่อนไหว: $moves\nเวลา: ${_stopwatch.elapsed.inSeconds} วินาที'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class Tile extends StatelessWidget {
  final int row, col, number;
  final void Function()? onTap;
  const Tile(this.row, this.col, this.number, {this.onTap, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (number == 0) return Container();
    return GestureDetector(
      onTap: onTap,
      onPanUpdate: (details) {
        if (details.delta.dx > 10 || details.delta.dx < -10) {
          onTap?.call();
        } else if (details.delta.dy > 10 || details.delta.dy < -10) {
          onTap?.call();
        }
      },
      child: AnimatedAlign(
        alignment: FractionalOffset(col * 1 / 3, row * 1 / 3),
        duration: Duration(milliseconds: 200),
        child: FractionallySizedBox(
          heightFactor: 1 / 4,
          widthFactor: 1 / 4,
          child: Card(
            color: Color.fromARGB(255, 255, 177, 50),
            child: Center(
                child: Text(
              number.toString(),
              style: TextStyle(fontSize: 24),
            )),
          ),
        ),
      ),
    );
  }
}
