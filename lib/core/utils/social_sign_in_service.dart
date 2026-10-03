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
    required this.idToken,
    this.givenName,
    this.familyName,
  });

  /// Firebase ID token obtained after Apple authentication. This is what the
  /// Walima backend verifies; never send Apple's raw identity token instead.
  final String idToken;
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

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: const [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      nonce: nonce,
    );

    final identityToken = appleCredential.identityToken?.trim() ?? '';
    if (identityToken.isEmpty) {
      throw StateError('Apple sign-in returned empty credentials.');
    }

    final givenName = _nonEmpty(appleCredential.givenName);
    final familyName = _nonEmpty(appleCredential.familyName);

    final credential = AppleAuthProvider.credentialWithIDToken(
      identityToken,
      rawNonce,
      AppleFullPersonName(givenName: givenName, familyName: familyName),
    );
    final userCredential = await FirebaseAuth.instance.signInWithCredential(
      credential,
    );
    final firebaseIdToken =
        (await userCredential.user?.getIdToken(true))?.trim() ?? '';

    if (firebaseIdToken.isEmpty) {
      throw StateError('Firebase sign-in returned empty ID token.');
    }

    return AppleSignInResult(
      idToken: firebaseIdToken,
      givenName: givenName,
      familyName: familyName,
    );
  }

  static Future<void> signOutFirebase() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (_) {}
  }

  static String? _nonEmpty(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? null : trimmed;
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
