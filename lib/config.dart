import 'dart:math';
import 'package:tuple/tuple.dart';

class GameConfig {
  final int boardRows;
  final int boardCols;
  final int mineNumber;
  late int flagNumber;
  late double boardWidth;
  late double boardHeight;
  late bool _isGameContinue;
  late bool firstTap;
  // 网格状态：Tuple<bool,int>，bool表示是否埋雷，int表示显示状态（0 遮盖，1 插旗，2 无遮盖）
  late List<List<List<dynamic>>> boardStates;

  GameConfig({required this.boardRows, required this.boardCols, required this.mineNumber}) {
    gameReset();
  }

  void gameReset() {
    _isGameContinue = true;
    firstTap = true;
    spawnMines();
    flagNumber = 0;
  }

  bool isGameContinue() {
    return _isGameContinue;
  }

  void setGameOver() {
    _isGameContinue = false;
  }

  void spawnMines() {
    boardStates = List.generate(
      boardRows,
          (i) => List.generate(boardCols, (j) => [false, 0]),
    );

    int cnt = 0;
    Set<Tuple2<int, int>> mines = {};
    while (cnt < mineNumber) {
      int r = Random().nextInt(boardRows);
      int c = Random().nextInt(boardCols);
      var nextMine = Tuple2(r, c);
      if (!mines.contains(nextMine)){
        mines.add(nextMine);
        boardStates[r][c][0] = true;
        cnt++;
      }
    }
  }

  int countMinesCovered() {
    int cnt = 0;
    for (var innerList in boardStates) {
      for (var element in innerList) {
        if (element[0] == true && (element[1] == 0 || element[1] == 1)) {
          cnt ++;
        }
      }
    }
    return cnt;
  }
}
