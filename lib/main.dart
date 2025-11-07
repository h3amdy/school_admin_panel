// main.dart
import 'package:ashil_school/Utils/theme/theme.dart';
import 'package:ashil_school/bindings/general_bindings.dart';
import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:provider/provider.dart';

GlobalKey<NavigatorState> materialKey = GlobalKey<NavigatorState>();

main() async {
  WidgetsFlutterBinding.ensureInitialized();
 
  // [الخطوة الأساسية] تهيئة GetStorage بشكل غير متزامن
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => StudentProvider()),
      ],
      child: GetMaterialApp(
        textDirection: TextDirection.rtl,
        initialBinding: GeneralBindings(),
        navigatorKey: materialKey,
        debugShowCheckedModeBanner: false,
        theme: KAppTheme.buildLightTheme(),
        darkTheme: KAppTheme.buildDarkTheme(),
        themeMode: ThemeMode.system,
        home: const Scaffold(), // استخدم Scaffold فارغ أو أي ويدجت مؤقتة
      ),
    );
  }
}
