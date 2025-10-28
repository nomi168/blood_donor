import 'package:blood_donor/features/auth/data/models/user_model.dart';
import 'package:blood_donor/features/dashboard/account/data/datasource/remote_account_datasource.dart';
import 'package:blood_donor/features/dashboard/account/data/models/history_model.dart';
import 'package:blood_donor/features/dashboard/account/data/models/voucher_model.dart';

class AccountRepository {
  AccountRepository._privateController();
  static final AccountRepository _accountRepository =
      AccountRepository._privateController();
  factory AccountRepository() {
    return _accountRepository;
  }
  final RemoteAccountDatasource _datasource = RemoteAccountDatasource();

  Future<bool> checkDonorAvailability(String email) async {
    try {
      return await _datasource.checkDonorAvailability(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<DateTime?> getDonorBackToDonate(String email) async {
    try {
      return await _datasource.getDonorBackToDonate(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> updateUserType(String userType, String email) async {
    try {
      return await _datasource.updateUserType(userType, email);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkingDonorSwitcher(String email) async {
    try {
      return await _datasource.checkingDonorSwitcher(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addingDonorSwitcher(String email) async {
    try {
      return await _datasource.addingDonorSwitcher(email);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addHomeAddress(dynamic payload) async {
    try {
      return await _datasource.addHomeAddress(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addWorkAddress(dynamic payload) async {
    try {
      return await _datasource.addWorkAddress(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> addTravelAddress(dynamic payload) async {
    try {
      return await _datasource.addTravelAddress(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<BloodHistoryModel>> getHistoryList(
      String email, String type) async {
    try {
      return await _datasource.getHistoryList(email, type);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel?> updateProfile(Map<String, dynamic> payload) async {
    try {
      return await _datasource.updateProfile(payload);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<VoucherModel>> getVoucherHistory() async {
    try {
      return await _datasource.getVoucherHistory();
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> checkUserCnicVerification(String card) async {
    try {
      return await _datasource.checkUserCnicVerification(card);
    } catch (e) {
      rethrow;
    }
  }
}
