import 'package:flutter/material.dart';
import '../themes/app_colors.dart';

class FoodCard extends StatelessWidget {
  final Map<String, dynamic> food;
  final bool isRecommended;

  const FoodCard({
    super.key,
    required this.food,
    required this.isRecommended,
  });

  @override
  Widget build(BuildContext context) {
    Color cardColor = isRecommended ? AppColors.healthGreen : AppColors.dangerRed;
    
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12.0),
        border: Border.all(color: cardColor.withOpacity(0.3)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          if (food['image'] != null)
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12.0),
                topRight: Radius.circular(12.0),
              ),
              child: Image.asset(
                food['image'],
                width: double.infinity,
                height: 180.0,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 180.0,
                    color: AppColors.greyLight,
                    child: Icon(
                      food['icon'],
                      size: 48.0,
                      color: AppColors.textTertiary,
                    ),
                  );
                },
              ),
            ),
          // Header with icon and name
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.1),
              borderRadius: food['image'] != null
                  ? BorderRadius.zero
                  : const BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: cardColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Icon(
                    food['icon'],
                    color: cardColor,
                    size: 20.0,
                  ),
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        food['name'],
                        style: TextStyle(
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 2.0),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Text(
                          food['category'],
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w600,
                            color: cardColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  isRecommended ? Icons.check_circle : Icons.block,
                  color: cardColor,
                  size: 20.0,
                ),
              ],
            ),
          ),
          
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  food['description'],
                  style: TextStyle(
                    fontSize: 14.0,
                    color: AppColors.textSecondary,
                    height: 1.4,
                  ),
                ),
                
                const SizedBox(height: 12.0),
                
                if (isRecommended) ...[
                  // Benefits for recommended foods
                  if (food['benefits'] != null) ...[
                    Text(
                      'Manfaat:',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    ...food['benefits'].map<Widget>((benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: cardColor, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              benefit,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                  
                  if (food['tips'] != null) ...[
                    const SizedBox(height: 8.0),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.lightbulb_outline, color: AppColors.info, size: 16.0),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Tips:',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.info,
                                  ),
                                ),
                                Text(
                                  food['tips'],
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppColors.info,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ] else ...[
                  // Reason and alternatives for foods to avoid
                  if (food['reason'] != null) ...[
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: AppColors.warningAmber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber, color: AppColors.warningAmber, size: 16.0),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Alasan:',
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warningAmber,
                                  ),
                                ),
                                Text(
                                  food['reason'],
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    color: AppColors.warningAmber,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  
                  if (food['alternatives'] != null) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      'Alternatif yang lebih baik:',
                      style: TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    ...food['alternatives'].map<Widget>((alternative) => Padding(
                      padding: const EdgeInsets.only(bottom: 2.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('• ', style: TextStyle(color: AppColors.healthGreen, fontWeight: FontWeight.bold)),
                          Expanded(
                            child: Text(
                              alternative,
                              style: TextStyle(
                                fontSize: 12.0,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ],
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
