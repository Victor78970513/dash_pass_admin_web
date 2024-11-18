class UserModel {
  final String email;
  final String profilePicture;
  final String uid;
  final int rolId;
  final String name;

  UserModel({
    required this.email,
    required this.profilePicture,
    required this.uid,
    required this.rolId,
    required this.name,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      email: json['correo'],
      profilePicture: json['foto_perfil'],
      uid: json['id_administrador'],
      rolId: json['id_rol'],
      name: json['nombre'],
    );
  }
}
