// import 'package:ashil_school/features/question/view/fill_in_the_blank_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../AppResources.dart';
// import '../../../Controllers/QuestionController.dart';
// import '../../../Providers/LessonProvider.dart';
// import '../../../Providers/QuestionProvider.dart';
// import '../../../Utils/Styles.dart';
// import '../../../models/lesson.dart';
// import '../../../models/QuestionModels/QuestionBase.dart';
// import '../../../models/QuestionModels/MultipleChoiceQuestion.dart';
// import '../../../models/QuestionModels/OrderingQuestion.dart';
// import '../../../models/QuestionModels/MatchingQuestion.dart';
// import '../../../models/QuestionModels/FillInTheBlankQuestion.dart';

// import 'multiple_choice_widget.dart';
// import 'ordering_widget.dart';
// import 'matching_widget.dart';
// import 'fill_in_the_blank_widget.dart';

// class QuestionRow extends StatelessWidget {
//   final QuestionBase question;
//   final VoidCallback onDelete;

//   const QuestionRow({
//     Key? key,
//     required this.question,
//     required this.onDelete,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       elevation: 2,
//       child: Padding(
//         padding: const EdgeInsets.all(12),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             _buildHeader(context),
//             const SizedBox(height: 16),
//             _buildQuestionContent(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Text(
//             question.text,
//             style: normalStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//               color: Colors.black87,
//             ),
//             textAlign: TextAlign.right,
//           ),
//         ),
//         IconButton(
//           icon: const Icon(Icons.delete, color: Colors.red),
//           tooltip: 'حذف  السؤال',
//           onPressed: () => _confirmDelete(context),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuestionContent() {
//     switch (question.questionType) {
//       case QuestionType.multipleChoice:
//         return MultipleChoiceWidget(question as MultipleChoiceQuestion);
//       case QuestionType.ordering:
//         return OrderingWidget(question as OrderingQuestion);
//       case QuestionType.matching:
//         return MatchingWidget(question as MatchingQuestion);
//       case QuestionType.fillInTheBlank:
//         return FillInTheBlankWidget(question as FillInTheBlankQuestion);
//       default:
//         return const Text('نوع  سؤال  غير  معروف');
//     }
//   }

//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('تأكيد  الحذف'),
//         content: const Text('هل  أنت  متأكد  من  حذف  هذا  السؤال؟'),
//         actions: [
//           TextButton(
//             child: const Text('إلغاء'),
//             onPressed: () => Navigator.of(ctx).pop(),
//           ),
//           TextButton(
//             child: const Text('حذف', style: TextStyle(color: Colors.red)),
//             onPressed: () async {
//               Navigator.of(ctx).pop();
//               bool success =
//                   await QuestionController.deleteQuestion(question.id!);
//               //  if  (success)  {
//               //      Lesson?  lesson  =  ctx.read<LessonProvider>().selectedLesson;
//               //      ctx.read<QuestionProvider>().fetchQuestions(lesson?.id  ??  "");
//               //  }
//               onDelete();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
