import 'package:flutter/material.dart';
import '../models/detected_device.dart';
import '../services/ble_scanner.dart';
import '../theme/app_theme.dart';
import '../widgets/device_card.dart';
import '../widgets/spectra_logo.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final BleScanner _scanner = BleScanner();
  List<DetectedDevice> _devices = [];
  String? _error;
  bool _scanning = false;

  @override
  void initState() {
    super.initState();
    _scanner.devices.listen(
      (d) => setState(() {
        _devices = d;
        _error = null;
      }),
      onError: (e) => setState(() => _error = e.toString()),
    );
  }

  Future<void> _toggle() async {
    if (_scanning) {
      await _scanner.stop();
    } else {
      await _scanner.start();
    }
    setState(() => _scanning = _scanner.isScanning);
  }

  @override
  void dispose() {
    _scanner.dispose();
    super.dispose();
  }

  int get _flagged => _devices.where((d) => d.confidence >= 70).length;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Row(
                children: [
                  const SpectraLogo(size: 40),
                  const SizedBox(width: 12),
                  const Text(
                    'SpectraSense',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (_scanning)
                    const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppTheme.greenLight),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                _scanning
                    ? 'Scanning for recording-capable wearables…'
                    : 'Tap scan to check what is around you.',
                style: const TextStyle(
                    color: AppTheme.textSecondary, fontSize: 14),
              ),
              const SizedBox(height: 16),
              if (_flagged > 0)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppTheme.bandMaybe.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                    border:
                        Border.all(color: AppTheme.bandMaybe.withOpacity(0.4)),
                  ),
                  child: Text(
                    '$_flagged possible recording-capable device(s) nearby',
                    style: const TextStyle(
                        color: AppTheme.bandMaybe,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              if (_error != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(_error!,
                      style: const TextStyle(color: Colors.redAccent)),
                ),
              const SizedBox(height: 12),
              Expanded(child: _buildList()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor:
            _scanning ? AppTheme.greenDark : AppTheme.primaryGreen,
        onPressed: _toggle,
        icon: Icon(_scanning ? Icons.stop : Icons.radar),
        label: Text(_scanning ? 'Stop' : 'Scan'),
      ),
    );
  }

  Widget _buildList() {
    if (_devices.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Opacity(opacity: 0.4, child: const SpectraLogo(size: 88)),
            const SizedBox(height: 16),
            Text(
              _scanning ? 'Listening…' : 'No scan yet',
              style: const TextStyle(color: AppTheme.textSecondary),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      itemCount: _devices.length,
      itemBuilder: (_, i) => DeviceCard(device: _devices[i]),
    );
  }
}
