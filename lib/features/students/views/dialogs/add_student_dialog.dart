// features/students/widgets/add_student_dialog.dart
import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:ashil_school/features/students/models/student.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Add this import for Clipboard
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:math';

class AddStudentDialog extends StatefulWidget {
  const AddStudentDialog({super.key});

  @override
  State<AddStudentDialog> createState() => _AddStudentDialogState();
}

class _AddStudentDialogState extends State<AddStudentDialog> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _phone = '';
  String _email = '';
  String _grade = 'الصف الأول';
  String _section = 'أ';
  String? _generatedCode;
  bool _showDetailsForm = false;

  final List<String> grades = [
    'الصف الأول',
    'الصف الثاني',
    'الصف الثالث',
    'الصف الرابع'
  ];
  final List<String> sections = ['أ', 'ب', 'ج'];

  @override
  void initState() {
    super.initState();
    _generateCode();
  }

  void _generateCode() {
    final gradePrefix = _grade.split(' ')[1];
    final uniqueNumber = Random().nextInt(99999);
    setState(() {
      _generatedCode = 'STU-$gradePrefix-${uniqueNumber.toString().padLeft(5, '0')}';
    });
  }

  void _shareCode() async {
    if (_generatedCode != null) {
      await Share.share('هذا هو كود تسجيل الدخول الخاص بك: $_generatedCode');
    }
  }

  void _copyCode() {
    if (_generatedCode != null) {
      Clipboard.setData(ClipboardData(text: _generatedCode!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم نسخ الكود بنجاح.')),
      );
    }
  }

  void _saveStudent() {
    if (_showDetailsForm) {
      if (!_formKey.currentState!.validate()) {
        return;
      }
      _formKey.currentState!.save();
    }

    final newStudent = Student(
      id: DateTime.now().toString(),
      name: _name.isNotEmpty ? _name : 'طالب جديد',
      grade: _grade,
      section: _section,
      code: _generatedCode!,
      isActive: false,
      isRegistered: false,
      overallProgress: 0.0, // Correctly added to the new model
      subjects: [], // Required by the new model
      answers: [], // Required by the new model
      phone: _phone, // Added phone
      email: _email, // Added email
    );

    // TODO: uncomment this line to add student to provider
    // Provider.of<StudentProvider>(context, listen: false).addStudent(newStudent);

    Navigator.of(context).pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('تم إنشاء الطالب بنجاح: $_generatedCode')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('إضافة طالب جديد'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section 1: Grade and Code Generation
            DropdownButtonFormField<String>(
              value: _grade,
              decoration: const InputDecoration(labelText: 'الصف'),
              items: grades.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  _grade = newValue!;
                  _generateCode();
                });
              },
            ),
            const SizedBox(height: 16),
            if (_generatedCode != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'الكود: $_generatedCode',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: _copyCode,
                    icon: const Icon(Icons.copy, color: Colors.blue),
                    tooltip: 'نسخ الكود',
                  ),
                  IconButton(
                    onPressed: _shareCode,
                    icon: const Icon(Icons.share, color: Colors.blue),
                    tooltip: 'مشاركة الكود',
                  ),
                ],
              ),
            const SizedBox(height: 16),
            // Section 2: Show/Hide Student Details
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'بيانات الطالب',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _showDetailsForm = !_showDetailsForm;
                    });
                  },
                  icon: Icon(
                    _showDetailsForm
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_left,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Section 3: Student Details Form with animation
            AnimatedSize(
              duration: const Duration(milliseconds: 300),
              child: ConstrainedBox(
                constraints:
                    BoxConstraints(maxHeight: _showDetailsForm ? 500 : 0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'الاسم الكامل'),
                        onSaved: (value) => _name = value ?? '',
                        validator: _showDetailsForm
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'الرجاء إدخال الاسم';
                                }
                                return null;
                              }
                            : null,
                      ),
                      TextFormField(
                        decoration:
                            const InputDecoration(labelText: 'رقم الهاتف'),
                        keyboardType: TextInputType.phone,
                        onSaved: (value) => _phone = value ?? '',
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            labelText: 'البريد الإلكتروني'),
                        keyboardType: TextInputType.emailAddress,
                        onSaved: (value) => _email = value ?? '',
                      ),
                      DropdownButtonFormField<String>(
                        value: _section,
                        decoration: const InputDecoration(labelText: 'الفصل'),
                        items: sections.map((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            _section = newValue!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('إلغاء'),
        ),
        ElevatedButton(
          onPressed: _saveStudent,
          child: const Text('حفظ'),
        ),
      ],
    );
  }
}