// import 'package:flutter/material.dart';

// import '../../../Utils/Styles.dart';
// import '../../../models/QuestionModels/OrderingQuestion.dart';

// class OrderingWidget extends StatelessWidget {
//   final OrderingQuestion question;

//   const OrderingWidget(this.question, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'رتب العناصر التالية بالترتيب الصحيح:',
//           style: normalStyle(fontSize: 14, fontWeight: FontWeight.w600),
//           textAlign: TextAlign.right,
//         ),
//         const SizedBox(height: 10),
//         Wrap(
//           children: [
//             ...question.correctOrder.map(
//                   (item) => ConstrainedBox(
//                     constraints: BoxConstraints(minWidth: 48),
//                     child: Container(
//                                     margin: const EdgeInsets.symmetric(vertical: 4,horizontal: 4),
//                                     padding: const EdgeInsets.all(4),
//                                     decoration: BoxDecoration(
//                     border: Border.all(color: Colors.grey.shade400),
//                     borderRadius: BorderRadius.circular(8),
//                     color: Colors.grey.shade100,
//                                     ),
//                                     child: Text(
//                     item,
//                     textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                   ),
//             ),
//           ],
//         )
//       ],
//     );
//   }
// }
