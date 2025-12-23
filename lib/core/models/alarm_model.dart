import 'package:flutter/material.dart';

class AlarmModel {
  final int? id;
  final String type; // 'meal' or 'medicine'
  final String title;
  final String subtitle;
  final TimeOfDay time;
  final String description;
  final bool isActive;
  final String days;
  final int iconCodePoint; // Changed from IconData to int
  final DateTime createdAt;
  final DateTime? updatedAt;

  AlarmModel({
    this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.description,
    required this.isActive,
    required this.days,
    required this.iconCodePoint, // Changed from icon to iconCodePoint
    required this.createdAt,
    this.updatedAt,
  });

  // Helper: return const icon based on known types to enable icon tree-shaking
  IconData getIcon() {
    switch (type) {
      case 'meal':
        return Icons.restaurant;
      case 'medicine':
        return Icons.medication;
      default:
        return Icons.alarm;
    }
  }

  // Convert to Map for database storage
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'subtitle': subtitle,
      'time_hour': time.hour,
      'time_minute': time.minute,
      'description': description,
      'is_active': isActive ? 1 : 0,
      'days': days,
      'icon_codepoint':
          iconCodePoint, // Use iconCodePoint instead of icon.codePoint
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt?.millisecondsSinceEpoch,
    };
  }

  // Create from Map (from database)
  factory AlarmModel.fromMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'],
      type: map['type'],
      title: map['title'],
      subtitle: map['subtitle'],
      time: TimeOfDay(hour: map['time_hour'], minute: map['time_minute']),
      description: map['description'],
      isActive: map['is_active'] == 1,
      days: map['days'],
      iconCodePoint:
          map['icon_codepoint'], // Use iconCodePoint instead of creating IconData
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: map['updated_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['updated_at'])
          : null,
    );
  }

  // Create from the old Map format (for backward compatibility)
  factory AlarmModel.fromOldMap(Map<String, dynamic> map) {
    return AlarmModel(
      id: map['id'],
      type: map['type'],
      title: map['title'],
      subtitle: map['subtitle'],
      time: map['rawTime'] ?? TimeOfDay.now(),
      description: map['description'],
      isActive: map['isActive'],
      days: map['days'],
      iconCodePoint:
          map['icon']?.codePoint ??
          Icons.alarm.codePoint, // Convert icon to codePoint
      createdAt: DateTime.now(),
    );
  }

  // Copy with method for updates
  AlarmModel copyWith({
    int? id,
    String? type,
    String? title,
    String? subtitle,
    TimeOfDay? time,
    String? description,
    bool? isActive,
    String? days,
    IconData? icon,
    int? iconCodePoint,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AlarmModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      time: time ?? this.time,
      description: description ?? this.description,
      isActive: isActive ?? this.isActive,
      days: days ?? this.days,
      iconCodePoint: iconCodePoint ?? icon?.codePoint ?? this.iconCodePoint,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  // Get formatted time string
  String get timeString {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  // Get next alarm date time
  DateTime get nextAlarmDateTime {
    final now = DateTime.now();
    var alarmDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      time.hour,
      time.minute,
    );

    // If alarm time has passed today, schedule for tomorrow
    if (alarmDateTime.isBefore(now)) {
      alarmDateTime = alarmDateTime.add(const Duration(days: 1));
    }

    return alarmDateTime;
  }

  @override
  String toString() {
    return 'AlarmModel(id: $id, title: $title, time: $timeString, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AlarmModel &&
        other.id == id &&
        other.type == type &&
        other.title == title &&
        other.time == time &&
        other.isActive == isActive;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        type.hashCode ^
        title.hashCode ^
        time.hashCode ^
        isActive.hashCode;
  }
}
