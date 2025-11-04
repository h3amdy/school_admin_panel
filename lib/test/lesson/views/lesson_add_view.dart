// lesson_add_view.dart

import 'package:ashil_school/Utils/constants/colors.dart';
import 'package:ashil_school/test/lesson/models/lesson_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/lesson_controller.dart';

class LessonAddView extends StatelessWidget {
  final LessonController controller = Get.put(LessonController());

  // === 1. الشريط العلوي (AppBar & Edit Form) ===
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      actionsPadding: EdgeInsets.all(0),
      title: Obx(() => ListTile(
          leading: CircleAvatar(
            child: Text('${controller.lessonOrder.value}',
                style: TextStyle(fontSize: 20, color: KColors.primary)),
          ),
          title: Text(controller.lessonTitle.value,
              maxLines: 1, style: TextStyle(color: KColors.white)),
          subtitle: Text(controller.lessonDetails.value,
              maxLines: 1,
              style: TextStyle(color: Colors.white70, fontSize: 14)))),
          bottom: PreferredSize(
        preferredSize:
            Size.fromHeight(controller.isEditing.value ? 150.0 : 10.0),
        child: Obx(() {
          return controller.isEditing.value
              ? _buildEditForm()
              : SizedBox.shrink();
        }),
      ),
      // ----------------------------------------------------
      actions: [
        IconButton(
          icon: Icon(Icons.quiz_outlined, color: Colors.white),
          tooltip: 'الانتقال للأسئلة',
          onPressed: () => print('Go to Questions'),
        ),
        Obx(() => IconButton(
              icon: Icon(controller.isEditing.value ? Icons.cancel : Icons.edit,
                  color: Colors.white),
              tooltip: controller.isEditing.value
                  ? 'إلغاء التعديل'
                  : 'تعديل التفاصيل',
              onPressed: () => controller.isEditing.toggle(),
            )),
      ],
      backgroundColor: Colors.indigo,
    );
  }

  Widget _buildEditForm() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: Colors.indigo.shade700,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'عنوان الدرس',
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true),
                  onChanged: (val) => controller.lessonTitle.value = val,
                  controller:
                      TextEditingController(text: controller.lessonTitle.value),
                ),
              ),
              SizedBox(width: 8),
              SizedBox(
                width: 60,
                child: TextField(
                  decoration: InputDecoration(
                      hintText: 'الترتيب',
                      filled: true,
                      fillColor: Colors.white,
                      isDense: true),
                  keyboardType: TextInputType.number,
                  onChanged: (val) =>
                      controller.lessonOrder.value = int.tryParse(val) ?? 1,
                  controller: TextEditingController(
                      text: controller.lessonOrder.value.toString()),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          TextField(
            decoration: InputDecoration(
                hintText: 'تفاصيل الدرس',
                filled: true,
                fillColor: Colors.white,
                isDense: true),
            onChanged: (val) => controller.lessonDetails.value = val,
            controller:
                TextEditingController(text: controller.lessonDetails.value),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => controller.isEditing.toggle(),
                child: Text('إلغاء', style: TextStyle(color: Colors.white70)),
              ),
              ElevatedButton(
                onPressed: () {
                  // منطق حفظ البيانات هنا
                  controller.isEditing.value = false;
                  Get.snackbar('حفظ', 'تم حفظ تفاصيل الدرس بنجاح');
                },
                child: Text('حفظ'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // === 2. قسم المحتوى المعروض ===
  Widget _buildContentDisplaySection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Obx(() => controller.isVerticalView.value
          ? ReorderableListView.builder(
              itemCount: controller.contentList.length,
              onReorder: controller.reorderContent,
              itemBuilder: (context, index) {
                final item = controller.contentList[index];
                final color = controller.getContentBorderColor(index);
                return _buildContentItemCard(item, color, index);
              },
            )
          : SizedBox(
              height: 250, // ارتفاع ثابت للعرض الأفقي
              child: ReorderableListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                onReorder: controller.reorderContent,
                children: controller.contentList.asMap().entries.map((entry) {
                  int index = entry.key;
                  ContentItem item = entry.value;
                  final color = controller.getContentBorderColor(index);
                  // يجب استخدام مفتاح ثابت (Key) في ReorderableListView
                  return Padding(
                    key: ValueKey(item.id),
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Container(
                      width: 200,
                      child: _buildContentItemCard(item, color, index,
                          isHorizontal: true),
                    ),
                  );
                }).toList(),
              ),
            )),
    );
  }

  Widget _buildContentItemCard(ContentItem item, Color color, int index,
      {bool isHorizontal = false}) {
    // محاكاة تمييز العنصر المربوط بالصوت (مثلاً، أول عنصر)
    bool isActive = index == 0 && controller.isAudioPlaying.value;

    return Card(
      key: ValueKey(item.id), // مفتاح ثابت لإعادة الترتيب
      margin: isHorizontal ? null : const EdgeInsets.symmetric(vertical: 6.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
        side: BorderSide(color: color, width: isActive ? 4.0 : 2.0),
      ),
      child: ListTile(
        leading: Icon(
          item.type == ContentType.text ? Icons.article : Icons.image,
          color: color,
        ),
        title: Text(item.type == ContentType.text
            ? item.content.substring(0, 30) + '...'
            : 'صورة مرفقة'),
        subtitle: Text(item.type.name),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: Icon(Icons.edit, size: 20), onPressed: () {}),
            IconButton(icon: Icon(Icons.delete, size: 20), onPressed: () {}),
          ],
        ),
      ),
    );
  }

  // === 3. شريط المحتوى كأيقونات صغيرة ===
  Widget _buildMiniContentStrip() {
    return Container(
      height: 70,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
      child: Obx(() => ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.contentList.length + 1, // +1 لزر الإضافة
            itemBuilder: (context, index) {
              if (index == controller.contentList.length) {
                // زر الإضافة في النهاية
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: FloatingActionButton.small(
                    onPressed: () => Get.defaultDialog(
                        title: 'إضافة محتوى',
                        content: Text('اختر نوع المحتوى')),
                    child: Icon(Icons.add),
                    backgroundColor: Colors.amber,
                  ),
                );
              }

              final item = controller.contentList[index];
              final color = controller.getContentBorderColor(index);

              // أيقونة المحتوى القابلة للسحب
              return Draggable<ContentItem>(
                data: item,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleAvatar(
                    backgroundColor: color,
                    child: Icon(
                      item.type == ContentType.text
                          ? Icons.text_fields
                          : Icons.photo,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
                feedback: CircleAvatar(
                  backgroundColor: color.withOpacity(0.7),
                  child: Icon(Icons.drag_handle, color: Colors.white),
                ),
                childWhenDragging: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: CircleAvatar(backgroundColor: Colors.grey.shade300),
                ),
              );
            },
          )),
    );
  }

  // === 4. شريط المقطع الصوتي (CustomPainter محاكاة) ===
  Widget _buildAudioTimelineStrip() {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          // زر إيقاف تشغيل الصوت
          Obx(() => IconButton(
                icon: Icon(
                  controller.isAudioPlaying.value
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_filled,
                  size: 40,
                  color: Colors.indigo,
                ),
                onPressed: () => controller.isAudioPlaying.toggle(),
              )),
          SizedBox(width: 10),
          // محاكاة الشريط الزمني الملون
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(5),
              ),
              child: CustomPaint(
                painter: AudioTimelinePainter(controller.audioSegments),
                child: Center(
                    child: Text('شريط المقطع الصوتي الملون (لربط الشرائح)',
                        style: TextStyle(fontSize: 12))),
              ),
            ),
          ),
          SizedBox(width: 10),
          // مؤشر الوقت
          Obx(() => Text(
                '${controller.currentTime.value.inSeconds} / ${controller.audioDuration.value.inSeconds} ثانية',
                style: TextStyle(fontSize: 12),
              )),
        ],
      ),
    );
  }

  // === 5. الشريط السفلي (Bottom Bar) ===
  Widget _buildBottomBar() {
    return BottomAppBar(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // اليسار: زر حذف المقطع الصوتي
            IconButton(
              icon: Icon(Icons.delete_forever, color: Colors.red),
              tooltip: 'حذف المقطع الصوتي',
              onPressed: () => print('Delete Audio'),
            ),

            // الوسط: زر إيقاف تشغيل الصوت
            Obx(() => IconButton(
                  icon: Icon(
                    Icons.stop_circle_outlined,
                    size: 45,
                    color: controller.isAudioPlaying.value
                        ? Colors.red
                        : Colors.grey,
                  ),
                  tooltip: 'إيقاف تشغيل الصوت',
                  onPressed: () => controller.isAudioPlaying.value = false,
                )),

            // اليمين: الحفظ والمعاينة
            Row(
              children: [
                OutlinedButton.icon(
                  onPressed: () => print('Preview Lesson'),
                  icon: Icon(Icons.visibility),
                  label: Text('معاينة'),
                ),
                SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => print('Save Lesson'),
                  icon: Icon(Icons.save),
                  label: Text('حفظ الدرس'),
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // دعم اللغة العربية
      child: Scaffold(
        appBar: _buildAppBar(),
        bottomNavigationBar: _buildBottomBar(),
        body: Column(
          children: [
            // 3. شريط الأيقونات المصغرة
            _buildMiniContentStrip(),
            // 4. شريط المقطع الصوتي
            _buildAudioTimelineStrip(),
            // 2. قسم المحتوى المعروض (يأخذ المساحة المتبقية)
            Expanded(child: _buildContentDisplaySection()),
            // زر تبديل العرض (عمودي/أفقي)
            Align(
              alignment: Alignment.bottomLeft,
              child: Obx(() => IconButton(
                    icon: Icon(
                        controller.isVerticalView.value
                            ? Icons.swap_vert
                            : Icons.swap_horiz,
                        size: 30,
                        color: Colors.blueGrey),
                    tooltip: controller.isVerticalView.value
                        ? 'تبديل للأفقي'
                        : 'تبديل للعمودي',
                    onPressed: () => controller.isVerticalView.toggle(),
                  )),
            ),
          ],
        ),
      ),
    );
  }
}

// CustomPainter لرسم شرائح الصوت الملونة (لغرض المحاكاة)
class AudioTimelinePainter extends CustomPainter {
  final RxList<AudioSegment> segments;

  AudioTimelinePainter(this.segments);

  @override
  void paint(Canvas canvas, Size size) {
    double totalDuration = 105; // المدة الافتراضية بالثواني (من Controller)

    for (var segment in segments) {
      final startRatio = segment.startTime.inSeconds / totalDuration;
      final endRatio = segment.endTime.inSeconds / totalDuration;

      final startX = size.width * startRatio;
      final endX = size.width * endRatio;

      final paint = Paint()
        ..color = segment.color.withOpacity(0.6)
        ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTRB(startX, 0, endX, size.height), paint);

      // رسم حدود بيضاء بين الشرائح
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.0;
      canvas.drawLine(Offset(endX, 0), Offset(endX, size.height), borderPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
