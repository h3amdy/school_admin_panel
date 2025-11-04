// widgets/student_basic_info.dart
import 'package:ashil_school/features/students/models/student.dart';
import 'package:flutter/material.dart';

class StudentBasicInfo extends StatefulWidget {
  final Student student;

  const StudentBasicInfo({super.key, required this.student});

  @override
  State<StudentBasicInfo> createState() => _StudentBasicInfoState();
}

class _StudentBasicInfoState extends State<StudentBasicInfo> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  late String _name;
  late String _grade;
  late String _section;

  @override
  void initState() {
    super.initState();
    _name = widget.student.name;
    _grade = widget.student.grade;
    _section = widget.student.section;
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Call provider to update student data
      setState(() {
        _isEditing = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم حفظ التعديلات بنجاح')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(widget.student.imageUrl),
                  child: _isEditing ? const Icon(Icons.camera_alt, size: 30) : null,
                ),
                IconButton(
                  onPressed: _isEditing ? _saveChanges : _toggleEditing,
                  icon: Icon(_isEditing ? Icons.check : Icons.edit, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _isEditing
                      ? TextFormField(
                          initialValue: _name,
                          decoration: const InputDecoration(labelText: 'الاسم الكامل'),
                          onSaved: (value) => _name = value!,
                        )
                      : Text(
                          'الاسم: ${widget.student.name}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                  _isEditing
                      ? TextFormField(
                          initialValue: _grade,
                          decoration: const InputDecoration(labelText: 'الصف'),
                          onSaved: (value) => _grade = value!,
                        )
                      : Text('الصف: ${widget.student.grade}'),
                  _isEditing
                      ? TextFormField(
                          initialValue: _section,
                          decoration: const InputDecoration(labelText: 'الفصل'),
                          onSaved: (value) => _section = value!,
                        )
                      : Text('الفصل: ${widget.student.section}'),
                  Text('الكود: ${widget.student.code}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}