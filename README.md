# SpectraSense

Detect nearby smart glasses and recording-capable wearables from **public Bluetooth signals**. Starting with Ray-Ban Meta.

No hacking, no connecting, no interfering. The app passively listens to BLE advertisement packets that devices broadcast publicly, and flags ones that match known wearable fingerprints with a confidence score.

## Status: MVP scaffold (v0.1.0)

This is a working skeleton, **not** a finished product. It scans, scores, and displays — but the fingerprint database is **unverified placeholder data**. See `HANDOFF_PROMPT.md` for what to do next.

## What works now
- Android BLE scanning via `flutter_blue_plus`
- Live device list with RSSI / proximity
- Confidence scoring engine (manufacturer ID + UUID + payload prefix + name)
- Confidence bands: Highly likely (90+) / Possible (70+) / Unknown
- Brand UI, in-code logo (no asset needed), green `#0E8C2C` theme

## What is NOT done
- Fingerprints are guesses. **Nothing is verified against real hardware.**
- iOS is limited: CoreBluetooth hides manufacturer data + MAC, so the heaviest scoring signal is unavailable. Android is the real target.
- No Bluetooth Classic discovery (Meta glasses also use Classic for audio).
- No persistence, no fingerprint DB sync, no visual-recognition layer.

## Run it
```bash
flutter pub get
flutter run
```
Requires a physical Android device (BLE does not work in emulators). Grant Bluetooth + location permissions when prompted.

## Project layout
```
lib/
  main.dart                  app entry
  theme/app_theme.dart       brand colors + dark theme
  models/
    detected_device.dart     scored device model
    fingerprint.dart         fingerprint DB (PLACEHOLDER DATA)
  services/
    ble_scanner.dart         flutter_blue_plus wrapper
    scoring_engine.dart      confidence scoring (weights need calibration)
  widgets/
    spectra_logo.dart        in-code logo
    device_card.dart         result card
  screens/
    scan_screen.dart         main screen
```

## Ethics / legal note
This tool is for **personal privacy awareness** — knowing what may be recording near you. It must stay passive (listen only, never connect to others' devices) and must never be used to track identified individuals. Bluetooth-scanning apps face app-store scrutiny and jurisdiction-specific consent laws; get a legal pass before public release.
# SpectraSense
