import '../models/fingerprint.dart';

/// Result of scoring a raw advertisement against the fingerprint DB.
class ScoreResult {
  final int confidence; // 0-100
  final String verdict;
  final List<String> matchedSignals;
  final String? matchedLabel;

  ScoreResult(this.confidence, this.verdict, this.matchedSignals,
      this.matchedLabel);
}

/// Confidence scoring engine.
///
/// Weights are INITIAL ESTIMATES. They must be recalibrated from measured
/// precision/recall once real fingerprints exist. Do not treat the bands
/// below as accurate until the DB is verified.
class ScoringEngine {
  static const int wManufacturer = 40;
  static const int wUuid = 30;
  static const int wPrefix = 20;
  static const int wName = 10;

  static ScoreResult score({
    required String name,
    required Map<int, List<int>> manufacturerData,
    required List<String> serviceUuids,
  }) {
    int best = 0;
    List<String> bestSignals = [];
    String? bestLabel;

    for (final fp in FingerprintDb.all) {
      int score = 0;
      final signals = <String>[];

      // Manufacturer ID match
      for (final id in fp.manufacturerIds) {
        if (manufacturerData.containsKey(id)) {
          score += wManufacturer;
          signals.add('Manufacturer ID match');
          break;
        }
      }

      // Service UUID match
      if (fp.serviceUuids.isNotEmpty) {
        final lower = serviceUuids.map((u) => u.toLowerCase()).toSet();
        final hit = fp.serviceUuids.any((u) => lower.contains(u.toLowerCase()));
        if (hit) {
          score += wUuid;
          signals.add('Service UUID match');
        }
      }

      // Manufacturer payload prefix match
      if (fp.manufacturerPrefix.isNotEmpty) {
        for (final entry in manufacturerData.entries) {
          if (_startsWith(entry.value, fp.manufacturerPrefix)) {
            score += wPrefix;
            signals.add('Advertisement structure match');
            break;
          }
        }
      }

      // Name match
      if (name.isNotEmpty &&
          (name.toLowerCase().contains('ray-ban') ||
              name.toLowerCase().contains('meta') ||
              name.toLowerCase().contains(fp.label.toLowerCase()))) {
        score += wName;
        signals.add('Name match');
      }

      if (score > best) {
        best = score;
        bestSignals = signals;
        bestLabel = fp.label;
      }
    }

    return ScoreResult(best, _verdict(best), bestSignals, bestLabel);
  }

  static String _verdict(int score) {
    if (score >= 90) return 'Highly likely';
    if (score >= 70) return 'Possible';
    if (score >= 40) return 'Unknown wearable';
    return 'Unknown';
  }

  static bool _startsWith(List<int> data, List<int> prefix) {
    if (data.length < prefix.length) return false;
    for (var i = 0; i < prefix.length; i++) {
      if (data[i] != prefix[i]) return false;
    }
    return true;
  }
}
