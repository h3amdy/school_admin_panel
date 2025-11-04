// import 'package:flutter/material.dart';

// import '../../../Utils/Styles.dart';
// import '../../../models/QuestionModels/MatchingQuestion.dart';

// class MatchingWidget extends StatelessWidget {
//   final MatchingQuestion question;

//   const MatchingWidget(this.question, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: [
//         Text(
//           'وصل العناصر من العمود الأيسر مع العمود الأيمن:',
//           style: normalStyle(fontWeight: FontWeight.bold),
//           textAlign: TextAlign.right,
//         ),
//         const SizedBox(height: 10),
//         Row(
//           children: [
//             Expanded(child: _buildColumnItems(question.leftColumn)),
//             const SizedBox(width: 16),
//             Expanded(child: _buildColumnItems(question.rightColumn)),
//           ],
//         ),
//         const SizedBox(height: 12),
//         _buildMatchingCorrectPairs(),
//       ],
//     );
//   }

//   Widget _buildColumnItems(List<String> items) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.stretch,
//       children: items
//           .map(
//             (item) => Container(
//           margin: const EdgeInsets.symmetric(vertical: 4),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.grey.shade100,
//           ),
//           child: Text(
//             item,
//             textAlign: TextAlign.right,
//           ),
//         ),
//       )
//           .toList(),
//     );
//   }

//   Widget _buildMatchingCorrectPairs() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'الأزواج الصحيحة:',
//           style: normalStyle(fontWeight: FontWeight.w600),
//           textAlign: TextAlign.right,
//         ),
//         const SizedBox(height: 6),
//         Wrap(
//           spacing: 8,
//           children: question.correctMatches.map((pair) {
//             final leftIndex = pair['leftIndex'] ?? -1;
//             final rightIndex = pair['rightIndex'] ?? -1;

//             String leftItem = leftIndex >= 0 && leftIndex < question.leftColumn.length
//                 ? question.leftColumn[leftIndex]
//                 : 'غير معروف';
//             String rightItem = rightIndex >= 0 && rightIndex < question.rightColumn.length
//                 ? question.rightColumn[rightIndex]
//                 : 'غير معروف';

//             return Chip(
//               label: Text('$leftItem ↔ $rightItem'),
//               backgroundColor: Colors.blue.shade50,
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }
// }
