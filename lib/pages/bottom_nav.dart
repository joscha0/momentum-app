import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:momentum/pages/home.dart';
import 'package:momentum/pages/users.dart';
import 'package:momentum/providers/bottom_nav_provider.dart';

class BottomNavigationBarView extends ConsumerWidget {
  const BottomNavigationBarView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int pageIndex = ref.watch(pageIndexProvider);

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: pageIndex,
        onTap: (index) {
          ref.read(pageIndexProvider.state).state = index;
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Users'),
        ],
      ),
      body: IndexedStack(
        index: pageIndex,
        children: const [
          HomePage(),
          UsersPage(),
        ],
      ),
    );
  }
}
