import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/pages/error.dart';
import 'package:momentum/pages/home.dart';
import 'package:momentum/pages/login.dart';
import 'package:momentum/providers/auth_provider.dart';

class AuthPage extends ConsumerWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(userProvider);
    return currentUser.when(
        data: (data) {
          if (data != null) return const HomePage();
          return const LoginPage();
        },
        loading: () => const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
        error: (e, trace) => ErrorScreen(e, trace));
  }
}
