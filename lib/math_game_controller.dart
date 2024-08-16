import 'package:get/get.dart';
import 'dart:math';
import 'package:flutter/material.dart';

class MathGameController extends GetxController {
  var droppedValue = '0'.obs;
  var firstNumber = 0.obs;
  var secondNumber = 0.obs;
  var colorAnswer = Colors.grey.shade100.obs;
  var showIcon = false.obs;
  var starCount = 2.obs;
  var isTrue = false.obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    generateRandomNumbers();
  }

  void generateRandomNumbers() {
    final random = Random();
    firstNumber.value = random.nextInt(10);
    secondNumber.value = random.nextInt(10 - firstNumber.value);
    droppedValue.value = '0';
    colorAnswer.value = Colors.grey.shade100;
    showIcon.value = false;
    starCount.value = 2;
    isTrue.value = false;
  }

  void validateAnswer() {
    int answer = int.parse(droppedValue.value);
    if (answer == firstNumber.value + secondNumber.value) {
      colorAnswer.value = Colors.green;
      showIcon.value = false;
      isTrue.value = true;
      Get.snackbar("Correct!", "Next Your Question",
          colorText: Colors.white, backgroundColor: Colors.green);
    } else {
      colorAnswer.value = Colors.red;
      showIcon.value = false;
      starCount.value--;
      if (starCount.value == 0) {
        showGameOverDialog();
      }
    }
  }

  void showGameOverDialog() {
    Get.defaultDialog(
      title: "Game Over",
      content: Text("You've used all your chances. Try again!"),
      confirm: TextButton(
        onPressed: () {
          Get.back();
          generateRandomNumbers();
        },
        child: Text("OK"),
      ),
    );
  }

  void showInformation() {
    Get.defaultDialog(
      title: "Complete the Game",
      titleStyle: TextStyle(fontWeight: FontWeight.bold),
      content: const Text(
        "Complete this game, then you can continue to next question",
        textAlign: TextAlign.center,
      ),
      confirm: TextButton(
        onPressed: () {
          Get.back();
        },
        child: Text("OK"),
      ),
    );
  }
}
