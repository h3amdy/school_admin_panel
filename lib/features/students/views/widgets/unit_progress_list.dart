// widgets/unit_progress_list.dart
import 'package:ashil_school/features/students/models/student.dart';
import 'package:flutter/material.dart';

class UnitProgressList extends StatelessWidget {
  final List<UnitProgress> units;

  const UnitProgressList({super.key, required this.units});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: units.length,
      itemBuilder: (context, index) {
        final unit = units[index];
        return ListTile(
          title: Text(unit.unitName),
          subtitle: LinearProgressIndicator(
            value: unit.completedLessons / unit.totalLessons,
            backgroundColor: Colors.grey[300],
            color: Colors.blue,
          ),
          trailing: Text('${unit.completedLessons} / ${unit.totalLessons} درس'),
          onTap: () {
            // TODO: Navigate to Lesson details
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('تفاصيل وحدة ${unit.unitName}')),
            );
          },
        );
      },
    );
  }
}