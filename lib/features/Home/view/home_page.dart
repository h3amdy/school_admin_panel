import 'package:ashil_school/data/repositories/authentication_repository.dart';
import 'package:ashil_school/features/Home/controllers/home_controller.dart';
import 'package:ashil_school/features/Home/view/profile_page.dart';
import 'package:ashil_school/features/grade/controllers/grade_controller.dart';
import 'package:ashil_school/features/grade/views/curriculum_page.dart';
// import 'package:ashil_school/features/grade/views/grades_page.dart'; // تم الإزالةimport 'package:ashil_school/features/grade/controllers/grade_controller.dart'; // تم الإضافة للحصول على الصف الافتراضي
import 'package:ashil_school/features/students/views/students_list_screen.dart';
import 'package:ashil_school/features/teacher/view/teachers_page.dart';
import 'package:ashil_school/models/user_model/base_user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController homeController = Get.put(HomeController());
    final AuthenticationRepository authController =
        AuthenticationRepository.instance;
    final PageController pageController =
        PageController(initialPage: homeController.currentIndex.value);

    // 1. تهيئة والوصول لوحدة التحكم الخاصة بالصفوف
    final GradeController gradeController = Get.put(GradeController());

    // نستخدم Obx للانتظار حتى يتم تحميل قائمة الصفوف والحصول على الصف الافتراضي
    return Obx(() {
      final List<Widget> pages = [];

      // تحديد الصف الافتراضي (أول صف في القائمة)
      // إذا لم يكن هناك صفوف، نستخدم قيمة افتراضية أو شاشة تحميل مؤقتة
      final defaultGrade = gradeController.grades.firstWhereOrNull((_) => true);

      // إذا لم يتم تحميل الصفوف بعد (أو لم توجد)
      if (defaultGrade == null && gradeController.isLoading.isTrue) {
        // شاشة تحميل مؤقتة تظهر حتى يتم الحصول على أول صف
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      // تحديد المُعرف والاسم الافتراضيين
      final String initialGradeId = defaultGrade?.id ?? 'default_grade_id';
      final String initialGradeName = defaultGrade?.name ?? 'المنهج الافتراضي';

      // بناء قائمة الصفحات بعد توفر بيانات الصف الافتراضي
      pages.addAll([
        TeachersPage(),
        // استخدام CurriculumDetailsView بدلاً من GradesPage
        //   GradesPage(),
        CurriculumPage(
            gradeId: initialGradeId, gradeName: initialGradeName),
        StudentsListScreen(),
        ProfilePage(),
        // ReasonsScreen(),
      ]);

      // تطبيق منطق إزالة صفحة الطلاب للمعلمين
      if (authController.currentUser.value?.role == UserRole.teacher) {
        if (pages.length > 2) {
          // إزالة صفحة الطلاب (الطلاب) وهي في الموقع 2 في القائمة الكاملة
          pages.removeAt(2);
        }
      }

      return Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: (index) {
            homeController.changePage(index);
          },
          children: pages,
        ),

        //  الشريط  السفلي  المخصص
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, -3),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              // المعلمين (الخيار 0)
              _buildNavItem(
                context,
                icon: Icons.group_outlined,
                activeIcon: Icons.group,
                label: "المعلمين",
                index: 0,
                currentIndex: homeController.currentIndex.value,
                onTap: () {
                  homeController.changePage(0);
                  pageController.jumpToPage(0);
                },
              ),
              // المنهج (الخيار 1)
              _buildNavItem(
                context,
                icon: Icons.menu_book_outlined,
                activeIcon: Icons.menu_book,
                label: "المنهج",
                index: 1,
                currentIndex: homeController.currentIndex.value,
                onTap: () {
                  homeController.changePage(1);
                  pageController.jumpToPage(1);
                },
              ),
              // الطلاب (الخيار 2، موجود فقط لغير المعلمين)
              // يتم التحقق مما إذا كانت صفحة الطلاب موجودة في القائمة النهائية
              if (pages.any((widget) => widget is StudentsListScreen))
                _buildNavItem(
                  context,
                  icon: Icons.people_outline,
                  activeIcon: Icons.people,
                  label: "الطلاب",
                  // يتم البحث عن الفهرس الحقيقي لصفحة الطلاب في القائمة المعدلة
                  index: pages.indexOf(pages
                      .firstWhere((widget) => widget is StudentsListScreen)),
                  currentIndex: homeController.currentIndex.value,
                  onTap: () {
                    final studentIndex = pages.indexOf(pages
                        .firstWhere((widget) => widget is StudentsListScreen));
                    homeController.changePage(studentIndex);
                    pageController.jumpToPage(studentIndex);
                  },
                ),
              // الملف الشخصي (الخيار 3 في القائمة الكاملة، أو 2 للمُعلم)
              _buildNavItem(
                context,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: "الملف الشخصي",
                // الملف الشخصي هو دائماً آخر عنصر في القائمة النهائية
                index: pages.length - 1,
                currentIndex: homeController.currentIndex.value,
                onTap: () {
                  final profileIndex = pages.length - 1;
                  homeController.changePage(profileIndex);
                  pageController.jumpToPage(profileIndex);
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  //  دالة  مساعدة  لبناء  عناصر  الشريط  السفلي
  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
    required int currentIndex,
    required VoidCallback onTap,
  }) {
    final bool isSelected = index == currentIndex;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        decoration: isSelected
            ? BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? activeIcon : icon,
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : Colors.grey.shade600,
            ),
            SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey.shade600,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("إدارة الطلاب"),
      ),
    );
  }
}
