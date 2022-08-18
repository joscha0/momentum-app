import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/models/app_user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

const String baseAuthUrl = "https://auth.momentum-mod.org/auth";

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
    if (refreshToken != null && refreshToken != "") {
      String body = json.encode({'refreshToken': refreshToken});
      http.Response response = await http.post(
        Uri.parse("$baseAuthUrl/refresh"),
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      if (response.statusCode == 200) {
        final Map data = jsonDecode(response.body);
        if (data.containsKey("accessToken")) {
          return AppUser.fromJson(
              jsonDecode(prefs.getString("steamUser") ?? ""),
              refreshToken,
              data['accessToken']);
        }
      } else {
        throw Exception(response.reasonPhrase);
      }
    }
    return null;
  }
}

final authProvider = Provider<AuthService>((ref) => AuthService());

final userProvider = FutureProvider<AppUser?>((ref) async {
  return ref.read(authProvider).getUser();
});
