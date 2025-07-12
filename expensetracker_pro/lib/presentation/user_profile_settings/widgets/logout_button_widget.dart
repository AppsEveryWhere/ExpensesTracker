import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class LogoutButtonWidget extends StatelessWidget {
  final VoidCallback onLogout;

  const LogoutButtonWidget({
    Key? key,
    required this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 4.w),
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onLogout,
        icon: CustomIconWidget(
          iconName: 'logout',
          color: Colors.white,
          size: 20,
        ),
        label: Text(
          'Logout',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.errorColor,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
          shadowColor: AppTheme.errorColor.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
