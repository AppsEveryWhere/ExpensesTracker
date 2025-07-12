import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class TotalBudgetCardWidget extends StatelessWidget {
  final double totalBudget;
  final double totalSpent;
  final double remainingBudget;

  const TotalBudgetCardWidget({
    Key? key,
    required this.totalBudget,
    required this.totalSpent,
    required this.remainingBudget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double progressPercentage =
        totalBudget > 0 ? (totalSpent / totalBudget).clamp(0.0, 1.0) : 0.0;
    final bool isOverBudget = totalSpent > totalBudget;

    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.all(6.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Budget',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontWeight: FontWeight.w500,
                    ),
              ),
              CustomIconWidget(
                iconName: 'edit',
                color: Colors.white.withValues(alpha: 0.9),
                size: 20,
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Text(
            '\$${totalBudget.toStringAsFixed(0)}',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
          ),
          SizedBox(height: 3.h),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Spent',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      '\$${totalSpent.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      isOverBudget ? 'Over Budget' : 'Remaining',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      isOverBudget
                          ? '-\$${(totalSpent - totalBudget).toStringAsFixed(0)}'
                          : '\$${remainingBudget.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: isOverBudget
                                ? AppTheme.errorColor
                                : Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 3.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Progress',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                        ),
                  ),
                  Text(
                    '${(progressPercentage * 100).toStringAsFixed(0)}%',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              SizedBox(height: 1.h),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progressPercentage,
                  backgroundColor: Colors.white.withValues(alpha: 0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(
                    isOverBudget ? AppTheme.errorColor : AppTheme.successColor,
                  ),
                  minHeight: 1.h,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
