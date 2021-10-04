import 'package:flutter/material.dart';
import 'music_add_page.dart';
import 'db_provider.dart';

void main() => runApp(Siggmo());

class Siggmo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // アプリ名
      title: 'My Todo App',
      theme: ThemeData(
        // ダークモード
        brightness:Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF212121),
        accentColor: const Color(0xFF64ffda),
        canvasColor: const Color(0xFF303030),
      ),
      // リスト一覧画面を表示
      home: MainPage(),
    );
  }
}

// リスト一覧画面用Widget
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // 入力されたテキストをデータとして持つ
  String _musicName = '';
  String _artistName = '';
  double _averageMin = 0.0;
  double _averageMax = 100.0;
  double _maxMin = 0.0;
  double _maxMax = 100.0;
  double _minMin = 0.0;
  double _minMax = 100.0;
  // 曲一覧を取得
  List musicList = [];

  //画面読み込み時にDBから曲一覧を取得する
  _MainPageState(){
    fetchMusicList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBarを表示し、タイトルも設定
      appBar: AppBar(
        title: Text('登録曲一覧'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () => onSearch(),
          ),
          IconButton(
            icon: Icon(Icons.view_list),
            onPressed: () => fetchMusicList(),
          )
        ]
      ),
      body: ListView.builder(
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(musicList[index]),
              onTap:(){
                print("onTap called");
              },
              onLongPress:() {
                print("onLongTap called.");
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // "push"で新規画面に遷移
          // 曲追加画面から渡される値を受け取る
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              // 遷移先の画面としてリスト追加画面を指定
              return MusicAddPage();
            }),
          );
          if(newListText != null){
            // キャンセルした場合は返り値がnullとなるので注意
            setState(() {
              // リスト追加
              musicList.add(newListText);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void fetchMusicList(){
    //DBクラスを呼び出す
    DatabaseFactory factory = DatabaseFactory();
    late SiggmoDao helper = SiggmoDao(factory);

    // 曲一覧を取得
    helper.mainAllFetch().then((musicList) => {
      musicList!.forEach((value) {
        this.musicList.add(value.toString());
      })
    });
  }

  //検索用ポップアップ
  void onSearch(){
    // 検索用ポップアップ表示
    print("検索用ポップアップ表示");
    // 曲名、アーティスト名
    Map<String, String> musicArtist = {
      'musicName' : '',
      'artistName' : ''
    };
    // 点数系
    Map<String, double> averageMaxMin = {
      'averageMin' : 0.0,
      'averageMax' : 100.0,
      'maxMin' : 0.0,
      'maxMax' : 100.0,
      'minMin' : 0.0,
      'minMax' : 100.0
    };
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text("検索"),
          content:
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text("曲名"),
                TextField(
                  onChanged: (String value){
                    setState((){ _musicName = value; musicArtist['musicName'] = _musicName;});
                  },
                ),
                const Text("アーティスト名"),
                TextField(
                  onChanged: (String value){
                    setState((){ _artistName = value; musicArtist['artistName'] = _artistName;});
                  },
                ),
                const Text("平均点"),
                Row(
                  children: <Widget>[
                    Flexible(child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState((){ _averageMin = double.parse(value); averageMaxMin['averageMin'] = _averageMin;});
                      },
                    )),
                    const Text("点～"),
                    Flexible(child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState((){ _averageMax = double.parse(value); averageMaxMin['averageMax'] = _averageMax; });
                      },)),
                    const Text("点")
                  ],
                ),
                const Text("最高点"),
                Row(
                  children: <Widget>[
                    Flexible(child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState((){ _maxMin = double.parse(value); averageMaxMin['maxMin'] = _maxMin;});
                      },)),
                    const Text("点～"),
                    Flexible(child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState((){ _maxMax = double.parse(value); averageMaxMin['maxMax'] = _maxMax;});
                      },)),
                    const Text("点")
                  ],
                ),
                const Text("最低点"),
                Row(
                  children: <Widget>[
                    Flexible(child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState((){ _minMin = double.parse(value); averageMaxMin['minMin'] = _minMin;});
                      },)),
                    const Text("点～"),
                    Flexible(child: TextField(
                      keyboardType: TextInputType.number,
                      onChanged: (value){
                        setState((){ _minMax = double.parse(value); averageMaxMin['minMax'] = _minMax;});
                      },)),
                    const Text("点")
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            //ボタン領域
            FlatButton(
              child: const Text("cancel"),
              onPressed: () => Navigator.pop(context),
            ),
            FlatButton(
              child: const Text("検索"),
              onPressed: () {
                search(musicArtist, averageMaxMin);
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  //検索処理
  Future<List<Map>?> search(Map musicArtist, Map averageMaxMin) async {
    //DBクラスを呼び出す
    DatabaseFactory factory = DatabaseFactory();
    late SiggmoDao helper = SiggmoDao(factory);

    // 曲一覧を取得
    helper.fetch(musicArtist, averageMaxMin).then((musicList) => {
      musicList!.forEach((value) {
        this.musicList.add(value.toString());
      })
    });
    print(musicList);
  }
}

