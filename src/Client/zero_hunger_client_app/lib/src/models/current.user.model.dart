class CurrentUserModel {
  final String? token;
  final String? userId;
  final String? displayName;
  final String? email;
  final String? role;
  final bool? isLogged;

  CurrentUserModel({
    this.token,
    this.displayName,
    this.email,
    this.role,
    this.userId,
    this.isLogged,
  });

  factory CurrentUserModel.fromJson(Map<String, dynamic> json) {
    return CurrentUserModel(
      token: json['token'],
      displayName: json['displayName'],
      email: json['email'],
      userId: json['userId'],
      isLogged: json['isLogged'],
    );
  }
}
