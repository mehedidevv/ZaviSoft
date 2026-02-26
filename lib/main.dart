import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'bindings/bindings.dart';
import 'views/login_screen.dart';
import 'views/home_screen.dart';
import 'views/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'ZaviSoft',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorSchemeSeed: const Color(0xFFE53935),
            useMaterial3: true,
            appBarTheme: const AppBarTheme(
              backgroundColor: Color(0xFFE53935),
              foregroundColor: Colors.white,
            ),
          ),
          initialRoute: '/login',
          getPages: [
            GetPage(
              name: '/login',
              page: () => const LoginScreen(),
              binding: AuthBinding(),
            ),
            GetPage(
              name: '/home',
              page: () => const HomeScreen(),
              binding: HomeBinding(),
            ),
            GetPage(
              name: '/profile',
              page: () => const ProfileScreen(),
            ),
          ],
        );
      },
    );
  }
}