import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';

import '../models/detected_device.dart';
import 'scoring_engine.dart';

/// Wraps flutter_blue_plus to scan for BLE advertisements and convert each
/// into a scored DetectedDevice.
///
/// PLATFORM NOTE: iOS does not expose manufacturer data or the real MAC via
/// CoreBluetooth, so the manufacturer-ID signal (the heaviest weight) is
/// unavailable there. Android is the primary target for the MVP.
class BleScanner {
  final _controller = StreamController<List<DetectedDevice>>.broadcast();
  Stream<List<DetectedDevice>> get devices => _controller.stream;

  final Map<String, DetectedDevice> _seen = {};
  StreamSubscription<List<ScanResult>>? _sub;
  bool _scanning = false;

  bool get isScanning => _scanning;

  /// Request the permissions needed to scan. Returns true if granted.
  Future<bool> ensurePermissions() async {
    final statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.locationWhenInUse, // Android ties BLE scan to location
    ].request();
    return statuses.values.every((s) => s.isGranted || s.isLimited);
  }

  Future<void> start() async {
    if (_scanning) return;
    final ok = await ensurePermissions();
    if (!ok) {
      _controller.addError('Bluetooth/location permission denied');
      return;
    }
    if (await FlutterBluePlus.isSupported == false) {
      _controller.addError('Bluetooth not supported on this device');
      return;
    }

    _scanning = true;
    _seen.clear();

    _sub = FlutterBluePlus.scanResults.listen((results) {
      for (final r in results) {
        final d = _fromScanResult(r);
        _seen[d.id] = d;
      }
      _emit();
    });

    await FlutterBluePlus.startScan(
      continuousUpdates: true, // keep RSSI fresh
      androidUsesFineLocation: true,
    );
  }

  Future<void> stop() async {
    _scanning = false;
    await FlutterBluePlus.stopScan();
    await _sub?.cancel();
    _sub = null;
  }

  void _emit() {
    final list = _seen.values.toList()
      ..sort((a, b) => b.confidence.compareTo(a.confidence));
    _controller.add(list);
  }

  DetectedDevice _fromScanResult(ScanResult r) {
    final adv = r.advertisementData;

    final mfr = <int, List<int>>{};
    adv.manufacturerData.forEach((key, value) => mfr[key] = value);

    final uuids = adv.serviceUuids.map((u) => u.toString()).toList();
    final name = adv.advName.isNotEmpty ? adv.advName : r.device.platformName;

    final scored = ScoringEngine.score(
      name: name,
      manufacturerData: mfr,
      serviceUuids: uuids,
    );

    return DetectedDevice(
      id: r.device.remoteId.str,
      name: name,
      rssi: r.rssi,
      manufacturerData: mfr,
      serviceUuids: uuids,
      lastSeen: DateTime.now(),
      confidence: scored.confidence,
      verdict: scored.verdict,
      matchedSignals: scored.matchedSignals,
    );
  }

  void dispose() {
    _sub?.cancel();
    _controller.close();
  }
}
