import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class GoogleSignInResult {
  const GoogleSignInResult({
    required this.idToken,
    required this.accessToken,
    this.serverAuthCode,
  });

  final String idToken;
  final String accessToken;
  final String? serverAuthCode;
}

class AppleSignInResult {
  const AppleSignInResult({
    required this.identityToken,
    required this.authorizationCode,
    required this.nonce,
    this.email,
    this.givenName,
    this.familyName,
  });

  final String identityToken;
  final String authorizationCode;
  final String nonce;
  final String? email;
  final String? givenName;
  final String? familyName;
}

class SocialSignInService {
  SocialSignInService._();

  static Future<GoogleSignInResult?> signInWithGoogle() async {
    if (kIsWeb) {
      throw UnsupportedError('Google sign-in is not configured for web.');
    }

    final googleSignIn = GoogleSignIn(
      scopes: const <String>['email', 'profile'],
    );

    final account = await googleSignIn.signIn();
    if (account == null) return null;

    final authentication = await account.authentication;
    final googleIdToken = authentication.idToken?.trim() ?? '';
    final accessToken = authentication.accessToken?.trim() ?? '';
    final serverAuthCode = account.serverAuthCode?.trim();

    if (googleIdToken.isEmpty && accessToken.isEmpty) {
      try {
        await googleSignIn.signOut();
      } catch (_) {}
      throw StateError('Google sign-in returned empty credentials.');
    }

    final credential = GoogleAuthProvider.credential(
      idToken: googleIdToken.isEmpty ? null : googleIdToken,
      accessToken: accessToken.isEmpty ? null : accessToken,
    );
    final userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    final firebaseIdToken =
        (await userCredential.user?.getIdToken(true))?.trim() ?? '';

    if (firebaseIdToken.isEmpty) {
      throw StateError('Firebase sign-in returned empty ID token.');
    }

    return GoogleSignInResult(
      idToken: firebaseIdToken,
      accessToken: accessToken,
      serverAuthCode: serverAuthCode?.isEmpty == true ? null : serverAuthCode,
    );
  }

  static Future<AppleSignInResult?> signInWithApple() async {
    if (kIsWeb) {
      throw UnsupportedError('Apple sign-in is not supported on web.');
    }

    final rawNonce = _generateNonce();
    final nonce = _sha256OfString(rawNonce);

    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final identityToken = credential.identityToken?.trim() ?? '';
    final authorizationCode = credential.authorizationCode.trim();

    if (identityToken.isEmpty || authorizationCode.isEmpty) {
      throw StateError('Apple sign-in returned empty credentials.');
    }

    return AppleSignInResult(
      identityToken: identityToken,
      authorizationCode: authorizationCode,
      nonce: rawNonce,
      email: credential.email,
      givenName: credential.givenName,
      familyName: credential.familyName,
    );
  }

  static String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  static String _sha256OfString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
