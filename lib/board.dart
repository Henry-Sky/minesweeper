import 'package:flutter/material.dart';
import 'package:minesweeper/manager.dart';

class Chessboard extends StatefulWidget {
  final double width;
  final double height;
  final GameManager manager;

  const Chessboard({
    super.key,
    required this.width,
    required this.height,
    required this.manager,
  });

  @override
  createState() => _ChessboardState();
}

class _ChessboardState extends State<Chessboard> {
  late GameManager config;
  late double boardWidth;
  late double boardHeight;
  late double gridWidth;
  late double gridHeight;
  late double cellWidth;
  final double borderWidth = 4.0;

  static const _nearbyDelta = [
    (-1, 1),
    (0, 1),
    (1, 1),
    (-1, 0),
    /*(0,0),*/
    (1, 0),
    (-1, -1),
    (0, -1),
    (1, -1),
  ];

  @override
  Widget build(BuildContext context) {
    config = widget.manager;
    double bias = config.boardCols / config.boardRows;
    if ((widget.width - borderWidth * 2) / (widget.height - borderWidth * 2) >
        bias) {
      gridHeight = (widget.height - borderWidth * 2);
      gridWidth = gridHeight * bias;
    } else {
      gridWidth = (widget.width - borderWidth * 2);
      gridHeight = gridWidth / bias;
    }
    boardWidth = gridWidth + borderWidth * 2;
    boardHeight = gridHeight + borderWidth * 2;
    cellWidth = gridWidth / config.boardCols;

    return Center(
      child: Container(
        width: boardWidth,
        height: boardHeight,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.green, width: borderWidth),
          borderRadius: const BorderRadius.all(Radius.circular(2.0)),
        ),
        child: Center(
          child: Container(
            width: gridWidth,
            height: gridHeight,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: config.boardCols, // 每行显示的子组件数量
                childAspectRatio: 1, // 子组件的宽高比
              ),
              itemBuilder: (context, index) {
                int row = index ~/ config.boardCols; // 计算行号
                int col = index % config.boardCols; // 计算列号
                return GestureDetector(
                  onTap: () => _handleTap(row, col), // 点按
                  onLongPress: () => _handleLongPress(row, col), // 长按
                  onSecondaryTap: () => _handleLongPress(row, col), // 鼠标右键
                  child: _itemCell(row, col),
                );
              },
              itemCount: config.boardRows * config.boardCols, // 子组件总数
            ),
          ),
        ),
      ),
    );
  }

  Container _itemCell(row, col) {
    int stateDisplay = config.boardStates[row][col][1];
    // Display 0: 网格被遮盖
    if (stateDisplay == 0) {
      return _coveredDisplay(false);
    }
    // Display 1: 网格插旗
    else if (stateDisplay == 1) {
      return _coveredDisplay(true);
    }
    // Display 2: 网格无遮盖
    else if (stateDisplay == 2) {
      return _uncoveredDisplay(row, col);
    } else {
      print("Error! ($row, $col) 未知显示模式");
      return Container();
    }
  }

  Container _coveredDisplay(flag) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey,
        border: Border.all(color: Colors.brown, width: cellWidth * 0.05),
        borderRadius: const BorderRadius.all(Radius.circular(2.0)),
      ),
      child: flag
          ? Center(
              child: Icon(
                Icons.flag,
                color: Colors.yellow,
                size: cellWidth * 0.9,
              ),
            )
          : null,
    );
  }

  Container _uncoveredDisplay(row, col) {
    int num = _countMinesAround(row, col);
    bool isMine = config.boardStates[row][col][0];

    if (isMine) {
      config.setGameOver(); // 游戏结束
    }

    return Container(
      child: Center(
        child: isMine
            ? Icon(
                Icons.add_circle,
                color: Colors.red,
                size: cellWidth * 0.9,
              )
            : (num != 0
                ? Text(
                    "$num",
                    style: TextStyle(
                        color: Colors.green,
                        fontFamily: "Arial",
                        fontSize: cellWidth * 0.8,
                        fontWeight: FontWeight.w700
                    ),
                  )
                : null),
      ),
    );
  }

  bool _isCellInBoard(row, col) {
    return (row >= 0 &&
        row < config.boardRows &&
        col >= 0 &&
        col < config.boardCols);
  }

  int _countMinesAround(row, col) {
    int cnt = 0;
    for (int r = row - 1; r <= row + 1; r++) {
      for (int c = col - 1; c <= col + 1; c++) {
        if (_isCellInBoard(r, c) && config.boardStates[r][c][0] == true) {
          cnt += 1;
        }
      }
    }
    return cnt;
  }

  void _checkAroundCell(int row, int col) {
    // 检查周围单元格
    if (_countMinesAround(row, col) == 0) {
      for (final (dr, dc) in _nearbyDelta) {
        int nr = row + dr;
        int nc = col + dc;
        // 检查是否在棋盘范围内
        if (_isCellInBoard(nr, nc)) {
          var nma = _countMinesAround(nr, nc);
          if (config.boardStates[nr][nc][1] == 0 && nma == 0) {
            config.boardStates[nr][nc][1] = 2;
            _checkAroundCell(nr, nc);
          } else if (!config.boardStates[nr][nc][0] &&
              config.boardStates[nr][nc][1] == 0 &&
              nma != 0) {
            config.boardStates[nr][nc][1] = 2;
          }
        }
      }
    }
  }

  void _handleTap(row, col) {
    if (config.isGameContinue()) {
      setState(() {
        int stateDisplay = config.boardStates[row][col][1];
        if (stateDisplay == 0) {
          if (config.firstTap) {
            while (config.boardStates[row][col][0] || _countMinesAround(row, col) > 0) {
              config.spawnMines();
            }
            config.firstTap = false;
          }
          config.boardStates[row][col][1] = 2;
          // 递推周围空白网格
          _checkAroundCell(row, col);
        } else if (stateDisplay == 1) {
          config.boardStates[row][col][1] = 0;
          config.flagNumber -= 1;
        }
      });
    }
  }

  void _handleLongPress(row, col) {
    if (config.isGameContinue()) {
      setState(() {
        int stateDisplay = config.boardStates[row][col][1];
        if (stateDisplay == 0) {
          config.boardStates[row][col][1] = 1;
          config.flagNumber += 1;
        } else if (stateDisplay == 1) {
          config.boardStates[row][col][1] = 0;
        }
      });
    }
  }
}
