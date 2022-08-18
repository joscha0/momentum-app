class User {
  final int id;
  final String steamID;
  final String name;
  final String? avatarURL;
  final String country;
  final String joinDate;
  User({
    required this.id,
    required this.steamID,
    required this.name,
    this.avatarURL,
    required this.country,
    required this.joinDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      steamID: json['steamID'],
      name: json['alias'],
      avatarURL: json['avatarURL'],
      country: json['country'] ?? "",
      joinDate: json['createdAt'],
    );
  }

  User copyWith({
    int? id,
    String? steamID,
    String? name,
    String? avatarURL,
    String? country,
    String? joinDate,
  }) {
    return User(
      id: id ?? this.id,
      steamID: steamID ?? this.steamID,
      name: name ?? this.name,
      avatarURL: avatarURL ?? this.avatarURL,
      country: country ?? this.country,
      joinDate: joinDate ?? this.joinDate,
    );
  }
}
