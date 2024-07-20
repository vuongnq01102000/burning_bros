import 'dart:async';

import 'package:flutter/material.dart';

class Debouncer {
  final Duration delay;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
   if (_timer != null) {
     _timer!.cancel();
     
   }else {
      action();
   }
    _timer = Timer(delay, action);
  }
}