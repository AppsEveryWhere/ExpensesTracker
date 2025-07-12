import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class MonthlySummaryCardWidget extends StatelessWidget {
  final Map<String, dynamic> summaryData;
  final VoidCallback onTap;

  const MonthlySummaryCardWidget({
    super.key,
    required this.summaryData,
    required this.onTap,
  });

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'success':
        return AppTheme.successColor;
      case 'warning':
        return AppTheme.warningColor;
      case 'error':
        return AppTheme.errorColor;
      default:
        return AppTheme.successColor;
    }
  }

  String _getStatusText(String status, double percentage) {
    if (percentage >= 1.0) {
      return 'Budget exceeded';
    } else if (percentage >= 0.8) {
      return 'Approaching limit';
    } else {
      return 'On track';
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalSpent = summaryData["totalSpent"] as double? ?? 0.0;
    final budget = summaryData["budget"] as double? ?? 0.0;
    final percentage = summaryData["percentage"] as double? ?? 0.0;
    final status = summaryData["status"] as String? ?? "success";

    final statusColor = _getStatusColor(status);
    final statusText = _getStatusText(status, percentage);
    final remainingBudget = budget - totalSpent;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(4.w),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context)
                      .colorScheme
                      .shadow
                      .withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Monthly Summary',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 2.w, vertical: 0.5.h),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        statusText,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                // Amount Display
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${totalSpent.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            height: 1.0,
                          ),
                    ),
                    SizedBox(width: 2.w),
                    Padding(
                      padding: EdgeInsets.only(bottom: 1.h),
                      child: Text(
                        'of \$${budget.toStringAsFixed(0)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withValues(alpha: 0.8),
                              fontWeight: FontWeight.w400,
                            ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Progress Bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${(percentage * 100).toStringAsFixed(0)}% used',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                        Text(
                          remainingBudget >= 0
                              ? '\$${remainingBudget.toStringAsFixed(0)} left'
                              : '\$${(-remainingBudget).toStringAsFixed(0)} over',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                    SizedBox(height: 1.h),
                    Container(
                      height: 1.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage.clamp(0.0, 1.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: statusColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                // Tap hint
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Tap for detailed breakdown',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                    SizedBox(width: 1.w),
                    CustomIconWidget(
                      iconName: 'arrow_forward_ios',
                      size: 3.w,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
