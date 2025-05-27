import 'package:blood_donor/features/dashboard/post_blood/data/datasource/remote_post_request_datasource.dart';

class RepositoryPostRequest {
  final RemotePostRequestDatasource _postRequestDatasource =
      RemotePostRequestDatasource();
  RepositoryPostRequest._privateController();
  static final RepositoryPostRequest _repositoryPostRequest =
      RepositoryPostRequest._privateController();
  factory RepositoryPostRequest() {
    return _repositoryPostRequest;
  }

  Future<bool> postBloodRequest(dynamic payload) async {
    try {
      return await _postRequestDatasource.postBloodRequest(payload);
    } catch (e) {
      rethrow;
    }
  }
}
