import 'package:flutter/material.dart';

class MyProfileScreen extends StatelessWidget {
  const MyProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: Column(
      children: [
        const Text('MyProfileScreen'),
        TextButton(
          onPressed: () {
          },
          child: const Text('로그아웃하기'),
        ),
      ],
    ),);
  }
}