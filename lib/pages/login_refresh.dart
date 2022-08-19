import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/api/api.dart';
import 'package:momentum/pages/auth.dart';
import 'package:momentum/providers/auth_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRefresh extends ConsumerStatefulWidget {
  const LoginRefresh({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginRefresh> createState() => _LoginRefreshState();
}

class _LoginRefreshState extends ConsumerState<LoginRefresh> {
  late TextEditingController _controller;
  String errorMsg = "";
  bool loading = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login with refresh token')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Get your refresh token in Chrome: \nDev tools - Application - Storage - Cookies - refreshToken Value"),
          ),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                "Get your refresh token in Firefox: \nDev tools - Storage - Cookies - refreshToken Value"),
          ),
          TextField(
            controller: _controller,
            onChanged: (value) {
              setState(() {
                errorMsg = "";
              });
            },
            decoration: const InputDecoration(
                hintText:
                    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTU4NTcsImlhdCI6MTY2MDkyNDkwNiwiZXhwIjoxNjYx..."),
          ),
          Center(
              child: loading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: () async {
                        String refreshToken = _controller.text;
                        setState(() {
                          loading = true;
                        });
                        String? accessToken =
                            await API.getNewAccessToken(refreshToken);

                        if (accessToken == null) {
                          setState(() {
                            errorMsg = "Invalid refresh token!";
                            loading = false;
                          });
                        } else {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString("refreshToken", refreshToken);
                          Map<String, dynamic>? steamUser = await API.getUser();
                          await prefs.setString("accessToken", accessToken);
                          await prefs.setString(
                              "steamUser", json.encode(steamUser));
                          ref.refresh(userProvider);
                          await ref.read(userProvider.future);
                          if (!mounted) return;
                          Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: ((context) => const AuthPage())),
                              (route) => false);
                        }
                      },
                      child: const Text('Login'))),
          Text(errorMsg),
        ]),
      ),
    );
  }
}
