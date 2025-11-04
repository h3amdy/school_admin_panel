import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    final totalStudents = studentProvider.filteredStudents.length;
    final activeStudents =
        studentProvider.filteredStudents.where((s) => s.isActive).length;
    final inactiveStudents = totalStudents - activeStudents;
    final registeredStudents =
        studentProvider.filteredStudents.where((s) => s.isRegistered).length;
    final notRegisteredStudents = totalStudents - registeredStudents;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatCard('الطلاب الظاهرين', totalStudents.toString()),
          _buildStatCard('مفعل', activeStudents.toString(), color: Colors.green),
          _buildStatCard('غير مفعل', inactiveStudents.toString(), color: Colors.red),
          _buildStatCard('تم التسجيل', registeredStudents.toString(), color: Colors.blue),
          _buildStatCard('لم يتم التسجيل', notRegisteredStudents.toString(), color: Colors.orange),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, {Color color = Colors.grey}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 10),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: color,
          ),
        ),
      ],
    );
  }
}