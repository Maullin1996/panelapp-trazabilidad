import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user_model.dart';

abstract class UsersRemoteDataSource {
  Future<List<AppUserModel>> fetchAllUsers();
}

class UsersRemoteDataSourceImpl implements UsersRemoteDataSource {
  final FirebaseFirestore _firestore;
  final String collectionPath;

  UsersRemoteDataSourceImpl({
    FirebaseFirestore? firestore,
    this.collectionPath = 'users',
  }) : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<AppUserModel>> fetchAllUsers() async {
    final qs = await _firestore.collection(collectionPath).get();
    return qs.docs
        .map((d) => AppUserModel.fromJson(d.data(), docId: d.id))
        .toList();
  }
}
