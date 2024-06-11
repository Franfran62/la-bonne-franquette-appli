class User {
  final String username;
  final String password;

  User({required this.username, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username': this.username,
      'password': this.password,
    };
  }

 factory User.fromJson(Map<String, dynamic> json) {
    if (json['username'] == null || json['password'] == null) {
      throw Exception('Erreur: Données incorrectes');
    }
    return User(
      username: json['username'],
      password: json['password'],
    );
  }
}