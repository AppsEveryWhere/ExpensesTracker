import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class BudgetChartWidget extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  final String chartType;

  const BudgetChartWidget({
    Key? key,
    required this.categories,
    required this.chartType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(4.w),
      child: chartType == 'pie'
          ? _buildPieChart(context)
          : _buildBarChart(context),
    );
  }

  Widget _buildPieChart(BuildContext context) {
    final List<PieChartSectionData> sections =
        (categories as List).asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value as Map<String, dynamic>;
      final budgetAmount = category["budgetAmount"] as double;
      final categoryColor = Color(category["color"] as int);

      return PieChartSectionData(
        color: categoryColor,
        value: budgetAmount,
        title:
            '${((budgetAmount / _getTotalBudget()) * 100).toStringAsFixed(0)}%',
        radius: 15.w,
        titleStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: PieChart(
            PieChartData(
              sections: sections,
              centerSpaceRadius: 8.w,
              sectionsSpace: 2,
              startDegreeOffset: -90,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        _buildLegend(context),
      ],
    );
  }

  Widget _buildBarChart(BuildContext context) {
    final List<BarChartGroupData> barGroups =
        (categories as List).asMap().entries.map((entry) {
      final index = entry.key;
      final category = entry.value as Map<String, dynamic>;
      final budgetAmount = category["budgetAmount"] as double;
      final spentAmount = category["spentAmount"] as double;
      final categoryColor = Color(category["color"] as int);

      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: budgetAmount,
            color: categoryColor.withValues(alpha: 0.3),
            width: 4.w,
            borderRadius: BorderRadius.circular(2),
          ),
          BarChartRodData(
            toY: spentAmount,
            color: categoryColor,
            width: 4.w,
            borderRadius: BorderRadius.circular(2),
          ),
        ],
      );
    }).toList();

    return Column(
      children: [
        Expanded(
          child: BarChart(
            BarChartData(
              barGroups: barGroups,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 10.w,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '\$${value.toInt()}',
                        style: Theme.of(context).textTheme.bodySmall,
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      if (value.toInt() < categories.length) {
                        final category =
                            categories[value.toInt()];
                        return Padding(
                          padding: EdgeInsets.only(top: 1.h),
                          child: CustomIconWidget(
                            iconName: category["icon"] as String,
                            color: Color(category["color"] as int),
                            size: 20,
                          ),
                        );
                      }
                      return SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: false),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                horizontalInterval: _getMaxBudget() / 5,
                getDrawingHorizontalLine: (value) {
                  return FlLine(
                    color: Theme.of(context).dividerColor,
                    strokeWidth: 1,
                  );
                },
              ),
              maxY: _getMaxBudget() * 1.1,
            ),
          ),
        ),
        SizedBox(height: 2.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLegendItem(
              context,
              'Budget',
              Theme.of(context).colorScheme.outline,
            ),
            SizedBox(width: 4.w),
            _buildLegendItem(
              context,
              'Spent',
              Theme.of(context).colorScheme.primary,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      spacing: 3.w,
      runSpacing: 1.h,
      children: (categories as List).map((category) {
        final categoryMap = category as Map<String, dynamic>;
        return _buildLegendItem(
          context,
          categoryMap["name"] as String,
          Color(categoryMap["color"] as int),
        );
      }).toList(),
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 3.w,
          height: 3.w,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 2.w),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  double _getTotalBudget() {
    return (categories as List).fold(
      0.0,
      (sum, category) =>
          sum + ((category as Map<String, dynamic>)["budgetAmount"] as double),
    );
  }

  double _getMaxBudget() {
    return (categories as List).fold(
      0.0,
      (max, category) {
        final budgetAmount =
            (category as Map<String, dynamic>)["budgetAmount"] as double;
        return budgetAmount > max ? budgetAmount : max;
      },
    );
  }
}
