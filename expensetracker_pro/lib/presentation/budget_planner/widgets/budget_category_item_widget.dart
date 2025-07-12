import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class BudgetCategoryItemWidget extends StatefulWidget {
  final Map<String, dynamic> category;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final Function(double) onBudgetUpdate;

  const BudgetCategoryItemWidget({
    Key? key,
    required this.category,
    required this.onTap,
    required this.onLongPress,
    required this.onBudgetUpdate,
  }) : super(key: key);

  @override
  State<BudgetCategoryItemWidget> createState() =>
      _BudgetCategoryItemWidgetState();
}

class _BudgetCategoryItemWidgetState extends State<BudgetCategoryItemWidget> {
  late TextEditingController _budgetController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _budgetController = TextEditingController(
      text: (widget.category["budgetAmount"] as double).toStringAsFixed(0),
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        final newAmount = double.tryParse(_budgetController.text) ?? 0.0;
        widget.onBudgetUpdate(newAmount);
      }
    });
  }

  Color _getProgressColor() {
    final budgetAmount = widget.category["budgetAmount"] as double;
    final spentAmount = widget.category["spentAmount"] as double;
    final percentage = budgetAmount > 0 ? spentAmount / budgetAmount : 0.0;

    if (percentage >= 1.0) return AppTheme.errorColor;
    if (percentage >= 0.8) return AppTheme.warningColor;
    return AppTheme.successColor;
  }

  @override
  Widget build(BuildContext context) {
    final budgetAmount = widget.category["budgetAmount"] as double;
    final spentAmount = widget.category["spentAmount"] as double;
    final categoryName = widget.category["name"] as String;
    final iconName = widget.category["icon"] as String;
    final categoryColor = Color(widget.category["color"] as int);
    final progressPercentage =
        budgetAmount > 0 ? (spentAmount / budgetAmount).clamp(0.0, 1.0) : 0.0;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: widget.onTap,
        onLongPress: widget.onLongPress,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 12.w,
                    height: 12.w,
                    decoration: BoxDecoration(
                      color: categoryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: CustomIconWidget(
                        iconName: iconName,
                        color: categoryColor,
                        size: 24,
                      ),
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          categoryName,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          '\$${spentAmount.toStringAsFixed(0)} spent',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _isEditing
                          ? SizedBox(
                              width: 20.w,
                              child: TextField(
                                controller: _budgetController,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.end,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  prefix: Text('\$'),
                                ),
                                onSubmitted: (_) => _toggleEdit(),
                              ),
                            )
                          : GestureDetector(
                              onTap: _toggleEdit,
                              child: Text(
                                '\$${budgetAmount.toStringAsFixed(0)}',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ),
                      SizedBox(height: 0.5.h),
                      Text(
                        'budget',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(width: 2.w),
                  _isEditing
                      ? IconButton(
                          onPressed: _toggleEdit,
                          icon: CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.successColor,
                            size: 20,
                          ),
                        )
                      : CustomIconWidget(
                          iconName: 'chevron_right',
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                          size: 20,
                        ),
                ],
              ),
              SizedBox(height: 2.h),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${(progressPercentage * 100).toStringAsFixed(0)}% used',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: _getProgressColor(),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                      Text(
                        '\$${(budgetAmount - spentAmount).toStringAsFixed(0)} left',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurfaceVariant,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: 1.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progressPercentage,
                      backgroundColor: Theme.of(context)
                          .colorScheme
                          .outline
                          .withValues(alpha: 0.2),
                      valueColor:
                          AlwaysStoppedAnimation<Color>(_getProgressColor()),
                      minHeight: 0.8.h,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
