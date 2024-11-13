class UserModel {
  final String name;
  final String correo;
  final int rolId;
  final String uid;
  final String profilePicture;

  UserModel({
    required this.name,
    required this.correo,
    required this.rolId,
    required this.uid,
    required this.profilePicture,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      correo: json['correo'],
      rolId: json['rol_id'],
      uid: json['uid'],
      profilePicture: json['profile_picture'],
    );
  }
}
