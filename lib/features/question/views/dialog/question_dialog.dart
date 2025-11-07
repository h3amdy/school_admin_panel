import 'package:ashil_school/Utils/constants/sizes.dart';
import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/Utils/question/question_utils.dart';
import 'package:ashil_school/common/widgets/section_heading.dart';
import 'package:ashil_school/features/question/controllers/question_controller.dart';
import 'package:ashil_school/features/question/controllers/question_dialog_controller.dart';
import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:ashil_school/features/question/models/option_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuestionDialog extends StatelessWidget {
  final BaseQuestion? questionToEdit;
  final Function(Map<String, dynamic>, {String? questionId}) onSave;

  const QuestionDialog({
    super.key,
    this.questionToEdit,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    // استخدم Get.put لاستبدال الكنترولر عند فتح نافذة التعديل
    final controller = Get.put(QuestionDialogController());
    final formKey = GlobalKey<FormState>();

    // تهيئة حالة التعديل أو الإضافة
    if (questionToEdit != null) {
      controller.loadQuestionForEdit(questionToEdit!);
    } else {
      try {
        final questionsCount = Get.find<QuestionController>().questions.length;
        controller.orderController.text = (questionsCount + 1).toString();
      } catch (_) {
        controller.orderController.text = '1';
      }
      // ✅ T2: تأكد من إضافة الحقل الأول للنوع الافتراضي (MCQ)
      controller.addFirstFieldIfNeeded(controller.selectedType.value);
    }

    return CustomDialog(
      title: questionToEdit == null ? "إضافة سؤال جديد" : "تعديل السؤال",
      body: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              fit: FlexFit.loose,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    // حقول الترتيب والنوع
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child:
                              Obx(() => DropdownButtonFormField<QuestionType>(
                                    value: controller.selectedType.value,
                                    onChanged: controller.setSelectedType,
                                    decoration: const InputDecoration(
                                      labelText: "نوع السؤال",
                                      border: OutlineInputBorder(),
                                    ),
                                    items: QuestionType.values
                                        .map((type) => DropdownMenuItem(
                                              value: type,
                                              child: Text(
                                                  getQuestionTypeName(type)),
                                            ))
                                        .toList(),
                                  )),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: controller.orderController,
                            decoration: const InputDecoration(
                              labelText: "الترتيب",
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "مطلوب";
                              }
                              if (int.tryParse(value) == null) {
                                return "أدخل رقمًا";
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ✅ T1: نص السؤال مع زر الميديا
                    TextFormField(
                      controller: controller.questionTextController,
                      decoration: InputDecoration(
                        labelText: "نص السؤال",
                        border: const OutlineInputBorder(),
                        alignLabelWithHint: true,
                        // ✅ T2: تغيير الأيقونة إلى لاحقة
                        suffixIcon: PopupMenuButton<String>(
                          icon: const Icon(Icons.attach_file),
                          onSelected: (value) {
                            if (value == 'camera') {
                              controller.pickImageFromCamera();
                            } else if (value == 'gallery') {
                              controller.pickImageFromGallery();
                            } else if (value == 'audio') {
                              controller.pickAudio();
                            }
                          },
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<String>>[
                            const PopupMenuItem<String>(
                              value: 'camera',
                              child: ListTile(
                                leading: Icon(Icons.camera_alt),
                                title: Text('الكاميرا'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'gallery',
                              child: ListTile(
                                leading: Icon(Icons.image),
                                title: Text('المعرض'),
                              ),
                            ),
                            const PopupMenuItem<String>(
                              value: 'audio',
                              child: ListTile(
                                leading: Icon(Icons.audiotrack),
                                title: Text('مقطع صوتي'),
                              ),
                            ),
                          ],
                        ),
                      ),
                      maxLines: 3,
                      minLines: 1,
                      validator: (value) {
                        // التحقق من الصحة يجب أن يأخذ في الاعتبار المرفقات
                        if ((value == null || value.isEmpty) &&
                            controller.questionImageUrl.value == null &&
                            controller.questionAudioUrl.value == null) {
                          return "نص السؤال (أو مرفقاته) لا يمكن أن يكون فارغًا.";
                        }
                        return null;
                      },
                    ),

                    // ✅ T1: عرض المرفقات المختارة للسؤال
                    Obx(() => _buildQuestionMediaAttachments(controller)),

                    const SizedBox(height: 16),

                    // حقل شرح الإجابة (Explanation)
                    TextFormField(
                      controller: controller.explanationController,
                      decoration: const InputDecoration(
                        labelText: "شرح الإجابة الصحيحة (اختياري)",
                        hintText: "شرح يظهر للمستخدم بعد الإجابة",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 2,
                      minLines: 1,
                    ),
                    const SizedBox(height: 20),
                    // حقول الخيارات الديناميكية
                    Obx(() => _buildDynamicFields(controller)),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
            // ✅ T1: إزالة زر الإضافة اليدوي
            // Obx(() => _buildAddButton(controller)), // ⛔️ تم الحذف
            const SizedBox(height: KSizes.spaceBewItems),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.red.shade400)),
                  onPressed: () => Get.back(),
                  child: const Text("إلغاء"),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final questionData = controller.prepareQuestionData();
                      onSave(questionData, questionId: questionToEdit?.id);
                      Get.back();
                    }
                  },
                  child: const Text("حفظ"),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  // ✅ T1: ويدجت لعرض مرفقات نص السؤال
  Widget _buildQuestionMediaAttachments(QuestionDialogController controller) {
    if (controller.questionImageUrl.value == null &&
        controller.questionAudioUrl.value == null) {
      return const SizedBox.shrink();
    }

    String title = '';
    IconData icon = Icons.error;

    if (controller.questionImageUrl.value != null) {
      title =
          'صورة مرفقة: ${controller.questionImageUrl.value!.split('/').last}';
      icon = Icons.image;
    } else if (controller.questionAudioUrl.value != null) {
      title =
          'صوت مرفق: ${controller.questionAudioUrl.value!.split('/').last}';
      icon = Icons.audiotrack;
    }

    return Card(
      margin: const EdgeInsets.only(
          top: 8, left: 40, right: 40), // تمت إضافة هامش لتمييزه
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis),
        trailing: IconButton(
          icon: const Icon(Icons.clear, size: 18, color: Colors.red),
          onPressed: () {
            controller.clearQuestionMedia();
          },
        ),
      ),
    );
  }

  // دالة تحدد نوع الحقول التي سيتم عرضها
  Widget _buildDynamicFields(QuestionDialogController controller) {
    switch (controller.selectedType.value) {
      case QuestionType.mcq:
        return _buildMCQFields(controller);
      case QuestionType.trueFalse:
        return _buildTrueFalseFields(controller);
      case QuestionType.matching:
        return _buildMatchingFields(controller);
      case QuestionType.fillBlank:
        return _buildFillBlankFields(controller);
      case QuestionType.ordering:
        return _buildOrderingFields(controller);
      case QuestionType.essay:
        return _buildEssayFields(controller);
    }
  }

  // ✅ T3: ويدجت لعرض مرفقات *الخيار*
  Widget _buildOptionMediaAttachments(Option option,
      {required Function onClearImage, required Function onClearAudio}) {
    return Column(
      children: [
        if (option.imageUrl != null && option.imageUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4.0, left: 40.0, right: 8.0),
            child: Row(
              children: [
                const Icon(Icons.image_outlined, size: 16, color: Colors.blue),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'صورة: ${option.imageUrl!.split('/').last}',
                    style: const TextStyle(fontSize: 11, color: Colors.blue),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Colors.red),
                  onPressed: () => onClearImage(),
                ),
              ],
            ),
          ),
        if (option.audioUrl != null && option.audioUrl!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 0.0, left: 40.0, right: 8.0),
            child: Row(
              children: [
                const Icon(Icons.volume_up, size: 16, color: Colors.orange),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    'صوت: ${option.audioUrl!.split('/').last}',
                    style: const TextStyle(fontSize: 11, color: Colors.orange),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.clear, size: 16, color: Colors.red),
                  onPressed: () => onClearAudio(),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // 💡 حقول الاختيار من متعدد
  Widget _buildMCQFields(QuestionDialogController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const KSectionHeading(title: "الخيارات:"),
        Obx(() => Column(
                children: controller.mcqOptions.asMap().entries.map((entry) {
              final index = entry.key;
              // التأكد من أن الخيار لا يزال موجوداً (قد يُحذف)
              if (index >= controller.mcqOptions.length)
                return const SizedBox.shrink();
              final option = controller.mcqOptions[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Checkbox
                        Obx(() => Checkbox(
                              value: controller.mcqCorrectAnswerIndexes
                                  .contains(index),
                              onChanged: (bool? isChecked) {
                                if (isChecked != null) {
                                  controller.toggleCorrectMCQAnswer(index,
                                      true); // افترض إمكانية تعدد الإجابات
                                }
                              },
                            )),
                        // حقل النص
                        Expanded(
                          // ✅ T2: إضافة Focus
                          child: Focus(
                            onFocusChange: (hasFocus) {
                              // ✅ T1: تعديل شرط الحذف التلقائي
                              if (!hasFocus &&
                                  controller.mcqOptions.length >
                                      2 && // يجب أن يكون هناك أكثر من حقلين
                                  index < controller.mcqOptions.length) {
                                final option = controller.mcqOptions[index];
                                final bool isEmpty =
                                    (option.text ?? '').isEmpty &&
                                        (option.imageUrl ?? '').isEmpty &&
                                        (option.audioUrl ?? '').isEmpty;
                                if (isEmpty) {
                                  // جدولة الحذف لتجنب أخطاء البناء
                                  Future.delayed(Duration.zero, () {
                                    controller.removeField(
                                        QuestionType.mcq, index);
                                  });
                                }
                              }
                            },
                            child: TextFormField(
                              initialValue: option.text, // استخدام القيمة مباشرة
                              decoration: InputDecoration(
                                labelText: "خيار ${index + 1}",
                                border: const OutlineInputBorder(),
                                // ✅ T2: تغيير الأيقونة إلى لاحقة
                                suffixIcon: PopupMenuButton<String>(
                                  icon: const Icon(Icons.attach_file,
                                      size: 20),
                                  onSelected: (value) {
                                    if (value == 'camera') {
                                      controller.pickImageForOption(
                                          controller.mcqOptions, index,
                                          fromCamera: true);
                                    } else if (value == 'gallery') {
                                      controller.pickImageForOption(
                                          controller.mcqOptions, index);
                                    } else if (value == 'audio') {
                                      controller.pickAudioForOption(
                                          controller.mcqOptions, index);
                                    }
                                  },
                                  itemBuilder: (BuildContext context) =>
                                      <PopupMenuEntry<String>>[
                                    const PopupMenuItem<String>(
                                        value: 'camera',
                                        child: Text('كاميرا')),
                                    const PopupMenuItem<String>(
                                        value: 'gallery',
                                        child: Text('معرض')),
                                    const PopupMenuItem<String>(
                                        value: 'audio',
                                        child: Text('صوت')),
                                  ],
                                ),
                              ),
                              onChanged: (value) {
                                // التأكد من أن الخيار لا يزال موجوداً قبل التحديث
                                if (index < controller.mcqOptions.length) {
                                  controller.mcqOptions[index] =
                                      option.copyWith(text: value);
                                }

                                // ✅ T2: إضافة حقل تالي تلقائيًا
                                if (index ==
                                        controller.mcqOptions.length - 1 &&
                                    value.isNotEmpty) {
                                  controller.addField(QuestionType.mcq);
                                }
                              },
                              validator: (value) {
                                // ✅ T3: تعديل التحقق
                                final bool isEmpty =
                                    (value == null || value.isEmpty) &&
                                        (option.imageUrl ?? '').isEmpty &&
                                        (option.audioUrl ?? '').isEmpty;
                                
                                // فقط الحقلين الأولين إجباريين
                                if (isEmpty && index < 2) {
                                  return "يجب ملء الخيارين الأولين";
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        // ✅ T2: إزالة زر الحذف اليدوي
                        // if (index > 1) ... else ... // ⛔️ تم الحذف
                      ],
                    ),
                    // ✅ T3: عرض المرفقات المختارة *لهذا الخيار*
                    _buildOptionMediaAttachments(
                      option,
                      onClearImage: () => controller.clearMediaForOption(
                          controller.mcqOptions, index,
                          clearImage: true),
                      onClearAudio: () => controller.clearMediaForOption(
                          controller.mcqOptions, index,
                          clearAudio: true),
                    ),
                    const Divider(height: 10, thickness: 1),
                  ],
                ),
              );
            }).toList())),
      ],
    );
  }

  Widget _buildTrueFalseFields(QuestionDialogController controller) {
    return Obx(() => Column(
          children: [
            ListTile(
              title: const Text("الإجابة الصحيحة هي 'صح'"),
              leading: Radio<bool>(
                value: true,
                groupValue: controller.questionData['isTrue'] as bool? ?? false,
                onChanged: (value) => controller.questionData['isTrue'] = value,
              ),
            ),
            ListTile(
              title: const Text("الإجابة الصحيحة هي 'خطأ'"),
              leading: Radio<bool>(
                value: false,
                groupValue: controller.questionData['isTrue'] as bool? ?? false,
                onChanged: (value) => controller.questionData['isTrue'] = value,
              ),
            ),
          ],
        ));
  }

  Widget _buildFillBlankFields(QuestionDialogController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "أدخل الإجابات الصحيحة لكل فراغ (يتم تحديد الفراغ باستخدام {{}} في نص السؤال):",
            style: TextStyle(fontWeight: FontWeight.bold)),
        Obx(() {
          return Column(
            children:
                controller.fillBlankCorrectAnswers.asMap().entries.map((entry) {
              final index = entry.key;
              final textController = entry
                  .value; // هنا يتم استخدام Controller لأنه مُدار في QuestionDialogController
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: textController,
                        decoration: InputDecoration(
                          labelText: "الإجابة للفراغ ${index + 1}",
                          border: const OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "الإجابة لا يمكن أن تكون فارغة.";
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => controller.removeFillBlank(index),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  // 💡 حقول المطابقة
  Widget _buildMatchingFields(QuestionDialogController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "أدخل أزواج المطابقة (العنصر الأيمن يطابق العنصر الأيسر في نفس الصف):"),
        Obx(() => Column(
                children:
                    controller.matchingLeftItems.asMap().entries.map((entry) {
              final index = entry.key;
              // التأكد من أن العناصر لا تزال موجودة
              if (index >= controller.matchingLeftItems.length ||
                  index >= controller.matchingRightItems.length) {
                return const SizedBox.shrink();
              }
              final leftOption = entry.value;
              final rightOption = controller.matchingRightItems[index];

              // دالة التحقق من الحذف التلقائي
              void checkAutoDelete() {
                // ✅ T1: تعديل شرط الحذف التلقائي
                if (controller.matchingLeftItems.length > 2 && // يجب أن يكون هناك أكثر من حقلين
                    index < controller.matchingLeftItems.length) {
                  final left = controller.matchingLeftItems[index];
                  final right = controller.matchingRightItems[index];
                  final bool leftIsEmpty = (left.text ?? '').isEmpty &&
                      (left.imageUrl ?? '').isEmpty &&
                      (left.audioUrl ?? '').isEmpty;
                  final bool rightIsEmpty = (right.text ?? '').isEmpty &&
                      (right.imageUrl ?? '').isEmpty &&
                      (right.audioUrl ?? '').isEmpty;

                  if (leftIsEmpty && rightIsEmpty) {
                    Future.delayed(Duration.zero, () {
                      controller.removeField(QuestionType.matching, index);
                    });
                  }
                }
              }

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Focus(
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) checkAutoDelete();
                                },
                                child: TextFormField(
                                  initialValue: leftOption.text,
                                  decoration: InputDecoration(
                                    labelText: "العنصر الأيمن",
                                    border: const OutlineInputBorder(),
                                    // ✅ T2: تغيير الأيقونة إلى لاحقة
                                    suffixIcon: PopupMenuButton<String>(
                                      icon: const Icon(Icons.attach_file,
                                          size: 20),
                                      onSelected: (value) {
                                        if (value == 'camera') {
                                          controller.pickImageForOption(
                                              controller.matchingLeftItems,
                                              index,
                                              fromCamera: true);
                                        } else if (value == 'gallery') {
                                          controller.pickImageForOption(
                                              controller.matchingLeftItems,
                                              index);
                                        } else if (value == 'audio') {
                                          controller.pickAudioForOption(
                                              controller.matchingLeftItems,
                                              index);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                            value: 'camera',
                                            child: Text('كاميرا')),
                                        const PopupMenuItem<String>(
                                            value: 'gallery',
                                            child: Text('معرض')),
                                        const PopupMenuItem<String>(
                                            value: 'audio',
                                            child: Text('صوت')),
                                      ],
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (index <
                                        controller.matchingLeftItems.length) {
                                      controller.matchingLeftItems[index] =
                                          leftOption.copyWith(text: value);
                                    }

                                    // ✅ T2: إضافة حقل تالي تلقائيًا
                                    // ✅ T1: إصلاح خطأ .text.isNotEmpty
                                    if (index ==
                                            controller.matchingLeftItems
                                                    .length -
                                                1 &&
                                        value.isNotEmpty &&
                                        (controller.matchingRightItems[index]
                                                    .text ??
                                                '')
                                            .isNotEmpty) {
                                      controller
                                          .addField(QuestionType.matching);
                                    }
                                  },
                                  validator: (value) {
                                    // ✅ T3: تعديل التحقق
                                    final bool isEmpty = (value == null || value.isEmpty) &&
                                        (leftOption.imageUrl ?? '').isEmpty &&
                                        (leftOption.audioUrl ?? '').isEmpty;
                                    
                                    if (isEmpty && index < 2) {
                                      return "الحقل إجباري";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              // ✅ T3: عرض مرفقات الخيار الأيمن
                              _buildOptionMediaAttachments(
                                leftOption,
                                onClearImage: () =>
                                    controller.clearMediaForOption(
                                        controller.matchingLeftItems, index,
                                        clearImage: true),
                                onClearAudio: () =>
                                    controller.clearMediaForOption(
                                        controller.matchingLeftItems, index,
                                        clearAudio: true),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Focus(
                                onFocusChange: (hasFocus) {
                                  if (!hasFocus) checkAutoDelete();
                                },
                                child: TextFormField(
                                  initialValue: rightOption.text,
                                  decoration: InputDecoration(
                                    labelText: "العنصر الأيسر",
                                    border: const OutlineInputBorder(),
                                    // ✅ T2: تغيير الأيقونة إلى لاحقة
                                    suffixIcon: PopupMenuButton<String>(
                                      icon: const Icon(Icons.attach_file,
                                          size: 20),
                                      onSelected: (value) {
                                        if (value == 'camera') {
                                          controller.pickImageForOption(
                                              controller.matchingRightItems,
                                              index,
                                              fromCamera: true);
                                        } else if (value == 'gallery') {
                                          controller.pickImageForOption(
                                              controller.matchingRightItems,
                                              index);
                                        } else if (value == 'audio') {
                                          controller.pickAudioForOption(
                                              controller.matchingRightItems,
                                              index);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                            value: 'camera',
                                            child: Text('كاميرا')),
                                        const PopupMenuItem<String>(
                                            value: 'gallery',
                                            child: Text('معرض')),
                                        const PopupMenuItem<String>(
                                            value: 'audio',
                                            child: Text('صوت')),
                                      ],
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (index <
                                        controller.matchingRightItems.length) {
                                      controller.matchingRightItems[index] =
                                          rightOption.copyWith(text: value);
                                    }

                                    // ✅ T2: إضافة حقل تالي تلقائيًا
                                    // ✅ T1: إصلاح خطأ .text.isNotEmpty
                                    if (index ==
                                            controller.matchingRightItems
                                                    .length -
                                                1 &&
                                        value.isNotEmpty &&
                                        (controller.matchingLeftItems[index]
                                                    .text ??
                                                '')
                                            .isNotEmpty) {
                                      controller
                                          .addField(QuestionType.matching);
                                    }
                                  },
                                  validator: (value) {
                                    // ✅ T3: تعديل التحقق
                                    final bool isEmpty = (value == null || value.isEmpty) &&
                                        (rightOption.imageUrl ?? '').isEmpty &&
                                        (rightOption.audioUrl ?? '').isEmpty;
                                    
                                    if (isEmpty && index < 2) {
                                      return "الحقل إجباري";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                              // ✅ T3: عرض مرفقات الخيار الأيسر
                              _buildOptionMediaAttachments(
                                rightOption,
                                onClearImage: () =>
                                    controller.clearMediaForOption(
                                        controller.matchingRightItems, index,
                                        clearImage: true),
                                onClearAudio: () =>
                                    controller.clearMediaForOption(
                                        controller.matchingRightItems, index,
                                        clearAudio: true),
                              ),
                            ],
                          ),
                        ),
                        // ✅ T2: إزالة زر الحذف اليدوي
                        // if (index > 1) ... else ... // ⛔️ تم الحذف
                      ],
                    ),
                    const Divider(height: 10, thickness: 1),
                  ],
                ),
              );
            }).toList())),
      ],
    );
  }

  // 💡 حقول الترتيب
  Widget _buildOrderingFields(QuestionDialogController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
            "أدخل العناصر بالترتيب الصحيح (اسحب أيقونة السحب لإعادة الترتيب):"),
        Obx(() => ReorderableListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorderStart: (index) => FocusScope.of(Get.context!).unfocus(),
              onReorder: (oldIndex, newIndex) {
                if (newIndex > oldIndex) {
                  newIndex -= 1;
                }
                // يتم تعديل القائمة المراقبة مباشرة
                final item = controller.orderingItems.removeAt(oldIndex);
                controller.orderingItems.insert(newIndex, item);
                // الترتيب الصحيح يُستنتج من ترتيب القائمة عند الحفظ
              },
              itemBuilder: (context, index) {
                // التأكد من أن العنصر لا يزال موجوداً
                if (index >= controller.orderingItems.length) {
                  // هذا العنصر (key) هو لـ ReorderableListView
                  return Card(key: ValueKey('empty_$index'));
                }
                final option = controller.orderingItems[index];

                return Card(
                  key: ObjectKey(option),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              // ✅ T2: إضافة Focus
                              child: Focus(
                                onFocusChange: (hasFocus) {
                                  // ✅ T1: تعديل شرط الحذف التلقائي
                                  if (!hasFocus &&
                                      controller.orderingItems.length >
                                          2 && // يجب أن يكون هناك أكثر من حقلين
                                      index < controller.orderingItems.length) {
                                    final option =
                                        controller.orderingItems[index];
                                    final bool isEmpty =
                                        (option.text ?? '').isEmpty &&
                                            (option.imageUrl ?? '').isEmpty &&
                                            (option.audioUrl ?? '').isEmpty;
                                    if (isEmpty) {
                                      Future.delayed(Duration.zero, () {
                                        controller.removeField(
                                            QuestionType.ordering, index);
                                      });
                                    }
                                  }
                                },
                                child: TextFormField(
                                  initialValue:
                                      option.text, // استخدام القيمة مباشرة
                                  decoration: InputDecoration(
                                    labelText: "العنصر ${index + 1}",
                                    border: const OutlineInputBorder(),
                                    // ✅ T2: تغيير الأيقونة إلى لاحقة
                                    suffixIcon: PopupMenuButton<String>(
                                      icon: const Icon(Icons.attach_file,
                                          size: 20),
                                      onSelected: (value) {
                                        if (value == 'camera') {
                                          controller.pickImageForOption(
                                              controller.orderingItems, index,
                                              fromCamera: true);
                                        } else if (value == 'gallery') {
                                          controller.pickImageForOption(
                                              controller.orderingItems, index);
                                        } else if (value == 'audio') {
                                          controller.pickAudioForOption(
                                              controller.orderingItems, index);
                                        }
                                      },
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry<String>>[
                                        const PopupMenuItem<String>(
                                            value: 'camera',
                                            child: Text('كاميرا')),
                                        const PopupMenuItem<String>(
                                            value: 'gallery',
                                            child: Text('معرض')),
                                        const PopupMenuItem<String>(
                                            value: 'audio',
                                            child: Text('صوت')),
                                      ],
                                    ),
                                  ),
                                  onChanged: (value) {
                                    if (index <
                                        controller.orderingItems.length) {
                                      controller.orderingItems[index] =
                                          option.copyWith(text: value);
                                    }

                                    // ✅ T2: إضافة حقل تالي تلقائيًا
                                    if (index ==
                                            controller.orderingItems.length -
                                                1 &&
                                        value.isNotEmpty) {
                                      controller
                                          .addField(QuestionType.ordering);
                                    }
                                  },
                                  validator: (value) {
                                    // ✅ T3: تعديل التحقق
                                    final bool isEmpty =
                                        (value == null || value.isEmpty) &&
                                            (option.imageUrl ?? '').isEmpty &&
                                            (option.audioUrl ?? '').isEmpty;
                                    
                                    // فقط الحقلين الأولين إجباريين
                                    if (isEmpty && index < 2) {
                                      return "يجب ملء العنصرين الأولين";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                            // ✅ T2: إزالة زر الحذف اليدوي
                            // if (index > 1) ... else ... // ⛔️ تم الحذف
                            
                            // أيقونة السحب
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.drag_handle),
                            ),
                          ],
                        ),
                        // ✅ T3: عرض المرفقات المختارة *لهذا الخيار*
                        _buildOptionMediaAttachments(
                          option,
                          onClearImage: () => controller.clearMediaForOption(
                              controller.orderingItems, index,
                              clearImage: true),
                          onClearAudio: () => controller.clearMediaForOption(
                              controller.orderingItems, index,
                              clearAudio: true),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.orderingItems.length,
            )),
      ],
    );
  }

  Widget _buildEssayFields(QuestionDialogController controller) {
    return TextFormField(
      initialValue: controller.questionData['sampleAnswer'] as String? ?? '',
      decoration: const InputDecoration(
        labelText: "الإجابة النموذجية (اختياري)",
        hintText: "أدخل إجابة نموذجية لمساعدة المصححين",
        border: OutlineInputBorder(),
      ),
      maxLines: null,
      onChanged: (value) {
        controller.questionData['sampleAnswer'] = value.trim();
      },
      validator: (value) {
        return null;
      },
    );
  }

  // ✅ T1: إزالة الدالة بالكامل
  /*
  // أزرار الإضافة لكل نوع سؤال
  Widget _buildAddButton(QuestionDialogController controller) {
    ... 
  }
  */
}