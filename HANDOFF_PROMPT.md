# HANDOFF PROMPT — for the AI continuing SpectraSense

Paste everything below into the next AI. It has full context and a prioritized plan.

---

## ROLE
You are continuing **SpectraSense**, a Flutter app that detects nearby smart glasses and recording-capable wearables (starting with Ray-Ban Meta) from **public Bluetooth advertisement signals only**. Passive listening, never connecting to or interfering with other people's devices. Act as a combined Bluetooth security researcher, Flutter engineer, and product architect. Be concrete; produce ready-to-use code, not explanations.

## WHAT EXISTS (this zip)
A working MVP scaffold:
- `flutter_blue_plus` BLE scanner (`lib/services/ble_scanner.dart`)
- Confidence scoring engine with weights manufacturer 40 / UUID 30 / payload-prefix 20 / name 10 (`lib/services/scoring_engine.dart`)
- Fingerprint DB (`lib/models/fingerprint.dart`) — **all values are UNVERIFIED PLACEHOLDERS**
- Scored device model, brand UI, in-code logo, dark green `#0E8C2C` theme
- Android manifest with correct BLE permissions; iOS plist additions noted

## CRITICAL TRUTHS — do not violate
1. **The fingerprints are guesses.** `0x01D9` (Meta) is cited but UNVERIFIED. Do NOT present any detection as confirmed until a fingerprint's `verified` flag is true, set only after matching real captured hardware data. Never fabricate manufacturer IDs / UUIDs.
2. **iOS is data-starved.** CoreBluetooth strips manufacturer data and the MAC. The heaviest signal (manufacturer ID) is unavailable on iOS. Android is the primary platform. Don't design as if iOS gives Android-level data.
3. **MAC randomization** (~every 15 min) makes addresses useless for persistent identity. Fingerprint on content + behavior, not address.
4. **Connected glasses often stop advertising.** They may only be detectable during pairing/setup/idle-unpaired. Validate this empirically; it affects the whole product premise.
5. **Meta glasses use Bluetooth Classic too** (A2DP/HFP for audio). A BLE-only scanner sees half the picture. Adding Android Classic discovery (`startDiscovery`) is high-value.
6. **Scoring weights are placeholders.** Recalibrate from measured precision/recall against a real control set — do not trust the 40/30/20/10 bands until then.

## PRIORITY ROADMAP
**P0 — Verify fingerprints (blocks everything).**
The human must capture real data from a Ray-Ban Meta unit + a control set (AirPods, Galaxy Buds, smartwatches, other glasses) using nRF Connect, Wireshark + Nordic nRF Sniffer, and the Android HCI snoop log. Capture across states: unpaired-idle, pairing, connected-idle, connected-recording, post-firmware-update. Then fill `FingerprintDb`, set `verified: true`, and recalibrate weights. Build a tiny in-app "capture mode" that dumps every raw advertisement (all manufacturer IDs, UUIDs, payload hex, RSSI, timestamps) to a shareable file to make this easier.

**P1 — Add Bluetooth Classic discovery on Android** and merge with BLE results (Class-of-Device bits help separate audio devices from glasses).

**P2 — Behavioral fingerprinting:** advertising interval, AD-structure ordering, TX-power, payload byte-prefix stability across MAC rotations. These survive randomization.

**P3 — Product polish:** persistent fingerprint DB (local + optional remote sync), detection history, background-scan alerting, onboarding that sets honest expectations ("may miss connected devices").

**P4 — Expansion:** generalize fingerprints to other smart glasses, AI pins, and recording wearables; add the visual-recognition corroboration layer as a secondary signal only.

## CONSTRAINTS
- Stay passive. No connecting to third-party devices in the field; GATT enumeration only on hardware the user owns, for DB building.
- Keep it honest: surface confidence + matched signals, never a bare "DETECTED" the data can't support.
- Privacy: never log others' rotating identifiers in a way that enables tracking. The app must not itself become a tracker.
- Brand: green `#0E8C2C`, dark UI, in-code logo already in `lib/widgets/spectra_logo.dart`.

## FIRST ACTIONS
1. Read `README.md` and skim every file under `lib/`.
2. Build the in-app "capture mode" (P0) so the human can start collecting real advertisements today.
3. Give the human a one-page capture checklist (tools, device states, what to record).
4. Only after real data exists: fill `FingerprintDb`, flip `verified`, recalibrate weights.

Ask the human one question before starting: **do they already have a Ray-Ban Meta unit and a Nordic sniffer dongle, or do they need a capture plan that works with just an Android phone (nRF Connect + HCI snoop log)?**
