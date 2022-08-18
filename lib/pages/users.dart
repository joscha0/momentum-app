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

  final PagingController<int, User> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(int pageKey) async {
    print(pageKey);
    try {
      final newItems = await API.getUsers(offset: pageKey, limit: _pageSize);
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
    return PagedListView<int, User>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<User>(
        animateTransitions: true,
        itemBuilder: (context, user, index) => ListTile(
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
    );

    // FutureBuilder<List<User>>(
    //     future: API.getUsers(),
    //     builder: (context, snapshot) {
    //       if (snapshot.hasData) {
    //         return ListView(children: [
    //           ...snapshot.data!.map((user) {
    //             return ListTile(
    //               title: Text(
    //                   "${user.name} ${countryEmoji[user.country]?['emoji'] ?? ''}"),
    //               subtitle: Text(
    //                   "${user.country != '' ? "country: ${countryEmoji[user.country]?['name'] ?? ''} \n" : ""}joined: ${user.joinDate.toIso8601String().split('T').first}"),
    //               trailing: user.avatarURL != null
    //                   ? CircleAvatar(
    //                       backgroundImage: NetworkImage(user.avatarURL!.replaceAll(
    //                           "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/",
    //                           "")),
    //                     )
    //                   : Container(),
    //             );
    //           })
    //         ]);
    //       } else if (snapshot.hasError) {
    //         return Text('${snapshot.error}');
    //       }
    //       return const Center(
    //         child: CircularProgressIndicator(),
    //       );
    //     });
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
