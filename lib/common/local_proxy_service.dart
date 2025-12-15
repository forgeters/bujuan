import 'dart:io';

import 'package:bujuan_music_api/api/song/entity/song_url_entity.dart';
import 'package:bujuan_music_api/common/music_api.dart';

class LocalProxyService {
  LocalProxyService._internal();

  static final LocalProxyService _instance = LocalProxyService._internal();

  factory LocalProxyService() => _instance;

  final int port = 8848;
  final Map<String, _CachedUrl> _cache = {}; // songId -> URL + expire
  final Map<String, DateTime> _lastRequestTime = {}; // songId -> 最近请求时间
  HttpServer? _server;
  bool _started = false;

  final Duration minInterval = Duration(seconds: 1); // 最小请求间隔

  Future<void> start() async {
    if (_started) return;
    _server = await HttpServer.bind(InternetAddress.loopbackIPv4, port);
    _started = true;
    print('LocalProxyService running on http://127.0.0.1:$port');
    _server!.listen((HttpRequest request) async {
      final path = request.uri.path;

      if (path.startsWith('/song/')) {
        final songId = path.split('/').last;

        try {
          // ① 获取真实播放地址
          final realUrl = await _getUrl(songId);
          if (realUrl.isEmpty) throw 'Real URL is empty';

          print('$songId  --->  $realUrl');

          // ② 转发真实音频请求（流式）
          final client = HttpClient();
          final realRequest = await client.getUrl(Uri.parse(realUrl));
          final realResponse = await realRequest.close();

          // ③ 把真实响应头复制给本地响应
          realResponse.headers.forEach((name, values) {
            request.response.headers.set(name, values.join(','));
          });

          request.response.statusCode = realResponse.statusCode;

          // ④ 流式转发（关键）
          await realResponse.pipe(request.response);
        } catch (e) {
          request.response
            ..statusCode = 500
            ..write('Proxy error: $e')
            ..close();
        }
      } else {
        request.response
          ..statusCode = 404
          ..write('Not found')
          ..close();
      }
    });

    // _server!.listen((HttpRequest req) async {
    //   final path = req.uri.path;
    //   if (path.startsWith('/song/')) {
    //     final songId = path.replaceFirst('/song/', '');
    //     try {
    //       final url = await _getUrl(songId);
    //       if (url.isEmpty) throw 'URL empty';
    //
    //       final client = HttpClient();
    //       final proxiedRequest = await client.getUrl(Uri.parse(url));
    //       final proxiedResponse = await proxiedRequest.close();
    //
    //       proxiedResponse.headers.forEach((name, values) {
    //         req.response.headers.set(name, values.join(','));
    //       });
    //
    //       await req.response.addStream(proxiedResponse);
    //       await req.response.close();
    //     } catch (e) {
    //       req.response.statusCode = 500;
    //       req.response.write('Failed to stream URL: $e');
    //       await req.response.close();
    //     }
    //   } else {
    //     req.response.statusCode = 404;
    //     await req.response.close();
    //   }
    // });
  }

  Future<String> _getUrl(String songId) async {
    final now = DateTime.now();

    // 拦截短时间内重复请求
    final lastTime = _lastRequestTime[songId];
    if (lastTime != null && now.difference(lastTime) < minInterval) {
      return _cache[songId]?.url ?? '';
    }
    _lastRequestTime[songId] = now;

    // 缓存有效直接返回
    final cached = _cache[songId];
    if (cached != null && cached.expire.isAfter(now.add(Duration(seconds: 15)))) {
      return cached.url;
    }

    // 缓存不存在或过期 → 请求后端
    final newUrl = await fetchUrlFromServer(songId);
    final expire = now.add(Duration(minutes: 15));
    _cache[songId] = _CachedUrl(newUrl, expire);

    return newUrl;
  }

  Future<String> fetchUrlFromServer(String songId) async {
    SongUrlEntity? songUrlEntity = await BujuanMusicManager().songUrl(ids: [songId]);
    if (songUrlEntity != null && (songUrlEntity.data ?? []).isNotEmpty) {
      return songUrlEntity.data!.first.url ?? '';
    }
    return '';
  }

  String proxyUrl(String songId) => 'http://127.0.0.1:$port/song/$songId';
}

class _CachedUrl {
  final String url;
  final DateTime expire;

  _CachedUrl(this.url, this.expire);
}
