import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:momentum/pages/auth.dart';
import 'package:momentum/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SteamLogin extends ConsumerWidget {
  final _webView = FlutterWebviewPlugin();

  SteamLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref, [bool mounted = true]) {
    _webView.onUrlChanged.listen((String url) async {
      if (url == "https://momentum-mod.org/dashboard") {
        var cookies = await _webView.getCookies();
        final prefs = await SharedPreferences.getInstance();

        prefs.setString("accessToken", cookies[" accessToken"] ?? "");
        prefs.setString("refreshToken",
            (cookies[" refreshToken"] ?? "").replaceAll(RegExp(r'"'), ""));
        prefs.setString(
            "steamUser", Uri.decodeComponent(cookies['"user'] ?? ""));
        // TODO once https://github.com/fluttercommunity/flutter_webview_plugin/issues/911 is fixed remove "
        await _webView.close();
        ref.refresh(userProvider);
        await ref.read(userProvider.future);
        if (!mounted) return;
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: ((context) => const AuthPage())),
            (route) => false);
      }
    });

    return WebviewScaffold(
        url: "https://api.momentum-mod.org/auth/steam",
        appBar: AppBar(
          title: const Text('Steam Login'),
        ));
  }
}
