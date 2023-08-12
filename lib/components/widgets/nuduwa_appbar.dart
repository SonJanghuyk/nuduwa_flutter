import 'package:flutter/material.dart';

class NuduwaAppBar extends StatelessWidget implements PreferredSizeWidget {
  const NuduwaAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('너두와앱바샘플'),
      backgroundColor: Colors.blue,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
