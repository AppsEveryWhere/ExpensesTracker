import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class RecentTransactionsWidget extends StatelessWidget {
  final List<Map<String, dynamic>> transactions;
  final Function(int) onTransactionEdit;
  final Function(int) onTransactionDelete;
  final VoidCallback onViewAll;

  const RecentTransactionsWidget({
    super.key,
    required this.transactions,
    required this.onTransactionEdit,
    required this.onTransactionDelete,
    required this.onViewAll,
  });

  Color _parseColor(String colorString) {
    try {
      return Color(int.parse(colorString.replaceFirst('#', '0xFF')));
    } catch (e) {
      return AppTheme.lightTheme.colorScheme.primary;
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final transactionDate = DateTime(date.year, date.month, date.day);

      if (transactionDate == today) {
        return 'Today';
      } else if (transactionDate == yesterday) {
        return 'Yesterday';
      } else {
        return '${date.month}/${date.day}';
      }
    } catch (e) {
      return dateString;
    }
  }

  Widget _buildTransactionItem(
    BuildContext context,
    Map<String, dynamic> transaction,
  ) {
    final id = transaction["id"] as int? ?? 0;
    final title = transaction["title"] as String? ?? "Unknown";
    final category = transaction["category"] as String? ?? "Other";
    final amount = transaction["amount"] as double? ?? 0.0;
    final date = transaction["date"] as String? ?? "";
    final iconName = transaction["icon"] as String? ?? "receipt";
    final colorString = transaction["color"] as String? ?? "#4A90E2";

    final iconColor = _parseColor(colorString);
    final formattedDate = _formatDate(date);

    return Dismissible(
      key: Key('transaction_$id'),
      background: Container(
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.successColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'edit',
              size: 5.w,
              color: AppTheme.successColor,
            ),
            SizedBox(width: 2.w),
            Text(
              'Edit',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
      secondaryBackground: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 4.w),
        decoration: BoxDecoration(
          color: AppTheme.errorColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Delete',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.errorColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            SizedBox(width: 2.w),
            CustomIconWidget(
              iconName: 'delete',
              size: 5.w,
              color: AppTheme.errorColor,
            ),
          ],
        ),
      ),
      onDismissed: (direction) {
        if (direction == DismissDirection.startToEnd) {
          onTransactionEdit(id);
        } else {
          onTransactionDelete(id);
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 1.h),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Category Icon
            Container(
              width: 10.w,
              height: 10.w,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: iconName,
                  size: 5.w,
                  color: iconColor,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            // Transaction Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Row(
                    children: [
                      Text(
                        category,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        ' • ',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                      Text(
                        formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              '-\$${amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.errorColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Transactions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              TextButton(
                onPressed: onViewAll,
                child: Text(
                  'View All',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          transactions.isEmpty
              ? Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.1),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      CustomIconWidget(
                        iconName: 'receipt_long',
                        size: 8.w,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        'No transactions yet',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: transactions
                      .map((transaction) =>
                          _buildTransactionItem(context, transaction))
                      .toList(),
                ),
        ],
      ),
    );
  }
}
