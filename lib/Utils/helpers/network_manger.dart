import 'dart:async';

import 'package:ashil_school/Utils/helpers/loaders/loaders.dart';
import 'package:ashil_school/data/services/sync/sync_manager.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get instance => Get.find();

  final Connectivity _connectivity = Connectivity();
  final RxBool isOnline = false.obs;

  // bool _isSyncingImages = false;
  // DateTime? _lastChecked;
  // final Duration _debounceDuration = Duration(seconds: 2);

  DateTime? _lastSnackbarShown;
  void Function()? onReconnect;

  bool get isConnectedNow => isOnline.value;

  @override
  void onInit() {
    super.onInit();
    _monitorInternetConnection();

    // ✅ استدعِ مزامنة الصور مباشرة عند التشغيل إذا كان متصل
    //  _checkAndSyncImages();

    // ✅ إعداد ردّة الفعل عند استعادة الاتصال
    onReconnect = () async {
      await Get.find<SyncManager>().syncAll();
    };
  }

  // Future<void> _checkAndSyncImages() async {
  //   if (!isConnectedNow) return;
  //   await ImageSyncRepository.safeSyncImages();
  // }

  Future<bool> isConnected() async {
    try {
      final results = await _connectivity.checkConnectivity();
      if (!results.any((r) => r != ConnectivityResult.none)) return false;

      return await _checkInternetAccess();
    } on PlatformException {
      return false;
    }
  }

  Future<bool> _checkInternetAccess() async {
    try {
      final response = await Dio().head(
        'https://www.google.com',
        options: Options(
          sendTimeout: Duration(seconds: 3),
          receiveTimeout: Duration(seconds: 3),
        ),
      );
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  void _monitorInternetConnection() {
    _connectivity.onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      _handleConnectivityChange(results);
    });

    Timer.periodic(Duration(seconds: 5), (timer) async {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
    });
  }

  Future<void> _handleConnectivityChange(
      List<ConnectivityResult> results) async {
    bool wasConnected = isOnline.value;
    bool isConnected = false;

    if (results.any((r) => r != ConnectivityResult.none)) {
      isConnected = await _checkInternetAccess();
    }

    if (isOnline.value != isConnected) {
      isOnline.value = isConnected;

      if (isConnected && !wasConnected) {
        onReconnect?.call();
      }
    }
  }

  void _showNoConnectionSnackBar() {
    if (_lastSnackbarShown == null ||
        DateTime.now().difference(_lastSnackbarShown!) >
            Duration(seconds: 10)) {
      _lastSnackbarShown = DateTime.now();
      KLoaders.warning(
        title: 'لا يوجد اتصال بالإنترنت',
        message: 'يرجى التحقق من اتصالك.',
      );
    }
  }

  Future<bool> checkInternetConnection() async {
    if (!isConnectedNow) {
      _showNoConnectionSnackBar();
      return false;
    }
    return true;
  }

  Future<void> checkConnectionAndShowStatus() async {
    bool connected = await isConnected();
    if (connected) {
      try {
        Get.back(); // لإغلاق SnackBar إذا كان ظاهرًا
      } catch (_) {}
    }
  }
}
