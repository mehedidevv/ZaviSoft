import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zavisoft/core/components/customSize.dart';
import 'package:zavisoft/widget/customButton.dart';
import 'package:zavisoft/widget/customText.dart';
import 'package:zavisoft/widget/customTextField.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends GetView<AuthController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameCtrl = TextEditingController(text: 'johnd');
    final passwordCtrl = TextEditingController(text: 'm38rmF\$');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// Logo
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFE53935),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.storefront,
                  color: Colors.white,
                  size: 48,
                ),
              ),

              heightBox14,

              CustomText(
                text: 'ZaviSoft',
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFE53935),
              ),

              heightBox10,

              CustomText(
                text: 'Sign in to continue',
                fontWeight: FontWeight.w500,
                fontSize: 13,
                color: Colors.grey,
              ),

              heightBox20,

              /// Card
              Card(
                elevation: 4,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomText(
                        text: 'User Name:',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),

                      heightBox10,

                      CustomTextField(
                        controller: usernameCtrl,
                        hintText: 'Username',
                        showObscure: false,
                        prefixIcon: Icons.person,
                      ),

                      heightBox20,

                      CustomText(
                        text: 'Password:',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),

                      heightBox10,

                      CustomTextField(
                        controller: passwordCtrl,
                        hintText: 'Password',
                        showObscure: true,
                        prefixIcon: Icons.lock,
                      ),

                      heightBox20,

                      Obx(
                        () => Stack(
                          alignment: Alignment.center,
                          children: [
                            CustomButtonWidget(
                              btnText: 'LOGIN',
                              iconWant: false,
                              onTap: controller.isLoading.value
                                  ? () {}
                                  : () async {
                                      final success = await controller.login(
                                        usernameCtrl.text.trim(),
                                        passwordCtrl.text.trim(),
                                      );
                                      if (success) Get.offAllNamed('/home');
                                    },
                              btnColor: controller.isLoading.value
                                  ? const Color(0xFFE53935).withOpacity(0.7)
                                  : const Color(0xFFE53935),
                              borderRadius: 12,
                              btnTextSize: 16,
                              btnTextFontWeight: FontWeight.bold,
                              btnTextColor: controller.isLoading.value
                                  ? Colors.transparent
                                  : Colors.white,
                            ),
                            if (controller.isLoading.value)
                              const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              heightBox14,

              CustomText(
                text: 'UserName:johnd',
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
              heightBox10,

              CustomText(
                text: 'Password:m38rmF\$',
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.w400,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
