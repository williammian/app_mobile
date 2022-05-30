import 'package:app_mobile/services/storage_service.dart';

class ServidorService {
  static const String _key = 'servidor';

  final StorageService _storageService = StorageService();

  bool hasServidor() {
    String servidor = getServidor();
    return servidor.isNotEmpty;
  }

  String getServidor() {
    return _storageService.getItem(_key);
  }

  Future<String> getServidorAsync() async {
    return await _storageService.getItemAsync(_key);
  }

  Future<void> setServidor(String servidor) async {
    await _storageService.setItem(_key, servidor);
  }

  Future<void> removeServidor() async {
    await _storageService.deleteItem(_key);
  }
}
