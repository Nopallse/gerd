import 'dart:async';
import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../core/models/alarm_model.dart';

class AlarmCountdownWidget extends StatefulWidget {
  final AlarmModel alarm;

  const AlarmCountdownWidget({
    super.key,
    required this.alarm,
  });

  @override
  State<AlarmCountdownWidget> createState() => _AlarmCountdownWidgetState();
}

class _AlarmCountdownWidgetState extends State<AlarmCountdownWidget> {
  Timer? _timer;
  Duration _timeUntilAlarm = Duration.zero;

  @override
  void initState() {
    super.initState();
    _calculateTimeUntilAlarm();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeUntilAlarm();
    });
  }

  void _calculateTimeUntilAlarm() {
    if (!widget.alarm.isActive) {
      setState(() {
        _timeUntilAlarm = Duration.zero;
      });
      return;
    }

    final now = DateTime.now();
    var nextAlarmTime = DateTime(
      now.year,
      now.month,
      now.day,
      widget.alarm.time.hour,
      widget.alarm.time.minute,
    );

    // If the alarm time has passed today, set it for tomorrow
    if (nextAlarmTime.isBefore(now)) {
      nextAlarmTime = nextAlarmTime.add(const Duration(days: 1));
    }

    final difference = nextAlarmTime.difference(now);
    
    setState(() {
      _timeUntilAlarm = difference;
    });
  }

  String _formatCountdown(Duration duration) {
    if (duration.isNegative || duration == Duration.zero) {
      return 'Alarm tidak aktif';
    }

    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours}j ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }

  Color _getCountdownColor() {
    if (!widget.alarm.isActive || _timeUntilAlarm == Duration.zero) {
      return AppColors.textTertiary;
    }

    if (_timeUntilAlarm.inMinutes <= 5) {
      return AppColors.dangerRed;
    } else if (_timeUntilAlarm.inHours <= 1) {
      return AppColors.dangerRed;
    } else {
      return AppColors.healthGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show debug info even for inactive alarms, but with different styling
    return Container(
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      decoration: BoxDecoration(
        color: _getCountdownColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          color: _getCountdownColor().withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.alarm.isActive ? Icons.schedule : Icons.schedule_outlined,
            size: 14.0,
            color: _getCountdownColor(),
          ),
          const SizedBox(width: 6.0),
          Text(
            widget.alarm.isActive 
                ? 'Alarm dalam: ${_formatCountdown(_timeUntilAlarm)}'
                : 'Alarm tidak aktif',
            style: TextStyle(
              fontSize: 11.0,
              fontWeight: FontWeight.w600,
              color: _getCountdownColor(),
            ),
          ),
        ],
      ),
    );
  }
}