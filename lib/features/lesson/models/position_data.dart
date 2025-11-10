/// نموذج بيانات لتمرير حالة مشغل الصوت (الموضع، المخزن، والمدة الكلية)
/// يُستخدم هذا الكلاس في أكثر من متحكم
class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}