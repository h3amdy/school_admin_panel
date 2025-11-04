// استيراد حزمة Flutter Material
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// الدالة الرئيسية لتشغيل التطبيق
void main() {
  runApp(const MyApp());
}

// الكلاس الرئيسي للتطبيق
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // تحديد اتجاه النص من اليمين إلى اليسار (RTL) للغة العربية
      localizationsDelegates: const [
        // يمكنك إضافة المزيد من الـ delegates للغات أخرى
      ],
      supportedLocales: const [
        Locale('ar', ''), // دعم اللغة العربية
      ],
      locale: const Locale('ar', ''),
      // تفعيل المظهر الفاتح
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          elevation: 0,
        ),
        cardTheme: CardThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        // تخصيص الألوان والنصوص
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          titleMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ),
      // إخفاء شريط "Debug"
      debugShowCheckedModeBanner: false,
      home: const StudentDetailsScreen(),
    );
  }
}

// ----------------------------------------------------------------------
// البيانات الوهمية المحدثة
// ----------------------------------------------------------------------

// البيانات الوهمية للمنهج بهيكله الجديد مع تحديثات
final List<Map<String, dynamic>> curriculum = [
  {
    'name': 'الرياضيات',
    'status': 'متقدم',
    'units': [
      {
        'name': 'الوحدة 1: الجبر',
        'lessons': [
          {
            'name': 'الدرس 1: المتغيرات',
            'completed': true,
            'questions': [
              {
                'question': 'ما هو ناتج 5 + 7؟',
                'studentAnswer': '12',
                'correct': true,
                'type': 'اختيار من متعدد'
              },
              {
                'question': 'حل المعادلة: س + 3 = 10',
                'studentAnswer': '7',
                'correct': true,
                'type': 'مقالي'
              },
            ]
          },
          {
            'name': 'الدرس 2: المعادلات الخطية',
            'completed': false,
            'questions': [
              {
                'question': 'معادلة الخط المستقيم هي ص=م س+ب (صح/خطأ)',
                'studentAnswer': 'خطأ',
                'correct': false,
                'type': 'صح أو خطأ'
              },
              {
                'question': 'ما هو ميل الخط ص = 2س + 3؟',
                'studentAnswer': '2',
                'correct': true,
                'type': 'مقالي'
              },
            ]
          },
        ]
      },
      {
        'name': 'الوحدة 2: الهندسة',
        'lessons': [
          {
            'name': 'الدرس 1: المساحات',
            'completed': true,
            'questions': [
              {
                'question': 'ما هي مساحة المربع الذي طول ضلعه 5؟',
                'studentAnswer': '25',
                'correct': true,
                'type': 'اختيار من متعدد'
              },
              {
                'question': 'ما هي مساحة الدائرة التي نصف قطرها 3؟',
                'studentAnswer': '9ط',
                'correct': true,
                'type': 'مقالي'
              },
            ]
          },
        ]
      },
    ]
  },
  {
    'name': 'العلوم',
    'status': 'متأخر',
    'units': [
      {
        'name': 'الوحدة 1: الكائنات الحية',
        'lessons': [
          {
            'name': 'الدرس 1: الخلية',
            'completed': true,
            'questions': [
              {
                'question': 'تعتبر الخلية الوحدة الأساسية للحياة. (صح/خطأ)',
                'studentAnswer': 'صح',
                'correct': true,
                'type': 'صح أو خطأ'
              },
              {
                'question': 'ما هي مكونات الخلية النباتية؟',
                'studentAnswer': 'الجدار الخلوي، الغشاء البلازمي، النواة',
                'correct': true,
                'type': 'مقالي'
              },
            ]
          },
          {
            'name': 'الدرس 2: التصنيف',
            'completed': false,
            'questions': [
              {
                'question': 'أصغر وحدة تصنيفية هي المملكة. (صح/خطأ)',
                'studentAnswer': 'صح',
                'correct': false,
                'type': 'صح أو خطأ'
              },
            ]
          },
        ]
      },
    ]
  },
];

// ----------------------------------------------------------------------
// دوال المساعدة لحساب التقدم والنسب
// ----------------------------------------------------------------------

// حساب نسبة التقدم في المنهج (عدد الدروس المكتملة / إجمالي الدروس)
double calculateProgressRate(List<Map<String, dynamic>>? units) {
  if (units == null) return 0.0;
  int completedLessons = 0;
  int totalLessons = 0;
  for (var unit in units) {
    List<dynamic> lessons = (unit['lessons'] as List?) ?? [];
    completedLessons += lessons.where((l) => l['completed']).length;
    totalLessons += lessons.length;
  }
  return totalLessons > 0 ? completedLessons / totalLessons : 0.0;
}

// حساب نسبة النجاح (عدد الأسئلة الصحيحة / إجمالي الأسئلة)
double calculateSuccessRate(List<Map<String, dynamic>>? units) {
  if (units == null) return 0.0;
  int correctQuestions = 0;
  int totalQuestions = 0;
  for (var unit in units) {
    List<dynamic> lessons = (unit['lessons'] as List?) ?? [];
    for (var lesson in lessons) {
      List<dynamic> questions = (lesson['questions'] as List?) ?? [];
      for (var question in questions) {
        totalQuestions++;
        if (question['correct'] == true) {
          correctQuestions++;
        }
      }
    }
  }
  return totalQuestions > 0 ? correctQuestions / totalQuestions : 0.0;
}

// ----------------------------------------------------------------------
// دايلوج تعديل البيانات
// ----------------------------------------------------------------------

Future<String?> showEditDataDialog({
  required BuildContext context,
  required String initialValue,
  String title = 'تعديل البيانات',
  String labelText = 'أدخل القيمة الجديدة',
}) {
  final TextEditingController controller =
      TextEditingController(text: initialValue);

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: labelText,
              border: const OutlineInputBorder(),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('إلغاء'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('حفظ'),
              onPressed: () {
                Navigator.of(context).pop(controller.text);
              },
            ),
          ],
        ),
      );
    },
  );
}

// ----------------------------------------------------------------------
// صفحة تفاصيل الطالب (StudentDetailsScreen)
// ----------------------------------------------------------------------

class StudentDetailsScreen extends StatefulWidget {
  const StudentDetailsScreen({Key? key}) : super(key: key);

  @override
  _StudentDetailsScreenState createState() => _StudentDetailsScreenState();
}

class _StudentDetailsScreenState extends State<StudentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // جعل بيانات الطالب قابلة للتغيير كجزء من الحالة
  Map<String, dynamic> studentData = {
    'name': 'أحمد علي ',
    'class': 'الصف السابع',
    'section': 'أ',
    'code': '2023ABC123',
    'isActive': true,
    'profilePictureUrl': 'https://placehold.co/100x100/A1C4FD/FFFFFF?text=AM',
    'studentPhone': '+966501234567',
    'parentPhone': '+966551234567',
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // دالة لمعالجة تعديل البيانات
  void _editField({
    required String key,
    required String title,
    required String labelText,
  }) async {
    final newValue = await showEditDataDialog(
      context: context,
      initialValue: studentData[key] ?? '',
      title: title,
      labelText: labelText,
    );
    if (newValue != null && newValue.isNotEmpty) {
      setState(() {
        studentData[key] = newValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تفاصيل الطالب'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'نظرة عامة'),
            Tab(text: 'المنهج'),
          ],
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    StudentHeader(
                      studentData: studentData,
                      onEditName: () => _editField(
                        key: 'name',
                        title: 'تعديل اسم الطالب',
                        labelText: 'الاسم الجديد',
                      ),
                      onEditStudentPhone: () => _editField(
                        key: 'studentPhone',
                        title: 'تعديل هاتف الطالب',
                        labelText: 'الهاتف الجديد',
                      ),
                      onEditParentPhone: () => _editField(
                        key: 'parentPhone',
                        title: 'تعديل هاتف ولي الأمر',
                        labelText: 'الهاتف الجديد',
                      ),
                      onEditClass: () => _editField(
                        key: 'class',
                        title: 'تعديل الصف',
                        labelText: 'الصف الجديد',
                      ),
                      onEditSection: () => _editField(
                        key: 'section',
                        title: 'تعديل القسم',
                        labelText: 'القسم الجديد',
                      ),
                    ),
                    const SizedBox(height: 16),
                    StudentStatusCard(studentData: studentData),
                    const SizedBox(height: 16),
                    CurriculumProgressCard(curriculum: curriculum),
                  ],
                ),
              ),
            ),
            SingleChildScrollView(
                child: CurriculumList(curriculum: curriculum)),
          ],
        ),
      ),
    );
  }
}

// ----------------------------------------------------------------------
// مكونات الصفحة الرئيسية
// ----------------------------------------------------------------------

class StudentHeader extends StatelessWidget {
  final Map<String, dynamic> studentData;
  final VoidCallback onEditName;
  final VoidCallback onEditStudentPhone;
  final VoidCallback onEditParentPhone;
  final VoidCallback onEditClass;
  final VoidCallback onEditSection;

  const StudentHeader({
    Key? key,
    required this.studentData,
    required this.onEditName,
    required this.onEditStudentPhone,
    required this.onEditParentPhone,
    required this.onEditClass,
    required this.onEditSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(studentData['profilePictureUrl'] ?? ''),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: onEditName,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child:
                          const Icon(Icons.edit, color: Colors.white, size: 20),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(studentData['name'] ?? 'اسم الطالب غير متوفر',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(studentData['class'] ?? 'الصف غير متوفر',
                    style: Theme.of(context).textTheme.bodyLarge),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                  onPressed: onEditClass,
                ),
                Text(' - '),
                Text(studentData['section'] ?? 'القسم غير متوفر',
                    style: Theme.of(context).textTheme.bodyLarge),
                IconButton(
                  icon: const Icon(Icons.edit, size: 16, color: Colors.grey),
                  onPressed: onEditSection,
                ),
              ],
            ),
            const SizedBox(height: 4),
            // بطاقة كود الطالب مع أزرار المشاركة والنسخ
            Card(
              elevation: 0,
              color: Colors.grey[100],
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                          'كود التسجيل: ${studentData['code'] ?? 'غير متوفر'}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.copy, size: 20),
                          onPressed: () {
                            Clipboard.setData(
                                ClipboardData(text: studentData['code'] ?? ''));
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم نسخ الكود')),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.share, size: 20),
                          onPressed: () {
                            // يمكنك هنا إضافة وظيفة مشاركة الكود
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('سيتم مشاركة الكود')),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // عرض أرقام الهاتف مع أزرار التعديل
            _buildContactInfo(context, Icons.phone_android, 'هاتف الطالب',
                studentData['studentPhone'] ?? 'غير متوفر', onEditStudentPhone),
            const SizedBox(height: 8),
            _buildContactInfo(context, Icons.phone_in_talk, 'هاتف ولي الأمر',
                studentData['parentPhone'] ?? 'غير متوفر', onEditParentPhone),
            const SizedBox(height: 16),
            // زر التعديل
            ElevatedButton.icon(
              onPressed: () {
                // يمكن هنا عرض قائمة أو دايلوج لتعديل جميع البيانات
                // حالياً، لا يقوم بشيء
              },
              icon: const Icon(Icons.edit),
              label: const Text('تعديل البيانات'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة مساعدة لبناء معلومات الاتصال
  Widget _buildContactInfo(BuildContext context, IconData icon, String label,
      String value, VoidCallback onEditPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text('$label: $value',
              style: Theme.of(context).textTheme.bodyLarge),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.edit, size: 20, color: Colors.grey),
          onPressed: onEditPressed,
        ),
      ],
    );
  }
}

class StudentStatusCard extends StatefulWidget {
  final Map<String, dynamic> studentData;
  const StudentStatusCard({Key? key, required this.studentData})
      : super(key: key);

  @override
  State<StudentStatusCard> createState() => _StudentStatusCardState();
}

class _StudentStatusCardState extends State<StudentStatusCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('حالة الحساب', style: Theme.of(context).textTheme.titleMedium),
            Row(
              children: [
                Text(
                  widget.studentData['isActive'] ? 'مفعل' : 'معطل',
                  style: TextStyle(
                    color: widget.studentData['isActive']
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Switch(
                  value: widget.studentData['isActive'] ?? false,
                  onChanged: (bool value) {
                    setState(() {
                      widget.studentData['isActive'] = value;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(value
                            ? 'تم تفعيل حساب الطالب'
                            : 'تم تعطيل حساب الطالب'),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CurriculumProgressCard extends StatelessWidget {
  final List<Map<String, dynamic>>? curriculum;
  const CurriculumProgressCard({Key? key, required this.curriculum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final progress = calculateProgressRate(curriculum);
    final success = calculateSuccessRate(curriculum);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('التقدم العام',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCircularProgress(
                    context, 'نسبة التقدم', progress, Colors.blue),
                _buildCircularProgress(
                    context, 'نسبة النجاح', success, Colors.green),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// دالة مساعدة لبناء مؤشر التقدم الدائري
Widget _buildCircularProgress(
    BuildContext context, String label, double value, Color color,
    {double size = 80, double strokeWidth = 8, double fontSize = 16}) {
  return Column(
    children: [
      Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: value,
              strokeWidth: strokeWidth,
              backgroundColor: color.withOpacity(0.2),
              color: color,
            ),
          ),
          Text(
            '${(value * 100).toStringAsFixed(0)}%',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
          ),
        ],
      ),
      Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    ],
  );
}

class CurriculumList extends StatelessWidget {
  final List<Map<String, dynamic>>? curriculum;
  const CurriculumList({Key? key, required this.curriculum}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: curriculum?.length ?? 0,
      itemBuilder: (context, index) {
        final subject = curriculum![index];

        // إصلاح الخطأ عبر التحويل الصريح للنوع
        final progress = calculateProgressRate(
            subject['units'] as List<Map<String, dynamic>>?);
        final success = calculateSuccessRate(
            subject['units'] as List<Map<String, dynamic>>?);

        final statusColor =
            subject['status'] == 'متقدم' ? Colors.green : Colors.red;

        return Card(
          child: ListTile(
            title: Text(subject['name'] ?? 'اسم المادة غير متوفر'),
            subtitle: Text('الحالة: ${subject['status'] ?? 'غير متوفر'}'),
            leading: Icon(Icons.menu_book, color: statusColor),
            trailing: Row(
              /// mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              // هذا هو الحل لمشكلة تجاوز الإطار
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildCircularProgress(context, 'التقدم', progress, statusColor,
                    size: 35, strokeWidth: 4, fontSize: 12),
                const SizedBox(width: 20),
                _buildCircularProgress(context, 'الدرجة', success, Colors.green,
                    size: 35, strokeWidth: 4, fontSize: 12),
              ],
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SubjectDetailsPage(subject: subject),
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------
// صفحة تفاصيل المادة (SubjectDetailsPage)
// ----------------------------------------------------------------------

class SubjectDetailsPage extends StatelessWidget {
  final Map<String, dynamic> subject;
  const SubjectDetailsPage({Key? key, required this.subject}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(subject['name'] ?? 'تفاصيل المادة'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: (subject['units'] as List? ?? []).map<Widget>((unit) {
                final progress = calculateProgressRate([unit]);
                final success = calculateSuccessRate([unit]);
                return Card(
                  child: ExpansionTile(
                    title: Text(unit['name'] ?? 'اسم الوحدة غير متوفر'),
                    // تم تعديل الـ subtitle لعرض المؤشرات الدائرية بدلاً من النص
                    subtitle: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _buildCircularProgress(
                              context, 'التقدم', progress, Colors.blue,
                              size: 50, strokeWidth: 5, fontSize: 12),
                          const SizedBox(width: 16),
                          _buildCircularProgress(
                              context, 'النجاح', success, Colors.green,
                              size: 50, strokeWidth: 5, fontSize: 12),
                        ],
                      ),
                    ),
                    children:
                        (unit['lessons'] as List? ?? []).map<Widget>((lesson) {
                      return _buildLessonTile(context, lesson);
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLessonTile(BuildContext context, Map<String, dynamic> lesson) {
    return ListTile(
      title: Text(lesson['name'] ?? 'اسم الدرس غير متوفر'),
      subtitle: Text(
          lesson['completed'] == true ? 'تمت مشاهدته ✅' : 'لم يتم مشاهدته ❌'),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LessonDetailsPage(lesson: lesson),
          ),
        );
      },
    );
  }
}

// ----------------------------------------------------------------------
// صفحة تفاصيل الدرس (LessonDetailsPage)
// ----------------------------------------------------------------------

class LessonDetailsPage extends StatefulWidget {
  final Map<String, dynamic> lesson;
  const LessonDetailsPage({Key? key, required this.lesson}) : super(key: key);

  @override
  State<LessonDetailsPage> createState() => _LessonDetailsPageState();
}

class _LessonDetailsPageState extends State<LessonDetailsPage> {
  String selectedFilter = 'جميع الأسئلة';

  final List<String> filters = [
    'جميع الأسئلة',
    'صحيحة',
    'خاطئة',
    'اختيار من متعدد',
    'مقالي',
    'صح أو خطأ'
  ];

  @override
  Widget build(BuildContext context) {
    final questions = widget.lesson['questions'] as List? ?? [];
    final int correctQuestions =
        questions.where((q) => q['correct'] == true).length;
    final int totalQuestions = questions.length;
    final double successRate =
        totalQuestions > 0 ? correctQuestions / totalQuestions : 0.0;

    final filteredQuestions = questions.where((q) {
      if (selectedFilter == 'جميع الأسئلة') {
        return true;
      } else if (selectedFilter == 'صحيحة') {
        return q['correct'] == true;
      } else if (selectedFilter == 'خاطئة') {
        return q['correct'] == false;
      } else {
        return q['type'] == selectedFilter;
      }
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson['name'] ?? 'تفاصيل الدرس'),
        centerTitle: true,
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة ملخص الأداء
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCircularProgress(context, 'نسبة النجاح',
                              successRate, Colors.green),
                        ],
                      ),
                      const Divider(),
                      _buildSummaryRow(
                          'الأسئلة الصحيحة', correctQuestions.toDouble()),
                      _buildSummaryRow('الأسئلة الخاطئة',
                          (totalQuestions - correctQuestions).toDouble()),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text('تحليل الأداء في الأسئلة',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: filters.map((filter) {
                    final isSelected = selectedFilter == filter;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ChoiceChip(
                        label: Text(filter),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            selectedFilter = selected ? filter : 'جميع الأسئلة';
                          });
                        },
                        selectedColor: Colors.blue,
                        labelStyle: TextStyle(
                            color: isSelected ? Colors.white : Colors.black),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                              color: isSelected ? Colors.blue : Colors.grey),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 16),
              if (filteredQuestions.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24.0),
                    child: Text('لا توجد أسئلة بهذا الفلتر.',
                        style: TextStyle(color: Colors.grey)),
                  ),
                )
              else
                ...filteredQuestions.map((q) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      leading: Icon(
                        q['correct'] == true
                            ? Icons.check_circle
                            : Icons.cancel,
                        color: q['correct'] == true ? Colors.green : Colors.red,
                      ),
                      title: Text(q['question'] ?? 'سؤال غير متوفر'),
                      subtitle: Text(
                          'إجابة الطالب: ${q['studentAnswer'] ?? 'غير متوفر'}'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          q['type'] ?? 'غير متوفر',
                          style:
                              const TextStyle(fontSize: 12, color: Colors.blue),
                        ),
                      ),
                    ),
                  );
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}

// دالة مساعدة لعرض صف الملخص
Widget _buildSummaryRow(String label, double value) {
  final isPercentage = label == 'نسبة النجاح';
  final displayValue = isPercentage
      ? '${(value * 100).toStringAsFixed(0)}%'
      : value.toStringAsFixed(0);
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(displayValue,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isPercentage
                  ? (value > 0.7 ? Colors.green : Colors.red)
                  : Colors.black,
            )),
      ],
    ),
  );
}
