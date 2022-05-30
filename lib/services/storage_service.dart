import 'package:localstorage/localstorage.dart';

class StorageService {
  final LocalStorage _storage = LocalStorage('app_session');

  String getItem(String key) {
    final value = _storage.getItem(key);
    return value != null ? value.toString() : '';
  }

  Future<String> getItemAsync(String key) async {
    await _storage.ready;
    final value = _storage.getItem(key);
    return value != null ? value.toString() : '';
  }

  Future<void> setItem(String key, String value) async {
    await _storage.ready;
    await _storage.setItem(key, value);
    Future.delayed(const Duration(seconds: 2));
  }

  Future<void> deleteItem(String key) async {
    await _storage.ready;
    await _storage.deleteItem(key);
    Future.delayed(const Duration(seconds: 2));
  }
}
