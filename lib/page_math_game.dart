import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:math_game/arrow_painter.dart';

import 'math_game_controller.dart';

class PageMathGame extends StatelessWidget {
  final controller = Get.put(MathGameController());
  final GlobalKey tagrgetKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 25, 25, 25),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                barGame(controller),
                Expanded(child: Container()),
                quizBox(controller),
                Expanded(child: Container()),
                numberPad(controller, context, tagrgetKey),
              ],
            ),
            Obx(() {
              if (controller.showArrow.value) {
                return Stack(
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width,
                          MediaQuery.of(context).size.height),
                      painter: ArrowPainter(
                        start: controller.dragStartOffset.value,
                        end: controller.dragEndOffset.value,
                      ),
                    ),
                    Positioned(
                      left: controller.dragEndOffset.value.dx -
                          15, // Adjust as necessary
                      top: controller.dragEndOffset.value.dy -
                          15, // Adjust as necessary
                      child: Container(),
                    ),
                  ],
                );
              }
              return Container();
            })
          ],
        ),
      ),
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
                  onPressed: () {},
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
                  key: tagrgetKey,
                  // onAccept: (value) {
                  //   // controller.droppedValue.value = value;
                  //   // controller.showIcon.value = true;
                  //   // controller.update();
                  // },
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

  Widget numberPad(MathGameController controller, BuildContext context,
      GlobalKey targetKey) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                5,
                (index) =>
                    numberInput(controller, "$index", context, tagrgetKey)),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
                5,
                (index) => numberInput(
                    controller, "${index + 5}", context, targetKey)),
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

  Widget numberInput(MathGameController controller, String input,
      BuildContext context, GlobalKey targetKey) {
    return Draggable<String>(
      data: input,
      onDragStarted: () {
        RenderBox box = context.findRenderObject() as RenderBox;
        Offset startPosition = box.localToGlobal(Offset.zero) +
            Offset(box.size.width / 2,
                box.size.height / 2); // Center of the widget
        controller.dragStartOffset.value = startPosition;
        controller.showArrow.value = true;
      },
      onDragUpdate: (details) {
        controller.dragEndOffset.value = details.globalPosition;
      },
      onDragEnd: (details) {
        controller.showArrow.value = false;

        // Implementasi kondisi jika `details.offset` berada di dalam `DragTarget`
        final RenderBox targetBox =
            targetKey.currentContext?.findRenderObject() as RenderBox;
        final Offset targetPosition = targetBox.localToGlobal(Offset.zero);
        final Size targetSize = targetBox.size;

        if (details.offset.dx >= targetPosition.dx &&
            details.offset.dx <= targetPosition.dx + targetSize.width &&
            details.offset.dy >= targetPosition.dy &&
            details.offset.dy <= targetPosition.dy + targetSize.height) {
          // `details.offset` berada di dalam area `DragTarget`
          print("Dropped inside DragTarget!");
          controller.droppedValue.value = input;
          controller.showIcon.value = true;
        } else {
          // `details.offset` berada di luar area `DragTarget`
          print("Dropped outside DragTarget!");
        }
      },
      feedback: Material(
        color: Colors.transparent,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text(input,
                style: const TextStyle(fontSize: 30, color: Colors.white)),
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
      child: GestureDetector(
        onPanStart: (details) {
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset startPosition = box.localToGlobal(details.localPosition);
          controller.dragStartOffset.value = startPosition;
          controller.showArrow.value = true;
        },
        onPanUpdate: (details) {
          controller.dragEndOffset.value = details.globalPosition;
        },
        onPanEnd: (details) {
          controller.showArrow.value = false;
          print("object");
        },
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
    );
  }
}
