import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class QuestionCard extends StatelessWidget {
  final String question;
  final List<String> options;
  final int? selectedOption;
  final Function(int) onOptionSelected;

  const QuestionCard({
    super.key,
    required this.question,
    required this.options,
    this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24.0),
          ...options.asMap().entries.map((entry) {
            int index = entry.key;
            String option = entry.value;
            bool isSelected = selectedOption == index;
            
            return Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: InkWell(
                onTap: () => onOptionSelected(index),
                borderRadius: BorderRadius.circular(12.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isSelected 
                        ? AppColors.primary.withOpacity(0.1)
                        : AppColors.greyLight,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(
                      color: isSelected 
                          ? AppColors.primary
                          : AppColors.border,
                      width: isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 20.0,
                        height: 20.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isSelected 
                              ? AppColors.primary
                              : Colors.transparent,
                          border: Border.all(
                            color: isSelected 
                                ? AppColors.primary
                                : AppColors.grey,
                            width: 2.0,
                          ),
                        ),
                        child: isSelected
                            ? const Icon(
                                Icons.check,
                                size: 12.0,
                                color: Colors.white,
                              )
                            : null,
                      ),
                      const SizedBox(width: 12.0),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 14.0,
                            fontWeight: isSelected 
                                ? FontWeight.w600
                                : FontWeight.w400,
                            color: isSelected 
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
