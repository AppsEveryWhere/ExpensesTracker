import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

class ThemeToggleWidget extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onToggle;

  const ThemeToggleWidget({
    Key? key,
    required this.isDarkMode,
    required this.onToggle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      padding: EdgeInsets.symmetric(vertical: 2.h),
      child: Row(
        children: [
          // Icon Container
          Container(
            width: 10.w,
            height: 10.w,
            decoration: BoxDecoration(
              color:
                  Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: CustomIconWidget(
                iconName: isDarkMode ? 'dark_mode' : 'light_mode',
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
            ),
          ),

          SizedBox(width: 4.w),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Dark Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),

          // Theme Toggle Switch
          Switch(
            value: isDarkMode,
            onChanged: onToggle,
            activeColor: Theme.of(context).colorScheme.primary,
            activeTrackColor:
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }
}
