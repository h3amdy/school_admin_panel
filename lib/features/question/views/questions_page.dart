import 'package:ashil_school/Utils/custom_dilog/confert_dilog.dart';
import 'package:ashil_school/Utils/question/question_utils.dart';
import 'package:ashil_school/features/question/controllers/question_controller.dart';
import 'package:ashil_school/features/question/views/dialog/question_details_dialog.dart';
import 'package:ashil_school/features/question/views/dialog/question_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ashil_school/features/question/models/base_question.dart';

class QuestionsPage extends StatelessWidget {
  final String lessonId;
  final String lessonName;

  const QuestionsPage(
      {super.key, required this.lessonId, required this.lessonName});

  @override
  Widget build(BuildContext context) {
    final QuestionController controller =
        Get.put(QuestionController(lessonId: lessonId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text("أسئلة درس: $lessonName"),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.value != null) {
          return Center(
            child: Text(
              controller.error.value!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          );
        }

        final questions = controller.questions;
        if (questions.isEmpty) {
          return const Center(child: Text("لا يوجد أسئلة لهذا الدرس."));
        }

        return ListView.builder(
          itemCount: questions.length,
          itemBuilder: (context, index) {
            final question = questions[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(
                  child: Icon(Icons.question_mark),
                ),
                title: Text(
                  question.text,
                  style: theme.textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text("النوع: ${getQuestionTypeName(question.type)}"),
               onTap: () => _showQuestionDetailsDialog(context, question),
                onLongPress: () => showEditDeleteOptions(
                    onEdit: () =>
                        _showQuestionDialog(context, questionToEdit: question),
                    onDelete: () => controller.deleteQuestion(question.id)),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showQuestionDialog(context),
        icon: const Icon(Icons.add),
        label: const Text("أضف سؤالًا"),
      ),
    );
  }

  void _showQuestionDialog(BuildContext context,
      {BaseQuestion? questionToEdit}) {
    Get.dialog(
      QuestionDialog(
        questionToEdit: questionToEdit,
        onSave: (questionData, {questionId}) {
          final QuestionController controller = Get.find<QuestionController>();
          controller.saveQuestion(questionData, questionId: questionId);
        },
      ),
    );
  }
}
  // أضف هذه الدالة الجديدة
  void _showQuestionDetailsDialog(BuildContext context, BaseQuestion question) {
    Get.dialog(
      QuestionDetailsDialog(question: question),
    );
  }