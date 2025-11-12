import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'game.dart';
import 'appbar.dart';
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
      home: MenuPage(),
    );
  }
}

class MenuPage extends StatelessWidget {

  // 游戏配置文件
  late var _gameConfig;

  MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final appbarHeight = screenHeight * 0.1;

    _gameConfig = GameConfig(boardRows: 18, boardCols: 32, mineNumber: 99);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: CustomAppBar(title: "Minesweeper", height: appbarHeight, config: _gameConfig,),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.6,
              height: screenHeight * 0.3,
              child: ElevatedButton(
                  onPressed: ()=> _onStartButtonPressed(context),
                  child: Text("开始游戏")
              ),
            ),
            SizedBox(
              height: screenHeight * 0.1,
              width: screenWidth,
            ),
            SizedBox(
              width: screenWidth * 0.6,
              height: screenHeight * 0.3,
              child: ElevatedButton(
                  onPressed: ()=> _onConfigButtonPressed(context),
                  child: Text("游戏设置")
              ),
            ),
          ],
        )
      )
    );
  }
  
  void _onStartButtonPressed(context) {
    _gameConfig.gameReset();
    Navigator.push(context, MaterialPageRoute(builder: (context)=> GamePage(gameConfig: _gameConfig,)));
  }
  
  void _onConfigButtonPressed(context) {
    
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
