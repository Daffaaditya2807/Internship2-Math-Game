import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MathGame extends StatefulWidget {
  const MathGame({super.key});

  @override
  State<MathGame> createState() => _MathGameState();
}

class _MathGameState extends State<MathGame> {
  String droppedValue = "0"; // To store the dropped value
  int firstNumber = 0;
  int secondNumber = 0;
  Color colorAnswer = Colors.grey.shade100;
  bool showIcon = false;
  int starCount = 2;
  bool isTrue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    final random = Random();
    setState(() {
      firstNumber = random.nextInt(10);
      secondNumber = random.nextInt(10 - firstNumber); // ensure sum <= 9
      droppedValue = "0";
      colorAnswer = Colors.grey.shade100;
      showIcon = false;
      starCount = 2;
      isTrue = false;
    });
  }

  void showGameOverDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Game Over"),
          content: Text("You've used all your chances. Try again!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                generateRandomNumbers(); // Reset the game after dialog is dismissed
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void validateAnswer() {
    int answer = int.parse(droppedValue);
    if (answer == firstNumber + secondNumber) {
      setState(() {
        colorAnswer = Colors.green;
        showIcon = false;
        isTrue = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Correct! Next Your Question"),
        backgroundColor: Colors.green,
      ));
    } else {
      setState(() {
        colorAnswer = Colors.red;
        showIcon = false;
        if (starCount > 0) {
          starCount--; // Decrease the star count by 1
        }
        if (starCount == 0) {
          showGameOverDialog(); // Show game over dialog when stars are zero
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
          child: Column(
        children: [
          barGame(
              refresh: () {
                setState(() {
                  droppedValue = "0";
                  generateRandomNumbers();
                });
              },
              next: generateRandomNumbers),
          Expanded(child: Container()),
          quizBox(),
          Expanded(child: Container()),
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        5, (index) => numberInput(input: "$index")),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                        5, (index) => numberInput(input: "${index + 5}")),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (showIcon)
                        const Padding(
                          padding: EdgeInsets.only(left: 20),
                          child: Icon(
                            CupertinoIcons.hand_point_right_fill,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                            onPressed:
                                isTrue ? generateRandomNumbers : validateAnswer,
                            style: ButtonStyle(
                              padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(
                                      10)), // Menambah padding di dalam tombol
                              minimumSize: WidgetStateProperty.all(const Size(
                                  150, 50)), // Mengatur ukuran minimum tombol
                            ),
                            child: Icon(
                              isTrue ? Icons.arrow_forward_ios : Icons.done,
                              color: colorAnswer == Colors.grey.shade100
                                  ? Colors.black
                                  : colorAnswer,
                            )),
                      ),
                      const Spacer(),
                    ],
                  ),
                  // validasi jawaban
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 90),
                  //   child: ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           minimumSize: const Size.fromHeight(50)),
                  //       onPressed: validateAnswer,
                  //       child: Icon(
                  //         Icons.done,
                  //         color: colorAnswer == Colors.grey.shade100
                  //             ? Colors.black
                  //             : colorAnswer,
                  //       )),
                  // )
                ],
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget numberInput({String? input}) {
    return Draggable<String>(
      data: input!,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              color: Colors.grey.shade700.withOpacity(0.5),
              shape: BoxShape.circle),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(input,
                  style: const TextStyle(fontSize: 30, color: Colors.white)),
            ),
          ),
        ),
      ),
      childWhenDragging: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade800.withOpacity(0.5),
            shape: BoxShape.circle),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(input,
                style: TextStyle(
                    fontSize: 30, color: Colors.white.withOpacity(0.5))),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
            color: Colors.grey.shade700.withOpacity(0.5),
            shape: BoxShape.circle),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(input,
                style: const TextStyle(fontSize: 30, color: Colors.white)),
          ),
        ),
      ),
    );
  }

  Widget quizBox() {
    return SizedBox(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 120),
        child: Column(
          children: [
            // input nilai awal dari random
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text(firstNumber.toString(),
                  style: const TextStyle(fontSize: 70, color: Colors.white)),
            ),
            // input nilai akhir dari random
            Align(
              alignment: AlignmentDirectional.centerEnd,
              child: Text("+ ${secondNumber.toString()}",
                  style: const TextStyle(fontSize: 70, color: Colors.white)),
            ),
            const Divider(),
            const SizedBox(height: 5),
            // hasil inputan
            DragTarget<String>(
              onAccept: (value) {
                setState(() {
                  droppedValue = value;
                  showIcon = true;
                });
              },
              builder: (_, candidateData, rejectedData) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: colorAnswer),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      droppedValue,
                      style: TextStyle(
                          fontSize: 70,
                          color: colorAnswer == Colors.grey.shade100
                              ? Colors.white
                              : colorAnswer),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container barGame(
      {VoidCallback? up, VoidCallback? refresh, VoidCallback? next}) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(30, 30, 30, 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: up,
                  icon: const Icon(
                    Icons.keyboard_arrow_up_sharp,
                    size: 30,
                    color: Colors.white,
                  )),
              // fungsi generate random
              IconButton(
                  onPressed: refresh,
                  icon: const Icon(
                    CupertinoIcons.refresh_thin,
                    size: 20,
                    color: Colors.white,
                  )),
            ],
          ),
          Row(
            children: List.generate(
              2,
              (index) => Icon(
                index < starCount
                    ? Icons.star
                    : Icons
                        .star_border_outlined, // Show filled or unfilled star
                size: 30,
                color: index < starCount ? Colors.green : Colors.white,
              ),
            ),
          ),
          IconButton(
              onPressed: next,
              icon: Icon(
                Icons.arrow_forward_ios_outlined,
                size: 20,
                color: isTrue ? Colors.green : Colors.white,
              )),
        ],
      ),
    );
  }
}
