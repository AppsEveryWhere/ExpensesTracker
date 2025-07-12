import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class EmptyGroupsWidget extends StatelessWidget {
  final VoidCallback onCreateGroup;
  final VoidCallback onJoinGroup;

  const EmptyGroupsWidget({
    Key? key,
    required this.onCreateGroup,
    required this.onJoinGroup,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 5.h),
            _buildIllustration(),
            SizedBox(height: 4.h),
            _buildTitle(),
            SizedBox(height: 2.h),
            _buildDescription(),
            SizedBox(height: 6.h),
            _buildActionButtons(),
            SizedBox(height: 5.h),
          ],
        ),
      ),
    );
  }

  Widget _buildIllustration() {
    return Container(
      width: 60.w,
      height: 30.h,
      decoration: BoxDecoration(
        color: AppTheme.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 20.w,
            height: 20.w,
            decoration: BoxDecoration(
              color: AppTheme.primaryLight.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'group_add',
              color: AppTheme.primaryLight,
              size: 40,
            ),
          ),
          SizedBox(height: 3.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildMiniAvatar(AppTheme.primaryLight),
              SizedBox(width: 2.w),
              _buildMiniAvatar(AppTheme.secondaryLight),
              SizedBox(width: 2.w),
              _buildMiniAvatar(AppTheme.accentColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniAvatar(Color color) {
    return Container(
      width: 8.w,
      height: 8.w,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
      child: CustomIconWidget(
        iconName: 'person',
        color: color,
        size: 16,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'No Groups Yet',
      style: TextStyle(
        fontSize: 24.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryLight,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      'Start collaborating on expenses by creating your first group or joining an existing one.',
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondaryLight,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onCreateGroup,
            icon: CustomIconWidget(
              iconName: 'add',
              color: Colors.white,
              size: 20,
            ),
            label: Text(
              'Create Your First Group',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryLight,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        SizedBox(height: 3.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onJoinGroup,
            icon: CustomIconWidget(
              iconName: 'group_add',
              color: AppTheme.primaryLight,
              size: 20,
            ),
            label: Text(
              'Join Existing Group',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppTheme.primaryLight,
              padding: EdgeInsets.symmetric(vertical: 2.h),
              side: BorderSide(color: AppTheme.primaryLight, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
