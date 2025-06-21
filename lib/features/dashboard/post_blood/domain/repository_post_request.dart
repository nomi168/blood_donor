import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/datasource/remote_post_request_datasource.dart';
import 'package:blood_donor/features/dashboard/post_blood/data/models/user_location_model.dart';

class RepositoryPostRequest {
  final RemotePostRequestDatasource _postRequestDatasource =
      RemotePostRequestDatasource();
  RepositoryPostRequest._privateController();
  static final RepositoryPostRequest _repositoryPostRequest =
      RepositoryPostRequest._privateController();
  factory RepositoryPostRequest() {
    return _repositoryPostRequest;
  }

  Future<bool> postBloodRequest(Map<String,dynamic> payload) async {
    try {
      return await _postRequestDatasource.postBloodRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserModel>> getUserData(String blood) async {
    try {
      return await _postRequestDatasource.getUserData(blood);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<UserLocationModel>> getDonorLocations() async {
    try {
      return await _postRequestDatasource.getDonorLocations();
    } catch (e) {
      rethrow;
    }
  }
}
