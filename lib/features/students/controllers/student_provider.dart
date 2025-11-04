// features/students/controllers/student_provider.dart
import 'package:ashil_school/features/students/models/student.dart';
import 'package:flutter/material.dart';

enum ActiveStatus { all, active, inactive }

enum RegisteredStatus { all, registered, notRegistered }

enum SortOrder { none, nameAsc, progressDesc, gradeDesc }

class StudentProvider with ChangeNotifier {
  // Updated dummy data to match the new Student model
  final List<Student> _students = [
    Student(
      id: '1',
      name: 'أحمد علي',
      grade: 'الصف السابع',
      section: 'أ',
      code: 'STU-2025-0012',
      isActive: true,
      isRegistered: true,
      imageUrl:
          'https://cdn-icons-png.flaticon.com/512/3135/3135715.png', // صورة افتراضية
      phone: '0501234567',
      email: 'ahmed.ali@example.com',
      overallProgress: 0.65, // تقدم إجمالي وهمي
      subjects: [
        SubjectProgress(
          subjectName: 'الرياضيات',
          progress: 0.85,
          status: 'متقدم',
          units: [
            UnitProgress(
                unitName: 'الجبر',
                completedLessons: 8,
                totalLessons: 10,
                lessons: [
                  Lesson(
                      lessonName: 'مقدمة في الجبر',
                      isWatched: true,
                      progress: 1.0),
                  Lesson(
                      lessonName: 'المعادلات الخطية',
                      isWatched: true,
                      progress: 1.0),
                  Lesson(lessonName: 'الدوال', isWatched: true, progress: 0.75),
                  Lesson(
                      lessonName: 'المتجهات', isWatched: false, progress: 0.0),
                ]),
            UnitProgress(
                unitName: 'الهندسة',
                completedLessons: 3,
                totalLessons: 5,
                lessons: [
                  Lesson(
                      lessonName: 'الأشكال الهندسية',
                      isWatched: true,
                      progress: 1.0),
                  Lesson(
                      lessonName: 'المساحات', isWatched: false, progress: 0.5),
                  Lesson(lessonName: 'الحجوم', isWatched: false, progress: 0.0),
                ]),
          ],
        ),
        SubjectProgress(
          subjectName: 'العلوم',
          progress: 0.50,
          status: 'متوسط',
          units: [
            UnitProgress(
                unitName: 'الكيمياء',
                completedLessons: 4,
                totalLessons: 8,
                lessons: [
                  Lesson(
                      lessonName: 'الذرات والجزيئات',
                      isWatched: true,
                      progress: 1.0),
                  Lesson(
                      lessonName: 'التفاعلات الكيميائية',
                      isWatched: true,
                      progress: 0.9),
                  Lesson(
                      lessonName: 'الحموض والقواعد',
                      isWatched: false,
                      progress: 0.0),
                ]),
            UnitProgress(
                unitName: 'الفيزياء',
                completedLessons: 1,
                totalLessons: 6,
                lessons: [
                  Lesson(
                      lessonName: 'الحركة والقوة',
                      isWatched: true,
                      progress: 1.0),
                  Lesson(
                      lessonName: 'الكهرباء', isWatched: false, progress: 0.0),
                ]),
          ],
        ),
        SubjectProgress(
          subjectName: 'اللغة العربية',
          progress: 0.40,
          status: 'متأخر',
          units: [
            UnitProgress(
                unitName: 'القواعد',
                completedLessons: 2,
                totalLessons: 7,
                lessons: [
                  Lesson(
                      lessonName: 'الجملة الاسمية والفعلية',
                      isWatched: true,
                      progress: 1.0),
                  Lesson(
                      lessonName: 'الفاعل والمفعول به',
                      isWatched: false,
                      progress: 0.0),
                ]),
          ],
        ),
      ],
      answers: [
        Answer(
            question: 'ما هي عاصمة اليمن؟',
            studentAnswer: 'صنعاء',
            correctAnswer: 'صنعاء',
            isCorrect: true,
            type: 'essay'),
        Answer(
            question: 'كم عدد الكواكب في المجموعة الشمسية؟',
            studentAnswer: '8',
            correctAnswer: '8',
            isCorrect: true,
            type: 'multiple_choice'),
        Answer(
            question: 'تتكون الشمس من غازات.',
            studentAnswer: 'صحيح',
            correctAnswer: 'صحيح',
            isCorrect: true,
            type: 'true_false'),
        Answer(
            question: 'ما هو حاصل جمع 5+7؟',
            studentAnswer: '13',
            correctAnswer: '12',
            isCorrect: false,
            type: 'multiple_choice'),
        Answer(
            question: 'ما هو أكبر محيط في العالم؟',
            studentAnswer: 'المحيط الهندي',
            correctAnswer: 'المحيط الهادئ',
            isCorrect: false,
            type: 'essay'),
      ],
    ),
    Student(
      id: '2',
      name: 'فاطمة محمد',
      grade: 'الصف الرابع',
      section: 'ب',
      code: 'STU-2025-0013',
      isActive: false,
      isRegistered: true,
      imageUrl: 'https://via.placeholder.com/150',
      overallProgress: 0.70,
      subjects: [], // بيانات فارغة
      answers: [], // بيانات فارغة
    ),
    Student(
      id: '3',
      name: 'خالد يوسف',
      grade: 'الصف الثالث',
      section: 'أ',
      code: 'STU-2025-0014',
      isActive: true,
      isRegistered: false,
      imageUrl: 'https://via.placeholder.com/150',
      overallProgress: 0.90,
      subjects: [], // بيانات فارغة
      answers: [], // بيانات فارغة
    ),
    Student(
      id: '4',
      name: 'نورا سعيد',
      grade: 'الصف الثالث',
      section: 'ب',
      code: 'STU-2025-0015',
      isActive: true,
      isRegistered: true,
      imageUrl: 'https://via.placeholder.com/150',
      overallProgress: 0.20,
      subjects: [], // بيانات فارغة
      answers: [], // بيانات فارغة
    ),
  ];

  String _searchQuery = '';
  String? _selectedGrade;
  String? _selectedSection;
  ActiveStatus _activeStatus = ActiveStatus.all;
  RegisteredStatus _registeredStatus = RegisteredStatus.all;
  SortOrder _sortOrder = SortOrder.none;

  List<Student> get students => _students;
  String get searchQuery => _searchQuery;
  String? get selectedGrade => _selectedGrade;
  String? get selectedSection => _selectedSection;
  ActiveStatus get activeStatus => _activeStatus;
  RegisteredStatus get registeredStatus => _registeredStatus;
  SortOrder get sortOrder => _sortOrder;

  List<Student> get filteredStudents {
    var filtered = _students.where((student) {
      final nameMatch = student.name.contains(_searchQuery) ||
          student.code.contains(_searchQuery);
      final gradeMatch =
          _selectedGrade == null || student.grade == _selectedGrade;
      final sectionMatch =
          _selectedSection == null || student.section == _selectedSection;
      final activeMatch = _activeStatus == ActiveStatus.all ||
          (_activeStatus == ActiveStatus.active && student.isActive) ||
          (_activeStatus == ActiveStatus.inactive && !student.isActive);
      final registeredMatch = _registeredStatus == RegisteredStatus.all ||
          (_registeredStatus == RegisteredStatus.registered &&
              student.isRegistered) ||
          (_registeredStatus == RegisteredStatus.notRegistered &&
              !student.isRegistered);

      return nameMatch &&
          gradeMatch &&
          sectionMatch &&
          activeMatch &&
          registeredMatch;
    }).toList();

    // Sorting Logic
    switch (_sortOrder) {
      case SortOrder.nameAsc:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case SortOrder.progressDesc:
        // Use overallProgress from the new model
        filtered.sort((a, b) => b.overallProgress.compareTo(a.overallProgress));
        break;
      case SortOrder.gradeDesc:
        // This property doesn't exist in the new model, so we need to either remove it or add it
        // As it's a new model, let's remove it to avoid confusion
        // Or, if you want it, you must add it to the model. I'll remove it for now.
        break;
      default:
        // No sorting
        break;
    }

    return filtered;
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void setGradeFilter(String? grade) {
    _selectedGrade = grade;
    notifyListeners();
  }

  void setSectionFilter(String? section) {
    _selectedSection = section;
    notifyListeners();
  }

  void setActiveStatusFilter(ActiveStatus status) {
    _activeStatus = status;
    notifyListeners();
  }

  void setRegisteredStatusFilter(RegisteredStatus status) {
    _registeredStatus = status;
    notifyListeners();
  }

  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    notifyListeners();
  }

  void resetFilters() {
    _searchQuery = '';
    _selectedGrade = null;
    _selectedSection = null;
    _activeStatus = ActiveStatus.all;
    _registeredStatus = RegisteredStatus.all;
    _sortOrder = SortOrder.none;
    notifyListeners();
  }

  // New method to get a single student by ID
  Student getStudentById(String id) {
    return _students.firstWhere((student) => student.id == id);
  }
}
