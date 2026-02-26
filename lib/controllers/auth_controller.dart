
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthController extends GetxController {
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final Rx<UserModel?> user = Rx<UserModel?>(null);
  final token = ''.obs;

  /// Login with username and password
  /// Fakestore default: username=johnd, password=m38rmF$

  Future<bool> login(String username, String password) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final t = await ApiService.login(username, password);
      token.value = t;
      /// Fetch user profile (userId=1 matches johnd in fakestore)
      final u = await ApiService.getUser(1);
      user.value = u;
      return true;
    } catch (e) {
      errorMessage.value = e.toString().replaceAll('Exception: ', '');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    token.value = '';
    user.value = null;
    Get.offAllNamed('/login');
  }
}
