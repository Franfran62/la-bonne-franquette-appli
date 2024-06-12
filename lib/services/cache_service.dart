import 'package:hive/hive.dart';

class CacheService {
  Future<void> saveCacheVersion(String version) async {
    var box = await Hive.openBox('cache');
    box.put('cacheVersion', version);
  }

  Future<String?> getCacheVersion() async {
    var box = await Hive.openBox('cache');
    return box.get('cacheVersion');
  }

    Future<void> clearCache() async {
    var box = await Hive.openBox('cache');
    await box.clear();
  }
}