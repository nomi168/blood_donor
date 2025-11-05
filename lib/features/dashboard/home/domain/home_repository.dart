import 'package:blood_donor/features/dashboard/home/data/datasource/remote_home_datasource.dart';
import 'package:blood_donor/features/dashboard/home/data/models/active_user_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/banner_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/blood_bank_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/donor_accept_model.dart';
import 'package:blood_donor/features/dashboard/home/data/models/taker_model.dart';

class HomeRepository {
  final RemoteHomeDatasource _datasource = RemoteHomeDatasource();
  HomeRepository._privateController();
  static final HomeRepository _homeRepository =
      HomeRepository._privateController();
  factory HomeRepository() {
    return _homeRepository;
  }

  Future<List<FeedTakerModel>> getTakersList() async {
    try {
      return await _datasource.getTakersList();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDonorLocation(String location, String userID) async {
    try {
      return await _datasource.updateDonorLocation(location, userID);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateFCMToken(String userId, String token) async {
    try {
      return await _datasource.updateFCMToken(userId, token);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> checkAvailabilityDonor() async {
    try {
      return await _datasource.checkAvailabilityDonor();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DonateAcceptModel>> getAcceptanceDonor() async {
    try {
      return await _datasource.getAcceptanceDonor();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateStatus(bool status) async {
    try {
      return await _datasource.updateStatus(status);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool?> getavailableDonor(String email) async {
    try {
      return await _datasource.getavailableDonor(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<DonateAcceptModel>> seeTakerAcceptanceData() async {
    try {
      return await _datasource.seeTakerAcceptanceData();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> aceeptDonationRequest(dynamic payload) async {
    try {
      return await _datasource.aceeptDonationRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteAcceptedRequest(dynamic payload) async {
    try {
      return await _datasource.deleteAcceptedRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getReceivedStatus(Map<String, dynamic> payload) async {
    try {
      return await _datasource.getReceivedStatus(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> getTakerReceivedStatus(String email, String donorEmall) async {
    try {
      return await _datasource.getTakerReceivedStatus(email, donorEmall);
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> getDonorCurrentLocation(String donorEmail) async {
    try {
      return await _datasource.getDonorCurrentLocation(donorEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateReceivedStatue(
      String takerEmail, String donorEmail) async {
    try {
      return await _datasource.updateReceivedStatue(takerEmail, donorEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTakerReceivedStatue(
      String takerEmail, String donorEmail) async {
    try {
      return await _datasource.updateTakerReceivedStatue(
          takerEmail, donorEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<double?> getDonorRating(String Id) async {
    try {
      return await _datasource.getDonorRating(Id);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addOrUpdateAvailableDonor() async {
    try {
      return await _datasource.addOrUpdateAvailableDonor();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addDonorHistory(dynamic payload) async {
    try {
      return await _datasource.addDonorHistory(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDonorStatus(String takerID, String donorId) async {
    try {
      return await _datasource.updateDonorStatus(takerID, donorId);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateAcceptDonationData(Map<String, dynamic> payload) async {
    try {
      return await _datasource.updateAcceptDonationData(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTakerStatus(String takerId) async {
    try {
      return await _datasource.updateTakerStatus(takerId);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteExpiredRequests() async {
    try {
      return await _datasource.deleteExpiredRequests();
    } catch (e) {
      rethrow;
    }
  }

  Future<DonateAcceptModel?> getSingleDonorAcceptance(
      String takerEmail, String donorEmail) async {
    try {
      return await _datasource.getSingleDonorAcceptance(takerEmail, donorEmail);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActiveUserModel>> getTodayActiveUsers() async {
    try {
      return await _datasource.getTodayActiveUsers();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addTodateActiveUser(dynamic payload) async {
    try {
      return await _datasource.addTodateActiveUser(payload);
    } catch (error) {
      rethrow;
    }
  }

  Future<int?> getDonorBloodCount() async {
    try {
      return await _datasource.getDonorBloodCount();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateDonorBloodCount(int count) async {
    try {
      return await _datasource.updateDonorBloodCount(count);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkTakerBloodRequest(Map<String, dynamic> payload) async {
    try {
      return await _datasource.checkTakerBloodRequest(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BannerModel>> getBanners() async {
    try {
      return await _datasource.getBanners();
    } catch (e) {
      rethrow;
    }
  }

  Future<FeedTakerModel?> checkTakerCondition() async {
    try {
      return await _datasource.checkTakerCondition();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BloodBank>> getBloodBanks() async {
    try {
      return await _datasource.getBloodBanks();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addBloodBankDonor(dynamic payload) async {
    try {
      return await _datasource.addBloodBankDonor(payload);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> checkUserCnicVerification() async {
    try {
      return await _datasource.checkUserCnicVerification();
    } catch (e) {
      rethrow;
    }
  }
}
