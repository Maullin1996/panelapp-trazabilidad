import '../../domain/entities/app_user.dart';

class AppUserModel {
  final String uid;
  final String email;
  final String? displayName;
  final String role;

  const AppUserModel({
    required this.uid,
    required this.email,
    required this.role,
    this.displayName,
  });

  /// 1) Model ⇐ Domain
  factory AppUserModel.fromEntity(AppUser e) => AppUserModel(
    uid: e.uid,
    email: e.email,
    displayName: e.displayName,
    role: e.role,
  );

  /// 2) Domain ⇐ Model
  AppUser toEntity() =>
      AppUser(uid: uid, email: email, displayName: displayName, role: role);

  /// 3) Firestore/JSON → Model
  /// Si NO guardas `uid` como campo, pásalo vía `docId`.
  factory AppUserModel.fromJson(Map<String, dynamic> json, {String? docId}) {
    return AppUserModel(
      uid: (json['uid'] as String?) ?? docId ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
      displayName: json['displayName'] as String?,
    );
  }

  /// 4) Model → Firestore/JSON
  Map<String, dynamic> toJson() => {
    'uid': uid, // opcional si usas doc.id como uid
    'email': email,
    'role': role,
    if (displayName != null) 'displayName': displayName,
  };
}
