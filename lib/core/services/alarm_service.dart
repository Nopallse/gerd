import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/alarm_model.dart';
import 'notification_service.dart';

class AlarmService extends ChangeNotifier {
  static final AlarmService _instance = AlarmService._internal();
  factory AlarmService() => _instance;
  AlarmService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  final NotificationService _notificationService = NotificationService();
  
  List<AlarmModel> _alarms = [];
  bool _isLoading = false;

  List<AlarmModel> get alarms => List.unmodifiable(_alarms);
  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _notificationService.initialize();
      await _notificationService.requestPermissions();
      await loadAlarms();
    } catch (e) {
      debugPrint('Error initializing AlarmService: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAlarms() async {
    try {
      _alarms = await _databaseHelper.getAllAlarms();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading alarms: $e');
    }
  }

  Future<AlarmModel?> addAlarm({
    required String type,
    required String title,
    required String subtitle,
    required TimeOfDay time,
    required String description,
    required bool isActive,
    required IconData icon,
  }) async {
    try {
      final alarm = AlarmModel(
        type: type,
        title: title,
        subtitle: subtitle,
        time: time,
        description: description,
        isActive: isActive,
        days: 'Setiap hari',
        iconCodePoint: icon.codePoint, // Use iconCodePoint instead of icon
        createdAt: DateTime.now(),
      );

      final id = await _databaseHelper.insertAlarm(alarm);
      final newAlarm = alarm.copyWith(id: id);
      
      _alarms.add(newAlarm);
      _sortAlarms();
      notifyListeners();

      // Schedule notification if alarm is active
      if (isActive) {
        debugPrint('=== ALARM SERVICE DEBUG ===');
        debugPrint('Adding alarm: ${newAlarm.title}');
        debugPrint('Alarm ID: ${newAlarm.id}');
        debugPrint('Alarm time: ${newAlarm.timeString}');
        debugPrint('Is active: ${newAlarm.isActive}');
        debugPrint('Scheduling notification...');
        
        await _notificationService.scheduleAlarm(newAlarm);
        
        debugPrint('Notification scheduled successfully');
        debugPrint('==========================');
      }

      return newAlarm;
    } catch (e) {
      debugPrint('Error adding alarm: $e');
      return null;
    }
  }

  Future<bool> updateAlarm(AlarmModel alarm) async {
    try {
      await _databaseHelper.updateAlarm(alarm);
      
      final index = _alarms.indexWhere((a) => a.id == alarm.id);
      if (index != -1) {
        _alarms[index] = alarm;
        _sortAlarms();
        notifyListeners();

        // Update notification
        await _notificationService.cancelAlarm(alarm.id!);
        if (alarm.isActive) {
          await _notificationService.scheduleAlarm(alarm);
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error updating alarm: $e');
      return false;
    }
  }

  Future<bool> deleteAlarm(int id) async {
    try {
      await _databaseHelper.deleteAlarm(id);
      await _notificationService.cancelAlarm(id);
      
      _alarms.removeWhere((alarm) => alarm.id == id);
      notifyListeners();
      
      return true;
    } catch (e) {
      debugPrint('Error deleting alarm: $e');
      return false;
    }
  }

  Future<bool> toggleAlarm(int id, bool isActive) async {
    try {
      await _databaseHelper.toggleAlarmStatus(id, isActive);
      
      final index = _alarms.indexWhere((alarm) => alarm.id == id);
      if (index != -1) {
        final alarm = _alarms[index];
        _alarms[index] = alarm.copyWith(isActive: isActive);
        notifyListeners();

        // Update notification
        await _notificationService.cancelAlarm(id);
        if (isActive) {
          await _notificationService.scheduleAlarm(_alarms[index]);
        }

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error toggling alarm: $e');
      return false;
    }
  }

  Future<void> rescheduleAllAlarms() async {
    try {
      await _notificationService.rescheduleAllAlarms(_alarms);
    } catch (e) {
      debugPrint('Error rescheduling alarms: $e');
    }
  }

  List<AlarmModel> getActiveAlarms() {
    return _alarms.where((alarm) => alarm.isActive).toList();
  }

  List<AlarmModel> getAlarmsByType(String type) {
    return _alarms.where((alarm) => alarm.type == type).toList();
  }

  AlarmModel? getAlarmById(int id) {
    try {
      return _alarms.firstWhere((alarm) => alarm.id == id);
    } catch (e) {
      return null;
    }
  }

  int get totalAlarms => _alarms.length;
  int get activeAlarms => _alarms.where((alarm) => alarm.isActive).length;
  int get mealAlarms => _alarms.where((alarm) => alarm.type == 'meal').length;
  int get medicineAlarms => _alarms.where((alarm) => alarm.type == 'medicine').length;

  void _sortAlarms() {
    _alarms.sort((a, b) {
      final aMinutes = a.time.hour * 60 + a.time.minute;
      final bMinutes = b.time.hour * 60 + b.time.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  // Debug methods
  Future<void> showTestNotification() async {
    await _notificationService.showTestNotification();
  }

  Future<void> showPendingNotifications() async {
    final pending = await _notificationService.getPendingNotifications();
    debugPrint('Pending notifications: ${pending.length}');
    for (final notification in pending) {
      debugPrint('ID: ${notification.id}, Title: ${notification.title}');
    }
  }

  Future<void> deleteAllAlarms() async {
    try {
      await _databaseHelper.deleteAllAlarms();
      await _notificationService.cancelAllAlarms();
      _alarms.clear();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting all alarms: $e');
    }
  }

  @override
  void dispose() {
    _databaseHelper.closeDatabase();
    super.dispose();
  }
}
