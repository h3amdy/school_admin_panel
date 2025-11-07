// // lib/features/grade/controllers/grade_details_controller.dart
// import 'package:ashil_school/Utils/custom_dilog/show_add_dialog_options.dart';
// import 'package:ashil_school/features/semester/controllers/semester_controller.dart';
// import 'package:ashil_school/features/semester/views/dialogs/add_edit_semester_dialog.dart';
// import 'package:ashil_school/features/subject/controllers/subject_controller.dart';
// import 'package:ashil_school/features/semester/models/semester.dart';
// import 'package:ashil_school/features/subject/models/subject.dart';
// import 'package:ashil_school/features/subject/views/dialogs/add_edit_subject_dialog.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class GradeDetailsController extends GetxController {
//   final String gradeId;

//   // Controllers are now managed by this class
//   late final SemesterController semesterController;
//   late final SubjectController subjectController;

//   // State variables
//   final Rx<SemesterModel?> selectedSemester = Rxn<SemesterModel>();
//   final RxBool isLoadingSemesters = true.obs;
//   final RxBool isLoadingSubjects = true.obs;
//   final RxList<SemesterModel> semesters = <SemesterModel>[].obs;
//   final RxList<SubjectModel> subjects = <SubjectModel>[].obs;

//   GradeDetailsController(this.gradeId);

//   @override
//   void onInit() {
//     super.onInit();
//     // Initialize child controllers and react to their changes
//     semesterController = Get.put(SemesterController(gradeId), tag: gradeId);
//     subjectController = Get.put(
//         SubjectController(gradeId: gradeId, semesterId: null),
//         tag: gradeId);

//     // Listen to semester changes
//     ever(semesterController.semesters, (List<SemesterModel> newSemesters) {
//       semesters.assignAll(newSemesters);
//       semesters.sort((a, b) => a.order.compareTo(b.order));
//       isLoadingSemesters.value = false;
//       if (newSemesters.isNotEmpty && selectedSemester.value == null) {
//         selectSemester(newSemesters.first);
//       }
//     });

//     // Listen to subject changes
//     ever(subjectController.subjects, (List<SubjectModel> newSubjects) {
//       subjects.assignAll(newSubjects);
//       isLoadingSubjects.value = false;
//     });

//     // Listen for semester controller loading state
//     ever(semesterController.isLoading, (bool loading) {
//       isLoadingSemesters.value = loading;
//     });

//     // Listen for subject controller loading state
//     ever(subjectController.isLoading, (bool loading) {
//       isLoadingSubjects.value = loading;
//     });
//   }

//   void selectSemester(SemesterModel semester) {
//     if (selectedSemester.value?.id != semester.id) {
//       selectedSemester.value = semester;
//       subjectController.updateSemesterId(semester.id);
//     }
//   }

//   void deleteSemester(String semesterId) {
//     semesterController.deleteSemester(semesterId);
//   }

//   void deleteSubject(String subjectId) {
//     subjectController.deleteSubject(subjectId);
//   }

//   void showAddDialogOptions(BuildContext context, {String? gradeName}) {
//     showTwoOptionDialog(
//         context: context,
//         firstIcon: Icons.book,
//         firstLabel: "إضافة فصل",
//         firstOnTap: () {
//           showAddEditSemesterDialog(
//             controller: semesterController,
//             gradeName: gradeName,
//           );
//         },
//         secondIcon: Icons.subject,
//         secondLabel: "إضافة مادة",
//         secondOnTap: () {
//           showAddEditSubjectDialog(
//             controller: subjectController,
//             selectedSemester: selectedSemester,
//             gradeName: gradeName,
//           );
//         },
//         isShowingAdd: RxBool(false));
//   }
// }
