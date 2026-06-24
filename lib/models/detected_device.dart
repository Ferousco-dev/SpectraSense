/// Represents a single detected BLE device plus the confidence
/// that it is a smart-glasses / recording-capable wearable.
class DetectedDevice {
  final String id; // platform device identifier (rotates on iOS)
  final String name; // advertised name, may be empty
  final int rssi; // signal strength (dBm)
  final Map<int, List<int>> manufacturerData; // company id -> bytes
  final List<String> serviceUuids;
  final DateTime lastSeen;

  // scoring output
  final int confidence; // 0-100
  final String verdict; // "Highly likely" / "Possible" / "Unknown"
  final List<String> matchedSignals; // human-readable reasons

  DetectedDevice({
    required this.id,
    required this.name,
    required this.rssi,
    required this.manufacturerData,
    required this.serviceUuids,
    required this.lastSeen,
    required this.confidence,
    required this.verdict,
    required this.matchedSignals,
  });

  /// Rough distance bucket from RSSI. Not exact — for UI only.
  String get proximity {
    if (rssi >= -55) return 'Very close';
    if (rssi >= -70) return 'Nearby';
    if (rssi >= -85) return 'In range';
    return 'Far';
  }

  DetectedDevice copyWith({
    int? rssi,
    DateTime? lastSeen,
    int? confidence,
    String? verdict,
    List<String>? matchedSignals,
  }) {
    return DetectedDevice(
      id: id,
      name: name,
      rssi: rssi ?? this.rssi,
      manufacturerData: manufacturerData,
      serviceUuids: serviceUuids,
      lastSeen: lastSeen ?? this.lastSeen,
      confidence: confidence ?? this.confidence,
      verdict: verdict ?? this.verdict,
      matchedSignals: matchedSignals ?? this.matchedSignals,
    );
  }
}
