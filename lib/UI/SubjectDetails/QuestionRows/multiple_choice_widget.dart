// import 'package:flutter/material.dart';

// import '../../../AppResources.dart';
// import '../../../Utils/Styles.dart';
// import '../../../models/QuestionModels/MultipleChoiceQuestion.dart';

// class MultipleChoiceWidget extends StatelessWidget {
//   final MultipleChoiceQuestion question;

//   const MultipleChoiceWidget(this.question, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     List<Widget> optionRows = [];

//     for (int i = 0; i < question.options.length; i += 2) {
//       List<Widget> rowChildren = [
//         Expanded(child: _optionTile(i)),
//       ];

//       if (i + 1 < question.options.length) {
//         rowChildren.add(const SizedBox(width: 12));
//         rowChildren.add(Expanded(child: _optionTile(i + 1)));
//       } else {
//         rowChildren.add(const Spacer());
//       }

//       optionRows.add(Row(children: rowChildren));
//       optionRows.add(const SizedBox(height: 10));
//     }

//     return Column(children: optionRows);
//   }

//   Widget _optionTile(int index) {
//     final optionText = question.options[index];
//     final isCorrect = index == question.correctAnswerIndex;

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//       decoration: BoxDecoration(
//         color: isCorrect ? primaryColor : Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: isCorrect ? secondaryColor : Colors.grey.shade300,
//           width: isCorrect ? 2 : 1,
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               optionText,
//               style: normalStyle(
//                 fontSize: 15,
//                 color: isCorrect ? secondaryColor : Colors.black87,
//               ),
//               textAlign: TextAlign.right,
//             ),
//           ),
//           if (isCorrect)
//             Icon(
//               Icons.check_circle,
//               color: secondaryColor,
//               size: 20,
//             ),
//         ],
//       ),
//     );
//   }
// }
