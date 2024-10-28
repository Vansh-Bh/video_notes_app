import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_notes_app/theme_changer.dart';

import 'modules/home/home_binding.dart';
import 'routes/app_pages.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = Get.put(ThemeService());

    return Obx(
      () => GetMaterialApp(
        title: "Video Note-taking App",
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        initialBinding: HomeBinding(),
        debugShowCheckedModeBanner: false,
        themeMode: themeService.theme,
        theme: MyAppThemes.lightTheme,
        darkTheme: MyAppThemes.darkTheme,
      ),
    );
  }
}
