import 'package:flutter/material.dart';
import 'game.dart';
import 'appbar.dart';
import 'settings.dart';

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

  const MenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: CustomAppBar(title: "Menu"),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: screenWidth * 0.4,
              height: screenHeight * 0.1,
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
              width: screenWidth * 0.4,
              height: screenHeight * 0.1,
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
    Navigator.push(context, MaterialPageRoute(builder: (context)=> GamePage()));
  }
  
  void _onConfigButtonPressed(context) {
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SettingsPage()));
  }
}
