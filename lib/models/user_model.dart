class UserLogin {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}

class UserRegister {
  final String email;
  final String password;
  final String username;

  UserRegister({required this.username, required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {
      'username':username,
      'email': email,
      'password': password,
    };
  }
}

class UserUpdate {
  final String email;
  final String username;
  final String password;
  final String avatar;

  UserUpdate({required this.username, required this.email, required this.password, required this.avatar});

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
      'avatar': avatar
    };
  }
}