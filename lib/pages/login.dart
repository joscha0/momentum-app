import 'package:flutter/material.dart';
import 'package:momentum/pages/login_refresh.dart';

import 'login_steam.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: CircleAvatar(
                  radius: 42,
                  child: Icon(
                    Icons.person,
                    size: 54,
                  )),
            ),
            ElevatedButton(
              child: const Text('Login with Steam'),
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SteamLogin()));
              },
            ),
            TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginRefresh()));
                },
                child: const Text('Login with refresh token'))
          ],
        ),
      ),
    );
  }
}
