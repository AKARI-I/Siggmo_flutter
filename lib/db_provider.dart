import 'package:sqflite/sqflite.dart';
import 'package:sqflite/src/exception.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'dart:io';

class Siggmo{
  final int musicId;
  final String musicName;
  final String musicNameKana;
  final String artistName;
  final String artistNameKana;
  final double average;
  final double max;
  final double min;
  final double latest;
  final double lastTime;
  final double twoTimesBefore;
  final String createDate;
  final String updateDate;

  const Siggmo(this.musicId, this.musicName, this.musicNameKana, this.artistName, this.artistNameKana, this.average, this.max, this.min, this.latest, this.lastTime, this.twoTimesBefore, this.createDate, this.updateDate);
}

//1.DDL操作の責務を持たせたクラス
class DatabaseFactory {
  Future<Database> create() async {
    var databasesPath = await getDatabasesPath();
    //2.joinメソッドはpathパッケージのもの
    final path = join(databasesPath, 'siggmo.db');
    print("path=${path}");
    //3.データベースが作成されていない場合にonCreate関数が呼ばれる(はず…)
    return await openDatabase(path,
      version: 1,
      onCreate: (
        Database db,
        int version,
    ) async {
      await db.execute('''
      CREATE TABLE ${SiggmoDaoHelper._tableName} (
      ${SiggmoDaoHelper._columnMusicId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${SiggmoDaoHelper._columnMusicName} TEXT,
      ${SiggmoDaoHelper._columnMusicNameKana} TEXT,
      ${SiggmoDaoHelper._columnArtistName} TEXT,
      ${SiggmoDaoHelper._columnArtistNameKana} TEXT,
      ${SiggmoDaoHelper._columnAverage} REAL,
      ${SiggmoDaoHelper._columnMax} REAL,
      ${SiggmoDaoHelper._columnMin} REAL,
      ${SiggmoDaoHelper._columnLatest} REAL,
      ${SiggmoDaoHelper._columnLastTime} REAL,
      ${SiggmoDaoHelper._columnTwoTimesBefore} REAL,
      ${SiggmoDaoHelper._columnCreateDate} TEXT,
      ${SiggmoDaoHelper._columnUpdateDate} TEXT
      )''');
    },);
  }
}

//4.データの取得・追加・更新・削除の責務を持たせたクラス
class SiggmoDaoHelper{
  static const _tableName = 'siggmo';
  static const _columnMusicId = 'musicId';
  static const _columnMusicName = 'musicName';
  static const _columnMusicNameKana = 'musicNameKana';
  static const _columnArtistName = 'artistName';
  static const _columnArtistNameKana = 'artistNameKana';
  static const _columnAverage = 'average';
  static const _columnMax = 'max';
  static const _columnMin = 'min';
  static const _columnLatest = 'latest';
  static const _columnLastTime = 'lastTime';
  static const _columnTwoTimesBefore = 'twoTimesBefore';
  static const _columnCreateDate = 'createDate';
  static const _columnUpdateDate = 'updateDate';

  final DatabaseFactory _factory;
  late Database _db;

  SiggmoDaoHelper(this._factory);

  Future<void> open() async {
    _db = await _factory.create();
  }

  //全件取得
  Future<List?> queryAllRows() async {
    List<Map> maps = await _db.query(_tableName,
        columns: [
          _columnMusicId,
          _columnMusicName,
          _columnMusicNameKana,
          _columnArtistName,
          _columnArtistNameKana,
          _columnAverage,
          _columnMax,
          _columnMin,
          _columnLatest,
          _columnLastTime,
          _columnTwoTimesBefore,
          _columnCreateDate,
          _columnUpdateDate,
        ]);
    if(maps.isNotEmpty){
      return maps;
      // return Siggmo(
      //   maps.first[_columnMusicId],
      //   maps.first[_columnMusicName],
      //   maps.first[_columnMusicNameKana],
      //   maps.first[_columnArtistName],
      //   maps.first[_columnArtistNameKana],
      //   maps.first[_columnAverage],
      //   maps.first[_columnMax],
      //   maps.first[_columnMin],
      //   maps.first[_columnLatest],
      //   maps.first[_columnLastTime],
      //   maps.first[_columnTwoTimesBefore],
      //   maps.first[_columnCreateDate],
      //   maps.first[_columnUpdateDate],
      // );
    }
    return null;
  }

  //5.取得操作、Listで返却される
  Future<List?> fetch(Map musicArtist, Map averageMaxMin) async {
    print("--- start fetch ---");
    String sql = "select * from $_tableName where ";
    String where = '';
    if(musicArtist['musicName'] != '' && musicArtist['artistName'] != ''){
      where += "musicName = '"+musicArtist['musicName']+"' and artistName = '"+musicArtist['artistName']+"'";
    } else if(musicArtist['musicName'] != '' && musicArtist['artistName'] == ''){
      where += "musicName = '"+musicArtist['musicName']+"'";
    } else if(musicArtist['musicName'] == '' && musicArtist['artistName'] != ''){
      where += "artistName = '"+musicArtist['artistName']+"'";
    }
    sql += where;
    print(sql);

    //検索結果取得
    List<Map> maps = await _db.rawQuery(sql);
    print("maps = $maps");

    if(maps.isNotEmpty){
      return maps;
    }
    return null;
  }

  //6.挿入処理
  Future<void> insert(String musicName, String musicNameKana, String artistName, String artistNameKana, double average,
      double max, double min, double latest, double lastTime, double twoTimesBefore, String createDate, String updateDate) async {
    // ignore: avoid_print
    print(musicName + "," + musicNameKana + "," + artistName + "," + artistNameKana + ",$average,$max,$min,$latest,$lastTime,$twoTimesBefore," + createDate + "," + updateDate);

    await _db.insert(_tableName,{
      _columnMusicName: musicName,
      _columnMusicNameKana: musicNameKana,
      _columnArtistName: artistName,
      _columnArtistNameKana: artistNameKana,
      _columnAverage: average,
      _columnMax: max,
      _columnMin: min,
      _columnLatest: latest,
      _columnLastTime: lastTime,
      _columnTwoTimesBefore: twoTimesBefore,
      _columnCreateDate: createDate,
      _columnUpdateDate: updateDate,
    });
  }

  //7.削除処理
  Future<void> delete(int musicId) async {
    await _db.delete(_tableName,
    where: '$_columnMusicId = ?',
    whereArgs: [musicId],
    );
  }

  //8.更新処理
  Future<void> update(int musicId, String musicName, String musicNameKana, String artistName, String artistNameKana, double average, double max, double min, double latest, double lastTime, double twoTimesBefore, String createDate, String updateDate) async {
    await _db.update(
      _tableName,
      {
        _columnMusicId: musicId,
        _columnMusicName: musicName,
        _columnMusicNameKana: musicNameKana,
        _columnArtistName: artistName,
        _columnArtistNameKana: artistNameKana,
        _columnAverage: average,
        _columnMax: max,
        _columnMin: min,
        _columnLatest: latest,
        _columnLastTime: lastTime,
        _columnTwoTimesBefore: twoTimesBefore,
        _columnCreateDate: createDate,
        _columnUpdateDate: updateDate,
      },
      where: '$_columnMusicId = ?',
      whereArgs: [musicId]
    );
  }

  Future<void> close() async => _db.close();
}

//Facade的な責務
class SiggmoDao {
  final DatabaseFactory factory;

  const SiggmoDao(this.factory);

  Future<void> save(String musicName, String musicNameKana, String artistName, String artistNameKana, double average, double max, double min, double latest, double lastTime, double twoTimesBefore, String createDate, String updateDate) async {
    var helper = SiggmoDaoHelper(factory);
    try{
      //9.必ず最初にopenする
      await helper.open();
      await helper.insert(musicName, musicNameKana, artistName, artistNameKana, average, max, min, latest, lastTime, twoTimesBefore, createDate, updateDate);
    } on SqfliteDatabaseException catch (e){
      print(e.message);
    } finally {
      //10.必ず最後にcloseする
      await helper.close();
    }
  }

  //全件取得
  Future<List?> mainAllFetch() async {
    var helper = SiggmoDaoHelper(factory);
    try {
      await helper.open();
      return await helper.queryAllRows();
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

  Future<List?> fetch(Map musicArtist, Map averageMaxMin) async {
    var helper = SiggmoDaoHelper(factory);
    try {
      await helper.open();
      return await helper.fetch(musicArtist, averageMaxMin);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
      return null;
    } finally {
      await helper.close();
    }
  }

  Future<void> delete(int musicId) async {
    var helper = SiggmoDaoHelper(factory);
    try{
      await helper.open();
      await helper.delete(musicId);
    } on SqfliteDatabaseException catch (e) {
      print(e.message);
    } finally {
      await helper.close();
    }
  }
}