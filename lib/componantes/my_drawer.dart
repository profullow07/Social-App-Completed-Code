import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  final String title;
  final IconData icons;
  final void Function()? onTap;
  const MyDrawer({
    super.key,
    required this.title,
    required this.icons,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Icon(
        icons,
        color: Colors.white,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 22),
      ),
    );
  }
}
