import 'package:flutter_secure_storage/flutter_secure_storage.dart';

mixin TokenManager {
  final secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        encryptedSharedPreferences: true,
      ));

  updateJWTToken({required String jwtToken}) async {
    await secureStorage.write(
      key: 'jwtToken',
      value: jwtToken,
    );
  }

  getJWTToken() async {
   return await secureStorage.read(key: 'jwtToken').catchError((error) {
      print('Error while getting JWT');
      throw error;
    });
  }

  logout() async {
    await secureStorage.deleteAll();
  }
}
