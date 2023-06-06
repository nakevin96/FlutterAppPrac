import 'dart:async';

import 'package:flutter/material.dart';

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
  int backgroundColorSelector = 0;
  int pomodoroTimeSetting = 1500;
  late int totalSeconds = pomodoroTimeSetting;
  int totalPomodoros = 0;
  late Timer timer;

  bool isPlaying = false;

  void resetPomodoro() {
    if (!isPlaying) {
      setState(() {
        totalPomodoros = 0;
        totalSeconds = pomodoroTimeSetting;
      });
    }
  }

  void onTick(Timer timer) {
    if (totalSeconds == 0) {
      setState(() {
        totalPomodoros++;
        backgroundColorSelector = (backgroundColorSelector + 1) % 6;
        isPlaying = false;
        totalSeconds = pomodoroTimeSetting;
      });
      timer.cancel();
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

  void refreshTimer() {
    if (!isPlaying) {
      if (totalSeconds == pomodoroTimeSetting) {
        setState(() {
          backgroundColorSelector = (backgroundColorSelector + 1) % 6;
        });
      } else {
        setState(() {
          totalSeconds = pomodoroTimeSetting;
        });
      }
    } else {
      setState(() {
        backgroundColorSelector = (backgroundColorSelector + 1) % 6;
      });
    }
  }

  String secondsToMinute(int seconds) {
    dynamic duration = Duration(seconds: seconds);
    duration = duration.toString().split(".")[0].split(":");
    return '${duration[1]}:${duration[2]}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorList[backgroundColorSelector],
      body: Column(
        children: [
          Flexible(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: refreshTimer,
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
            flex: 3,
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
                            children: [Expanded(child: SizedBox())],
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
