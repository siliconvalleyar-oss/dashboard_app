import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
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

  static Future<List<BottomKpi>> fetchCryptoPrices() async {
    try {
      final client = HttpClient();
      final request = await client.getUrl(Uri.parse(
        'https://api.coingecko.com/api/v3/simple/price?ids=bitcoin,ethereum,solana,ripple&vs_currencies=usd&include_24hr_change=true',
      ));
      final response = await request.close();
      final body = await response.transform(utf8.decoder).join();
      final json = jsonDecode(body) as Map<String, dynamic>;

      final cryptoConfig = {
        'bitcoin':  {'label': 'Bitcoin',  'icon': Icons.currency_bitcoin},
        'ethereum': {'label': 'Ethereum', 'icon': Icons.monetization_on_outlined},
        'solana':   {'label': 'Solana',   'icon': Icons.brightness_1},
        'ripple':   {'label': 'XRP',      'icon': Icons.opacity},
      };

      return cryptoConfig.entries.map((entry) {
        final id = entry.key;
        final cfg = entry.value;
        final data = json[id] as Map<String, dynamic>?;
        final price = data?['usd'] as num? ?? 0;
        final change = data?['usd_24h_change'] as num? ?? 0;
        return BottomKpi(
          label: cfg['label'] as String,
          value: price is int ? price.toDouble() : (price as double),
          change: change is int ? change.toDouble() : (change as double),
          icon: cfg['icon'] as IconData,
          isPositive: (change is int ? change.toDouble() : (change as double)) >= 0,
        );
      }).toList();
    } catch (_) {
      return [];
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
