import 'package:flutter/material.dart';
import 'timebar.dart';
import 'appbar.dart';
import 'board.dart';
import 'config.dart';

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