import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'math_game_controller.dart';

class PageMathGame extends StatelessWidget {
  final controller = Get.put(MathGameController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
          child: Column(
        children: [
          barGame(controller),
          Expanded(child: Container()),
          quizBox(controller),
          Expanded(child: Container()),
          numberPad(controller),
        ],
      )),
    );
  }

  Widget barGame(MathGameController controller) {
    return Container(
      decoration: const BoxDecoration(color: Color.fromRGBO(30, 30, 30, 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
                 IconButton(
                  onPressed: (){},
                  icon: const Icon(
                    Icons.keyboard_arrow_up_sharp,
                    size: 30,
                    color: Colors.white,
                  )),
              IconButton(
                  onPressed: controller.generateRandomNumbers,
                  icon: const Icon(Icons.refresh, color: Colors.white)),
            ],
          ),
          Obx(() => Row(
                children: List.generate(
                  2,
                  (index) => Icon(
                    index < controller.starCount.value
                        ? Icons.star
                        : Icons.star_border,
                    color: index < controller.starCount.value
                        ? Colors.green
                        : Colors.white,
                  ),
                ),
              )),
          IconButton(
            onPressed: () => controller.isTrue.value
                ? controller.generateRandomNumbers()
                : controller.showInformation(),
            icon: Obx(() => Icon(
                  controller.isTrue.value
                      ? Icons.arrow_forward_ios
                      : Icons.arrow_forward_ios,
                  color: controller.isTrue.value ? Colors.green : Colors.white,
                )),
          ),
        ],
      ),
    );
  }

  Widget quizBox(MathGameController controller) {
    return Obx(() => SizedBox(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 120),
            child: Column(
              children: [
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(controller.firstNumber.toString(),
                      style:
                          const TextStyle(fontSize: 70, color: Colors.white)),
                ),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text("+ ${controller.secondNumber.toString()}",
                      style:
                          const TextStyle(fontSize: 70, color: Colors.white)),
                ),
                const Divider(),
                const SizedBox(height: 5),
                DragTarget<String>(
                  onAccept: (value) {
                    controller.droppedValue.value = value;
                    controller.showIcon.value = true;
                  },
                  builder: (_, candidateData, rejectedData) {
                    return Obx(() => Container(
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: controller.colorAnswer.value),
                              borderRadius: BorderRadius.circular(10)),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                              controller.droppedValue.value,
                              style: TextStyle(
                                  fontSize: 70,
                                  color: controller.colorAnswer.value ==
                                          Colors.grey.shade100
                                      ? Colors.white
                                      : controller.colorAnswer.value),
                            ),
                          ),
                        ));
                  },
                ),
              ],
            ),
          ),
        ));
  }

  Widget numberPad(MathGameController controller) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children:
                List.generate(5, (index) => numberInput(controller, "$index")),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                5, (index) => numberInput(controller, "${index + 5}")),
          ),
          const SizedBox(height: 10),
          Obx(() => Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (controller.showIcon.value)
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
                        onPressed: controller.isTrue.value
                            ? controller.generateRandomNumbers
                            : controller.validateAnswer,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              controller.colorAnswer.value),
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.all(10)),
                          minimumSize:
                              MaterialStateProperty.all(const Size(150, 50)),
                        ),
                        child: Icon(
                          controller.isTrue.value
                              ? Icons.arrow_forward_ios
                              : Icons.done,
                          color: controller.colorAnswer.value ==
                                  Colors.grey.shade100
                              ? Colors.black
                              : Colors.white,
                        )),
                  ),
                  const Spacer(),
                ],
              )),
        ],
      ),
    );
  }

  Widget numberInput(MathGameController controller, String input) {
    return Draggable<String>(
      data: input,
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
}
