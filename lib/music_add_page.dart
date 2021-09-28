import 'package:flutter/material.dart';
import 'db_provider.dart';
import 'package:flutter/services.dart';

// リスト追加画面用Widget
class MusicAddPage extends StatefulWidget {
  @override
  _MusicAddPageState createState() => _MusicAddPageState();
}

class _MusicAddPageState extends State<MusicAddPage> {
  // 入力されたテキストをデータとして持つ
  String _musicName = '';
  String _musicNameKana = '';
  String _artistName = '';
  String _artistNameKana = '';
  double _average = 0.0;
  double _max = 0.0;
  double _min = 0.0;
  double _latest = 0.0;
  double _lastTime = 0.0;
  double _twoTimesBefore = 0.0;
  String _createDate = DateTime.now().toString();
  String _updateDate = DateTime.now().toString();
  int itemNameSize = 10;

  // データを元に表示するWidget
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('曲追加画面'),
      ),
      body: Container(
        // 余白を付ける
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView( //スクロールできるようにする
          child:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                //曲名
                const Text('曲名', style: TextStyle(fontSize: 15)),
                TextField(
                          onChanged: (String value){
                            setState((){
                              _musicName = value;
                            });
                          },
                        ),
                const SizedBox(height: 10),
                //曲名(かな)
                const Text('曲名(かな)', style: TextStyle(fontSize: 15)),
                TextField(
                        onChanged: (String value){
                          setState((){
                            _musicNameKana = value;
                          });
                        },
                      ),
                const SizedBox(height: 10),
                //アーティスト名
                const Text('アーティスト名', style: TextStyle(fontSize: 15)),
                TextField(
                        onChanged: (String value){
                          setState((){
                            _artistName = value;
                          });
                        },
                      ),
                const SizedBox(height: 10),
                //アーティスト名(かな)
                const Text('アーティスト名(かな)', style: TextStyle(fontSize: 15)),
                TextField(
                  onChanged: (String value){
                    setState((){ _artistNameKana = value; });
                  },
                ),
                const SizedBox(height: 10),
                //最新点
                const Text('最新点', style: TextStyle(fontSize: 15)),
                TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (value){
                          setState((){ _latest = double.parse(value); });
                  },
                ),
                const SizedBox(height: 10),
                //曲追加ボタン
                Container(
                  child: ElevatedButton(
                    onPressed: () {
                      insert(_musicName, _musicNameKana, _artistName, _artistNameKana, _average, _max, _min, _latest, _lastTime, _twoTimesBefore, DateTime.now().toString(), DateTime.now().toString());
                      Navigator.of(context).pop();
                    },
                    child: Text('保存', style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(height: 8),
                //キャンセルボタン
                Container(
                  child: SizedBox(
                    // キャンセルボタン
                    child: TextButton(
                      // ボタンをクリックした時の処理
                      onPressed: () {
                        // "pop"で前の画面に戻る
                        Navigator.of(context).pop();
                      },
                      child: Text('キャンセル'),
                    ),
                  ),
                ),
              ],
            )
        )
      ),
    );
  }

  //DBクラスを呼び出す
  DatabaseFactory factory = DatabaseFactory();
  late SiggmoDao helper = SiggmoDao(factory);

  void insert(musicName, musicNameKana, artistName, artistNameKana, average, max, min, latest, lastTime, twoTimesBefore, createDate, updateDate){
    print("--- insert処理 ---");
    print(helper.save(musicName, musicNameKana, artistName, artistNameKana, average, max, min, latest, lastTime, twoTimesBefore, createDate, updateDate));
  }
  void query(){
    print("--- query ---");
  }
  void update(){
    print("--- update処理 ---");
  }
  void delete(){
    print("--- delete処理 ---");
  }
}