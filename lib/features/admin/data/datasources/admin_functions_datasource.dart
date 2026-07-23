import 'package:cloud_functions/cloud_functions.dart';

abstract class AdminFunctionsDataSource {
  Future<void> changeUserPassword({
    required String uid,
    required String newPassword,
    bool revokeSessions,
  });
}

class AdminFunctionsDataSourceImpl implements AdminFunctionsDataSource {
  final FirebaseFunctions functions;
  AdminFunctionsDataSourceImpl({FirebaseFunctions? functions})
    : functions = functions ?? FirebaseFunctions.instance;

  @override
  Future<void> changeUserPassword({
    required String uid,
    required String newPassword,
    bool revokeSessions = true,
  }) async {
    final callable = functions.httpsCallable('adminUpdateUserPassword');
    await callable.call({
      'uid': uid,
      'newPassword': newPassword,
      'revoke': revokeSessions,
    });
  }
}
