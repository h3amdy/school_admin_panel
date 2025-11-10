import 'package:ashil_school/Utils/custom_dilog/custom_dialog.dart';
import 'package:ashil_school/Utils/question/question_utils.dart';
import 'package:ashil_school/features/question/models/base_question.dart';
import 'package:flutter/material.dart';
import 'package:ashil_school/features/question/models/mcq_question.dart';
import 'package:ashil_school/features/question/models/true_false_question.dart';
import 'package:ashil_school/features/question/models/fill_blank_question.dart';
import 'package:ashil_school/features/question/models/matching_question.dart';
import 'package:ashil_school/features/question/models/ordering_question.dart';
import 'package:ashil_school/features/question/models/essay_question.dart';
// يجب استيراد نموذج Option لأنه مستخدم الآن
import 'package:ashil_school/features/question/models/option_model.dart'; 

// ملاحظة: يُفترض أن BaseQuestion يحتوي على الخصائص الجديدة:
// (String? explanation) و (double? points).

class QuestionDetailsDialog extends StatelessWidget {
  final BaseQuestion question;

  const QuestionDetailsDialog({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomDialog(
      title: "تفاصيل السؤال",
      // تحديد عرض أقصى لضمان عرض جيد على الشاشات الكبيرة
      body: Scrollbar(
        thumbVisibility: true,
        interactive: true,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1. نوع السؤال ودرجته
              _buildHeaderInfo(context, theme),
              const SizedBox(height: 16),
              
              // 2. نص السؤال
              _buildQuestionTextCard(context, theme),
              const SizedBox(height: 24),
              
              // 3. تفاصيل الإجابة الصحيحة حسب النوع
              _buildAnswerSection(context, question),
              const SizedBox(height: 24),

              // 4. الشرح أو الإيضاح
              _buildExplanationSection(context, question),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderInfo(BuildContext context, ThemeData theme) {
    // تم تصحيح استخدام .toStringAsFixed(1) للدرجات
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // نوع السؤال
        Text(
          "نوع السؤال: ${getQuestionTypeName(question.type)}",
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        // درجة السؤال (يُفترض أن BaseQuestion يحتوي على حقل points)
        // Text(
        //   "الدرجة: ${question.points != null ? question.points!.toStringAsFixed(1) : 'غير محددة'} نقطة",
        //   style: theme.textTheme.bodyMedium?.copyWith(color: Colors.blueGrey),
        // ),
      ],
    );
  }

  Widget _buildQuestionTextCard(BuildContext context, ThemeData theme) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "نص السؤال:",
              style: theme.textTheme.titleSmall?.copyWith(color: Colors.grey.shade700),
            ),
            const Divider(height: 16),
            Text(
              question.text,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswerSection(BuildContext context, BaseQuestion question) {
    switch (question.type) {
      case QuestionType.mcq:
        return _buildMCQDetails(context, question as MCQQuestion);
      case QuestionType.trueFalse:
        return _buildTrueFalseDetails(context, question as TrueFalseQuestion);
      case QuestionType.fillBlank:
        return _buildFillBlankDetails(context, question as FillBlankQuestion);
      case QuestionType.matching:
        return _buildMatchingDetails(context, question as MatchingQuestion);
      case QuestionType.ordering:
        return _buildOrderingDetails(context, question as OrderingQuestion);
      case QuestionType.essay:
        return _buildEssayDetails(context, question as EssayQuestion);
    }
  }

  // ----------- تفاصيل الإجابات المحددة للأنواع -----------------

  Widget _buildMCQDetails(BuildContext context, MCQQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "الخيارات والإجابة الصحيحة:"),
        const SizedBox(height: 12),
        ...question.options.asMap().entries.map((entry) {
          final index = entry.key;
          // تم تصحيح: entry.value هو الآن كائن Option
          final Option option = entry.value; 
          final isCorrect = index == question.correctAnswerIndexes;
          
          // تم تصحيح: استخدام option.text مع معالجة القيمة null
          final optionText = option.text ?? 'لا يوجد نص (صورة/صوت)';

          return _buildDetailCard(
            context,
            isCorrect ? Colors.green : Colors.grey.shade300,
            ListTile(
              leading: Icon(
                isCorrect
                    ? Icons.check_circle_rounded
                    : Icons.radio_button_off,
                color: isCorrect ? Colors.green.shade700 : Colors.grey,
              ),
              title: Text(optionText),
              dense: true,
              // يمكن إضافة عرض للصورة أو الصوت هنا إذا كانت الخيارات غير نصية
              // trailing: option.imageUrl != null ? const Icon(Icons.image) : null,
            ),
          );
        }),
      ],
    );
  }

  Widget _buildTrueFalseDetails(
      BuildContext context, TrueFalseQuestion question) {
    final isTrue = question.isTrue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "الإجابة الصحيحة:"),
        const SizedBox(height: 12),
        _buildDetailCard(
          context,
          isTrue ? Colors.green : Colors.red,
          ListTile(
            leading: Icon(
              isTrue ? Icons.check_circle : Icons.cancel,
              color: isTrue ? Colors.green : Colors.red,
            ),
            title: Text(isTrue ? "صح" : "خطأ"),
            dense: true,
          ),
        ),
      ],
    );
  }

  Widget _buildFillBlankDetails(
      BuildContext context, FillBlankQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "الإجابات الصحيحة للفراغات:"),
        const SizedBox(height: 12),
        ...question.correctAnswers.asMap().entries.map((entry) {
          final index = entry.key;
          final answer = entry.value;
          return _buildDetailCard(
            context,
            Colors.blue.shade300,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                children: [
                  Text("فراغ ${index + 1}:",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 8),
                  Expanded(child: Text(answer)),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildMatchingDetails(
      BuildContext context, MatchingQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "أزواج المطابقة الصحيحة:"),
        const SizedBox(height: 12),
        ...question.correctPairs.entries.map(
          (entry) {
            // تم تصحيح: entry.key و entry.value هما فهارس (int)
            final int leftIndex = entry.key;
            final int rightIndex = entry.value;

            // الحصول على كائنات Option بناءً على الفهارس
            final Option leftOption = question.leftItems[leftIndex];
            final Option rightOption = question.rightItems[rightIndex];
            
            // استخراج النصوص مع معالجة Null
            final String leftText = leftOption.text ?? 'لا يوجد نص (صورة/صوت)';
            final String rightText = rightOption.text ?? 'لا يوجد نص (صورة/صوت)';

            return _buildDetailCard(
              context,
              Colors.orange.shade300,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        leftText, // استخدام النص المستخرج
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Icon(Icons.compare_arrows, color: Colors.orange),
                    Expanded(
                      child: Text(
                        rightText, // استخدام النص المستخرج
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ).toList(), // ToList ضرورية هنا
      ],
    );
  }

  Widget _buildOrderingDetails(
      BuildContext context, OrderingQuestion question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "الترتيب الصحيح للبنود:"),
        const SizedBox(height: 12),
        ...question.items.asMap().entries.map(
          (entry) {
            // تصحيح: entry.value هو الآن كائن Option
            final Option itemOption = entry.value;
            // استخراج النص مع معالجة القيمة null
            final String itemText = itemOption.text ?? 'لا يوجد نص (صورة/صوت)';
            
            return _buildDetailCard(
              context,
              Colors.purple.shade300,
              ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.purple.shade50,
                  child: Text("${entry.key + 1}",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.purple.shade700)),
                ),
                // تم التصحيح: استخدام النص المستخرج
                title: Text(itemText),
                dense: true,
              ),
            );
          },
        ).toList(), // ToList ضرورية هنا
      ],
    );
  }

  Widget _buildEssayDetails(BuildContext context, EssayQuestion question) {
    final sampleAnswer = question.sampleAnswer;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "الإجابة النموذجية:"),
        const SizedBox(height: 12),
        if (sampleAnswer != null && sampleAnswer.isNotEmpty)
          _buildDetailCard(
            context,
            Colors.teal.shade300,
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(sampleAnswer),
            ),
          )
        else
          Text(
            "لا توجد إجابة نموذجية محددة لهذا السؤال.",
            style: Theme.of(context)
                .textTheme
                .bodySmall
                ?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey.shade600),
          ),
      ],
    );
  }
  
  // ----------- قسم الشرح العام للسؤال -----------------

  Widget _buildExplanationSection(BuildContext context, BaseQuestion question) {
    final explanation = question.explanation;

    if (explanation == null || explanation.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(context, "إيضاح/شرح السؤال (اختياري):"),
        const SizedBox(height: 12),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.deepOrange.shade100, width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              explanation,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  // ----------- أدوات مساعدة لتوحيد المظهر -----------------

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildDetailCard(BuildContext context, Color borderColor, Widget child) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: borderColor.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      margin: const EdgeInsets.only(bottom: 8),
      child: child,
    );
  }
}
