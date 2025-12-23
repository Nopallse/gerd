import 'dart:io';
import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import '../models/alarm_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  NotificationService._internal();

  factory NotificationService() => _instance;

  static bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    // Initialize timezone with local timezone
    tz.initializeTimeZones();
    
    // Force set to Asia/Jakarta timezone
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Jakarta'));
      debugPrint('Successfully set timezone to Asia/Jakarta');
    } catch (e) {
      // Fallback to other Indonesian timezones if Asia/Jakarta fails
      try {
        tz.setLocalLocation(tz.getLocation('Asia/Makassar'));
        debugPrint('Fallback: Set timezone to Asia/Makassar');
      } catch (e2) {
        debugPrint('Warning: Could not set Indonesian timezone, using UTC');
      }
    }
    
    debugPrint('=== TIMEZONE INITIALIZATION ===');
    debugPrint('TZ Local: ${tz.local}');
    debugPrint('Current TZ time: ${tz.TZDateTime.now(tz.local)}');
    debugPrint('Current system time: ${DateTime.now()}');
    debugPrint('TZ Offset: ${tz.TZDateTime.now(tz.local).timeZoneOffset}');
    debugPrint('System Offset: ${DateTime.now().timeZoneOffset}');
    debugPrint('===============================');

    // Android initialization
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS initialization
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Combined initialization
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  static void _onNotificationTap(NotificationResponse response) {
    // Handle notification tap
    debugPrint('Notification tapped: ${response.payload}');
  }

  // Debug method to show notification when it should fire
  Future<void> showDebugNotification(String message) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      '🔥 DEBUG NOTIFICATION',
      message,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gerd_care_debug',
          'GERD Care Debug',
          channelDescription: 'Debug notifications for GERD Care app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  Future<bool> requestPermissions() async {
    if (Platform.isAndroid) {
      // Request notification permission for Android 13+
      final notifStatus = await Permission.notification.request();
      debugPrint('Notification permission: ${notifStatus}');
      
      // Request exact alarm permission for Android 12+
      final alarmStatus = await Permission.scheduleExactAlarm.request();
      debugPrint('Exact alarm permission: ${alarmStatus}');
      
      // Request ignore battery optimization
      try {
        final batteryStatus = await Permission.ignoreBatteryOptimizations.request();
        debugPrint('Battery optimization permission: ${batteryStatus}');
      } catch (e) {
        debugPrint('Could not request battery optimization permission: $e');
      }
      
      // Request system alert window (for overlay notifications)
      try {
        final alertStatus = await Permission.systemAlertWindow.request();
        debugPrint('System alert window permission: ${alertStatus}');
      } catch (e) {
        debugPrint('Could not request system alert permission: $e');
      }
      
      // Check if we can schedule exact alarms
      final canScheduleExactAlarms = await Permission.scheduleExactAlarm.isGranted;
      debugPrint('Can schedule exact alarms: $canScheduleExactAlarms');
      
      return notifStatus.isGranted && canScheduleExactAlarms;
    } else if (Platform.isIOS) {
      final bool? result = await _notifications
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      return result ?? false;
    }
    return true;
  }

  Future<void> scheduleAlarm(AlarmModel alarm) async {
    if (!alarm.isActive) return;

    // Use system DateTime and construct TZDateTime properly
    final systemNow = DateTime.now();
    var systemScheduledTime = DateTime(
      systemNow.year,
      systemNow.month,
      systemNow.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    // If the scheduled time has passed today, schedule for tomorrow
    if (systemScheduledTime.isBefore(systemNow)) {
      systemScheduledTime = systemScheduledTime.add(const Duration(days: 1));
    }

    // Create TZDateTime using constructor instead of from() to preserve local time
    final scheduledDateTime = tz.TZDateTime(
      tz.local,
      systemScheduledTime.year,
      systemScheduledTime.month,
      systemScheduledTime.day,
      systemScheduledTime.hour,
      systemScheduledTime.minute,
    );
    
    // Debug prints
    debugPrint('=== SCHEDULING ALARM ===');
    debugPrint('Alarm ID: ${alarm.id}');
    debugPrint('Alarm Title: ${alarm.title}');
    debugPrint('Alarm Time: ${alarm.time.hour}:${alarm.time.minute}');
    debugPrint('System Now: $systemNow');
    debugPrint('System Scheduled: $systemScheduledTime');
    debugPrint('TZ Scheduled: $scheduledDateTime');
    debugPrint('System offset: ${systemNow.timeZoneOffset}');
    debugPrint('TZ offset: ${scheduledDateTime.timeZoneOffset}');
    debugPrint('Time until alarm: ${systemScheduledTime.difference(systemNow)}');
    debugPrint('Is future time: ${systemScheduledTime.isAfter(systemNow)}');
    debugPrint('========================');

    if (systemScheduledTime.isAfter(systemNow)) {
      // Cancel any existing alarm with the same ID first
      await _notifications.cancel(alarm.id!);
      
      // DUAL STRATEGY: Schedule with Android + Setup Timer fallback
      
      // 1. Try Android scheduled notification (primary method)
      await _notifications.zonedSchedule(
        alarm.id!,
        _getNotificationTitle(alarm),
        _getNotificationBody(alarm),
        scheduledDateTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'gerd_care_alarms',
            'GERD Care Alarms',
            channelDescription: 'Alarm notifications for GERD Care app',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000]),
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            visibility: NotificationVisibility.public,
            autoCancel: false,
            ongoing: false,
            showWhen: true,
            when: scheduledDateTime.millisecondsSinceEpoch,
          ),
          iOS: const DarwinNotificationDetails(
            sound: 'alarm.wav',
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.critical,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'alarm_${alarm.id}',
      );
      
      // 2. Setup Timer fallback (secondary method)
      final timeUntilAlarm = systemScheduledTime.difference(systemNow);
      debugPrint('🔄 Setting up Timer fallback for ${timeUntilAlarm.inSeconds} seconds');
      
      Timer(timeUntilAlarm, () async {
        debugPrint('⏰ TIMER FALLBACK TRIGGERED for alarm ${alarm.id}');
        await _timerFallbackNotification(alarm);
      });
      
      // Verify the alarm was scheduled
      final pendingNotifications = await _notifications.pendingNotificationRequests();
      final scheduledAlarm = pendingNotifications.where((n) => n.id == alarm.id).firstOrNull;
      if (scheduledAlarm != null) {
        debugPrint('✅ Alarm verified in pending list: ${scheduledAlarm.title}');
        debugPrint('🔄 Timer fallback also set as backup');
      } else {
        debugPrint('❌ WARNING: Alarm not found in pending list!');
        debugPrint('⏰ But Timer fallback is still active');
      }
    } else {
      debugPrint('ERROR: Scheduled time is still in the past after adding one day!');
    }

    debugPrint('Alarm scheduled successfully for ID: ${alarm.id}');
    
    // Start countdown logging for this specific alarm
    _logSpecificAlarmCountdown(alarm);
  }

  // Timer fallback notification method
  Future<void> _timerFallbackNotification(AlarmModel alarm) async {
    debugPrint('🚨 FIRING TIMER FALLBACK NOTIFICATION');
    debugPrint('Alarm: ${alarm.title}');
    debugPrint('Time: ${DateTime.now()}');
    
    try {
      // Force immediate notification
      await _notifications.show(
        alarm.id! + 50000, // Different ID to avoid conflict
        '⏰ ${_getNotificationTitle(alarm)} (BACKUP)',
        '${_getNotificationBody(alarm)}\n\n🔄 Fired by Timer Fallback',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'gerd_care_alarms_fallback',
            'GERD Care Fallback Alarms',
            channelDescription: 'Fallback alarm notifications when scheduled fails',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 1000, 500, 1000, 500, 1000]),
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
            autoCancel: false,
            ongoing: false,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
            interruptionLevel: InterruptionLevel.critical,
          ),
        ),
      );
      
      debugPrint('✅ Timer fallback notification sent successfully');
    } catch (e) {
      debugPrint('❌ Timer fallback notification failed: $e');
    }
  }  // Log countdown for specific alarm that was just scheduled
  Future<void> _logSpecificAlarmCountdown(AlarmModel alarm) async {
    final now = DateTime.now();
    var scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      alarm.time.hour,
      alarm.time.minute,
    );

    // If the time has passed today, it's scheduled for tomorrow
    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    final difference = scheduledTime.difference(now);
    final hours = difference.inHours;
    final minutes = difference.inMinutes.remainder(60);
    final seconds = difference.inSeconds.remainder(60);

    debugPrint('🚨 ALARM SCHEDULED FROM SERVICE:');
    debugPrint('   📅 Alarm: ${alarm.title}');
    debugPrint('   ⏰ Set for: ${alarm.time.hour.toString().padLeft(2, '0')}:${alarm.time.minute.toString().padLeft(2, '0')}');
    debugPrint('   📍 Current time: ${now.toString().substring(11, 19)}');
    debugPrint('   🎯 Will fire at: ${scheduledTime.toString().substring(11, 19)}');
    debugPrint('   ⏳ Countdown: ${hours}h ${minutes}m ${seconds}s');
    debugPrint('   📱 Status: Scheduled in Android notification system');
    debugPrint('===========================================');
  }

  Future<void> cancelAlarm(int alarmId) async {
    await _notifications.cancel(alarmId);
  }

  Future<void> cancelAllAlarms() async {
    await _notifications.cancelAll();
  }

  Future<void> rescheduleAllAlarms(List<AlarmModel> alarms) async {
    // Cancel all existing alarms
    await cancelAllAlarms();

    // Schedule all active alarms
    for (final alarm in alarms) {
      if (alarm.isActive && alarm.id != null) {
        await scheduleAlarm(alarm);
      }
    }
  }

  String _getNotificationTitle(AlarmModel alarm) {
    switch (alarm.type) {
      case 'meal':
        return '🍽️ ${alarm.title}';
      case 'medicine':
        return '💊 ${alarm.title}';
      default:
        return alarm.title;
    }
  }

  String _getNotificationBody(AlarmModel alarm) {
    switch (alarm.type) {
      case 'meal':
        return 'Saatnya makan! ${alarm.description}';
      case 'medicine':
        return 'Saatnya minum obat! ${alarm.description}';
      default:
        return alarm.description;
    }
  }

  Future<List<PendingNotificationRequest>> getPendingNotifications() async {
    return await _notifications.pendingNotificationRequests();
  }

  Future<void> showInstantNotification(AlarmModel alarm) async {
    await _notifications.show(
      DateTime.now().millisecondsSinceEpoch.remainder(100000),
      _getNotificationTitle(alarm),
      _getNotificationBody(alarm),
      NotificationDetails(
        android: AndroidNotificationDetails(
          'gerd_care_instant',
          'GERD Care Instant',
          channelDescription: 'Instant notifications for GERD Care app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'instant_${alarm.id}',
    );
  }

  // Debug method to test notifications
  Future<void> showTestNotification() async {
    await _notifications.show(
      999,
      'Test Alarm',
      'Ini adalah test notification untuk GERD Care',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gerd_care_test',
          'GERD Care Test',
          channelDescription: 'Test notifications for GERD Care app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
    );
  }

  // Debug method to show all pending notifications
  Future<void> showPendingNotificationsDebug() async {
    final pending = await getPendingNotifications();
    debugPrint('=== PENDING NOTIFICATIONS ===');
    debugPrint('Total pending: ${pending.length}');
    for (final notification in pending) {
      debugPrint('ID: ${notification.id}');
      debugPrint('Title: ${notification.title}');
      debugPrint('Body: ${notification.body}');
      debugPrint('Payload: ${notification.payload}');
      debugPrint('---');
    }
    debugPrint('=============================');
  }

  // Debug method to schedule a test alarm in 10 seconds
  Future<void> scheduleTestAlarmIn10Seconds() async {
    // Use timezone-aware datetime directly
    final now = tz.TZDateTime.now(tz.local);
    final testTime = now.add(const Duration(seconds: 10));
    
    debugPrint('=== SCHEDULING TEST ALARM ===');
    debugPrint('Current TZ Time: ${now.hour}:${now.minute}:${now.second}');
    debugPrint('Test Alarm TZ Time: ${testTime.hour}:${testTime.minute}:${testTime.second}');
    debugPrint('Current System Time: ${DateTime.now().toString()}');
    debugPrint('Test Alarm System Time: ${testTime.toLocal().toString()}');
    debugPrint('Timezone: ${tz.local.name}');
    debugPrint('Difference: ${testTime.difference(now).inSeconds} seconds');
    debugPrint('=============================');

    // Cancel previous test alarm if exists
    await _notifications.cancel(888);

    await _notifications.zonedSchedule(
      888, // Test ID
      '🧪 Test Alarm 10s',
      'Test alarm dijadwalkan pada ${testTime.toString()}',
      testTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gerd_care_alarms',
          'GERD Care Alarms',
          channelDescription: 'Alarm notifications for GERD Care app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'alarm.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'test_alarm_10s_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    debugPrint('Test alarm scheduled for 10 seconds from now using zonedSchedule!');
  }

  // Debug method to check all permissions
  Future<void> checkAllPermissions() async {
    debugPrint('=== CHECKING ALL PERMISSIONS ===');
    
    if (Platform.isAndroid) {
      final notifPerm = await Permission.notification.status;
      final alarmPerm = await Permission.scheduleExactAlarm.status;
      
      debugPrint('Notification permission: $notifPerm');
      debugPrint('Schedule exact alarm permission: $alarmPerm');
      debugPrint('Can schedule exact alarms: ${await Permission.scheduleExactAlarm.isGranted}');
    }
    
    debugPrint('================================');
  }

  // Debug method to check timezone info
  Future<void> checkTimezoneInfo() async {
    debugPrint('=== TIMEZONE DEBUG INFO ===');
    final now = DateTime.now();
    final tzNow = tz.TZDateTime.now(tz.local);
    
    debugPrint('System DateTime.now(): $now');
    debugPrint('TZ DateTime.now(): $tzNow');
    debugPrint('Local timezone: ${tz.local.name}');
    debugPrint('TZ offset: ${tzNow.timeZoneOffset}');
    debugPrint('System offset: ${now.timeZoneOffset}');
    debugPrint('Difference: ${tzNow.difference(now)}');
    debugPrint('===========================');
  }

  // Alternative method: schedule test alarm using system time instead of TZ
  Future<void> scheduleTestAlarmWithSystemTime() async {
    final now = DateTime.now();
    final testTime = now.add(const Duration(seconds: 10));
    
    // Create TZDateTime with correct UTC offset instead of using from()
    final tzTestTime = tz.TZDateTime(
      tz.local,
      testTime.year,
      testTime.month,
      testTime.day,
      testTime.hour,
      testTime.minute,
      testTime.second,
      testTime.millisecond,
    );
    
    debugPrint('=== SCHEDULING TEST ALARM (SYSTEM TIME) ===');
    debugPrint('System Now: $now');
    debugPrint('System Test Time: $testTime');
    debugPrint('TZ Test Time (corrected): $tzTestTime');
    debugPrint('System offset: ${now.timeZoneOffset}');
    debugPrint('TZ offset: ${tzTestTime.timeZoneOffset}');
    debugPrint('Time difference: ${testTime.difference(now).inSeconds} seconds');
    debugPrint('==========================================');

    // Cancel previous test alarm
    await _notifications.cancel(887);

    await _notifications.zonedSchedule(
      887, // Different ID
      '🕐 System Time Test 10s',
      'Test dengan system time - ${testTime.toString()}',
      tzTestTime,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'gerd_care_alarms',
          'GERD Care Alarms',
          channelDescription: 'Alarm notifications for GERD Care app',
          importance: Importance.high,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
        ),
        iOS: DarwinNotificationDetails(
          sound: 'alarm.wav',
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: 'system_test_alarm_${DateTime.now().millisecondsSinceEpoch}',
    );
    
    debugPrint('System time test alarm scheduled with corrected timezone!');
  }

  // Manual timer test - fire notification after 10 seconds using Timer
  Future<void> scheduleManualTimerTest() async {
    debugPrint('=== MANUAL TIMER TEST ===');
    debugPrint('Starting 10 second countdown...');
    debugPrint('Current time: ${DateTime.now()}');
    
    // Show immediate notification that timer started
    await showDebugNotification('Manual timer test started - 10 seconds countdown');
    
    // Use Timer to fire notification after 10 seconds
    Timer(const Duration(seconds: 10), () async {
      debugPrint('=== MANUAL TIMER FIRED ===');
      debugPrint('Timer fired at: ${DateTime.now()}');
      
      await showDebugNotification('🎯 MANUAL TIMER ALARM - This should work!');
      
      debugPrint('Manual notification sent!');
      debugPrint('=========================');
    });
    
    debugPrint('Timer scheduled for 10 seconds');
    debugPrint('=========================');
  }

  // Debug method to check battery optimization and other issues
  Future<void> checkBatteryOptimization() async {
    debugPrint('=== BATTERY OPTIMIZATION CHECK ===');
    
    if (Platform.isAndroid) {
      // Check various permissions
      final permissions = [
        Permission.notification,
        Permission.scheduleExactAlarm,
        Permission.ignoreBatteryOptimizations,
      ];
      
      for (final permission in permissions) {
        final status = await permission.status;
        debugPrint('${permission.toString()}: $status');
      }
      
      // Check if app is whitelisted from battery optimization
      final batteryOptStatus = await Permission.ignoreBatteryOptimizations.status;
      if (batteryOptStatus.isDenied) {
        debugPrint('WARNING: App may be battery optimized - this can prevent alarms!');
        debugPrint('Consider requesting battery optimization exemption');
        
        // Try to request battery optimization exemption
        try {
          await Permission.ignoreBatteryOptimizations.request();
          debugPrint('Requested battery optimization exemption');
        } catch (e) {
          debugPrint('Could not request battery exemption: $e');
        }
      }
    }
    
    debugPrint('==================================');
  }

  // Comprehensive method to check why scheduled alarms are not working
  Future<void> diagnosePushNotificationIssues() async {
    debugPrint('🔍 === COMPREHENSIVE ALARM DIAGNOSIS ===');
    
    // 1. Check all permissions
    await checkAllPermissions();
    
    // 2. Check timezone
    await checkTimezoneInfo();
    
    // 3. Check battery optimization
    await checkBatteryOptimization();
    
    // 4. Check pending notifications
    final pendingNotifications = await _notifications.pendingNotificationRequests();
    debugPrint('📋 Pending notifications: ${pendingNotifications.length}');
    for (final notification in pendingNotifications) {
      debugPrint('  - ID: ${notification.id}, Title: ${notification.title}');
    }
    
    // 5. Test immediate notification
    debugPrint('📱 Testing immediate notification...');
    await showDebugNotification('Immediate test - if you see this, notifications work!');
    
    // 6. Schedule a very short test
    debugPrint('⏰ Scheduling 15-second test alarm...');
    await scheduleVeryShortTestAlarm();
    
    debugPrint('🎯 === DIAGNOSIS COMPLETE ===');
  }

  // Schedule a very short test alarm (15 seconds) to test if scheduling works at all
  Future<void> scheduleVeryShortTestAlarm() async {
    final now = DateTime.now();
    final testTime = now.add(const Duration(seconds: 15));
    
    final tzTestTime = tz.TZDateTime(
      tz.local,
      testTime.year,
      testTime.month,
      testTime.day,
      testTime.hour,
      testTime.minute,
      testTime.second,
    );
    
    await _notifications.zonedSchedule(
      12345, // Unique test ID
      '⚡ Short Test Alarm',
      'This test alarm should fire in 15 seconds at ${testTime.toString().substring(11, 19)}',
      tzTestTime,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'gerd_care_alarms',
          'GERD Care Alarms',
          channelDescription: 'Test alarm notifications',
          importance: Importance.max,
          priority: Priority.max,
          icon: '@mipmap/ic_launcher',
          playSound: true,
          enableVibration: true,
          fullScreenIntent: true,
          category: AndroidNotificationCategory.alarm,
          autoCancel: false,
          ongoing: false,
          visibility: NotificationVisibility.public,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.critical,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
    
    debugPrint('✅ 15-second test alarm scheduled at: $tzTestTime');
  }

  // Test Timer fallback method specifically
  Future<void> testTimerFallbackMethod() async {
    debugPrint('🧪 === TESTING TIMER FALLBACK METHOD ===');
    debugPrint('This will fire a notification in 5 seconds using Timer only');
    
    final now = DateTime.now();
    debugPrint('Current time: ${now.toString().substring(11, 19)}');
    debugPrint('Timer will fire at: ${now.add(Duration(seconds: 5)).toString().substring(11, 19)}');
    
    Timer(Duration(seconds: 5), () async {
      debugPrint('🔥 TIMER FALLBACK TEST FIRED!');
      
      await _notifications.show(
        99999, // Test ID
        '🎯 TIMER FALLBACK TEST',
        'This notification was fired using Timer fallback method at ${DateTime.now().toString().substring(11, 19)}',
        NotificationDetails(
          android: AndroidNotificationDetails(
            'gerd_care_alarms_fallback',
            'GERD Care Fallback Test',
            channelDescription: 'Testing timer fallback notifications',
            importance: Importance.max,
            priority: Priority.max,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
            vibrationPattern: Int64List.fromList([0, 500, 250, 500, 250, 500]),
            fullScreenIntent: true,
            category: AndroidNotificationCategory.alarm,
          ),
        ),
      );
      
      debugPrint('✅ Timer fallback test notification sent!');
    });
    
    debugPrint('⏲️ Timer set for 5 seconds from now');
    debugPrint('========================================');
  }

  // Debug method to force reset timezone
  Future<void> forceResetTimezone() async {
    
    try {
      // Try to set to Asia/Jakarta
      final jakarta = tz.getLocation('Asia/Jakarta');
      tz.setLocalLocation(jakarta);
      debugPrint('Successfully reset to Asia/Jakarta');
    } catch (e) {
      debugPrint('Error setting Jakarta: $e');
      
      // List available timezones that might work
      final locations = tz.timeZoneDatabase.locations;
      final asiaLocations = locations.keys.where((name) => name.startsWith('Asia/')).take(10);
      debugPrint('Available Asia timezones: $asiaLocations');
    }
    
    final newTzNow = tz.TZDateTime.now(tz.local);
    final systemNow = DateTime.now();
    
    debugPrint('After reset:');
    debugPrint('TZ Local: ${tz.local.name}');
    debugPrint('TZ Time: $newTzNow');
    debugPrint('System Time: $systemNow');
    debugPrint('TZ Offset: ${newTzNow.timeZoneOffset}');
    debugPrint('System Offset: ${systemNow.timeZoneOffset}');
    debugPrint('===============================');
  }

  // Console log countdown dari alarm service (pending notifications)
  Future<void> logAlarmCountdownFromService() async {
    try {
      final pendingNotifications = await _notifications.pendingNotificationRequests();
      final now = DateTime.now();
      
      if (pendingNotifications.isEmpty) {
        debugPrint('🔔 No pending alarms in notification service');
        return;
      }
      
      debugPrint('⏰ === COUNTDOWN FROM SERVICE (${now.toString().substring(11, 19)}) ===');
      
      // Filter real alarms (not test alarms)
      final realAlarms = pendingNotifications.where((n) => 
        n.id < 10000 && // Real alarm IDs are typically small
        (n.title?.contains('Alarm') == true || n.title?.contains('alarm') == true)
      ).toList();
      
      if (realAlarms.isEmpty) {
        debugPrint('📱 No real alarms found, only test notifications');
        debugPrint('Total pending: ${pendingNotifications.length}');
      } else {
        debugPrint('🚨 Active alarms in system: ${realAlarms.length}');
        
        for (int i = 0; i < realAlarms.length; i++) {
          final notification = realAlarms[i];
          debugPrint('   ${i + 1}. [ID:${notification.id}] ${notification.title}');
          debugPrint('      📝 ${notification.body}');
          debugPrint('      ✅ Status: READY TO FIRE (managed by Android)');
        }
      }
      
      debugPrint('============================================');
    } catch (e) {
      debugPrint('Error getting alarm countdown from service: $e');
    }
  }

  // Start periodic countdown logging (every 10 seconds)
  Timer? _countdownTimer;
  
  void startAlarmCountdownLogging() {
    stopAlarmCountdownLogging(); // Stop existing timer if any
    
    debugPrint('🎯 Starting alarm countdown logging (every 10 seconds)...');
    
    // Log immediately
    logAlarmCountdownFromService();
    
    // Then log every 10 seconds
    _countdownTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      await logAlarmCountdownFromService();
    });
  }
  
  void stopAlarmCountdownLogging() {
    if (_countdownTimer != null) {
      _countdownTimer!.cancel();
      _countdownTimer = null;
      debugPrint('⏹️ Stopped alarm countdown logging');
    }
  }

  // Enhanced method to get detailed alarm info from service with countdown
  Future<void> getDetailedAlarmCountdown() async {
    try {
      final pendingNotifications = await _notifications.pendingNotificationRequests();
      final now = DateTime.now();
      
      debugPrint('🕐 === DETAILED ALARM COUNTDOWN ===');
      debugPrint('Current time: ${now.toString()}');
      debugPrint('Timezone: ${now.timeZoneName} (${now.timeZoneOffset})');
      debugPrint('Total scheduled alarms in service: ${pendingNotifications.length}');
      
      if (pendingNotifications.isEmpty) {
        debugPrint('❌ No alarms currently scheduled in notification service!');
        debugPrint('This means either:');
        debugPrint('  - No alarms have been created');
        debugPrint('  - Alarms failed to schedule'); 
        debugPrint('  - Alarms were cancelled');
        debugPrint('==================================');
        return;
      }

      // Group by channel and show details
      final alarmNotifications = pendingNotifications.where((n) => 
        n.title?.contains('Alarm') == true || 
        n.body?.contains('alarm') == true ||
        n.id < 1000000 // Assume alarm IDs are smaller
      ).toList();

      final testNotifications = pendingNotifications.where((n) => 
        n.title?.contains('Test') == true || n.id > 1000000
      ).toList();

      debugPrint('📱 Real alarms scheduled: ${alarmNotifications.length}');
      debugPrint('🧪 Test alarms scheduled: ${testNotifications.length}');
      
      // Show details for each real alarm
      for (int i = 0; i < alarmNotifications.length; i++) {
        final notification = alarmNotifications[i];
        debugPrint('');
        debugPrint('⏰ ALARM ${i + 1}:');
        debugPrint('   📋 ID: ${notification.id}');
        debugPrint('   📝 Title: ${notification.title}');
        debugPrint('   💬 Body: ${notification.body}');
        debugPrint('   ⏳ Status: WAITING IN ANDROID SYSTEM');
        debugPrint('   🔔 Will fire when scheduled time arrives');
      }
      
      // Show test alarms too
      if (testNotifications.isNotEmpty) {
        debugPrint('');
        debugPrint('🧪 TEST ALARMS:');
        for (final test in testNotifications) {
          debugPrint('   🔬 ${test.id}: ${test.title}');
        }
      }
      
      debugPrint('');
      debugPrint('💡 NOTE: Android manages exact firing time internally');
      debugPrint('💡 Check device notifications to see when they trigger');
      debugPrint('==================================');
      
    } catch (e) {
      debugPrint('❌ Error getting detailed countdown: $e');
    }
  }
}
