//  import  'package:ashil_school/AppResources.dart';
//  import  'package:ashil_school/Providers/QuestionProvider.dart';
//  import  'package:ashil_school/Utils/MySnackBar.dart';
//  import  'package:ashil_school/Utils/Styles.dart';
//  import  'package:ashil_school/models/subject.dart';
//  import  'package:flutter/material.dart';
//  import  'package:provider/provider.dart';

//  import  '../../Dialogs/NewSubjectDialog.dart';
//  import  '../../Dialogs/new_question_dialog.dart';
//  import  '../../Providers/LessonProvider.dart';
//  import  '../../Providers/UnitProvider.dart';
//  import  'LessonListWidget.dart';
//  import  'QuestionRow.dart';
//  import  'QuestionRows/question_row.dart';
//  import  'UnitListWidget.dart';

//  class  SubjectDetailsUI  extends  StatefulWidget  {
//      final  Subject  subject;

//      SubjectDetailsUI(this.subject,  {super.key});

//      @override
//      State<SubjectDetailsUI>  createState()  =>  _SubjectDetailsUIState();
//  }

//  class  _SubjectDetailsUIState  extends  State<SubjectDetailsUI>  {
//      bool  showExplanation  =  true;

//      late  UnitProvider  unitProvider;
//      late  LessonProvider  lessonProvider;
//      late  QuestionProvider  questionProvider;

//      @override
//      void  initState()  {
//          super.initState();
//          Future.microtask((){
//              _getUnits();
//          });

//      }

//      @override
//      Widget  build(BuildContext  context)  {
//          _init();
//          return  Directionality(
//              textDirection:  TextDirection.rtl,
//              child:  Scaffold(
//                  appBar:  AppBar(
//                      title:  Text(widget.subject.name,
//                              style:  normalStyle(
//                                      fontSize:  22,
//                                      fontWeight:  FontWeight.bold,
//                                      color:  Colors.white)),
//                      backgroundColor:  secondaryColor,
//                      elevation:  4,
//                      leading:  InkWell(
//                              onTap:  ()=>Navigator.pop(context),
//                              child:  Icon(Icons.arrow_back_ios,color:  Colors.white,)),
//                  ),
//                  body:  Padding(
//                      padding:  const  EdgeInsets.symmetric(horizontal:  12,  vertical:  8),
//                      child:  Column(
//                          crossAxisAlignment:  CrossAxisAlignment.start,
//                          children:  [
//                              UnitListWddget(widget.subject,onSelected:  ()=>_getLessons(),),
//                              const  SizedBox(height:  12),
//                              LessonListWidget(onSelected:  ()=>_getQuestions(),),
//                              const  SizedBox(height:  12),
//                              explanationToggleBtn(),
//                              if  (showExplanation)  explanationWidget(),
//                              const  SizedBox(height:  16),
//                              Text(
//                                  "أسئلة  الدرس",
//                                  style:  normalStyle(
//                                          fontSize:  20,
//                                          fontWeight:  FontWeight.bold,
//                                          color:  Colors.black87),
//                              ),
//                              const  SizedBox(height:  8),
//                              Expanded(child:  questionListWidget()),
//                          ],
//                      ),
//                  ),
//              ),
//          );
//      }

//      Widget  explanationToggleBtn()  {
//          return  Align(
//              alignment:  Alignment.centerRight,
//              child:  Padding(
//                  padding:  const  EdgeInsets.symmetric(vertical:  6),
//                  child:  ElevatedButton.icon(
//                      icon:  Icon(
//                          showExplanation  ?  Icons.visibility_off  :  Icons.visibility,
//                          size:  20,
//                          color:  primaryColor,
//                      ),
//                      label:  Text(
//                          showExplanation  ?  "إخفاء  الشرح"  :  "عرض  الشرح",
//                          style:  normalStyle(fontSize:  14,  color:  primaryColor),
//                      ),
//                      style:  ElevatedButton.styleFrom(
//                          padding:  const  EdgeInsets.symmetric(horizontal:  14,  vertical:  8),
//                          shape:
//                                  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(8)),
//                          backgroundColor:  secondaryColor,
//                      ),
//                      onPressed:  ()  {
//                          setState(()  {
//                              showExplanation  =  !showExplanation;
//                          });
//                      },
//                  ),
//              ),
//          );
//      }

//      Widget  explanationWidget()  {
//          final  explanationText  =  lessonProvider.selectedLesson?.explanation?.trim();
//          return  Container(
//              width:  double.infinity,
//              margin:  const  EdgeInsets.symmetric(vertical:  8),
//              padding:  const  EdgeInsets.all(12),
//              decoration:  BoxDecoration(
//                  color:  Colors.blueGrey.shade50,
//                  borderRadius:  BorderRadius.circular(12),
//                  border:  Border.all(color:  Colors.blueGrey.shade100),
//              ),
//              child:  Text(
//                  (explanationText  ==  null  ||  explanationText.isEmpty)
//                          ?  "لا  يوجد  شرح."
//                          :  explanationText,
//                  style:  normalStyle(fontSize:  15,  color:  Colors.black87),
//                  textAlign:  TextAlign.right,
//              ),
//          );
//      }

//      Widget  questionListWidget()  {
//          if  (questionProvider.isLoading)  {
//              return  Center(child:  CircularProgressIndicator(color:  secondaryColor));
//          }
//          if  (questionProvider.error  !=  null)  {
//              return  Center(
//                      child:  Text(questionProvider.error!,
//                              style:  normalStyle(color:  Colors.red)));
//          }
//          if  (questionProvider.questions.isEmpty)  {
//              return  Center(
//                  child:  Column(
//                      mainAxisSize:  MainAxisSize.min,
//                      children:  [
//                          Text(
//                              "لا  توجد  أسئلة  لهذا  الدرس.",
//                              style:  normalStyle(color:  Colors.grey.shade700,  fontSize:  16),
//                              textAlign:  TextAlign.center,
//                          ),
//                          const  SizedBox(height:  16),
//                          addQuestionBtn(),
//                      ],
//                  ),
//              );
//          }

//          return  ListView.separated(
//              itemCount:  questionProvider.questions.length  +  1,
//              separatorBuilder:  (_,  __)  =>  const  Divider(height:  1,  color:  Colors.grey),
//              itemBuilder:  (context,  index)  {
//                  if  (index  ==  questionProvider.questions.length)  {
//                      return  addQuestionBtn();
//                  }
//                  final  question  =  questionProvider.questions[index];
//                  return  QuestionRow(  question:  question,onDelete:  (){

//                  },);
//              },
//          );
//      }
//      Widget  addQuestionBtn()  {
//          return  Padding(
//              padding:  const  EdgeInsets.symmetric(vertical:  12,  horizontal:  8),
//              child:  ElevatedButton.icon(
//                  icon:  const  Icon(
//                      Icons.add,
//                      color:  Colors.white,
//                      size:  20,
//                  ),
//                  label:  Text(
//                      "إضافة  سؤال  جديد",
//                      style:  normalStyle(color:  Colors.white),
//                  ),
//                  style:  ElevatedButton.styleFrom(
//                      backgroundColor:  secondaryColor,
//                      padding:  const  EdgeInsets.symmetric(vertical:  12,  horizontal:  12),
//                      shape:  RoundedRectangleBorder(borderRadius:  BorderRadius.circular(10)),
//                  ),
//                  onPressed:  ()  async  {
//                      if  (lessonProvider.selectedLesson  !=  null)  {
//                          bool?  success  =  await  showCustomDialog(
//                              context,
//                              NewQuestionDialog(lessonProvider.selectedLesson!.id),
//                          );
//                          if  (success  ==  true)  _getQuestions();
//                      }  else  {
//                          showSnackBar("يرجى  اختيار  درس  أولاً");
//                      }
//                  },
//              ),
//          );
//      }

    

//      _getQuestions()  async  {
//          if  (lessonProvider.selectedLesson  ==  null)  return;
//          await  questionProvider.fetchQuestions(lessonProvider.selectedLesson!.id);
//      }

//      _getUnits()  async  {
//          await  unitProvider.fetchUnits(widget.subject.id);
//      }

//      void  _init()  {
//          unitProvider  =  context.watch<UnitProvider>();
//          lessonProvider  =  context.watch<LessonProvider>();
//          questionProvider  =  context.watch<QuestionProvider>();
//      }

//      _getLessons()  async  {
//          if  (unitProvider.selectedUnit  ==  null)  return;
//          await  context
//                  .read<LessonProvider>()
//                  .fetchLessons(unitProvider.selectedUnit!.id);
//      }
//  }
