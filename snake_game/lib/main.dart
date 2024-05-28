import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int xPos = 5;
  int yPos = 1;
  int direction = 0; // 0123 for RBLU
  int velocity = 500;

  // variable that tells if the head of the snake collides to a wall
  bool isWallCollision() {
    if (xPos <= 0 || xPos >= 9 || yPos <= 0 || yPos >= 9) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // moves the snake as long as it doesn't collide to a wall (cannot move anymore when it touches a wall though :) )
    // ignore: unused_local_variable
    Timer continuousMovement = Timer.periodic(Duration(milliseconds: velocity), (arg) {
      setState(() {
        if (!isWallCollision()) {
          direction == 0
              ? yPos++
              : direction == 1
                  ? xPos++
                  : direction == 2
                      ? yPos--
                      : direction == 3
                          ? xPos--
                          : null;
        }
      });
      //continuousMovement.cancel() //to terminate this timer
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);

    generateRow() {
      List<Widget> rowList = [];
      for (int i = 0; i < 10; i++) {
        rowList.add(
          containerRow(context, i, xPos, yPos),
        );
      }
      return rowList;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Algogo",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(children: [...generateRow()]),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // up button
                  children: [
                    GestureDetector(
                      onTap: () {
                        debugPrint("Up Button");
                        setState(() {
                          direction = 3;
                        });
                      },
                      child: Material(
                        elevation: 3,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(20),
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 160, 160, 190),
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                          ),
                          padding: const EdgeInsets.all(20.0),
                          child: Icon(
                            Icons.keyboard_arrow_up,
                            size: size.width * 0.09,
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
            Row(
              // left and right button
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  child: Material(
                    elevation: 3,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 160, 160, 190),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.keyboard_arrow_left,
                        size: size.width * 0.09,
                      ),
                    ),
                  ),
                  onTap: () {
                    debugPrint("Left Button");
                    setState(() {
                      direction = 2;
                    });
                  },
                ),
                GestureDetector(
                  child: Material(
                    elevation: 3,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 160, 160, 190),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.keyboard_arrow_right,
                        size: size.width * 0.09,
                      ),
                    ),
                  ),
                  onTap: () {
                    debugPrint("Right Button");
                    setState(() {
                      direction = 0;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // down button
              children: [
                GestureDetector(
                  onTap: () {
                    debugPrint("Down Button");
                    setState(() {
                      direction = 1;
                    });
                  },
                  child: Material(
                    elevation: 3,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 160, 160, 190),
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                      padding: const EdgeInsets.all(20.0),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: size.width * 0.09,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Material(
                  color: Color.fromARGB(0, 0, 0, 0),
                  elevation: 3,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 205, 205, 238),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                    margin: const EdgeInsets.only(bottom: 5),
                    padding: const EdgeInsets.all(10),
                    child: const Text(
                      "Start",
                      style: TextStyle(color: Colors.lightBlue),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget containerRow(BuildContext context, int indexX, int xPos, int yPos) {
  generateColumn() {
    List<Widget> columnList = [];
    for (int i = 0; i < 10; i++) {
      columnList.add(
        columnCase(context, indexX, i, xPos, yPos),
      );
    }
    return columnList;
  }

  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: generateColumn(),
    ),
  );
}

Widget columnCase(
    BuildContext context, int iX, int iY, int snakeXPos, int snakeYPos) {
  var size = MediaQuery.sizeOf(context);
  return Column(
    children: [
      Container(
        width: size.width * 0.09,
        height: size.width * 0.09,
        decoration: BoxDecoration(
          color: snakeXPos == iX && snakeYPos == iY
              ? Colors.green
              : Colors.grey[200],
          border: Border(
            left: const BorderSide(color: Colors.black),
            right: (iY == 9)
                ? const BorderSide(color: Colors.black)
                : BorderSide.none,
            bottom: (iX == 9)
                ? const BorderSide(color: Colors.black)
                : BorderSide.none,
            top: const BorderSide(color: Colors.black),
          ),
        ),
      ),
    ],
  );
}
