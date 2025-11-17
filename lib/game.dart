import 'package:flutter/material.dart';
import 'timebar.dart';
import 'appbar.dart';
import 'board.dart';
import 'manager.dart';
import 'preferences.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameManager? gameManager;          // ① 先置空

  @override
  void initState() {
    super.initState();
    _initManager();                  // ② 异步初始化
  }

  Future<void> _initManager() async {
    final orientation = await Prefs.getOrientation();
    final manager = orientation == 'landscape'
        ? GameManager(boardRows: 18, boardCols: 32, mineNumber: 99)
        : GameManager(boardRows: 32, boardCols: 18, mineNumber: 99);
    setState(() => gameManager = manager); // ③ 拿到后再刷新
  }

  @override
  Widget build(BuildContext context) {
    // ④ 数据还没回来，先给加载占位
    if (gameManager == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final appbarHeight = screenHeight * 0.1;
    final boardHeight = screenHeight * 0.8;
    final timebarHeight = screenHeight * 0.1;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: CustomAppBar(title: 'Minesweeper', height: appbarHeight),
      body: Center(
        child: Column(
          children: [
            Chessboard(
              width: screenWidth,
              height: boardHeight,
              manager: gameManager!, // ⑤ 非空断言，此时一定有值
            ),
            TimeBar(
              duration: 5 * 60,
              height: timebarHeight,
              manager: gameManager!,
            ),
          ],
        ),
      ),
    );
  }
}