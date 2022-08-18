class AppUser {
  final String steamID;
  final String name;
  final String avatarURL;
  final String accessToken;
  final String refreshToken;
  AppUser({
    required this.steamID,
    required this.name,
    required this.avatarURL,
    required this.accessToken,
    required this.refreshToken,
  });

  factory AppUser.fromJson(
      Map<String, dynamic> json, String accessToken, String refreshToken) {
    return AppUser(
      steamID: json['steamID'],
      name: json['alias'],
      avatarURL: json['avatarURL'],
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }
}
