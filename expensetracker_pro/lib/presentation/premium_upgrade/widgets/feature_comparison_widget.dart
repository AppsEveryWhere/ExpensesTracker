import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class FeatureComparisonWidget extends StatelessWidget {
  final List<Map<String, dynamic>> features;

  const FeatureComparisonWidget({
    super.key,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Premium Features',
          style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: features.length,
          separatorBuilder: (context, index) => SizedBox(height: 2.h),
          itemBuilder: (context, index) {
            final feature = features[index];
            return _buildFeatureCard(context, feature);
          },
        ),
      ],
    );
  }

  Widget _buildFeatureCard(BuildContext context, Map<String, dynamic> feature) {
    final String iconName = feature['icon'] as String;
    final String title = feature['title'] as String;
    final String description = feature['description'] as String;
    final bool isPremium = feature['isPremium'] as bool? ?? false;

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isPremium
              ? AppTheme.accentColor.withValues(alpha: 0.3)
              : Theme.of(context).colorScheme.outline.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Feature icon
          Container(
            width: 12.w,
            height: 12.w,
            decoration: BoxDecoration(
              color: isPremium
                  ? AppTheme.accentColor.withValues(alpha: 0.1)
                  : Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: CustomIconWidget(
              iconName: iconName,
              color: isPremium
                  ? AppTheme.accentColor
                  : Theme.of(context).colorScheme.primary,
              size: 6.w,
            ),
          ),
          SizedBox(width: 4.w),

          // Feature content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style:
                            AppTheme.lightTheme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                    ),
                    if (isPremium)
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.accentColor,
                              AppTheme.accentColor.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'PREMIUM',
                          style: AppTheme.lightTheme.textTheme.labelSmall
                              ?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 1.h),
                Text(
                  description,
                  style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
