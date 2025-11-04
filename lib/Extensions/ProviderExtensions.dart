

import 'package:flutter/cupertino.dart';

extension DelayedNotify on ChangeNotifier {
  Future<void> notifyListenersDelayed({int milliseconds = 300}) async {
    await Future.delayed(Duration(milliseconds: milliseconds));
    notifyListeners();
  }
}
