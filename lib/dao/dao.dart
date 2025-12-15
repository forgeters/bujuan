// import 'dart:convert';
//
// import 'package:audio_service/audio_service.dart';
// import 'package:bujuan_music/dao/played_info_entity.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
//
// class PlayedInfoDatabase {
//   static final PlayedInfoDatabase _instance = PlayedInfoDatabase._internal();
//
//   factory PlayedInfoDatabase() => _instance;
//
//   PlayedInfoDatabase._internal();
//
//   Database? _database;
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDatabase();
//     return _database!;
//   }
//
//   Future<Database> _initDatabase() async {
//     final path = join(await getDatabasesPath(), 'bujuan_tv.db');
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (db, version) async {
//         await db.execute('''
//           CREATE TABLE played_info(
//             id TEXT PRIMARY KEY,
//             name TEXT,
//             playIndex INTEGER,
//             progress INTEGER,
//             playlist TEXT
//           )
//         ''');
//       },
//     );
//   }
//
//   // 插入或更新记录
//   Future<void> insertOrUpdate(PlayedInfoEntity info) async {
//     final db = await database;
//     final data = info.toJson();
//     // urls 是复杂对象，单独序列化成字符串存储
//     data['playlist'] = jsonEncode(
//       info.playlist?.map((e) {
//             return e.toJson();
//           }).toList() ??
//           [],
//     );
//     await db.insert('played_info', data, conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   // 获取所有播放记录
//   Future<List<PlayedInfoEntity>> getAllPlayedInfo() async {
//     final db = await database;
//     final List<Map<String, dynamic>> maps = await db.query(
//       'played_info'
//     );
//
//     return maps.map((first) {
//       // 解析 urls
//       List<MediaItem> urls = [];
//       final rawUrls = first['playlist'];
//       if (rawUrls != null) {
//         if (rawUrls is String) {
//           try {
//             final decoded = jsonDecode(rawUrls);
//             if (decoded is List) {
//               urls = decoded.map((e) => MediaItemJsonFactory.fromJson(e)).toList();
//             }
//           } catch (e) {
//             print('Failed to decode urls: $e');
//           }
//         } else if (rawUrls is List) {
//           urls = rawUrls.map((e) => MediaItemJsonFactory.fromJson(e)).toList();
//         }
//       }
//
//       // 创建可变 Map，替换 urls
//       final mutableMap = Map<String, dynamic>.from(first);
//       mutableMap['playlist'] = urls;
//
//       final playedInfoEntity = PlayedInfoEntity.fromJson(mutableMap);
//       return playedInfoEntity;
//     }).toList();
//   }
//
//   // 获取单个播放记录
//   Future<PlayedInfoEntity?> getRecord(String id) async {
//     final db = await database;
//     final maps = await db.query('played_info', where: 'id = ?', whereArgs: [id]);
//
//     if (maps.isEmpty) return null;
//
//     final first = maps.first;
//
//     // 解析 urls
//     List<MediaItem> urls = [];
//     final rawUrls = first['urls'];
//     if (rawUrls != null) {
//       if (rawUrls is String) {
//         try {
//           final decoded = jsonDecode(rawUrls);
//           if (decoded is List) {
//             urls = decoded.map((e) => MediaItemJsonFactory.fromJson(e)).toList();
//           }
//         } catch (e) {
//           print('Failed to decode urls: $e');
//         }
//       } else if (rawUrls is List) {
//         urls = rawUrls.map((e) => MediaItemJsonFactory.fromJson(e)).toList();
//       }
//     }
//
//     // 创建可变 Map，替换 urls
//     final mutableMap = Map<String, dynamic>.from(first);
//     mutableMap['urls'] = urls;
//
//     final playedInfoEntity = PlayedInfoEntity.fromJson(mutableMap);
//     return playedInfoEntity;
//   }
//
//   // 删除播放记录
//   Future<void> deleteRecord(String id) async {
//     final db = await database;
//     await db.delete('played_info', where: 'id = ?', whereArgs: [id]);
//   }
//
//   // 清空所有记录
//   Future<void> clearAll() async {
//     final db = await database;
//     await db.delete('played_info');
//   }
// }
