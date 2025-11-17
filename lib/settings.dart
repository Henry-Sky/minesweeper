import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io' show Platform;
import 'preferences.dart';
import 'appbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<StatefulWidget> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _orientation = 'auto';
  String _difficulty = 'easy';

  Future<void> _load() async {
    _orientation = await Prefs.getOrientation();
    _difficulty = await Prefs.getDifficulty();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      appBar: CustomAppBar(title: "Settings"),
      body: ListView(
        children: [
          ListTile(
            title: const Text('屏幕方向'),
            trailing: DropdownButton<String>(
              value: _orientation,
              items: [
                DropdownMenuItem(value:'auto', child: Text('自动')),
                DropdownMenuItem(value:'portrait', child: Text('垂直')),
                DropdownMenuItem(value:'landscape', child: Text('横向')),
              ],
              onChanged: (String? value) async {
                if (value != null) {
                  await Prefs.setOrientation(value);
                  setState(() {
                    _orientation = value;
                  });
                }
              },
            ),
          )
        ],
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