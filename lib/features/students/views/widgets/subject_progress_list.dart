// widgets/subject_progress_list.dart
import 'package:ashil_school/features/students/models/student.dart';
import 'package:ashil_school/features/students/views/widgets/unit_progress_list.dart';
import 'package:flutter/material.dart';

class SubjectProgressList extends StatelessWidget {
  final List<SubjectProgress> subjects;

  const SubjectProgressList({super.key, required this.subjects});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: subjects.length,
      itemBuilder: (context, index) {
        final subject = subjects[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ExpansionTile(
            title: Text(subject.subjectName, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: LinearProgressIndicator(
              value: subject.progress,
              backgroundColor: Colors.grey[300],
              color: subject.status == 'متقدم' ? Colors.green : Colors.orange,
            ),
            trailing: Text('${(subject.progress * 100).toStringAsFixed(0)}%'),
            children: [
              UnitProgressList(units: subject.units),
            ],
          ),
        );
      },
    );
  }
}