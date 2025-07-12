import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class QuickStatsRowWidget extends StatelessWidget {
  final Map<String, dynamic> statsData;
  final Function(String) onStatTap;

  const QuickStatsRowWidget({
    super.key,
    required this.statsData,
    required this.onStatTap,
  });

  Widget _buildStatCard({
    required BuildContext context,
    required String title,
    required String value,
    required String iconName,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(3.w),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: iconColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: CustomIconWidget(
                        iconName: iconName,
                        size: 4.w,
                        color: iconColor,
                      ),
                    ),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      size: 3.w,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Text(
                  value,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final expensesCount = statsData["expensesCount"] as int? ?? 0;
    final remainingBudget = statsData["remainingBudget"] as double? ?? 0.0;
    final topCategory = statsData["topCategory"] as String? ?? "N/A";

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Stats',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          SizedBox(height: 1.5.h),
          Row(
            children: [
              _buildStatCard(
                context: context,
                title: 'Expenses',
                value: expensesCount.toString(),
                iconName: 'receipt_long',
                iconColor: Theme.of(context).colorScheme.primary,
                onTap: () => onStatTap('expenses'),
              ),
              SizedBox(width: 3.w),
              _buildStatCard(
                context: context,
                title: 'Remaining',
                value: remainingBudget >= 0
                    ? '\$${remainingBudget.toStringAsFixed(0)}'
                    : '-\$${(-remainingBudget).toStringAsFixed(0)}',
                iconName: 'account_balance_wallet',
                iconColor: remainingBudget >= 0
                    ? AppTheme.successColor
                    : AppTheme.errorColor,
                onTap: () => onStatTap('budget'),
              ),
              SizedBox(width: 3.w),
              _buildStatCard(
                context: context,
                title: 'Top Category',
                value: topCategory.length > 8
                    ? '${topCategory.substring(0, 8)}...'
                    : topCategory,
                iconName: 'pie_chart',
                iconColor: Theme.of(context).colorScheme.secondary,
                onTap: () => onStatTap('category'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
