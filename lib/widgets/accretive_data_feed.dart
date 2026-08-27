import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../core/app_colors.dart';

class AccretiveDataFeed extends StatefulWidget {
  const AccretiveDataFeed({super.key});

  @override
  State<AccretiveDataFeed> createState() => _AccretiveDataFeedState();
}

class _AccretiveDataFeedState extends State<AccretiveDataFeed> {
  final List<String> _logs = [];
  final Random _random = Random();
  late Timer _timer;

  final List<String> _possibleLogs = [
    "SYNC_COMPLETE: ARCHIVE_V2.0",
    "DECRYPTING: PROJECT_LAYER_0xAF",
    "UPLINK_STABLE: 104.2 MBPS",
    "NEURAL_HANDSHAKE: ACTIVE",
    "RENDERING_ACCRETIVE_LAYERS...",
    "ACCESSING_CORE_FRAGMENTS",
    "LATENCY: 4ms",
    "ENCRYPTION: AES-256-QUANTUM",
    "MEM_ALLOC: 4.2GB / 16GB",
    "CACHE_HIT: 98.4%",
  ];

  @override
  void initState() {
    super.initState();
    _startFeeding();
  }

  void _startFeeding() {
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (mounted) {
        setState(() {
          _logs.insert(0, _possibleLogs[_random.nextInt(_possibleLogs.length)]);
          if (_logs.length > 5) _logs.removeLast();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppColors.primary.withValues(alpha: 0.1),
            width: 0.5,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: _logs.map((log) => _buildLogLine(log)).toList(),
      ),
    );
  }

  Widget _buildLogLine(String log) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "[${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}]",
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.3),
              fontSize: 8,
              fontFamily: 'monospace',
            ),
          ),
          const SizedBox(width: 10),
          Text(
            log,
            style: TextStyle(
              color: AppColors.primary.withValues(alpha: 0.6),
              fontSize: 9,
              fontFamily: 'monospace',
              letterSpacing: 1,
            ),
          ),
        ],
      ).animate().fadeIn(duration: 400.ms).moveX(begin: -5, end: 0),
    );
  }
}
