// features/students/widgets/student_card.dart
import 'package:ashil_school/features/students/models/student.dart';
import 'package:ashil_school/features/students/views/student_details_screen.dart';
import 'package:ashil_school/main2.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StudentCard extends StatelessWidget {
  final Student student;

  const StudentCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: ListTile(
        onTap: () {
          Get.to(() => StudentDetailsScreen2(
                studentId: student.id,
              ));
        },
        title: Text(
          student.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('الصف: ${student.grade} - الفصل: ${student.section}'),
            Text('الكود: ${student.code}'),
            Row(
              children: [
                const Text('الحالة: '),
                Text(
                  student.isActive ? 'مفعل' : 'غير مفعل',
                  style: TextStyle(
                    color: student.isActive ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        trailing: InkWell(
          onTap: () {
            Get.to(() => StudentDetailsScreen());
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 50,
                height: 50,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    CircularProgressIndicator(
                      value: student
                          .overallProgress, // Updated to use overallProgress
                      backgroundColor: Colors.grey[300],
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                    Center(
                      child: Text(
                        '${(student.overallProgress * 100).toInt()}%', // Updated to use overallProgress
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
