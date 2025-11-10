import 'dart:io';

import 'package:ashil_school/features/lesson/models/lesson.dart';
import 'package:ashil_school/features/lesson/models/position_data.dart'; // <-- استدعاء الكلاس الجديد
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:rxdart/rxdart.dart' as rxdart;



/// متحكم لإدارة حالة الصوت في شاشة تفاصيل الدرس
class LessonDetailsController extends GetxController {
  final LessonModel lesson;
  LessonDetailsController({required this.lesson});

  final audioPlayer = AudioPlayer();
  final isPlaying = false.obs;
  final isLoadingAudio = true.obs;
  final hasAudio = false.obs;

  // Stream لبيانات شريط التقدم
  Stream<PositionData> get positionDataStream =>
      rxdart.Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
        audioPlayer.positionStream,
        audioPlayer.bufferedPositionStream,
        audioPlayer.durationStream,
        (pos, buff, dur) => PositionData(pos, buff, dur ?? Duration.zero),
      );

  @override
  void onInit() {
    super.onInit();
    _initAudio();
  }

  /// تهيئة مشغل الصوت
  Future<void> _initAudio() async {
    if (lesson.audioUrl != null && lesson.audioUrl!.isNotEmpty) {
      hasAudio.value = true;
      try {
        // التحقق إذا كان المسار من الشبكة أو ملف محلي (للمعاينة)
        bool isNetwork = lesson.audioUrl!.startsWith('http');

        if (isNetwork) {
          await audioPlayer.setUrl(lesson.audioUrl!);
        } else {
          // التأكد أن الملف موجود قبل محاولة تحميله (للمعاينة)
          final file = File(lesson.audioUrl!);
          if (await file.exists()) {
            await audioPlayer.setFilePath(lesson.audioUrl!);
          } else {
            throw Exception("ملف المعاينة غير موجود");
          }
        }

        await audioPlayer.setLoopMode(LoopMode.off);

        // مستمعات لتحديث الواجهة
        audioPlayer.playerStateStream.listen((state) {
          if (state.processingState == ProcessingState.completed) {
            audioPlayer.seek(Duration.zero);
            audioPlayer.pause();
          }
        });
        audioPlayer.playingStream.listen((playing) {
          isPlaying.value = playing;
        });
        isLoadingAudio.value = false;
      } catch (e) {
        print("خطأ في تحميل الصوت: $e");
        isLoadingAudio.value = false;
        hasAudio.value = false; // فشل تحميل المقطع
      }
    } else {
      isLoadingAudio.value = false;
      hasAudio.value = false;
    }
  }

  /// تشغيل/إيقاف
  void togglePlayPause() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }
  }

  @override
  void onClose() {
    audioPlayer.dispose();
    super.onClose();
  }
}