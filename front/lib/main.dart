import 'package:flutter/material.dart';
import 'package:snail/splash.dart';
import 'package:snail/tests/guides/backspace_guide.dart';
import 'package:snail/tests/tests/story_video.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Pretendard',
      ),
      title: 'SNaiL',
      home: Scaffold(
        body: StoryVideoScreen(),
      ), //처음 접하는 화면을 SplashScreen으로 설정.
    );
  }
}
