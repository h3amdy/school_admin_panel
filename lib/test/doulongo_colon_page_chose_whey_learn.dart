import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/Utils/theme/decorations/app_decorations.dart';
import 'package:flutter/material.dart';

class ReasonsScreen extends StatefulWidget {
  const ReasonsScreen({super.key});

  @override
  State<ReasonsScreen> createState() => _ReasonsScreenState();
}

class _ReasonsScreenState extends State<ReasonsScreen> {
  // قائمة الأسباب
  final List<Map<String, dynamic>> reasons = [
    {"title": "التواصل مع الآخرين", "icon": Icons.people, "selected": false},
    {
      "title": "الاستفادة من الوقت",
      "icon": Icons.access_time,
      "selected": false
    },
    {"title": "الاستمتاع فقط", "icon": Icons.celebration, "selected": true},
    {"title": "دفعة في العمل", "icon": Icons.work, "selected": false},
    {"title": "الاستعداد للسفر", "icon": Icons.flight, "selected": false},
    {"title": "دعم تعلّمي", "icon": Icons.menu_book, "selected": true},
    {"title": "أخرى", "icon": Icons.more_horiz, "selected": false},
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 20),

              // العنوان
              Text(
                'كل هذه أسباب رائعة للتعلّم!',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              Expanded(
                child: ListView.builder(
                  itemCount: reasons.length,
                  itemBuilder: (context, index) {
                    final selected = reasons[index]['selected'] as bool;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      child: Container(
                        decoration: AppDecorations.cardDecoration(context,
                            selected: selected),
                        child: CheckboxListTile(
                          title: Text(
                            reasons[index]['title'],
                            style: theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          secondary: Icon(
                            reasons[index]['icon'],
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          value: selected,
                          onChanged: (val) {
                            setState(() {
                              reasons[index]['selected'] = val!;
                            });
                          },
                          activeColor: theme.colorScheme.primary,
                          checkColor: Colors.white,
                          controlAffinity: ListTileControlAffinity.trailing,
                        ),
                      ),
                    );
                  },
                ),
              ),

              // زر المتابعة
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.secondary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: Text(
                      'المتابعة',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------ Theme Setup ----------------

final lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    dividerColor: Colors.grey.shade400,
    shadowColor: Colors.grey.shade400,
    scaffoldBackgroundColor: Colors.grey[50],
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.green,
      surface: Colors.white,
      onSurface: Colors.black87,
    ));

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blue[300],
  scaffoldBackgroundColor: Colors.black,
  colorScheme: ColorScheme.dark(
    primary: Colors.blue[300]!,
    secondary: Colors.green[300]!,
    surface: Colors.grey[900]!,
    onSurface: Colors.white,
  ),
  cardColor: Color(0xFF181E2E),
  dividerColor: KColors.darkGrey,
  shadowColor: KColors.darkGrey,
);

// ------------ Main ----------------
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: lightTheme, // التصميم الحالي لا يتغير
    darkTheme: darkTheme,
    // نضيف ألوان الداكن
    themeMode: ThemeMode.system, // تلقائي حسب نظام الجهاز
    home: const ReasonsScreen(),
  ));
}
