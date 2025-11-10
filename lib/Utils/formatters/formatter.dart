/// كلاس يحتوي على دوال مساعدة لتنسيق البيانات
class KFormatter {
  /// يمنع إنشاء نسخ من هذا الكلاس
  KFormatter._();

  /// تحويل [Duration] إلى تنسيق "mm:ss"
  /// مثال: 01:30
  static String formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }


}