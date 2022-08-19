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
        backgroundColor: Theme.of(context).colorScheme.surface,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        type: BottomNavigationBarType.shifting,
        currentIndex: pageIndex,
        onTap: (index) {
          ref.read(pageIndexProvider.state).state = index;
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: 'Users',
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
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
