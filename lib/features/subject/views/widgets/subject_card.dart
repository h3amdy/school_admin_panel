import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/features/subject/models/subject.dart';
import 'package:flutter/material.dart';

class SubjectCard extends StatelessWidget {
  final SubjectModel subject;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        onLongPress: () {
          showEditDeleteOptions(
            onEdit: onEdit,
            onDelete: onDelete,
          );
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.book_outlined,
                  size: 40, color: Colors.blueAccent),
              const SizedBox(height: 12),
              Expanded(
                child: Text(
                  subject.name,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
