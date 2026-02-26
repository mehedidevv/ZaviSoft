import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
  }
}

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<ProductController>(ProductController());
  }
}