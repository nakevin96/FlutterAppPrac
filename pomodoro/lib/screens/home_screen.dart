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
                      // showDialog(
                      //   context: context,
                      //   barrierDismissible: false,
                      //   builder: (BuildContext contenxt) {
                      //     return AlertDialog(
                      //       content: Column(
                      //         children: [
                      //           const Text('시간을 변경합니다.'),
                      //           Padding(
                      //             padding: const EdgeInsets.only(top: 20),
                      //             child: Row(
                      //               mainAxisAlignment:
                      //                   MainAxisAlignment.spaceBetween,
                      //               children: [
                      //                 IconButton(
                      //                   onPressed: () {
                      //                     setState(() {
                      //                       totalSeconds -= 300;
                      //                     });
                      //                   },
                      //                   icon: const Icon(Icons.remove),
                      //                 ),
                      //                 Text(
                      //                   secondsToMinute(totalSeconds),
                      //                   style: const TextStyle(
                      //                     fontSize: 40,
                      //                     fontWeight: FontWeight.w600,
                      //                   ),
                      //                 ),
                      //                 IconButton(
                      //                   onPressed: () {
                      //                     setState(() {
                      //                       totalSeconds += 300;
                      //                     });
                      //                   },
                      //                   icon: const Icon(Icons.add),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //         ],
                      //       ),
                      //       actions: [
                      //         TextButton(
                      //           onPressed: () {
                      //             Navigator.of(context).pop();
                      //           },
                      //           child: const Text('적용'),
                      //         )
                      //       ],
                      //     );
                      //   },
                      // );
                    } else {
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: const Text('시간을 초기화합니다'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  setState(() {
                                    totalSeconds = pomodoroTimeSetting;
                                  });
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          );
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
                                        onPressed: resetPomodoro,
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
}
