import 'package:ashil_school/Utils/custom_dilog/cusom_dilog.dart';
import 'package:ashil_school/features/students/controllers/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterDialog extends StatelessWidget {
  const FilterDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomDialog(
      title: 'خيارات الفلترة والفرز',
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            child: Consumer<StudentProvider>(
              builder: (context, studentProvider, child) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Filter by Grade
                    _buildDropdownFilter(
                      label: 'الصف',
                      value: studentProvider.selectedGrade,
                      items: ['الصف الثالث', 'الصف الرابع'],
                      onChanged: (String? value) =>
                          studentProvider.setGradeFilter(value),
                    ),
                    const SizedBox(height: 16),
                    // Filter by Section
                    _buildDropdownFilter(
                      label: 'الفصل',
                      value: studentProvider.selectedSection,
                      items: ['أ', 'ب'],
                      onChanged: (String? value) =>
                          studentProvider.setSectionFilter(value),
                    ),
                    const SizedBox(height: 16),
                    // Filter by Active Status
                    _buildToggleButtons(
                      label: 'حالة الحساب',
                      onPressed: (int index) {
                        if (index == 0) {
                          studentProvider.setActiveStatusFilter(
                            studentProvider.activeStatus == ActiveStatus.active
                                ? ActiveStatus.all
                                : ActiveStatus.active,
                          );
                        } else {
                          studentProvider.setActiveStatusFilter(
                            studentProvider.activeStatus ==
                                    ActiveStatus.inactive
                                ? ActiveStatus.all
                                : ActiveStatus.inactive,
                          );
                        }
                      },
                      isSelected: [
                        studentProvider.activeStatus == ActiveStatus.active,
                        studentProvider.activeStatus == ActiveStatus.inactive,
                      ],
                      labels: ['مفعل', 'غير مفعل'],
                    ),
                    const SizedBox(height: 16),
                    // Filter by Registered Status
                    _buildToggleButtons(
                      label: 'حالة التسجيل',
                      onPressed: (int index) {
                        if (index == 0) {
                          studentProvider.setRegisteredStatusFilter(
                            studentProvider.registeredStatus ==
                                    RegisteredStatus.registered
                                ? RegisteredStatus.all
                                : RegisteredStatus.registered,
                          );
                        } else {
                          studentProvider.setRegisteredStatusFilter(
                            studentProvider.registeredStatus ==
                                    RegisteredStatus.notRegistered
                                ? RegisteredStatus.all
                                : RegisteredStatus.notRegistered,
                          );
                        }
                      },
                      isSelected: [
                        studentProvider.registeredStatus ==
                            RegisteredStatus.registered,
                        studentProvider.registeredStatus ==
                            RegisteredStatus.notRegistered,
                      ],
                      labels: ['تم التسجيل', 'لم يتم التسجيل'],
                    ),
                    const SizedBox(height: 16),
                    // Sorting
                    _buildSortDropdown(studentProvider),
                  ],
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              OutlinedButton(
                onPressed: () {
                  Provider.of<StudentProvider>(context, listen: false)
                      .resetFilters();
                  Navigator.of(context).pop();
                },
                child: const Text('إعادة ضبط'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('إغلاق'),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDropdownFilter({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          hint: const Text('الكل'),
          items: [
            const DropdownMenuItem<String>(
              value: null,
              child: Text('الكل'),
            ),
            ...items.map((String item) {
              return DropdownMenuItem<String>(
                value: item,
                child: Text(item),
              );
            }),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildToggleButtons({
    required String label,
    required void Function(int) onPressed,
    required List<bool> isSelected,
    required List<String> labels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        ToggleButtons(
          isSelected: isSelected,
          onPressed: onPressed,
          children: labels
              .map((label) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(label),
                  ))
              .toList(),
        ),
      ],
    );
  }

  Widget _buildSortDropdown(StudentProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('الفرز حسب', style: TextStyle(fontWeight: FontWeight.bold)),
        DropdownButton<SortOrder>(
          isExpanded: true,
          value: provider.sortOrder,
          hint: const Text('لا يوجد'),
          items: const [
            DropdownMenuItem(value: SortOrder.none, child: Text('لا يوجد')),
            DropdownMenuItem(
                value: SortOrder.nameAsc, child: Text('حسب الاسم')),
            DropdownMenuItem(
                value: SortOrder.progressDesc, child: Text('الأوائل (تقدم)')),
            DropdownMenuItem(
                value: SortOrder.gradeDesc, child: Text('الأوائل (درجات)')),
          ],
          onChanged: (SortOrder? value) => provider.setSortOrder(value!),
        ),
      ],
    );
  }
}
