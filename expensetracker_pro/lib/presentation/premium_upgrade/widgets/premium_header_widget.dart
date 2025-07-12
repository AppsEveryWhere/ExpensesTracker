import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class PremiumHeaderWidget extends StatelessWidget {
  const PremiumHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.accentColor.withValues(alpha: 0.1),
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.accentColor.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          // Premium badge icon
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.accentColor,
                  Theme.of(context).colorScheme.primary,
                ],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.accentColor.withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CustomIconWidget(
              iconName: 'workspace_premium',
              color: Colors.white,
              size: 10.w,
            ),
          ),
          SizedBox(height: 3.h),

          // Title
          Text(
            'Unlock Premium Features',
            style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 1.h),

          // Subtitle
          Text(
            'Get AI-powered insights, unlimited groups, and advanced analytics to take control of your finances',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 3.h),

          // Feature highlights
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildHighlightItem(
                context,
                'psychology',
                'AI Insights',
              ),
              _buildHighlightItem(
                context,
                'analytics',
                'Analytics',
              ),
              _buildHighlightItem(
                context,
                'group',
                'Groups',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightItem(
    BuildContext context,
    String iconName,
    String label,
  ) {
    return Column(
      children: [
        Container(
          width: 12.w,
          height: 12.w,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: CustomIconWidget(
            iconName: iconName,
            color: Theme.of(context).colorScheme.primary,
            size: 6.w,
          ),
        ),
        SizedBox(height: 1.h),
        Text(
          label,
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
