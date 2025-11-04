// import 'package:flutter/material.dart';

// import '../../../AppResources.dart';
// import '../../../Utils/Styles.dart';
// import '../../../models/QuestionModels/FillInTheBlankQuestion.dart';

// class FillInTheBlankWidget extends StatelessWidget {
//   final FillInTheBlankQuestion question;

//   const FillInTheBlankWidget(this.question, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> optionWidgets = [];

//     for (int i = 0; i < question.options.length; i++) {
//       final optionText = question.options[i];
//       final isCorrect = i == question.correctAnswerIndex;

//       optionWidgets.add(Container(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           color: isCorrect ? primaryColor : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(10),
//           border: Border.all(
//             color: isCorrect ? secondaryColor : Colors.grey.shade300,
//             width: isCorrect ? 2 : 1,
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Expanded(
//               child: Text(
//                 optionText,
//                 style: normalStyle(
//                   fontSize: 15,
//                   color: isCorrect ? secondaryColor : Colors.black87,
//                 ),
//                 textAlign: TextAlign.right,
//               ),
//             ),
//             if (isCorrect)
//               Icon(
//                 Icons.check_circle,
//                 color: secondaryColor,
//                 size: 20,
//               ),
//           ],
//         ),
//       ));
//     }

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           question.text,
//           style: normalStyle(fontWeight: FontWeight.bold, fontSize: 16),
//           textAlign: TextAlign.right,
//         ),
//         const SizedBox(height: 12),
//         ...optionWidgets,
//       ],
//     );
//   }
// }
