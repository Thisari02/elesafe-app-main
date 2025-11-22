import 'package:logging/logging.dart';
import 'package:flutter/material.dart';

class LogManager {
  LogManager._(); // Private constructor to prevent instantiation

  static bool _isInitialized = false;

  static void init() {
    if (!_isInitialized) {
      _isInitialized = true;
      Logger.root.level = Level.INFO;
      Logger.root.onRecord.listen((LogRecord e) {
        debugPrint(e.message); // Print only the log message
      });
    }
  }
}
