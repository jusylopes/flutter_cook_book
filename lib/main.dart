import 'package:flutter/material.dart';
import 'package:flutter_cook_book/di/service_locator.dart';
import 'package:flutter_cook_book/routes/app_router.dart';
import 'package:flutter_cook_book/utils/config/env.dart';
import 'package:flutter_cook_book/utils/theme/custom_theme_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Env.init();
  await Supabase.initialize(url: Env.supabaseUrl, anonKey: Env.supabaseAnonKey);
  await setupDependencies();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Get.put(CustomThemeController());

    return Obx(
      () => MaterialApp.router(
        title: 'CookBook',
        debugShowCheckedModeBanner: false,
        theme: theme.customTheme,
        darkTheme: theme.customThemeDark,
        themeMode: theme.isDark.value ? ThemeMode.dark : ThemeMode.light,
        routerConfig: AppRouter().router,
      ),
    );
  }
}
