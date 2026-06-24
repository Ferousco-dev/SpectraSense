import 'package:flutter/material.dart';
import '../models/detected_device.dart';
import '../theme/app_theme.dart';

class DeviceCard extends StatelessWidget {
  final DetectedDevice device;
  const DeviceCard({super.key, required this.device});

  Color get _bandColor {
    if (device.confidence >= 90) return AppTheme.bandHigh;
    if (device.confidence >= 70) return AppTheme.bandMaybe;
    return AppTheme.bandUnknown;
  }

  @override
  Widget build(BuildContext context) {
    final title = device.name.isNotEmpty ? device.name : 'Unnamed device';
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: _bandColor.withOpacity(0.35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: AppTheme.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              _ConfidenceBadge(value: device.confidence, color: _bandColor),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            device.verdict,
            style: TextStyle(color: _bandColor, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _meta(Icons.wifi_tethering, device.proximity),
              const SizedBox(width: 16),
              _meta(Icons.graphic_eq, '${device.rssi} dBm'),
            ],
          ),
          if (device.matchedSignals.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: device.matchedSignals
                  .map((s) => Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryGreen.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          s,
                          style: const TextStyle(
                              color: AppTheme.greenSoft, fontSize: 12),
                        ),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _meta(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 15, color: AppTheme.textSecondary),
        const SizedBox(width: 4),
        Text(text,
            style:
                const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
      ],
    );
  }
}

class _ConfidenceBadge extends StatelessWidget {
  final int value;
  final Color color;
  const _ConfidenceBadge({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text('$value',
          style: TextStyle(color: color, fontWeight: FontWeight.w600)),
    );
  }
}
