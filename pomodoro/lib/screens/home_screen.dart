import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vibration/vibration.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Color> backgroundColorList = [
    const Color(0xFF8A2BE2),
    const Color(0xFFF0A957),
    const Color(0xFF000080),
    const Color(0xFF800080),
    const Color(0xFF467EC6),
    const Color(0xFF85ac20),
  ];
  List<String> backgroundImgList = [
    "ine",
    "jingburger",
    "lilpa",
    "jururu",
    "gosegu",
    "viichan",
  ];
  int backgroundSelector = 0;
  int pomodoroTimeSetting = 1500;
  late int totalSeconds = pomodoroTimeSetting;
  int totalPomodoros = 0;
  late Timer timer;

  // shared_preferences 적용
  late SharedPreferences prefs;

  Future initPrefs() async {
    prefs = await SharedPreferences.getInstance();
    final totalPomodoroCount = prefs.getInt('totalPomodoroCount');
    if (totalPomodoroCount != null) {
      setState(() {
        totalPomodoros = totalPomodoroCount;
      });
    } else {
      await prefs.setInt('totalPomodoroCount', 0);
      setState(() {
        totalPomodoros = 0;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  bool isPlaying = false;

  void vibrateDevice() async {
    if (await Vibration.hasVibrator() ?? false) {
      Vibration.vibrate(duration: 1600);
    }
  }

  void resetPomodoro() async {
    if (!isPlaying) {
      setState(() {
        totalPomodoros = 0;
        totalSeconds = pomodoroTimeSetting;
      });
      await prefs.setInt('totalPomodoroCount', 0);
    }
  }

  void onTick(Timer timer) async {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros++;
        backgroundSelector = (backgroundSelector + 1) % 6;
        isPlaying = false;
        totalSeconds = pomodoroTimeSetting;
        vibrateDevice();
      });
      timer.cancel();
      await prefs.setInt('totalPomodoroCount', totalPomodoros);
    } else {
      setState(() {
        totalSeconds--;
      });
    }
  }

  void onStartPressed() {
    timer = Timer.periodic(
      const Duration(seconds: 1),
      onTick,
    );
    setState(() {
      isPlaying = true;
    });
  }

  void onPausePressed() {
    timer.cancel();
    setState(() {
      isPlaying = false;
    });
  }

  String secondsToMinute(int seconds) {
    dynamic duration = Duration(seconds: seconds);
    duration = duration.toString().split(".")[0].split(":");
    return '${duration[1]}:${duration[2]}';
  }

  void onCharacterPressed() {
    setState(() {
      backgroundSelector = (backgroundSelector + 1) % 6;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorList[backgroundSelector],
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: () {
                  if (!isPlaying) {
                    if (totalSeconds == pomodoroTimeSetting) {
                      // TODO: 1. 초기 포모도로 시간 조정
                    } else {
                      customShowDialog(
                        context: context,
                        backgroundColor:
                            backgroundColorList[backgroundSelector],
                        mainContent: "시간을 초기화 합니다!",
                        acceptBtnText: "확인",
                        cancelBtnText: "취소",
                        onAcceptBtnPressed: () {
                          setState(() {
                            totalSeconds = pomodoroTimeSetting;
                          });
                          Navigator.of(context).pop();
                        },
                        onCancelBtnPressed: () {
                          Navigator.of(context).pop();
                        },
                      );
                    }
                  }
                },
                child: Text(
                  secondsToMinute(totalSeconds),
                  style: TextStyle(
                    color: Theme.of(context).cardColor,
                    fontSize: 88,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            flex: 2,
            child: Center(
              child: GestureDetector(
                onTap: onCharacterPressed,
                child: Image.asset(
                  'assets/images/${backgroundImgList[backgroundSelector]}.png',
                ),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Center(
              child: IconButton(
                iconSize: 120,
                color: Theme.of(context).cardColor,
                onPressed: isPlaying ? onPausePressed : onStartPressed,
                icon: Icon(isPlaying
                    ? Icons.pause_circle_outline
                    : Icons.play_circle_outline),
              ),
            ),
          ),
          Flexible(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: SizedBox(),
                              )
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Pomodoros',
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                              Text(
                                '$totalPomodoros',
                                style: TextStyle(
                                    fontSize: 56,
                                    fontWeight: FontWeight.w600,
                                    color: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.color),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 1,
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    IconButton(
                                        color: Theme.of(context)
                                            .textTheme
                                            .displayLarge
                                            ?.color,
                                        iconSize: 32,
                                        onPressed: () {
                                          customShowDialog(
                                            backgroundColor:
                                                backgroundColorList[
                                                    backgroundSelector],
                                            context: context,
                                            mainContent:
                                                "고생했어요!🤓\n포모도로를 초기화 하시겠어요?",
                                            acceptBtnText: "초기화 해 줘",
                                            cancelBtnText: "아니 좀 더 할게",
                                            onAcceptBtnPressed: () {
                                              resetPomodoro();
                                              Navigator.of(context).pop();
                                            },
                                            onCancelBtnPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                        icon: const Icon(Icons.refresh_sharp)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> customShowDialog({
    required BuildContext context,
    required String mainContent,
    required String acceptBtnText,
    required String cancelBtnText,
    required Function onAcceptBtnPressed,
    required Function onCancelBtnPressed,
    Color backgroundColor = Colors.white,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          backgroundColor: backgroundColor,
          content: Text(mainContent,
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w400)),
          actions: [
            TextButton(
              onPressed: () {
                onAcceptBtnPressed();
              },
              child: Text(
                acceptBtnText,
                style: const TextStyle(
                  color: Color.fromARGB(255, 237, 233, 233),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                onCancelBtnPressed();
              },
              child: Text(
                cancelBtnText,
                style: const TextStyle(
                  color: Color.fromARGB(255, 237, 233, 233),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
