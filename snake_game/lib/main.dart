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
  List<int> startXPos = [5];
  List<int> startYPos = [1];
  List<int> xPos = [5];
  List<int> yPos = [1];
  int direction = 0; // 0123 for RBLU
  int velocity = 500000;
  final int startVelocity = 500000;
  var fruitXPos = Random().nextInt(10);
  var fruitYPos = Random().nextInt(10);
  var rareFruitXPos = Random().nextInt(10);
  var rareFruitYPos = Random().nextInt(10);
  var score = 0;
  var highScore = 0;
  bool startClicked = false;

  // function changing the fruit's position
  bool isFruitTouched() {
    if (xPos[0] == fruitXPos && yPos[0] == fruitYPos) {
      return true;
    }
    return false;
  }

  bool isRareFruitTouched() {
    if (xPos[0] == rareFruitXPos && yPos[0] == rareFruitYPos) {
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
    if ((yPos[0] <= 9 && direction == 0) ||
        (yPos[0] >= 0 && direction == 2) ||
        ((yPos[0] <= 9 || yPos[0] >= 0) && xPos[0] >= 0 && direction == 3) ||
        ((yPos[0] <= 9 || yPos[0] >= 0) && xPos[0] <= 9 && direction == 1)) {
      return false;
    } else {
      return true;
    }
  }

  bool gameStarted(bool startButtonClicked) {
    if (startButtonClicked) {
      return true;
    }
    return false;
  }

  void scoreReset() {
    score = 0;
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
              ? yPos[0]++
              : direction == 1
                  ? xPos[0]++
                  : direction == 2
                      ? yPos[0]--
                      : direction == 3
                          ? xPos[0]--
                          : null;
          if (isFruitTouched()) {
            velocity -= 20000;
          }
          if (isWallCollision()) {
            velocity = startVelocity;
          }
        }
      });
      //continuousMovement.cancel() //to terminate this timer
    });

    // ignore: unused_local_variable
    Timer checksFruitCollision =
        Timer.periodic(const Duration(microseconds: 5), (arg) {
      setState(() {
        if (isFruitTouched()) {
          fruitXPos = Random().nextInt(10);
          fruitYPos = Random().nextInt(10);
          score += 1;
        }
        if (isRareFruitTouched()) {
          rareFruitXPos = -1;
          rareFruitYPos = -1;
          score += 5;
        }
      });
    });

    // ignore: unused_local_variable
    Timer checksWallCollision =
        Timer.periodic(const Duration(microseconds: 1), (arg) {
      setState(() {
        if (isWallCollision()) {
          // xPos.clear();
          // yPos.clear();
          if (highScore < score) {
            highScore = score;
          }
          scoreReset();
          xPos[0] = startXPos[0];
          yPos[0] = startYPos[0];
          direction = 0;
          startClicked = false;
          fruitXPos = Random().nextInt(10);
          fruitYPos = Random().nextInt(10);
          rareFruitXPos = Random().nextInt(10);
          rareFruitYPos = Random().nextInt(10);
        }
      });
      //continuousMovement.cancel() //to terminate this timer
    });

    // ignore: unused_local_variable
    Timer spawnRareFruit = Timer.periodic(const Duration(seconds: 30), (arg) {
      setState(() {
        var previousRareFruitXPos = rareFruitXPos;
        var previousRareFruitYPos = rareFruitYPos;
        if (startClicked) {
          rareFruitXPos = Random().nextInt(10);
          rareFruitYPos = Random().nextInt(10);
          if (!((0 <= previousRareFruitXPos && previousRareFruitXPos >= 9) ||
              (0 <= previousRareFruitYPos && previousRareFruitYPos >= 9))) {
            rareFruitXPos = previousRareFruitXPos;
            rareFruitYPos = previousRareFruitYPos;
          }
          if (rareFruitXPos != fruitXPos || rareFruitYPos != fruitYPos) {
            rareFruitXPos = Random().nextInt(10);
            rareFruitYPos = Random().nextInt(10);
          }
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
          containerRow(context, i, xPos, yPos, fruitXPos, fruitYPos,
              rareFruitXPos, rareFruitYPos),
        );
      }
      return rowList;
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "AlgogoLizard",
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Text(
                    'Score: $score',
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: Text(
                    'High score: $highScore',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ),
                Material(
                  color: Color.fromARGB(0, 0, 0, 0),
                  elevation: 3,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        startClicked == true
                            ? startClicked = false
                            : startClicked = true;
                      });
                    },
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 205, 205, 238),
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                      margin: const EdgeInsets.only(right: 10),
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        startClicked ? "Pause" : "Start",
                        style: TextStyle(color: Colors.lightBlue),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
                          if (startClicked) {
                            direction = 3;
                          }
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
                      if (startClicked) {
                        direction = 2;
                      }
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
                      if (startClicked) {
                        direction = 0;
                      }
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
                      if (startClicked) {
                        direction = 1;
                      }
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
          ],
        ),
      ),
    );
  }
}

Widget containerRow(
    BuildContext context,
    int indexX,
    List<int> xPos,
    List<int> yPos,
    var fruitXPos,
    var fruitYPos,
    var rareFruitXPos,
    var rareFruitYPos) {
  generateColumn() {
    List<Widget> columnList = [];
    for (int i = 0; i < 10; i++) {
      columnList.add(
        columnCase(context, indexX, i, xPos, yPos, fruitXPos, fruitYPos,
            rareFruitXPos, rareFruitYPos),
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
    BuildContext context,
    int iX,
    int iY,
    List<int> snakeXPos,
    List<int> snakeYPos,
    var fruitXPos,
    var fruitYPos,
    var rareFruitXPos,
    var rareFruitYPos) {
  var size = MediaQuery.sizeOf(context);
  return Column(
    children: [
      Container(
        width: size.width * 0.09,
        height: size.width * 0.09,
        decoration: BoxDecoration(
          color: snakeXPos[0] == iX && snakeYPos[0] == iY
              ? Colors.green
              : fruitXPos == iX && fruitYPos == iY
                  ? Colors.red
                  : rareFruitXPos == iX && rareFruitYPos == iY
                      ? Colors.orangeAccent
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
