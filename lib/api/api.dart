import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:momentum/global/config.dart';
import 'package:momentum/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class API {
  static const String baseAuthUrl = CONFIG.releaseMode
      ? "https://auth.momentum-mod.org/auth/"
      : "http://192.168.1.72:3002/auth/";
  static const String baseUrl = CONFIG.releaseMode
      ? "https://api.momentum-mod.org/api"
      : "http://192.168.1.72:3002/api";
  static const String dashboardUrl = CONFIG.releaseMode
      ? "https://momentum-mod.org/dashboard"
      : "http://192.168.1.72:3002/dashboard";

  static Future<String?> getNewAccessToken(String refreshToken) async {
    String body = json.encode({'refreshToken': refreshToken});
    http.Response response = await http.post(
      Uri.parse("$baseAuthUrl/refresh"),
      headers: {"Content-Type": "application/json"},
      body: body,
    );
    if (response.statusCode == 200) {
      final Map data = jsonDecode(response.body);
      if (data.containsKey("accessToken")) {
        return data['accessToken'];
      }
    } else {
      log("getNewAccessToken${response.reasonPhrase ?? ""}");
    }

    return null;
  }

  static String mapToParamsString(Map params) {
    String paramsString = "?";
    for (var param in params.keys) {
      if (params[param] != null) {
        paramsString = "$paramsString$param=${params[param]}&";
      }
    }
    return paramsString.substring(0, paramsString.length - 1);
  }

  static Future<Map<String, dynamic>?> apiRequest(String url,
      {Map params = const {}}) async {
    final prefs = await SharedPreferences.getInstance();
    String? refreshToken = prefs.getString("refreshToken");
    String? accessToken = prefs.getString("accessToken");
    if (refreshToken != null && accessToken != null) {
      if (Jwt.isExpired(accessToken)) {
        accessToken = await getNewAccessToken(refreshToken);
      }
      if (accessToken != null) {
        String headers = json.encode({'authorization': "Bearer $accessToken"});
        String paramsString = mapToParamsString(params);
        http.Response response = await http.get(
          Uri.parse("$baseUrl/$url$paramsString"),
          headers: {
            "Content-Type": "application/json",
            "authorization": "Bearer $accessToken"
          },
        );
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          if (!data.containsKey("error")) {
            return data;
          }
        } else {
          log("apiRequest $url ${response.reasonPhrase ?? ""}");
        }
      }
    }
    return null;
  }

  static Future<List<User>> getUsers({
    int? limit,
    int? offset,
    String? search,
  }) async {
    Map? data = await apiRequest("users/",
        params: {"limit": limit, "offset": offset, "search": search});
    if (data != null) {
      List<User> users = [];
      for (var user in data['users']) {
        users.add(User.fromJson(user));
      }
      return users;
    }
    return [];
  }

  static Future<Map<String, dynamic>?> getUser() async {
    return await apiRequest(
      "user/",
    );
  }
}
