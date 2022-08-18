import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo Steam Login',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? steamId;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Steam Login'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () async {
                // Navigate to the login page.
                final result = await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SteamLogin()));
                setState(() {
                  steamId = result;
                });
              },
            ),
            Text('Steamid: $steamId'),
          ],
        ),
      ),
    );
  }
}

class SteamLogin extends StatelessWidget {
  final _webView = FlutterWebviewPlugin();

  @override
  Widget build(BuildContext context) {
    // Listen to the onUrlChanged events, and when we are ready to validate do so.
    _webView.onUrlChanged.listen((String url) async {
      print(url);
      if (url == "https://momentum-mod.org/dashboard") {
        var cookies = await _webView.getCookies();
        await _webView.close();
        Navigator.of(context).pop(cookies.toString());
      }
    });

    return WebviewScaffold(
        url: "https://api.momentum-mod.org/auth/steam",
        appBar: AppBar(
          title: const Text('Steam Login'),
        ));
  }
}
