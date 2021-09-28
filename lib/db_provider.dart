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
    print("=== create method now ===");
    var databasesPath = await getDatabasesPath();
    //2.joinメソッドはpathパッケージのもの
    final path = join(databasesPath, 'siggmo.db');
    //3.データベースが作成されていない場合にonCreate関数が呼ばれる
    return await openDatabase(path, version: 1, onCreate: (
        Database db,
        int version,
    ) async {
      await db.execute('''
      create table ${SiggmoDaoHelper._tableName} (
      ${SiggmoDaoHelper._columnMusicId} int primary key auto increment,
      ${SiggmoDaoHelper._columnMusicName} text,
      ${SiggmoDaoHelper._columnMusicNameKana} text,
      ${SiggmoDaoHelper._columnArtistName} text,
      ${SiggmoDaoHelper._columnArtistNameKana} text,
      ${SiggmoDaoHelper._columnAverage} real,
      ${SiggmoDaoHelper._columnMax} real,
      ${SiggmoDaoHelper._columnMin} real,
      ${SiggmoDaoHelper._columnLatest} real,
      ${SiggmoDaoHelper._columnLastTime} real,
      ${SiggmoDaoHelper._columnTwoTimesBefore} real,
      ${SiggmoDaoHelper._columnCreateDate} text,
      ${SiggmoDaoHelper._columnUpdateDate} text
      )
      ''');
    });
  }
}

//4.データの取得・追加・更新・削除の責務を持たせたクラス
class SiggmoDaoHelper{
  static const _tableName = 'Siggmo';
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
    print("=== open method now ===");
    _db = await _factory.create();
  }

  //5.取得操作、必ずListで返却される
  Future<Siggmo?> fetch(int musicId) async {
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
    ],
    where: '$_columnMusicId = ?',
    whereArgs: [musicId]);
    if(maps.isNotEmpty){
      return Siggmo(
        maps.first[_columnMusicId],
        maps.first[_columnMusicName],
        maps.first[_columnMusicNameKana],
        maps.first[_columnArtistName],
        maps.first[_columnArtistNameKana],
        maps.first[_columnAverage],
        maps.first[_columnMax],
        maps.first[_columnMin],
        maps.first[_columnLatest],
        maps.first[_columnLastTime],
        maps.first[_columnTwoTimesBefore],
        maps.first[_columnCreateDate],
        maps.first[_columnUpdateDate],
      );
    }
    return null;
  }

  //6.挿入処理
  Future<void> insert(String musicName, String musicNameKana, String artistName, String artistNameKana, double average, double max, double min, double latest, double lastTime, double twoTimesBefore, String createDate, String updateDate) async {
    print("=== insert method now ===");
    print(musicName + "," + musicNameKana + "," + artistName + "," + artistNameKana + ",${average},${max},${min},${latest},${lastTime},${twoTimesBefore}," + createDate + "," + updateDate);
    print("=========================");
    print("=== 全件取得 ===");
    print (queryAllRows());
    print("===============");

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

  //全件取得
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    print("--- start 全件取得 ---");
    return await _db.query('siggmo.db'); //全件取得
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

  Future<Siggmo?> fetch(int musicId, String musicName, String artistName, String artistNameKana, double average, double max, double min, double latest, double lastTime, double twoTimesBefore, String createDate, String updateDate) async {
    var helper = SiggmoDaoHelper(factory);
    try {
      await helper.open();
      return await helper.fetch(musicId);
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