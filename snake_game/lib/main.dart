import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.sizeOf(context);
    generateRow() {
      List<Widget> rowList = [];
      for (int i = 0; i < 10; i++) {
        rowList.add(containerRow(context, i));
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
                        debugPrint("Up button tapped");
                      },
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: size.width * 0.09,
                      ),
                    ),
                  ],
                )
              ],
            ),
            Row(
              // left and right button
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    size: size.width * 0.09,
                  ),
                  onTap: () {
                    debugPrint("Left Button");
                  },
                ),
                GestureDetector(
                  child: Icon(
                    Icons.keyboard_arrow_right,
                    size: size.width * 0.09,
                  ),
                  onTap: () {
                    debugPrint("Right Button");
                  },
                ),
              ],
            ),
            Row(
              // down button
              children: [
                GestureDetector(
                  child:
                      Icon(Icons.keyboard_arrow_down, size: size.width * 0.09),
                  onTap: () {
                    debugPrint("Down Button");
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget containerRow(BuildContext context, int index_X) {
  generateColumn() {
    List<Widget> columnList = [];
    for (int i = 0; i < 10; i++) {
      columnList.add(columnCase(context, index_X, i));
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

Widget columnCase(BuildContext context, int iX, int iY) {
  var size = MediaQuery.sizeOf(context);
  return Column(
    children: [
      Container(
        width: size.width * 0.09,
        height: size.width * 0.09,
        decoration: BoxDecoration(
          color: Colors.red,
          border: Border(
              left: const BorderSide(color: Colors.black),
              right: (iY == 9)
                  ? const BorderSide(color: Colors.black)
                  : BorderSide.none,
              bottom: (iX == 9)
                  ? const BorderSide(color: Colors.black)
                  : BorderSide.none,
              top: const BorderSide(color: Colors.black)),
        ),
      ),
    ],
  );
}
