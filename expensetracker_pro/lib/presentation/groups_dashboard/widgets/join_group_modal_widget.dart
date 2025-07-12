import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class JoinGroupModalWidget extends StatefulWidget {
  final Function(String groupId) onJoinGroup;

  const JoinGroupModalWidget({
    Key? key,
    required this.onJoinGroup,
  }) : super(key: key);

  @override
  State<JoinGroupModalWidget> createState() => _JoinGroupModalWidgetState();
}

class _JoinGroupModalWidgetState extends State<JoinGroupModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _groupIdController = TextEditingController();
  bool _isJoining = false;
  bool _isValidating = false;
  String? _validationMessage;

  @override
  void dispose() {
    _groupIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 6.w),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4.h),
                    _buildIllustration(),
                    SizedBox(height: 4.h),
                    _buildTitle(),
                    SizedBox(height: 2.h),
                    _buildDescription(),
                    SizedBox(height: 4.h),
                    _buildGroupIdField(),
                    if (_validationMessage != null) ...[
                      SizedBox(height: 2.h),
                      _buildValidationMessage(),
                    ],
                    SizedBox(height: 6.h),
                    _buildJoinButton(),
                    SizedBox(height: 4.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 16.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ),
          Expanded(
            child: Text(
              'Join Group',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimaryLight,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 20.w), // Balance the cancel button
        ],
      ),
    );
  }

  Widget _buildIllustration() {
    return Center(
      child: Container(
        width: 30.w,
        height: 15.h,
        decoration: BoxDecoration(
          color: AppTheme.primaryLight.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'group_add',
              color: AppTheme.primaryLight,
              size: 32,
            ),
            SizedBox(height: 1.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildMiniDot(AppTheme.primaryLight),
                SizedBox(width: 1.w),
                _buildMiniDot(AppTheme.secondaryLight),
                SizedBox(width: 1.w),
                _buildMiniDot(AppTheme.accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniDot(Color color) {
    return Container(
      width: 2.w,
      height: 2.w,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      'Join an Existing Group',
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.w600,
        color: AppTheme.textPrimaryLight,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      'Enter the group ID shared by the group admin to join and start collaborating on expenses.',
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: AppTheme.textSecondaryLight,
        height: 1.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildGroupIdField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group ID',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _groupIdController,
          decoration: InputDecoration(
            hintText: 'Enter group ID (e.g., GRP123456)',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'tag',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
            suffixIcon: _isValidating
                ? Padding(
                    padding: EdgeInsets.all(3.w),
                    child: SizedBox(
                      width: 5.w,
                      height: 5.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.primaryLight,
                      ),
                    ),
                  )
                : null,
          ),
          onChanged: _onGroupIdChanged,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a group ID';
            }
            if (value.trim().length < 6) {
              return 'Group ID must be at least 6 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildValidationMessage() {
    final isError = _validationMessage!.contains('Invalid') ||
        _validationMessage!.contains('not found');

    return Container(
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        color: isError
            ? AppTheme.errorColor.withValues(alpha: 0.1)
            : AppTheme.successColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isError
              ? AppTheme.errorColor.withValues(alpha: 0.3)
              : AppTheme.successColor.withValues(alpha: 0.3),
          style: BorderStyle.solid,
        ),
      ),
      child: Row(
        children: [
          CustomIconWidget(
            iconName: isError ? 'error' : 'check_circle',
            color: isError ? AppTheme.errorColor : AppTheme.successColor,
            size: 20,
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              _validationMessage!,
              style: TextStyle(
                fontSize: 14.sp,
                color: isError ? AppTheme.errorColor : AppTheme.successColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildJoinButton() {
    final canJoin = _groupIdController.text.trim().length >= 6 &&
        !_isValidating &&
        (_validationMessage == null ||
            !_validationMessage!.contains('Invalid'));

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: (_isJoining || !canJoin) ? null : _joinGroup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryLight,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isJoining
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Join Group',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  void _onGroupIdChanged(String value) {
    if (value.trim().length >= 6) {
      _validateGroupId(value.trim());
    } else {
      setState(() {
        _validationMessage = null;
      });
    }
  }

  void _validateGroupId(String groupId) async {
    setState(() {
      _isValidating = true;
      _validationMessage = null;
    });

    // Simulate API call delay
    await Future.delayed(Duration(seconds: 1));

    // Mock validation logic
    if (groupId.toLowerCase().startsWith('grp') && groupId.length >= 8) {
      setState(() {
        _isValidating = false;
        _validationMessage = 'Group found! Ready to join.';
      });
    } else if (groupId.length >= 6) {
      setState(() {
        _isValidating = false;
        _validationMessage = 'Group found! Ready to join.';
      });
    } else {
      setState(() {
        _isValidating = false;
        _validationMessage = 'Invalid group ID. Please check and try again.';
      });
    }
  }

  void _joinGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isJoining = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    final groupId = _groupIdController.text.trim();
    widget.onJoinGroup(groupId);

    Navigator.pop(context);
  }
}
