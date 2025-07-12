import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../../../widgets/custom_image_widget.dart';

class GroupCardWidget extends StatelessWidget {
  final Map<String, dynamic> groupData;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onSwipeLeft;

  const GroupCardWidget({
    Key? key,
    required this.groupData,
    required this.onTap,
    required this.onLongPress,
    required this.onSwipeLeft,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(groupData["id"]),
      direction: DismissDirection.endToStart,
      background: _buildSwipeBackground(),
      onDismissed: (direction) => onSwipeLeft(),
      confirmDismiss: (direction) async {
        onSwipeLeft();
        return false; // Don't actually dismiss
      },
      child: Card(
        elevation: Theme.of(context).cardTheme.elevation,
        shape: Theme.of(context).cardTheme.shape,
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 2.h),
                _buildMemberAvatars(),
                SizedBox(height: 2.h),
                _buildExpenseInfo(),
                if (groupData["recentActivity"] != null) ...[
                  SizedBox(height: 1.h),
                  _buildRecentActivity(),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwipeBackground() {
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(right: 6.w),
      decoration: BoxDecoration(
        color: AppTheme.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'more_horiz',
            color: Colors.white,
            size: 24,
          ),
          SizedBox(height: 0.5.h),
          Text(
            'Actions',
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      groupData["name"],
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                        color: AppTheme.textPrimaryLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (groupData["unreadCount"] > 0)
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.5.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.accentColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '${groupData["unreadCount"]}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 0.5.h),
              Row(
                children: [
                  CustomIconWidget(
                    iconName: 'people',
                    color: AppTheme.textSecondaryLight,
                    size: 16,
                  ),
                  SizedBox(width: 1.w),
                  Text(
                    '${groupData["memberCount"]} members',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppTheme.textSecondaryLight,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (groupData["isAdmin"]) ...[
                    SizedBox(width: 2.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 2.w,
                        vertical: 0.3.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryLight.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Admin',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTheme.primaryLight,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
        CustomIconWidget(
          iconName: 'chevron_right',
          color: AppTheme.textSecondaryLight,
          size: 20,
        ),
      ],
    );
  }

  Widget _buildMemberAvatars() {
    final members = (groupData["members"] as List).take(4).toList();

    return Builder(
      builder: (BuildContext context) {
        return Row(
          children: [
            SizedBox(
              height: 8.w,
              child: Stack(
                children: members.asMap().entries.map((entry) {
                  final index = entry.key;
                  final member = entry.value;

                  return Positioned(
                    left: index * 6.w,
                    child: Container(
                      width: 8.w,
                      height: 8.w,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Theme.of(context).cardColor,
                          width: 2,
                        ),
                      ),
                      child: ClipOval(
                        child: CustomImageWidget(
                          imageUrl: member["avatar"],
                          width: 8.w,
                          height: 8.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (groupData["memberCount"] > 4) ...[
              SizedBox(width: 2.w),
              Container(
                width: 8.w,
                height: 8.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppTheme.textSecondaryLight.withValues(alpha: 0.2),
                  border: Border.all(
                    color: Theme.of(context).cardColor,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    '+${groupData["memberCount"] - 4}',
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildExpenseInfo() {
    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: AppTheme.successColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Total Expenses',
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppTheme.textSecondaryLight,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  '\$${groupData["totalExpenses"].toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'This Month',
            style: TextStyle(
              fontSize: 12.sp,
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivity() {
    final lastUpdated = groupData["lastUpdated"] as DateTime;
    final timeAgo = _getTimeAgo(lastUpdated);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
      decoration: BoxDecoration(
        color: AppTheme.textSecondaryLight.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: 'access_time',
            color: AppTheme.textSecondaryLight,
            size: 14,
          ),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              groupData["recentActivity"],
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTheme.textSecondaryLight,
                fontWeight: FontWeight.w400,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            timeAgo,
            style: TextStyle(
              fontSize: 11.sp,
              color: AppTheme.textSecondaryLight,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }
}