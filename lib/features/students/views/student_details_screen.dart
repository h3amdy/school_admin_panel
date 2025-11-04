// screens/student_details_screen.dart
import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:ashil_school/features/students/views/widgets/student_answers_analysis.dart';
import 'package:ashil_school/features/students/views/widgets/student_basic_info.dart';
import 'package:ashil_school/features/students/views/widgets/student_progress_summary.dart';
import 'package:ashil_school/features/students/views/widgets/subject_progress_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentDetailsScreen2 extends StatelessWidget {
  final String studentId;

  const StudentDetailsScreen2({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    final student = Provider.of<StudentProvider>(context, listen: false)
        .getStudentById(studentId);

    return Scaffold(
      appBar: AppBar(
        title: Text(student.name),
        actions: [
          // Manage student account status
          IconButton(
            icon: Icon(student.isActive ? Icons.check_circle : Icons.cancel,
                color: student.isActive ? Colors.green : Colors.red),
            onPressed: () {
              // TODO: Implement toggle active status logic
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(student.isActive
                        ? 'تم تعطيل حساب الطالب'
                        : 'تم تفعيل حساب الطالب')),
              );
            },
            tooltip: 'حالة الحساب',
          ),
          // Regenerate code
          IconButton(
            icon: const Icon(Icons.vpn_key),
            onPressed: () {
              // TODO: Implement regenerate code logic
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إعادة توليد الكود بنجاح.')),
              );
            },
            tooltip: 'إعادة توليد الكود',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Basic Info
            StudentBasicInfo(student: student),
            const SizedBox(height: 24),

            // Section 2: Overall Progress
            const Text(
              'التقدم في المنهج',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            StudentProgressSummary(progress: student.overallProgress),
            const SizedBox(height: 24),

            // Section 3: Subject Progress
            const Text(
              'التقدم في المواد',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            SubjectProgressList(subjects: student.subjects),
            const SizedBox(height: 24),

            // Section 4: Answers Analysis
            const Text(
              'تحليل أداء الطالب في الأسئلة',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            StudentAnswersAnalysis(answers: student.answers),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
