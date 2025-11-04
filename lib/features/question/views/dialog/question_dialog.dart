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
                    // نص السؤال
                    TextFormField(
                      controller: controller.questionTextController,
                      decoration: const InputDecoration(
                        labelText: "نص السؤال",
                        border: OutlineInputBorder(),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 3,
                      minLines: 1,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "نص السؤال لا يمكن أن يكون فارغًا.";
                        }
                        return null;
                      },
                    ),
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
            // أزرار الإضافة والحفظ
            Obx(() => _buildAddButton(controller)),
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

  // دالة مساعدة معمة لبناء أزرار الرفع وعرض الروابط الحالية لأي قائمة خيارات
  Widget _buildMediaButtons(QuestionDialogController controller, Option option,
      int index, RxList<Option> optionsList) {
    return Obx(() {
      final currentOption = optionsList[index];
      void updateList(Option newOption) {
        optionsList[index] = newOption;
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
           
              ElevatedButton.icon(
                icon: const Icon(Icons.image, size: 16),
                label: const Text('صورة'),
                onPressed: () {},
              ),
              ElevatedButton.icon(
                icon: const Icon(Icons.audiotrack, size: 16),
                label: const Text('صوت'),
                onPressed: () {},
              ),
            ],
          ),
          // عرض رابط الصورة الحالي
          if (currentOption.imageUrl != null &&
              currentOption.imageUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.image_outlined,
                      size: 16, color: Colors.blue),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'صورة مرفوعة: ${currentOption.imageUrl!.split('/').last}',
                      style: const TextStyle(fontSize: 12, color: Colors.blue),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 16, color: Colors.red),
                    onPressed: () {
                      // إزالة رابط الصورة
                      updateList(currentOption.copyWith(imageUrl: null));
                    },
                  ),
                ],
              ),
            ),
          // عرض رابط الصوت الحالي
          if (currentOption.audioUrl != null &&
              currentOption.audioUrl!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Row(
                children: [
                  const Icon(Icons.volume_up, size: 16, color: Colors.orange),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      'صوت مرفوع: ${currentOption.audioUrl!.split('/').last}',
                      style:
                          const TextStyle(fontSize: 12, color: Colors.orange),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.clear, size: 16, color: Colors.red),
                    onPressed: () {
                      // إزالة رابط الصوت
                      updateList(currentOption.copyWith(audioUrl: null));
                    },
                  ),
                ],
              ),
            ),
        ],
      );
    });
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
              final option = controller.mcqOptions[index];

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
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
                                  controller.toggleCorrectMCQAnswer(
                                      index, true);
                                }
                              },
                            )),
                        // حقل النص
                        Expanded(
                          child: TextFormField(
                            initialValue: option.text, // استخدام القيمة مباشرة
                            decoration: InputDecoration(
                              labelText: "خيار ${index + 1}",
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              controller.mcqOptions[index] =
                                  option.copyWith(text: value);
                            },
                            validator: (value) {
                              if ((value == null || value.isEmpty) &&
                                  option.imageUrl == null &&
                                  option.audioUrl == null) {
                                return "يجب إدخال نص أو صورة أو صوت للخيار.";
                              }
                              return null;
                            },
                          ),
                        ),
                        // زر الحذف
                        IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              controller.removeField(QuestionType.mcq, index);
                            }),
                      ],
                    ),
                    // 💡 إضافة أزرار الرفع وعرض الروابط
                    _buildMediaButtons(
                        controller, option, index, controller.mcqOptions),
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

  // 💡 حقول المطابقة - تم إضافة دعم الصورة والصوت لكلا العمودين
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
              final leftOption = entry.value;
              final rightOption = controller.matchingRightItems[index];

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
                              TextFormField(
                                initialValue: leftOption.text,
                                decoration: const InputDecoration(
                                  labelText: "العنصر الأيمن",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // تحديث قيمة العنصر الأيمن
                                  controller.matchingLeftItems[index] =
                                      leftOption.copyWith(text: value);
                                },
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      leftOption.imageUrl == null &&
                                      leftOption.audioUrl == null) {
                                    return "العنصر لا يمكن أن يكون فارغًا.";
                                  }
                                  return null;
                                },
                              ),
                              // 💡 إضافة أزرار الوسائط للعنصر الأيمن
                              _buildMediaButtons(controller, leftOption, index,
                                  controller.matchingLeftItems),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                initialValue: rightOption.text,
                                decoration: const InputDecoration(
                                  labelText: "العنصر الأيسر",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // تحديث قيمة العنصر الأيسر
                                  controller.matchingRightItems[index] =
                                      rightOption.copyWith(text: value);
                                },
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      rightOption.imageUrl == null &&
                                      rightOption.audioUrl == null) {
                                    return "العنصر لا يمكن أن يكون فارغًا.";
                                  }
                                  return null;
                                },
                              ),
                              // 💡 إضافة أزرار الوسائط للعنصر الأيسر
                              _buildMediaButtons(controller, rightOption, index,
                                  controller.matchingRightItems),
                            ],
                          ),
                        ),
                        IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.red),
                            onPressed: () {
                              controller.removeField(
                                  QuestionType.matching, index);
                            }),
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

  // 💡 حقول الترتيب - تم إضافة دعم الصورة والصوت
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
                final option = controller.orderingItems[index];

                return Card(
                  key: ObjectKey(option),
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                initialValue:
                                    option.text, // استخدام القيمة مباشرة
                                decoration: InputDecoration(
                                  labelText: "العنصر ${index + 1}",
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  // تحديث قيمة الـ Option في الكنترولر عند تغيير حقل النص
                                  controller.orderingItems[index] =
                                      option.copyWith(text: value);
                                },
                                validator: (value) {
                                  if ((value == null || value.isEmpty) &&
                                      option.imageUrl == null &&
                                      option.audioUrl == null) {
                                    return "العنصر لا يمكن أن يكون فارغًا.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  controller.removeField(
                                    QuestionType.ordering,
                                    index,
                                  );
                                }),
                            // أيقونة السحب
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 8.0),
                              child: Icon(Icons.drag_handle),
                            ),
                          ],
                        ),
                        _buildMediaButtons(controller, option, index,
                            controller.orderingItems),
                      ],
                    ),
                  ),
                );
              },
              itemCount: controller.orderingItems.length,
            )),
        // بفرض أن لديك زر لإضافة عنصر جديد هنا
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

  // أزرار الإضافة لكل نوع سؤال
  Widget _buildAddButton(QuestionDialogController controller) {
    switch (controller.selectedType.value) {
      case QuestionType.mcq:
        return OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("أضف خيارًا"),
          onPressed: () => controller.addField(QuestionType.mcq),
        );
      case QuestionType.fillBlank:
        return OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("أضف إجابة للفراغ"),
          // لا نضيف هنا {{}} بل نعتمد على إضافة المستخدم لها في نص السؤال
          onPressed: () => controller.addFillBlank(),
        );
      case QuestionType.matching:
        return OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("أضف زوج مطابقة"),
          onPressed: () => controller.addField(QuestionType.matching),
        );
      case QuestionType.ordering:
        return OutlinedButton.icon(
          icon: const Icon(Icons.add),
          label: const Text("أضف عنصر ترتيب"),
          onPressed: () => controller.addField(QuestionType.ordering),
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
