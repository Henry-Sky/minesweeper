import 'package:flutter/material.dart';
import 'dart:async';
import 'package:minesweeper/manager.dart';

class TimeBar extends StatefulWidget {
  final int duration; // 倒计时总时长（秒）
  final double height;
  final GameManager manager;

  const TimeBar({super.key, required this.duration, required this.height, required this.manager});

  @override
  createState() => _TimeBarState();
}

class _TimeBarState extends State<TimeBar> {
  int _secondsRemaining = 0;
  Timer? _timer;
  late GameManager config;

  @override
  void initState() {
    super.initState();
    _secondsRemaining = widget.duration;
    _startTimer();
    config = widget.manager;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (!config.isGameContinue()) {
        Navigator.pop(context);
      }
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        config.setGameOver();  // 游戏结束
        timer.cancel();
      }
    });
  }

  String _getTimeInfo() {
    int minute = (_secondsRemaining / 60).floor();
    int second = _secondsRemaining - (minute * 60);
    String minuteStr = minute < 10 ? "0$minute" : "$minute";
    String secondStr = second < 10 ? "0$second" : "$second";
    return "$minuteStr:$secondStr";
  }

  String _getFlagInfo() {
    int flagNum = config.flagNumber;
    int minesAll = config.mineNumber;
    String nowStr = flagNum < 10 ? "0$flagNum" : "$flagNum";
    String allStr = minesAll < 10 ? "0$minesAll" : "$minesAll";
    return "$nowStr/$allStr";
  }

  @override
  void dispose() {
    _timer?.cancel(); // 确保在组件销毁时取消 Timer
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double maxWidth = MediaQuery.of(context).size.width;
    double maxHeight = widget.height;
    double paddingWidth = 8.0;
    Radius borderRadius = const Radius.circular(10.0);
    double borderWidth = 4.0;
    BorderSide borderSide = BorderSide(color: Colors.white, width: borderWidth);
    // 游戏信息获取
    String timeInfo = _getTimeInfo();
    String gameInfo = _getFlagInfo();

    return SizedBox(
      height: maxHeight,
      width: maxWidth,
      child: Padding(
        padding: EdgeInsets.all(paddingWidth),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: maxWidth / 2 - paddingWidth,
                height: maxHeight - 2 * borderWidth,
                decoration: BoxDecoration(
                  color: Colors.red,
                  border: Border(left: borderSide, top: borderSide, bottom: borderSide,),
                  borderRadius: BorderRadius.only(topLeft: borderRadius, bottomLeft: borderRadius,),
                ),
                child: Center(
                  child: Text(gameInfo, style: TextStyle(fontSize: maxHeight * 0.3),),
                ),
              ),
              Container(
                width: maxWidth / 2 - paddingWidth,
                height: maxHeight - 2 * borderWidth,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border(right: borderSide, top: borderSide, bottom: borderSide,),
                  borderRadius: BorderRadius.only(topRight: borderRadius, bottomRight: borderRadius,),
                ),
                child: Center(
                  child: Text(timeInfo, style: TextStyle(fontSize: maxHeight * 0.3),),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}