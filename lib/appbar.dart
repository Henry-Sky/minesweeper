import 'package:flutter/material.dart';
import 'package:minesweeper/config.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double height;
  final GameConfig config;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.config,
    this.height = kToolbarHeight,
  });

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(height),
      child: AppBar(
        title: Text(title),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}