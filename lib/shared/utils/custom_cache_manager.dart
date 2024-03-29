// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:file/file.dart' as file;
import 'package:file/local.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// ignore: implementation_imports
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart' as filesystem;
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import 'custom_logger.dart';

class CustomCacheManager {
  static const _keyCustomCacheImage = 'coolmovies';
  static CacheManager? _instanceCache;

  static CacheManager get instance {
    _instanceCache ??= CacheManager(
      Config(
        _keyCustomCacheImage,
        stalePeriod: const Duration(days: 7),
        repo: JsonCacheInfoRepository(databaseName: _keyCustomCacheImage),
        fileSystem: _IOFileSystem(_keyCustomCacheImage),
        fileService: HttpFileService(),
      ),
    );
    return _instanceCache!;
  }

  /// Clear all cache
  static Future<void> clear({
    bool clearBackgroundImages = true,
    bool clearLiveImages = true,
    bool clearCacheImage = true,
  }) async {
    if (clearBackgroundImages) imageCache.clear();

    if (clearLiveImages) imageCache.clearLiveImages();

    if (clearCacheImage) instance.emptyCache().then((_) => LoggerApp.success('DELETED CACHED IMAGES'));
  }
}

class _IOFileSystem implements filesystem.FileSystem {
  final Future<file.Directory> _fileDir;

  _IOFileSystem(String key) : _fileDir = _createDirectory(key);

  static Future<file.Directory> _createDirectory(String key) async {
    try {
      final Directory baseDir = await getApplicationDocumentsDirectory();

      final String target = path.join(baseDir.path, key);

      final directory = const LocalFileSystem().directory((target));

      if (!directory.existsSync()) directory.createSync(recursive: true);

      return directory;
    } catch (e) {
      final Directory baseDir = await getTemporaryDirectory();

      final String target = path.join(baseDir.path, key);

      return const LocalFileSystem().directory(target);
    }
  }

  @override
  Future<file.File> createFile(String name) async => (await _fileDir).childFile(name);
}
