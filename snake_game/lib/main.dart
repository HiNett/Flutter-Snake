import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

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
  int velocity = 500000;
  var fruitXPos = Random().nextInt(10);
  var fruitYPos = Random().nextInt(10);
  var score = 0;
  bool startClicked = false;

  // function changing the fruit's position
  bool isFruitTouched() {
    if (xPos == fruitXPos && yPos == fruitYPos) {
      return true;
    }
    return false;
  }

  // 0 c'est droite
  // 1 c'est bas
  // 2 c'est gauche
  // 3 c'est haut
  // variable that tells if the head of the snake collides to a wall
  bool isWallCollision() {
    if ((yPos <= 8 && direction == 0) ||
        (yPos >= 1 && direction == 2) ||
        ((yPos <= 8 || yPos >= 1) && xPos >= 1 && direction == 3) ||
        ((yPos <= 8 || yPos >= 1) && xPos <= 8 && direction == 1)) {
      print('Y POS : $yPos');
      print('X POS : $xPos');
      print('Direction : $direction');
      return false;
    } else {
      return true;
    }
  }

  bool gameStarted(bool startButtonClicked) {
    if (startButtonClicked) {
      direction = 0; 
      return true;
    }
    return false;
  }

  @override
  void initState() {
    // moves the snake as long as it doesn't collide to a wall (cannot move anymore when it touches a wall though :) )
    // ignore: unused_local_variable
    Timer continuousMovement =
        Timer.periodic(Duration(microseconds: velocity), (arg) {
      setState(() {
        if (!isWallCollision() && gameStarted(startClicked)) {
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
    // ignore: unused_local_variable
    Timer checksFruitCollision =
        Timer.periodic(const Duration(microseconds: 1), (arg) {
      setState(() {
        if (isFruitTouched()) {
          fruitXPos = Random().nextInt(10);
          fruitYPos = Random().nextInt(10);
          score += 1;
          velocity -= 20000;
        }
      });
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
          containerRow(context, i, xPos, yPos, fruitXPos, fruitYPos),
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
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Your score: $score',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
              ],
            ),
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
                      onLongPress: () {
                        debugPrint("Up Button Long Press");
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
                  onLongPress: () {
                    debugPrint("Left Button Long Press");
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
                  onLongPress: () {
                    debugPrint("Right Button Long Press");
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
                  onLongPress: () {
                    debugPrint("Down Button Long Press");
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
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        startClicked = true;
                 
                      });
                    },
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget containerRow(BuildContext context, int indexX, int xPos, int yPos,
    var fruitXPos, var fruitYPos) {
  generateColumn() {
    List<Widget> columnList = [];
    for (int i = 0; i < 10; i++) {
      columnList.add(
        columnCase(context, indexX, i, xPos, yPos, fruitXPos, fruitYPos),
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

Widget columnCase(BuildContext context, int iX, int iY, int snakeXPos,
    int snakeYPos, var fruitXPos, var fruitYPos) {
  var size = MediaQuery.sizeOf(context);
  return Column(
    children: [
      Container(
        width: size.width * 0.09,
        height: size.width * 0.09,
        decoration: BoxDecoration(
          color: snakeXPos == iX && snakeYPos == iY
              ? Colors.green
              : fruitXPos == iX && fruitYPos == iY
                  ? Colors.red
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
