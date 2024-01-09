import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:nosooh/components/loading_indicator.dart';
import 'package:nosooh/services/api_service.dart';
import 'package:nosooh/services/navigation_service.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:the_apple_sign_in/the_apple_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io' show Platform;

class AuthProvider extends APIService {
  String? countryCode;
  String? phoneNumber;
  final FirebaseAuth auth = FirebaseAuth.instance;
    String get deviceType {
    if (Platform.isAndroid) {
      return "2";
    } else if (Platform.isIOS) {
      return "1";
    }
    return "0";
  }
  Future<Map> login() async {
    const String loginApi = 'login';
    
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    final res = await postRequest(
            invalidTokenRedirection: false,
            url: webBaseUrl + loginApi,
            body: {'countryCode': countryCode, 'phoneNumber': phoneNumber,"device_token":fcmToken,"device_type":deviceType},
            hasToken: false)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {
          'status': false,
          'data': value.data['data'],
        };
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> loginGoogle(String email,String accessToken) async {
    const String loginApi = 'google/callback';
      String? fcmToken = await FirebaseMessaging.instance.getToken();
    final res = await getRequest(
            url: webBaseUrl + loginApi,queryParameters: {'code':accessToken,"device_token":fcmToken??"","device_type":deviceType})
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {
          'status': false,
          'data': value.data['data'],
        };
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> loginApple(String name,String email,String accessToken) async {
    const String loginApi = 'get-apple-details';
      String? fcmToken = await FirebaseMessaging.instance.getToken();
    final res = await postRequest(
            url: webBaseUrl + loginApi,body: {"Name":name,"Email":email,'token':accessToken,"device_token":fcmToken??"","device_type":deviceType})
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 ) {
        return {
          'status': true,
          'data': value.data['data'],
        };
      } else {
        return {
          'status': false,
          'data': value.data['data'],
        };
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> login2({
    required String email,
    required String password,
  }) async {
    const String loginApi = 'login';
      String? fcmToken = await FirebaseMessaging.instance.getToken();

    final res = await postRequest(
            invalidTokenRedirection: false,
            url: webBaseUrl + loginApi,
            body: {'email': email, 'password': password,"device_token":fcmToken??"","device_type":deviceType},
            hasToken: false)
        .then((value) async {
          print(value.data);
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {
          'status': false,
          'data': value.data,
        };
      }
    }).catchError((error) {
      print(error);
      return {
        'status': false,
        'msg':"Please try again later"
      };
    });
    return res;
  }

  signInWithGoogle() async {
    try{
      
      final GoogleSignInAccount? googleSignInAccount =
          await GoogleSignIn().signIn();
      if (googleSignInAccount == null) {
        // User cancelled the sign-in process
        return;
      }
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential authResult =
          await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      // Check if it's the first time the user is registering
      if (user != null) {
        if (authResult.additionalUserInfo?.isNewUser == true) {
          // This is a new user
          print('This is the first time the user is registering');
        } else {
          // This is an existing user
          print('This is an existing user');
        }
        // Access token
        final String accessToken = googleSignInAuthentication.accessToken!;
        print('Access Token: $accessToken');

        // User's email
        final String userEmail = user.email!;
        print('Email: $userEmail');

        // User's photo URL
        final String userPhotoURL =
            user.photoURL ?? ""; // You can check if photoURL is null
        print('Profile Picture URL: $userPhotoURL');

        return await loginGoogle(userEmail,accessToken);
      }
    } catch (error) {
      print("Error while signing with google $error");
    }
   
  }

  signInWithApple({List<Scope> scopes = const []}) async {
   /* final result = await TheAppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final AppleIdCredential = result.credential!;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
            idToken: String.fromCharCodes(AppleIdCredential.identityToken!));
        final UserCredential = await auth.signInWithCredential(credential);
        final firebaseUser = UserCredential.user!;
        if (scopes.contains(Scope.fullName)) {
          final fullName = AppleIdCredential.fullName;
          if (fullName != null &&
              fullName.givenName != null &&
              fullName.familyName != null) {
            final displayName = '${fullName.givenName} ${fullName.familyName}';
            await firebaseUser.updateDisplayName(displayName);
          }
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
            code: 'ERROR_AUTHORIZATION_DENIED',
            message: result.error.toString());

      case AuthorizationStatus.cancelled:
        throw PlatformException(
            code: 'ERROR_ABORTED_BY_USER', message: 'Sign in aborted by user');

      default:
        throw UnimplementedError();
    }*/

    final AuthorizationCredentialAppleID credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    print("Apple login Successfull, user ${credential?.givenName} with email ${credential?.email}. user token ${credential?.authorizationCode}");
    return await loginApple(credential.givenName??"",credential.email??"",credential.authorizationCode!);
  }

  Future<Map> forgetPassword({
    required String email,
  }) async {
    final res = await postRequestFormData(
            invalidTokenRedirection: false,
            url: 'https://evastocks.com/api/forgot-password',
            body: {
              'email': email,
            },
            hasToken: false)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {
          'status': false,
          'data': value.data,
        };
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> register({
    required String email,
    required String name,
    required String password,
  }) async {
    const String loginApi = 'register';
    String? fcmToken = await FirebaseMessaging.instance.getToken();

    final res = await postRequest(
            invalidTokenRedirection: false,
            url: webBaseUrl + loginApi,
            body: {
              'countryCode': countryCode,
              'phoneNumber': phoneNumber,
              'email': email,
              'name': name,
              'phone': phoneNumber,
              'password': password,
              "device_token":fcmToken??"",
              "device_type":deviceType
            },
            hasToken: false)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['code'].toString() == '0') {
        return {
          'status': true,
          'data': value.data,
        };
      } else {
        return {
          'status': false,
          'data': value.data,
        };
      }
    }).catchError((error) {
      return {
        'status': false,
      };
    });
    return res;
  }

  Future<Map> verifyOTP({
    required String otp,
  }) async {
    const String loginApi = 'verify';

    final res = await postRequest(
            invalidTokenRedirection: false,
            url: webBaseUrl + loginApi,
            body: {
              'countryCode': countryCode,
              'phoneNumber': phoneNumber,
              'otp': otp
            },
            hasToken: false)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        await updateJWTToken(jwtToken: value.data['data']['token']);
        notifyListeners();
        return {'status': true, 'data': value.data['data']};
      } else if (value.data['success'].toString() == 'false' &&
          value.data['response_code'] == 429) {
        return {
          'status': false,
          'data': 'robot-verification',
          'questionAndAnswers': value.data['data']
        };
      } else {
        return {
          'status': false,
        };
      }
    });
    return res;
  }

  Future<Map> verifyChallenge({
    required String answer,
  }) async {
    const String loginApi = 'verify-challenge';

    final res = await postRequest(
            invalidTokenRedirection: false,
            url: webBaseUrl + loginApi,
            body: {
              'countryCode': countryCode,
              'phoneNumber': phoneNumber,
              'answer': answer
            },
            hasToken: false)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        await updateJWTToken(jwtToken: value.data['data']['token']);
        notifyListeners();
        return {
          'status': true,
        };
      } else {
        return {
          'status': false,
        };
      }
    });
    return res;
  }

  Future<Map> logout() async {
    const String loginApi = 'logout';

    final res = await postRequest(
            invalidTokenRedirection: false,
            url: webBaseUrl + loginApi,
            body: {},
            hasToken: false)
        .then((value) async {
      if (value.statusCode! >= 200 &&
          value.statusCode! <= 299 &&
          value.data['success'].toString() == 'true') {
        return {
          'status': true,
        };
      } else {
        return {
          'status': false,
        };
      }
    });
    return res;
  }

  Future<Map> updatePersonalInfo({
    required String martialStatus,
    required String familyMembers,
    required String annualIncome,
    required String netSavings,
    required String educationalLevel,
    required String briefYourself,
    required String birthDate,
    required String email,
    required String personalNumber,
    required String fullName,
    required String userName,
    File? image,
  }) async {
    Map<String, String> generalHeaders = {
      'language':
          AppLocalizations.of(NavigationService.context!)!.localeName == 'en'
              ? '2'
              : '1',
      'deviceType': '2',
      'deviceToken': '',
      'x-app-version': '1.1'
    };
    String endPoint =
        'update-personal-info?martialStatus=$martialStatus&familyMembers=$familyMembers&annualIncome=$annualIncome&netSavings=$netSavings&educationalLevel=$educationalLevel&briefYourself=$briefYourself&birthDate=$birthDate&email=$email&personalNumber=$personalNumber&fullName=$fullName&userName=$userName';

    showDialog(
        context: NavigationService.context!,
        builder: (ctx) => LoadingIndicator(),
        barrierColor: Colors.black12,
        barrierDismissible: false);

    final request = http.MultipartRequest(
      'POST',
      Uri.parse(webBaseUrl + endPoint),
    );

    if (image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('userImage', image.path));
    }

    request.headers.addAll(generalHeaders);

    final token = await getJWTToken();
    request.headers.addAll({'Authorization': 'Bearer $token'});

    final res = await request.send().then((value) async {
      Navigator.of(NavigationService.context!).pop();

      String respStr = await value.stream.bytesToString();
      print(respStr);
      if (value.statusCode >= 200 &&
          value.statusCode <= 299 &&
          jsonDecode(respStr)['success'] == true) {
        return {
          'status': true,
          //'data': value.data['data'],
        };
      } else {
        return {'status': false, 'data': null};
      }
    }).catchError((error) {
      print(error);
      return {
        'status': false,
      };
    });
    return res;
  }
}
