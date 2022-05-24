import 'package:localstorage/localstorage.dart';

class StorageService {
  static const String KEY_SERVIDOR = 'servidor';

  final LocalStorage _storage = LocalStorage('app_session');

  Future<String> getItem(String key) async {
    await _storage.ready;
    final value = await _storage.getItem(key);
    return value != null ? value.toString() : '';
  }

  Future<void> setItem(String key, String value) async {
    await _storage.ready;
    await _storage.setItem(key, value);
  }

  Future<void> deleteItem(String key) async {
    await _storage.ready;
    await _storage.deleteItem(key);
  }
}
