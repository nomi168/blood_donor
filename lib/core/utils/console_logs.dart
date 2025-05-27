import 'dart:convert';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

enum LogColor { red, green, yellow, blue, purple, cyan, gray, animated }

const bool _isDebug = kDebugMode;

void logError([String? message = "..."]) {
  if (_isDebug) {
    _log("${_getColorCode(LogColor.red)}❌ $message");
  }
}

void logSuccess([String? message = "..."]) {
  if (_isDebug) {
    _log("${_getColorCode(LogColor.green)}✅ $message");
  }
}

void logWarning([String? message = "..."]) {
  if (_isDebug) {
    _log("${_getColorCode(LogColor.yellow)}⚠️ $message");
  }
}

void logInfo([Object? message = "..."]) {
  if (_isDebug) {
    _log("${_getColorCode(LogColor.blue)}ℹ️ $message");
  }
}

void logDebug([String? message = "..."]) {
  if (_isDebug) {
    _log("${_getColorCode(LogColor.purple)}🔍 $message");
  }
}

void logTrace([String? message = "..."]) {
  if (_isDebug) {
    _log("${_getColorCode(LogColor.cyan)}🔷 $message");
  }
}

void logJSON({String? message = "Object:", dynamic object}) {
  if (_isDebug) {
    _log(
        "${_getColorCode(LogColor.purple)} $message ${const JsonEncoder.withIndent('  ').convert(object)}");
  }
}

void logAnimatedText([String? message = "..."]) {
  if (_isDebug) {
    _log(
        "${_getColorCode(LogColor.yellow)} ${_getColorCode(LogColor.green)}🪄 $message");
  }
}

void _log(String message) {
  developer.log(message);
}

// Helper function to get color codes
String _getColorCode(LogColor color) {
  switch (color) {
    case LogColor.red:
      return "\u001b[1;31m";
    case LogColor.green:
      return "\u001b[1;32m";
    case LogColor.yellow:
      return "\u001b[1;33m";
    case LogColor.blue:
      return "\u001b[1;34m";
    case LogColor.purple:
      return "\u001b[1;35m";
    case LogColor.cyan:
      return "\u001b[1;36m";
    case LogColor.gray:
      return "\u001b[1;30m";
    case LogColor.animated:
      return "\u001b[1;38;5;208m";
    // ignore: unreachable_switch_default
    default:
      return "\u001b[1;34m";
  }
}
