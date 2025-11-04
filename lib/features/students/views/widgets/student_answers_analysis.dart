// widgets/student_answers_analysis.dart
import 'package:ashil_school/features/students/models/student.dart';
import 'package:flutter/material.dart';

class StudentAnswersAnalysis extends StatelessWidget {
  final List<Answer> answers;

  const StudentAnswersAnalysis({super.key, required this.answers});

  @override
  Widget build(BuildContext context) {
    final correctAnswers = answers.where((a) => a.isCorrect).toList();
    final wrongAnswers = answers.where((a) => !a.isCorrect).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Quick Stats
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatCard('الإجابات الصحيحة', correctAnswers.length.toString(), color: Colors.green),
            _buildStatCard('الإجابات الخاطئة', wrongAnswers.length.toString(), color: Colors.red),
          ],
        ),
        const SizedBox(height: 16),
        // List of all answers
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: answers.length,
          itemBuilder: (context, index) {
            final answer = answers[index];
            return Card(
              color: answer.isCorrect ? Colors.green[50] : Colors.red[50],
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                leading: Icon(answer.isCorrect ? Icons.check_circle : Icons.cancel,
                    color: answer.isCorrect ? Colors.green : Colors.red),
                title: Text(answer.question),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إجابة الطالب: ${answer.studentAnswer}'),
                    if (!answer.isCorrect)
                      Text('الإجابة الصحيحة: ${answer.correctAnswer}', style: const TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, {required Color color}) {
    return Column(
      children: [
        Text(title, style: const TextStyle(fontSize: 14)),
        Text(value, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color)),
      ],
    );
  }
}