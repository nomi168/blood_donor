import 'package:blood_donor/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:blood_donor/features/auth/data/models/user_model.dart';

class AuthRepository {
  AuthRepository._privateController();
  static final AuthRepository _authRepository =
      AuthRepository._privateController();
  factory AuthRepository() {
    return _authRepository;
  }
  final RemoteAuthDataSource _authDataSource = RemoteAuthDataSource();
  Future<bool> checkEmail(String email) async {
    try {
      return await _authDataSource.checkEmail(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> userAddLocation(String id, String name, String location) async {
    try {
      return await _authDataSource.userAddLocation(id, name, location);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> usereligible(String id) async {
    try {
      return await _authDataSource.usereligible(id);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addUser(Map<String,dynamic> payload, {bool flag = false}) async {
    try {
      return await _authDataSource.addUser(payload, flag: flag);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkingCNIC(String cnic) async {
    try {
      return await _authDataSource.checkingCNIC(cnic);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addCnicCardDetail(dynamic payload) async {
    try {
      return await _authDataSource.addCnicCardDetail(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> loginToFirestore(String email, String password) async {
    try {
      return await _authDataSource.loginToFirestore(email, password);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> forgotPassword(dynamic payload) async {
    try {
      return await _authDataSource.forgotPassword(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> getUserDataByEmail() async {
    try {
      return await _authDataSource.getUserDataByEmail();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateAppStatus(bool isActive) async {
    try {
      return await _authDataSource.updateAppStatus(isActive);
    } catch (e) {
      rethrow;
    }
  }
}
