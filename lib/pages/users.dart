import 'package:flutter/material.dart';
import 'package:momentum/api/api.dart';
import 'package:momentum/global/country_emoji.dart';
import 'package:momentum/models/user.dart';

class UsersPage extends StatelessWidget {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: API.getUsers(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView(children: [
              ...snapshot.data!.map((user) {
                return ListTile(
                  title: Text(
                      "${user.name} ${countryEmoji[user.country]?['emoji'] ?? ''}"),
                  subtitle: Text(
                      "${user.country != '' ? "country: ${countryEmoji[user.country]?['name'] ?? ''} \n" : ""}joined: ${user.joinDate.toIso8601String().split('T').first}"),
                  trailing: user.avatarURL != null
                      ? CircleAvatar(
                          backgroundImage: NetworkImage(user.avatarURL!.replaceAll(
                              "https://steamcdn-a.akamaihd.net/steamcommunity/public/images/avatars/",
                              "")),
                        )
                      : Container(),
                );
              })
            ]);
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
  }
}
