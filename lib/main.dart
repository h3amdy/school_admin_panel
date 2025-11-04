// main.dart
import 'package:ashil_school/Utils/theme/theme.dart';
import 'package:ashil_school/bindings/general_bindings.dart';
import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<NavigatorState> materialKey = GlobalKey<NavigatorState>();
late SharedPreferences prefs;

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  prefs = await SharedPreferences.getInstance();
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
