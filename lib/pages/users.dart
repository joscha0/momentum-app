import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:momentum/api/api.dart';
import 'package:momentum/global/country_emoji.dart';
import 'package:momentum/models/user.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  static const _pageSize = 20;
  String? _searchTerm;
  late TextEditingController _controller;

  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
    _controller = TextEditingController();
  }

  Future<void> _fetchPage(int pageKey) async {
    try {
      final newItems = await API.getUsers(
          offset: pageKey, limit: _pageSize, search: _searchTerm);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        final nextPageKey = pageKey + newItems.length;
        _pagingController.appendPage(newItems, nextPageKey);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  void _updateSearchTerm(String searchTerm) {
    _searchTerm = searchTerm;
    if (searchTerm == "") {
      _controller.text = searchTerm;
    }
    _pagingController.refresh();
  }

  String getImageUrl(String oldUrl) {
    if (oldUrl.allMatches("https://").length > 1) {
      return oldUrl.replaceAll(
          "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/",
          "");
    } else {
      String imgId = oldUrl.split("/").last;
      return "https://avatars.steamstatic.com/$imgId";
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: [
      const SliverAppBar(
        expandedHeight: 100.0,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: true,
          title: Text('Users'),
        ),
      ),
      SliverAppBar(
        pinned: true,
        actions: [IconButton(icon: const Icon(Icons.tune), onPressed: () {})],
        title: Container(
          height: 40,
          decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(5)),
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _updateSearchTerm("");
                  },
                ),
                hintText: 'Search...',
                border: InputBorder.none),
            onChanged: (searchTerm) => _updateSearchTerm(searchTerm),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.all(8.0),
        sliver: PagedSliverList<int, User>(
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<User>(
            animateTransitions: true,
            itemBuilder: (context, user, index) => Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                      "${user.name} ${countryEmoji[user.country]?['emoji'] ?? ''}"),
                  subtitle: Text(
                      "${user.country != '' ? "country: ${countryEmoji[user.country]?['name'] ?? ''} \n" : ""}joined: ${user.joinDate.toIso8601String().split('T').first}"),
                  trailing: user.avatarURL != null && user.avatarURL != ""
                      ? CircleAvatar(
                          backgroundImage:
                              NetworkImage(getImageUrl(user.avatarURL ?? "")),
                        )
                      : const CircleAvatar(
                          child: Icon(Icons.person),
                        ),
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _controller.dispose();
    super.dispose();
  }
}
