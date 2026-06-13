import 'dart:async';
import 'dart:io';
import 'package:battery_plus/battery_plus.dart';
import '../models/dashboard_models.dart';

class LiveDataService {
  static final Battery _battery = Battery();

  static Future<double> measurePingMs() async {
    try {
      final stopwatch = Stopwatch()..start();
      final result = await Process.run('ping', [
        '-c', '1',
        '-W', '3',
        '8.8.8.8',
      ]);
      stopwatch.stop();

      final output = result.stdout as String;
      final timeRegex = RegExp(r'time[=<]\s*(\d+\.?\d*)\s*ms');
      final match = timeRegex.firstMatch(output);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
      return stopwatch.elapsedMilliseconds.toDouble();
    } catch (_) {
      return 0;
    }
  }

  static Future<double> measureUploadMbps() async {
    try {
      final stopwatch = Stopwatch()..start();
      final result = await Process.run('ping', [
        '-c', '1',
        '-W', '3',
        '-s', '1400',
        '8.8.8.8',
      ]);
      stopwatch.stop();

      final output = result.stdout as String;
      final timeRegex = RegExp(r'time[=<]\s*(\d+\.?\d*)\s*ms');
      final match = timeRegex.firstMatch(output);
      if (match != null) {
        final ms = double.parse(match.group(1)!);
        if (ms > 0) {
          return (1400.0 * 8 / ms / 1000) * 2;
        }
      }
      return 0;
    } catch (_) {
      return 0;
    }
  }

  static Future<BatteryData> readBattery() async {
    try {
      final level = await _battery.batteryLevel;
      final state = await _battery.batteryState;
      return BatteryData(
        percentage: level.toDouble(),
        isCharging: state == BatteryState.charging || state == BatteryState.full,
      );
    } catch (_) {
      return BatteryData(percentage: 0, isCharging: false);
    }
  }
}
