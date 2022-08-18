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

  AppUser copyWith({
    String? steamID,
    String? name,
    String? avatarURL,
    String? accessToken,
    String? refreshToken,
  }) {
    return AppUser(
      steamID: steamID ?? this.steamID,
      name: name ?? this.name,
      avatarURL: avatarURL ?? this.avatarURL,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}
