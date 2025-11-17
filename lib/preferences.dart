import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  // 屏幕方向 'portrait' / 'landscape' / 'auto'
  static const String _orientationKey = 'orientation';
  // 游戏难度 'easy' / 'normal' / 'hard'
  static const String _difficultyKey = 'difficulty';

  static Future<String> getOrientation() async =>
      (await SharedPreferences.getInstance()).getString(_orientationKey) ??
      'auto';
  static Future<void> setOrientation(String v) async =>
      (await SharedPreferences.getInstance()).setString(_orientationKey, v);

  static Future<String> getDifficulty() async =>
      (await SharedPreferences.getInstance()).getString(_difficultyKey) ??
      'easy';
  static Future<void> setDifficulty(String v) async =>
      (await SharedPreferences.getInstance()).setString(_difficultyKey, v);

}
