import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PricingSectionWidget extends StatelessWidget {
  final List<Map<String, dynamic>> plans;
  final String selectedPlan;
  final Function(String) onPlanSelected;

  const PricingSectionWidget({
    super.key,
    required this.plans,
    required this.selectedPlan,
    required this.onPlanSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Your Plan',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: plans.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final plan = plans[index];
            return _buildPricingCard(context, plan);
          },
        ),
      ],
    );
  }

  Widget _buildPricingCard(BuildContext context, Map<String, dynamic> plan) {
    final String planId = plan['id'] as String;
    final String name = plan['name'] as String;
    final String price = plan['price'] as String;
    final String period = plan['period'] as String;
    final String? savings = plan['savings'] as String?;
    final String description = plan['description'] as String;
    final bool isSelected = selectedPlan == planId;
    final bool isPopular = planId == 'yearly';

    return GestureDetector(
      onTap: () => onPlanSelected(planId),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppTheme.accentColor
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.accentColor.withValues(alpha: 0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color:
                        Theme.of(context).shadowColor.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with popular badge
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            name,
                            style: AppTheme.lightTheme.textTheme.titleMedium
                                ?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                          ),
                          if (isPopular) ...[
                            SizedBox(width: 2.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 2.w,
                                vertical: 0.5.h,
                              ),
                              decoration: BoxDecoration(
                                color: AppTheme.successColor,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'POPULAR',
                                style: AppTheme.lightTheme.textTheme.labelSmall
                                    ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 9.sp,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (savings != null) ...[
                        SizedBox(height: 0.5.h),
                        Text(
                          savings,
                          style:
                              AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                            color: AppTheme.successColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),

                // Selection indicator
                Container(
                  width: 6.w,
                  height: 6.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected
                          ? AppTheme.accentColor
                          : Theme.of(context).colorScheme.outline,
                      width: 2,
                    ),
                    color:
                        isSelected ? AppTheme.accentColor : Colors.transparent,
                  ),
                  child: isSelected
                      ? CustomIconWidget(
                          iconName: 'check',
                          color: Colors.white,
                          size: 3.w,
                        )
                      : null,
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Price display
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: AppTheme.lightTheme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(width: 2.w),
                Text(
                  period,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),

            // Description
            Text(
              description,
              style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
