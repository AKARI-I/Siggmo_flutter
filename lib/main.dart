import 'package:flutter/material.dart';
import 'package:siggmo/view/main_page.dart';

void main() => runApp(Siggmo());

class Siggmo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // テーマカラー
        primarySwatch: Colors.blue,
      ),
      // リスト一覧画面を表示
      home: MainPage(),
    );
  }
}
