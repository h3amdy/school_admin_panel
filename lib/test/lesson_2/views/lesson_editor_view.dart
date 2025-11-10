// import 'package:ashil_school/Utils/constants/colors.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../controllers/lesson_editor_controller.dart';
// import '../models/lesson_model.dart';

// class LessonEditorView extends StatelessWidget {
//   const LessonEditorView({super.key});

//   // دالة مساعدة لتحويل Duration إلى تنسيق mm:ss
//   String formatDuration(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return '$minutes:$seconds';
//   }

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(LessonEditorController());

//     return Obx(() => Scaffold(
//           appBar: _buildAppBar(context, controller,
//               isEditing: controller.isEditingDetails),
//           body: Column(
//             children: [
//               // // 1. قسم لوحة التعديل المنسدلة
//               // Obx(() => controller.isEditingDetails.value
//               //     ? _buildEditPanel(context, controller)
//               //     : const SizedBox.shrink()),

//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.only(bottom: 10),
//                   child: Column(
//                     children: [
//                       // 2. قسم المحتوى (صور ونصوص)
//                       _buildContentSection(controller),
//                     ],
//                   ),
//                 ),
//               ),

//               // 3. شريط أيقونات المحتوى (شريط الإضافة الأفقي)
//               _buildContentIconStrip(controller),

//               // 4. شريط المقطع الصوتي (التسجيل والربط الزمني)
//               _buildAudioStrip(controller),

//               // 5. الشريط السفلي للأزرار
//               _buildBottomBar(controller),
//             ],
//           ),
//         ));
//   }

//   // ****************** 1. الشريط العلوي (AppBar) ******************
//   PreferredSizeWidget _buildAppBar(
//       BuildContext context, LessonEditorController controller,
//       {required RxBool isEditing}) {
//     return AppBar(
//       title: Obx(() => ListTile(
//           contentPadding: EdgeInsets.all(0),
//           leading: CircleAvatar(
//             child: Text('${controller.lesson.value.lessonNumber}',
//                 style: TextStyle(fontSize: 20, color: KColors.primary)),
//           ),
//           title: Text(controller.lesson.value.title.value,
//               maxLines: 1, style: TextStyle(color: KColors.white)),
//           subtitle: Text(controller.lesson.value.details.value,
//               maxLines: 1,
//               style: TextStyle(color: Colors.white70, fontSize: 14)))),
//       bottom: // 1. قسم لوحة التعديل المنسدلة
//           PreferredSize(
//         preferredSize: Size.fromHeight(isEditing.value ? 220.0 : 10.0),
//         child: Obx(() => isEditing.value
//             ? _buildEditPanel(context, controller)
//             : const SizedBox.shrink()),
//       ),
//       actions: [
//         IconButton(
//           onPressed: () =>
//               Get.snackbar('تنبيه', 'سيتم الانتقال إلى محرر الأسئلة'),
//           icon: const Icon(Icons.question_answer),
//           tooltip: 'إدارة الأسئلة',
//         ),
//         Obx(() => IconButton(
//               onPressed: controller.toggleEditDetails,
//               icon: Icon(
//                   controller.isEditingDetails.value ? Icons.close : Icons.edit),
//               tooltip: controller.isEditingDetails.value
//                   ? 'إلغاء التعديل'
//                   : 'تعديل تفاصيل الدرس',
//             )),
//         const SizedBox(width: 8),
//       ],
//     );
//   }

//   // ****************** لوحة تحرير التفاصيل المنسدلة ******************
//   Widget _buildEditPanel(
//       BuildContext context, LessonEditorController controller) {
//     final theme = Theme.of(context);
//     final containerColor = theme.colorScheme.onPrimaryContainer;
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(12),
//         color: containerColor,
//         boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 4)],
//       ),
//       child: Column(
//         children: [
//           TextField(
//             controller: controller.titleController,
//             decoration: const InputDecoration(labelText: 'اسم الدرس (العنوان)'),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: controller.detailsController,
//             decoration: const InputDecoration(
//                 labelText: 'التفاصيل', border: OutlineInputBorder()),
//           ),
//           const SizedBox(height: 10),
//           TextField(
//             controller: controller.orderController,
//             keyboardType: TextInputType.number,
//             decoration: const InputDecoration(
//                 labelText: 'الترتيب', border: OutlineInputBorder()),
//           ),
//           const SizedBox(height: 16),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   controller.toggleEditDetails();
//                   print("hamdy hamdy hamdy");
//                 },
//                 child: const Text('إلغاء'),
//               ),
//               const SizedBox(width: 10),
//               ElevatedButton.icon(
//                 onPressed: controller.saveDetails,
//                 icon: const Icon(Icons.save),
//                 label: const Text('حفظ التفاصيل'),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ****************** 2. قسم المحتوى ******************
//   Widget _buildContentSection(LessonEditorController controller) {
//     return Obx(
//       () => Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: ListView.builder(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: controller.lesson.value.contentItems.length,
//           itemBuilder: (context, index) {
//             final item = controller.lesson.value.contentItems[index];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8.0),
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   border: Border.all(color: item.color, width: 3),
//                   borderRadius: BorderRadius.circular(12),
//                   color: item.color.withOpacity(0.1),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'المحتوى المرتبط #${index + 1}',
//                       style: TextStyle(
//                         fontWeight: FontWeight.bold,
//                         color: item.color.darken(0.3),
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     if (item.type == ContentType.text)
//                       Text(item.content, style: const TextStyle(fontSize: 14))
//                     else
//                       // عرض placeholder للصورة
//                       Container(
//                         height: 100,
//                         alignment: Alignment.center,
//                         decoration: BoxDecoration(
//                           color: Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Icon(Icons.image,
//                             size: 40, color: item.color.darken(0.3)),
//                       ),
//                     const SizedBox(height: 8),
//                     // معلومات الربط الزمني
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Text(
//                           'المدة المرتبطة: ${formatDuration(item.startTime)} - ${formatDuration(item.endTime)}',
//                           style:
//                               const TextStyle(fontSize: 12, color: Colors.grey),
//                         ),
//                         InkWell(
//                           onTap: () {
//                             // منطق تعديل الربط الزمني
//                             controller.updateSelection(
//                                 item.startTime, item.endTime);
//                             Get.snackbar('تنبيه',
//                                 'تم تحديد الفترة الزمنية للعنصر ${index + 1} على شريط الصوت.');
//                           },
//                           child: Container(
//                             padding: const EdgeInsets.all(4),
//                             decoration: BoxDecoration(
//                               color: item.color,
//                               borderRadius: BorderRadius.circular(4),
//                             ),
//                             child: const Text('تحديد',
//                                 style: TextStyle(
//                                     color: Colors.white, fontSize: 12)),
//                           ),
//                         )
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   // ****************** 3. شريط أيقونات المحتوى ******************
//   Widget _buildContentIconStrip(LessonEditorController controller) {
//     return Container(
//       height: 70,
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.blueGrey.shade50,
//         border: Border.symmetric(
//             horizontal: BorderSide(color: Colors.grey.shade300)),
//       ),
//       child: Row(
//         children: [
//           // قائمة الأيقونات الصغيرة (قابلة للسحب)
//           Expanded(
//             child: Obx(
//               () => ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: controller.lesson.value.contentItems.length,
//                 itemBuilder: (context, index) {
//                   final item = controller.lesson.value.contentItems[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                     child: Tooltip(
//                       message: 'محتوى #${index + 1}',
//                       child: CircleAvatar(
//                         radius: 20,
//                         backgroundColor: item.color,
//                         child: Icon(
//                           item.type == ContentType.text
//                               ? Icons.text_fields
//                               : Icons.image,
//                           color: Colors.white,
//                           size: 18,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ),

//           // زر الإضافة في النهاية
//           Container(
//             margin: const EdgeInsets.only(left: 8),
//             decoration: BoxDecoration(
//               color: Colors.indigo.shade600,
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: IconButton(
//               onPressed: () {
//                 Get.bottomSheet(
//                   _buildAddContentSheet(controller),
//                   backgroundColor: Colors.white,
//                   shape: const RoundedRectangleBorder(
//                       borderRadius:
//                           BorderRadius.vertical(top: Radius.circular(16))),
//                 );
//               },
//               icon: const Icon(Icons.add, color: Colors.white),
//               tooltip: 'إضافة محتوى جديد',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ****************** 4. شريط المقطع الصوتي ******************
//   Widget _buildAudioStrip(LessonEditorController controller) {
//     return Obx(
//       () => Container(
//         height: 120,
//         padding: const EdgeInsets.all(16),
//         color: Colors.white,
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 // زر التسجيل/التشغيل/الإيقاف المؤقت
//                 _buildControlButtons(controller),

//                 // شريط التقدم الزمني
//                 Expanded(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
//                     child: _buildAudioSeekbar(controller),
//                   ),
//                 ),

//                 // عرض المدة الكلية
//                 Text(
//                   formatDuration(controller.totalDuration.value),
//                   style: TextStyle(color: Colors.grey.shade700),
//                 ),
//               ],
//             ),

//             // مؤشر حالة التسجيل
//             if (controller.isRecording.value)
//               const Padding(
//                 padding: EdgeInsets.only(top: 8.0),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Icon(Icons.circle, color: Colors.red, size: 12),
//                     SizedBox(width: 5),
//                     Text('جاري التسجيل...',
//                         style: TextStyle(color: Colors.red)),
//                   ],
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   // زر التحكم (تسجيل أو تشغيل)
//   Widget _buildControlButtons(LessonEditorController controller) {
//     if (controller.isRecording.value) {
//       // زر إيقاف التسجيل
//       return IconButton(
//         icon: const Icon(Icons.stop_circle, size: 48, color: Colors.red),
//         onPressed: controller.stopRecording,
//         tooltip: 'إيقاف التسجيل',
//       );
//     } else if (controller.totalDuration.value == Duration.zero) {
//       // زر بدء التسجيل
//       return IconButton(
//         icon: const Icon(Icons.mic, size: 48, color: Colors.green),
//         onPressed: controller.startRecording,
//         tooltip: 'بدء تسجيل شرح الدرس',
//       );
//     } else {
//       // زر تشغيل/إيقاف مؤقت
//       return IconButton(
//         icon: Icon(
//           controller.isPlaying.value
//               ? Icons.pause_circle_filled
//               : Icons.play_circle_fill,
//           size: 48,
//           color: Colors.blue.shade800,
//         ),
//         onPressed: controller.toggleAudioPlay,
//         tooltip: controller.isPlaying.value ? 'إيقاف مؤقت' : 'تشغيل',
//       );
//     }
//   }

//   // شريط التقدم الصوتي مع الفترات الملونة
//   Widget _buildAudioSeekbar(LessonEditorController controller) {
//     final totalMs = controller.totalDuration.value.inMilliseconds.toDouble();

//     if (totalMs == 0) {
//       return Container(
//         height: 30,
//         alignment: Alignment.center,
//         decoration: BoxDecoration(
//           color: Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(15),
//         ),
//         child: const Text('... لا يوجد مقطع صوتي، ابدأ التسجيل'),
//       );
//     }

//     return Container(
//       height: 30,
//       clipBehavior: Clip.hardEdge,
//       decoration: BoxDecoration(
//         color: Colors.grey.shade200,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Stack(
//         children: [
//           // 1. الفترات الزمنية الملونة المرتبطة بالمحتوى
//           ...controller.lesson.value.contentItems.map((item) {
//             final startRatio = item.startTime.inMilliseconds / totalMs;
//             final endRatio = item.endTime.inMilliseconds / totalMs;

//             return FractionallySizedBox(
//               widthFactor: endRatio - startRatio,
//               alignment: Alignment.topLeft,
//               child: Container(
//                 margin: const EdgeInsets.symmetric(vertical: 4),
//                 color: item.color.withOpacity(0.6),
//               ),
//             );
//           }),

//           // 2. مؤشر البداية والنهاية للتحديد (موك أب، يحتاج إلى منطق سحب حقيقي)
//           Positioned.fill(
//             child: Row(
//               children: [
//                 // مؤشر البداية
//                 SizedBox(
//                   width: controller.selectionStart.value.inMilliseconds /
//                       totalMs *
//                       MediaQuery.of(Get.context!).size.width *
//                       0.6,
//                 ),
//                 Icon(Icons.arrow_drop_up, color: Colors.red.shade700, size: 20),
//                 // مؤشر النهاية
//                 SizedBox(
//                   width: (controller.selectionEnd.value.inMilliseconds -
//                           controller.selectionStart.value.inMilliseconds) /
//                       totalMs *
//                       MediaQuery.of(Get.context!).size.width *
//                       0.6,
//                   child: Align(
//                     alignment: Alignment.centerRight,
//                     child: Icon(Icons.arrow_drop_up,
//                         color: Colors.red.shade700, size: 20),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // 3. شريط التقدم الفعلي (Slider)
//           Positioned.fill(
//             child: Slider(
//               min: 0.0,
//               max: totalMs,
//               value: controller.currentPosition.value.inMilliseconds
//                   .toDouble()
//                   .clamp(0.0, totalMs),
//               onChanged: (double value) {
//                 controller.audioPlayer
//                     .seek(Duration(milliseconds: value.toInt()));
//               },
//               activeColor:
//                   Colors.transparent, // لجعل الشريط يظهر فوق الشرائط الملونة
//               inactiveColor: Colors.transparent,
//               thumbColor: Colors.black, // مؤشر التشغيل
//             ),
//           ),

//           // 4. عرض التوقيت الحالي
//           Positioned(
//             left: 0,
//             bottom: 0,
//             child: Text(
//               formatDuration(controller.currentPosition.value),
//               style: const TextStyle(fontSize: 10, color: Colors.black54),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ****************** 5. الشريط السفلي ******************
//   Widget _buildBottomBar(LessonEditorController controller) {
//     return Container(
//       height: 70,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         boxShadow: [BoxShadow(color: Colors.grey.shade300, blurRadius: 5)],
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           // زر حذف المقطع الصوتي المختار
//           Obx(() => controller.lesson.value.audioPath.value.isNotEmpty
//               ? IconButton(
//                   onPressed: controller.deleteAudio,
//                   icon: const Icon(Icons.mic_off),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.red.shade400,
//                     foregroundColor: Colors.white,
//                   ),
//                   // label: const Text('حذف الصوت'),
//                 )
//               : const SizedBox(width: 100)), // للحفاظ على التنسيق

//           // زر إيقاف تشغيل الصوت (في المنتصف)
//           IconButton(
//             onPressed: () => controller.audioPlayer.stop(),
//             icon: const Icon(
//               Icons.stop,
//               size: 40,
//             ),
//             //label: const Text('إيقاف الصوت'),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.deepOrange,
//               foregroundColor: Colors.white,
//               shape: CircleBorder(),
//               elevation: 5,
//             ),
//           ),

//           // أزرار الحفظ والمعاينة
//           Row(
//             children: [
//               IconButton(
//                 onPressed: controller.previewLesson,
//                 icon: const Icon(Icons.visibility),
//                 // label: const Text('معاينة'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.grey.shade600,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//               const SizedBox(width: 10),
//               IconButton(
//                 onPressed: controller.saveLesson,
//                 icon: const Icon(Icons.send_outlined),
//                 // label: const Text('حفظ الدرس'),s
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.indigo.shade700,
//                   foregroundColor: Colors.white,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   // ****************** شيت إضافة المحتوى ******************
//   Widget _buildAddContentSheet(LessonEditorController controller) {
//     return Padding(
//       padding: const EdgeInsets.all(20.0),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: [
//           const Text('اختر نوع المحتوى للإضافة',
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           const SizedBox(height: 20),
//           ElevatedButton.icon(
//             onPressed: () => controller.addContentItem(ContentType.text),
//             icon: const Icon(Icons.text_fields),
//             label: const Text('إضافة نص', style: TextStyle(fontSize: 16)),
//             style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
//           ),
//           const SizedBox(height: 10),
//           ElevatedButton.icon(
//             onPressed: () => controller.addContentItem(ContentType.image),
//             icon: const Icon(Icons.image),
//             label: const Text('إضافة صورة', style: TextStyle(fontSize: 16)),
//             style: ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
// }

// // دالة مساعدة لتغميق اللون قليلاً
// extension ColorExtension on Color {
//   Color darken([double amount = .1]) {
//     assert(amount >= 0 && amount <= 1);
//     final hsl = HSLColor.fromColor(this);
//     final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
//     return hsl.withLightness(lightness).toColor();
//   }
// }
