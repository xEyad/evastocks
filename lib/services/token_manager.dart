import 'package:firebase_auth/firebase_auth.dart'; 
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    try{
      await GoogleSignIn().disconnect();
    }catch(e){}
    try{
      await FirebaseAuth.instance.signOut();
    }catch(e){}
  }
}
