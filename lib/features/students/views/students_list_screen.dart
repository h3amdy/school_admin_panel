import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:ashil_school/features/students/views/dialogs/add_student_dialog.dart';
import 'package:ashil_school/features/students/views/dialogs/filter_dialog.dart';
import 'package:ashil_school/features/students/views/widgets/quick_stats.dart';
import 'package:ashil_school/features/students/views/widgets/student_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class StudentsListScreen extends StatelessWidget {
  const StudentsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إدارة الطلاب'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تحديث قائمة الطلاب')),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar and Filter Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'ابحث عن طالب بالاسم أو الكود...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (query) {
                      Provider.of<StudentProvider>(context, listen: false)
                          .setSearchQuery(query);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) =>
                          const FilterDialog(), // Show the new dialog
                    );
                  },
                ),
              ],
            ),
          ),
          // Quick Stats
          const QuickStats(),
          // Student List
          Expanded(
            child: Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                final students = studentProvider.filteredStudents;
                if (students.isEmpty) {
                  return const Center(
                    child: Text('لا يوجد طلاب يطابقون الفلاتر المحددة.'),
                  );
                }
                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Slidable(
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        children: [
                          SlidableAction(
                            onPressed: (context) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تعديل بيانات الطالب')),
                              );
                            },
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'تعديل',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              // Provider.of<StudentProvider>(context, listen: false)
                              //     .deleteStudent(student.id);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('تم حذف الطالب بنجاح.')),
                              );
                            },
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            icon: Icons.delete,
                            label: 'حذف',
                          ),
                        ],
                      ),
                      child: StudentCard(student: student),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const AddStudentDialog(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
