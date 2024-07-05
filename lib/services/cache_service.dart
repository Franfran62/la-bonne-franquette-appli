import 'package:hive/hive.dart';

class CacheService {
  static Future<void> saveCacheVersion(String version) async {
    var box = await Hive.openBox('cache');
    box.put('cacheVersion', version);
  }

  static Future<String?> getCacheVersion() async {
    var box = await Hive.openBox('cache');
    return box.get('cacheVersion');
  }

    static Future<void> clearCache() async {
    var box = await Hive.openBox('cache');
    await box.clear();
  }
}