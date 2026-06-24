/// Fingerprint definitions for known recording-capable wearables.
///
/// IMPORTANT (for whoever continues this): every fingerprint below is a
/// PLACEHOLDER until `verified` is true. Replace the manufacturer IDs,
/// service UUIDs and payload prefixes with values captured from real
/// hardware (nRF Connect / Wireshark + nRF Sniffer / Android HCI snoop log).
/// Do not present these guesses to users as confirmed.
library;

class Fingerprint {
  final String label; // e.g. "Ray-Ban Meta"
  final String category; // "smart_glasses" | "ai_pin" | "earbuds"
  final List<int> manufacturerIds; // BT SIG company IDs
  final List<String> serviceUuids; // lowercase, 16-bit or full
  final List<int> manufacturerPrefix; // stable leading bytes of payload
  final bool recordingCapable;
  final bool verified; // true once confirmed against real hardware

  const Fingerprint({
    required this.label,
    required this.category,
    this.manufacturerIds = const [],
    this.serviceUuids = const [],
    this.manufacturerPrefix = const [],
    this.recordingCapable = true,
    this.verified = false,
  });
}

class FingerprintDb {
  // ---------------------------------------------------------------
  // UNVERIFIED PLACEHOLDERS — replace with real captured data.
  // 0x01D9 is the commonly-cited Meta Platforms company ID. CONFIRM it
  // against an actual Ray-Ban Meta capture before trusting it.
  // ---------------------------------------------------------------
  static const List<Fingerprint> all = [
    Fingerprint(
      label: 'Ray-Ban Meta',
      category: 'smart_glasses',
      manufacturerIds: [0x01D9],
      serviceUuids: [],
      manufacturerPrefix: [],
      recordingCapable: true,
      verified: false,
    ),
    Fingerprint(
      label: 'Smart glasses (generic)',
      category: 'smart_glasses',
      manufacturerIds: [],
      serviceUuids: [],
      recordingCapable: true,
      verified: false,
    ),
  ];
}
