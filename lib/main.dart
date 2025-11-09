import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'timebar.dart';
import 'appbar.dart';
import 'board.dart';
import 'config.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minesweeper',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: GamePage(),
    );
  }
}

class GamePage extends StatelessWidget {
  GamePage({super.key});

  // 游戏配置文件
  final gameConfig = GameConfig(boardRows: 18, boardCols: 32, mineNumber: 99);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    // 调整各组件高度
    final appbarHeight = screenHeight * 0.1;
    final boardHeight = screenHeight * 0.8;
    final timebarHeight = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: CustomAppBar(title: "Minesweeper", height: appbarHeight, config: gameConfig,),
      body: Center(
        child: Column(
          children: <Widget>[
            Chessboard(width: screenWidth, height: boardHeight, config: gameConfig,),
            TimeBar(duration: 5 * 60, height: timebarHeight, config: gameConfig,),
          ],
        ),
      ),
    );
  }
}

void infoShow(context) {
  // 检测运行平台
  String platform;
  if (kIsWeb) {
    platform = 'Web';
  } else if (Platform.isAndroid) {
    platform = 'Android';
  } else if (Platform.isIOS) {
    platform = 'iOS';
  } else if (Platform.isMacOS) {
    platform = 'macOS';
  } else if (Platform.isWindows) {
    platform = 'Windows';
  } else if (Platform.isLinux) {
    platform = 'Linux';
  } else {
    platform = 'Unknown';
  }
  // 检测屏幕方向
  String orientation =
      MediaQuery.of(context).orientation == Orientation.portrait
      ? 'Portrait Mode'
      : 'Landscape Mode';
  // 获取屏幕尺寸
  final screenWidth = MediaQuery.of(context).size.width;
  final screenHeight = MediaQuery.of(context).size.height;

  print("调试信息，平台：$platform，方向：$orientation，尺寸：（$screenWidth, $screenHeight）");
}
