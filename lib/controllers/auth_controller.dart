import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class User {
  final String name;
  final String email;
  final String photoUrl;

  User({required this.name, required this.email, required this.photoUrl});
}

class AuthController extends GetxController {
  User _user = User(email: '', photoUrl: '', name: '');
  RxBool _isLoading = false.obs;

  User get user => _user;
  bool get isLoading => _isLoading.value;

  Future<void> loginWithGoogle() async {
    try {
      _isLoading.value = true;
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider?.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        final result =
            await FirebaseAuth.instance.signInWithCredential(credential);

        final prefs = await SharedPreferences.getInstance();
        final userData = json.encode({
          'name': result.user?.displayName,
          'email': result.user?.email,
          'photoUrl': result.user?.photoURL
        });
        prefs.setString('userData', userData);
      }
    } on FirebaseAuthException catch (error) {
      print(error.toString());
    } on PlatformException catch (error) {
      if (error.code.contains("sign_in_canceled")) {
        // Checks for sign_in_canceled exception
        print(error.toString());
      }
    } catch (error) {
      print(error.toString());
    } finally {
      _isLoading.value = false;
    }
  }

  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      final prefs = await SharedPreferences.getInstance();
      prefs.remove('userData');
      User clearUserInfo = User(name: '', email: '', photoUrl: '');
      _user = clearUserInfo;
      update();
    } catch (error) {
      throw error;
    }
  }

  Future<void> obtainUserDataFromStorage() async {
    try {
      User personalData = User(name: '', email: '', photoUrl: '');
      final prefs = await SharedPreferences?.getInstance();
      if (prefs.containsKey('userData')) {
        final extractedUserData =
            json.decode(prefs.getString('userData')!) as Map<String, dynamic>;

        personalData = User(
            name: extractedUserData['name'],
            email: extractedUserData['email'],
            photoUrl: extractedUserData['photoUrl']);
        _user = personalData;
        print(personalData.photoUrl);
        update();
      }
    } catch (error) {
      throw error;
    }
  }
}
