import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:registro_panela/features/auth/domin/entities/authenticated_user.dart';
import 'package:registro_panela/features/auth/domin/enums/user_role.dart';
import 'package:registro_panela/features/auth/domin/repositories/auth_repository.dart';

/// Implementación de [AuthRepository] usando FirebaseAuth y Firestore.
class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentUser = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<AuthenticatedUser> signIn({
    required String email,
    required String password,
  }) async {
    // Autenticación con correo y contraseña
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final uid = credential.user?.uid;
    if (uid == null) throw Exception('Error al obtener UID del usuario');

    // Obtiene datos adicionales del usuario en Firestore
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception('Usuario no encontrado en Firestore');

    final data = doc.data()!;

    // Convierte el rol desde el string almacenado
    final role = UserRole.values.firstWhere(
      (user) => user.name == data['role'],
      orElse: () => throw Exception('Rol no reconocido: ${data['role']}'),
    );

    // Retorna el usuario autenticado
    return AuthenticatedUser(
      id: uid,
      name: data['name'],
      email: data['email'],
      role: role,
      token: await credential.user!.getIdToken() ?? '',
    );
  }

  @override
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
