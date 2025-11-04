//  import  'package:flutter/material.dart';
//  import  'package:provider/provider.dart';
//
//  import  '../../AppResources.dart';
//  import  '../../Controllers/QuestionController.dart';
//  import  '../../Providers/LessonProvider.dart';
//  import  '../../Providers/QuestionProvider.dart';
//  import  '../../Utils/Styles.dart';
//  import  '../../models/Lesson.dart';
//  import  '../../models/QuestionModels/QuestionBase.dart';
//  import  '../../models/QuestionModels/MultipleChoiceQuestion.dart';
//  import  '../../models/QuestionModels/OrderingQuestion.dart';
//  import  '../../models/QuestionModels/MatchingQuestion.dart';
//
//  class  QuestionRow  extends  StatelessWidget  {
//      final  QuestionBase  question;
//      final  VoidCallback  onDelete;
//
//      const  QuestionRow({
//          Key?  key,
//          required  this.question,
//          required  this.onDelete,
//      })  :  super(key:  key);
//
//      @override
//      Widget  build(BuildContext  context)  {
//          return  Card(
//              margin:  const  EdgeInsets.symmetric(horizontal:  8,  vertical:  6),
//              shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(12)),
//              elevation:  2,
//              child:  Padding(
//                  padding:  const  EdgeInsets.all(12),
//                  child:  Column(
//                      crossAxisAlignment:  CrossAxisAlignment.stretch,
//                      children:  [
//                          _buildHeader(context),
//                          const  SizedBox(height:  16),
//                          _buildQuestionContent(),
//                      ],
//                  ),
//              ),
//          );
//      }
//
//      ///  رأس  البطاقة:  نص  السؤال  وزر  الحذف
//      Widget  _buildHeader(BuildContext  context)  {
//          return  Row(
//              crossAxisAlignment:  CrossAxisAlignment.start,
//              children:  [
//                  Expanded(
//                      child:  Text(
//                          question.text,
//                          style:  normalStyle(
//                              fontSize:  16,
//                              fontWeight:  FontWeight.bold,
//                              color:  Colors.black87,
//                          ),
//                          textAlign:  TextAlign.right,
//                      ),
//                  ),
//                  IconButton(
//                      icon:  const  Icon(Icons.delete,  color:  Colors.red),
//                      tooltip:  'حذف  السؤال',
//                      onPressed:  ()  =>  _confirmDelete(context),
//                  ),
//              ],
//          );
//      }
//
//      ///  بناء  محتوى  السؤال  حسب  نوعه
//      Widget  _buildQuestionContent()  {
//          switch  (question.questionType)  {
//              case  QuestionType.multipleChoice:
//                  return  _buildMultipleChoiceContent(question  as  MultipleChoiceQuestion);
//              case  QuestionType.ordering:
//                  return  _buildOrderingContent(question  as  OrderingQuestion);
//              case  QuestionType.matching:
//                  return  _buildMatchingContent(question  as  MatchingQuestion);
//              case  QuestionType.fillInTheBlank:
//                  return  _buildFillInTheBlankContent();
//              default:
//                  return  const  Text('نوع  سؤال  غير  معروف');
//          }
//      }
//
//      ///  محتوى  سؤال  اختيار  من  متعدد
//      Widget  _buildMultipleChoiceContent(MultipleChoiceQuestion  question)  {
//          List<Widget>  optionRows  =  [];
//
//          for  (int  i  =  0;  i  <  question.options.length;  i  +=  2)  {
//              List<Widget>  rowChildren  =  [
//                  Expanded(child:  _optionTile(question,  i)),
//              ];
//
//              if  (i  +  1  <  question.options.length)  {
//                  rowChildren.add(const  SizedBox(width:  12));
//                  rowChildren.add(Expanded(child:  _optionTile(question,  i  +  1)));
//              }  else  {
//                  rowChildren.add(const  Spacer());
//              }
//
//              optionRows.add(Row(children:  rowChildren));
//              optionRows.add(const  SizedBox(height:  10));
//          }
//
//          return  Column(children:  optionRows);
//      }
//
//      ///  ويدجت  خيار  واحد  مع  تمييز  الصحيح
//      Widget  _optionTile(MultipleChoiceQuestion  question,  int  index)  {
//          final  optionText  =  question.options[index];
//          final  isCorrect  =  index  ==  question.correctAnswerIndex;
//
//          return  Container(
//              padding:  const  EdgeInsets.symmetric(horizontal:  12,  vertical:  14),
//              decoration:  BoxDecoration(
//                  color:  isCorrect  ?  primaryColor  :  Colors.grey.shade100,
//                  borderRadius:  BorderRadius.circular(10),
//                  border:  Border.all(
//                      color:  isCorrect  ?  secondaryColor  :  Colors.grey.shade300,
//                      width:  isCorrect  ?  2  :  1,
//                  ),
//              ),
//              child:  Row(
//                  mainAxisAlignment:  MainAxisAlignment.spaceBetween,
//                  children:  [
//                      Expanded(
//                          child:  Text(
//                              optionText,
//                              style:  normalStyle(
//                                  fontSize:  15,
//                                  color:  isCorrect  ?  secondaryColor  :  Colors.black87,
//                              ),
//                              textAlign:  TextAlign.right,
//                          ),
//                      ),
//                      if  (isCorrect)
//                          Icon(
//                              Icons.check_circle,
//                              color:  secondaryColor,
//                              size:  20,
//                          ),
//                  ],
//              ),
//          );
//      }
//
//      ///  محتوى  سؤال  ترتيب  الحل
//      Widget  _buildOrderingContent(OrderingQuestion  question)  {
//          return  Column(
//              crossAxisAlignment:  CrossAxisAlignment.start,
//              children:  [
//                  Text(
//                      'رتب  العناصر  التالية  بالترتيب  الصحيح:',
//                      style:  normalStyle(fontSize:  14),
//                  ),
//                  const  SizedBox(height:  10),
//                  ...question.items.map(
//                              (item)  =>  Container(
//                          margin:  const  EdgeInsets.symmetric(vertical:  4),
//                          padding:  const  EdgeInsets.all(12),
//                          decoration:  BoxDecoration(
//                              border:  Border.all(color:  Colors.grey.shade400),
//                              borderRadius:  BorderRadius.circular(8),
//                              color:  Colors.grey.shade100,
//                          ),
//                          child:  Text(item),
//                      ),
//                  ),
//              ],
//          );
//      }
//
//      ///  محتوى  سؤال  وصل  بين  عمودين
//      Widget  _buildMatchingContent(MatchingQuestion  question)  {
//          return  Column(
//              crossAxisAlignment:  CrossAxisAlignment.stretch,
//              children:  [
//                  const  Text(
//                      'وصل  العناصر  من  العمود  الأيسر  مع  العمود  الأيمن:',
//                      style:  TextStyle(fontWeight:  FontWeight.bold),
//                  ),
//                  const  SizedBox(height:  10),
//                  Row(
//                      children:  [
//                          Expanded(child:  _buildColumnItems(question.leftColumn)),
//                          const  SizedBox(width:  16),
//                          Expanded(child:  _buildColumnItems(question.rightColumn)),
//                      ],
//                  ),
//              ],
//          );
//      }
//
//      ///  بناء  عمود  من  العناصر
//      Widget  _buildColumnItems(List<String>  items)  {
//          return  Column(
//              crossAxisAlignment:  CrossAxisAlignment.stretch,
//              children:  items
//                      .map(
//                          (item)  =>  Container(
//                      margin: const EdgeInsets.symmetric(vertical: 4),
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             border: Border.all(color: Colors.grey.shade400),
//             borderRadius: BorderRadius.circular(8),
//             color: Colors.grey.shade100,
//           ),
//           child: Text(item),
//         ),
//       )
//           .toList(),
//     );
//   }
//
//   /// محتوى سؤال إكمال الفراغ
//   Widget _buildFillInTheBlankContent() {
//     return const Text(
//       '______',
//       style: TextStyle(fontSize: 20, color: Colors.blue),
//       textAlign: TextAlign.center,
//     );
//   }
//
//   /// عرض مربع تأكيد الحذف
//   void _confirmDelete(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: const Text('تأكيد الحذف'),
//         content: const Text('هل أنت متأكد من حذف هذا السؤال؟'),
//         actions: [
//           TextButton(
//             child: const Text('إلغاء'),
//             onPressed: () => Navigator.of(ctx).pop(),
//           ),
//           TextButton(
//             child: const Text('حذف', style: TextStyle(color: Colors.red)),
//             onPressed: () async {
//               Navigator.of(ctx).pop();
//               bool success = await QuestionController.deleteQuestion(question.id!);
//               if (success) {
//                 Lesson? lesson = ctx.read<LessonProvider>().selectedLesson;
//                 ctx.read<QuestionProvider>().fetchQuestions(lesson?.id ?? "");
//               }
//               onDelete();
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
