import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/api/api.dart';
import 'package:momentum/models/app_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  Future<void> _clearPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("accessToken");
    prefs.remove("refreshToken");
    prefs.remove("steamUser");
  }

  Future<AppUser?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    // await _clearPrefs();
    String? refreshToken = prefs.getString("refreshToken");
    // print(refreshToken);
    if (refreshToken != null && refreshToken != "") {
      String? accessToken = await API.getNewAccessToken(refreshToken);
      if (accessToken != null) {
        return AppUser.fromJson(jsonDecode(prefs.getString("steamUser") ?? ""),
            refreshToken, accessToken);
      }
    }
    return null;
  }
}

final authProvider = Provider<AuthService>((ref) => AuthService());

final userProvider = FutureProvider<AppUser?>((ref) async {
  return ref.read(authProvider).getUser();
});
