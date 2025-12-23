import 'package:flutter/material.dart';
import '../themes/app_colors.dart';
import '../core/models/alarm_model.dart';
import 'alarm_countdown_widget.dart';

class AlarmCard extends StatelessWidget {
  final AlarmModel alarm;
  final Function(bool) onToggle;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const AlarmCard({
    super.key,
    required this.alarm,
    required this.onToggle,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    Color typeColor = alarm.type == 'meal' 
        ? AppColors.healthGreen 
        : AppColors.primary;
    
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(
          color: alarm.isActive 
              ? typeColor.withOpacity(0.3)
              : AppColors.border,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  color: typeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  alarm.getIcon(),
                  color: typeColor,
                  size: 20.0,
                ),
              ),
              
              const SizedBox(width: 12.0),
              
              // Alarm Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          alarm.title,
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                          decoration: BoxDecoration(
                            color: typeColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Text(
                            alarm.subtitle,
                            style: TextStyle(
                              fontSize: 10.0,
                              fontWeight: FontWeight.w600,
                              color: typeColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Row(
                      children: [
                        Text(
                          alarm.timeString,
                          style: TextStyle(
                            fontSize: 24.0,
                            fontWeight: FontWeight.bold,
                            color: alarm.isActive 
                                ? typeColor 
                                : AppColors.textTertiary,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        Text(
                          alarm.days,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4.0),
                    Text(
                      alarm.description,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    // Debug countdown widget
                    AlarmCountdownWidget(alarm: alarm),
                  ],
                ),
              ),
              
              // Toggle Switch
              Switch(
                value: alarm.isActive,
                onChanged: onToggle,
                activeColor: typeColor,
                inactiveThumbColor: AppColors.grey,
                inactiveTrackColor: AppColors.greyLight,
              ),
            ],
          ),
          
          const SizedBox(height: 12.0),
          
          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onEdit,
                  icon: Icon(Icons.edit, size: 16.0, color: AppColors.primary),
                  label: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.primary,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete, size: 16.0, color: AppColors.dangerRed),
                  label: Text(
                    'Hapus',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: AppColors.dangerRed,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppColors.dangerRed),
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
