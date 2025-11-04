// permission_model.dart

class PermissionItem {
  final String key;
  final String title;
  final String description; // توضيح الصلاحية
  bool isEnabled;

  PermissionItem({
    required this.key,
    required this.title,
    required this.description,
    this.isEnabled = false,
  });
}