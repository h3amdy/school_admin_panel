//  import  'package:ashil_school/Controllers/LessonController.dart';
//  import  'package:ashil_school/Providers/LessonProvider.dart';
//  import  'package:ashil_school/Providers/UnitProvider.dart';
//  import  'package:ashil_school/models/lesson.dart';
//  import  'package:ashil_school/models/Unit.dart';
//  import  'package:flutter/cupertino.dart';
//  import  'package:flutter/material.dart';
//  import  'package:provider/provider.dart';

//  import  '../../AppResources.dart';
//  import  '../../Dialogs/NewLessonDialog.dart';
//  import  '../../Dialogs/NewSubjectDialog.dart';
//  import  '../../Utils/MySnackBar.dart';
//  import  '../../Utils/Styles.dart';

//  class  LessonListWidget  extends  StatefulWidget  {
//      Function  onSelected;


//        LessonListWidget({super.key,required  this.onSelected});

//      @override
//      State<LessonListWidget>  createState()  =>  _LessonListWidgetState();

//  }

//  class  _LessonListWidgetState  extends  State<LessonListWidget>  {
//      late  UnitProvider  unitProvider  =  context.read<UnitProvider>();
//      late  LessonProvider  lessonProvider  =  context.watch<LessonProvider>();

//      @override
//      Widget  build(BuildContext  context)  {
//          return  Row(
//              children:  [
//                  Expanded(child:  lessonListWidget()),
//                  IconButton(
//                      icon:  const  Icon(Icons.edit,  color:  secondaryColor),
//                      tooltip:  'تعديل  الدروس',
//                      onPressed:  ()  =>  _showEditLessonsDialog(),
//                  ),
//              ],
//          );
//      }

//        lessonListWidget()  {
//          return  SizedBox(
//              height:  52,
//              child:  ListView.separated(
//                  scrollDirection:  Axis.horizontal,
//                  itemCount:  lessonProvider.lessons.length  +
//                          (unitProvider.selectedUnit  !=  null  ?  1  :  0),
//                  separatorBuilder:  (_,  __)  =>  const  SizedBox(width:  8),
//                  itemBuilder:  (context,  index)  {
//                      if  (index  ==  lessonProvider.lessons.length  &&
//                              unitProvider.selectedUnit  !=  null)  {
//                          return  addLessonBtn();
//                      }
//                      final  lesson  =  lessonProvider.lessons[index];
//                      final  isSelected  =  lessonProvider.selectedLesson?.id  ==  lesson.id;
//                      return  ChoiceChip(
//                          label:  Text(lesson.name,
//                                  style:  normalStyle(
//                                          color:  isSelected  ?  Colors.white  :  Colors.black87)),
//                          selected:  isSelected,
//                          selectedColor:  secondaryColor,
//                          backgroundColor:  Colors.grey.shade200,
//                          onSelected:  (val)  async  {
//                              lessonProvider.selectLesson(lesson);
//                              widget.onSelected();
//                          },
//                          padding:  const  EdgeInsets.symmetric(horizontal:  14,  vertical:  8),
//                      );
//                  },
//              ),
//          );
//      }

//      Widget  addLessonBtn()  {
//          return  ChoiceChip(
//              label:  Icon(Icons.add,  color:  secondaryColor),
//              selected:  false,
//              backgroundColor:  Colors.grey.shade300,
//              onSelected:  (val)  async  {
//                  if  (unitProvider.selectedUnit  !=  null)  {
//                      bool?  success  =      await  showCustomDialog(
//                              context,  NewLessonDialog(unitProvider.selectedUnit!.id));
//                      if(success==true)
//                          _getLessons();
//                  }  else  {
//                      showSnackBar("يرجى  اختيار  وحدة  أولاً");
//                  }
//              },
//              padding:  const  EdgeInsets.all(8),
//          );
//      }

//      void  _getLessons()  {
//          context.read<LessonProvider>().fetchLessons(unitProvider.selectedUnit?.id??"");
//      }
//      void  _showEditLessonsDialog()  {
//          showDialog(
//              context:  context,
//              builder:  (context)  {
//                  return  AlertDialog(
//                      title:    Expanded(child:  Align(
//                              alignment:  Alignment.centerRight,
//                              child:  Text('تعديل  الدروس',style:  normalStyle(color:  secondaryColor,fontWeight:  FontWeight.bold,),))),
//                      content:  Directionality(
//                          textDirection:  TextDirection.rtl,
//                          child:  SizedBox(
//                              width:  double.maxFinite,
//                              child:  ListView.separated(
//                                  shrinkWrap:  true,
//                                  itemCount:  unitProvider.units.length,
//                                  separatorBuilder:  (_,  __)  =>  const  Divider(),
//                                  itemBuilder:  (context,  index)  {
//                                      final  lesson  =  lessonProvider.lessons[index];
//                                      return  ListTile(
//                                          title:  Text(lesson.name),
//                                          trailing:  IconButton(
//                                              icon:  const  Icon(Icons.delete,  color:  Colors.red),
//                                              tooltip:  'حذف  الوحدة',
//                                              onPressed:  ()  =>  _confirmDeleteLesson(lesson),
//                                          ),
//                                      );
//                                  },
//                              ),
//                          ),
//                      ),
//                      actions:  [
//                          TextButton(
//                              child:    Text('إغلاق',style:  normalStyle(),),
//                              onPressed:  ()  =>  Navigator.of(context).pop(),
//                          ),
//                      ],
//                  );
//              },
//          );
//      }

//      void  _confirmDeleteLesson(Lesson  lesson)  {
//          showDialog(
//              context:  context,
//              builder:  (ctx)  =>  AlertDialog(
//                  title:  const  Text('تأكيد  الحذف'),
//                  content:  Text('هل  أنت  متأكد  من  حذف  الدرس  "${lesson.name}"؟'),
//                  actions:  [
//                      TextButton(
//                          child:  const  Text('إلغاء'),
//                          onPressed:  ()  =>  Navigator.of(ctx).pop(),
//                      ),
//                      TextButton(
//                          child:  const  Text('حذف',  style:  TextStyle(color:  Colors.red)),
//                          onPressed:  ()  async{
//                              Navigator.of(ctx).pop();  //  إغلاق  مربع  التأكيد
//                              Navigator.of(context).pop();  //  إغلاق  مربع  التعديل
//                              await  LessonController.deleteLesson(lesson.id);
//                              lessonProvider.fetchLessons(unitProvider.selectedUnit?.id??"");
//                              showSnackBar('تم  حذف  الدرس  "${lesson.name}"');
//                          },
//                      ),
//                  ],
//              ),
//          );
//      }
//  }


