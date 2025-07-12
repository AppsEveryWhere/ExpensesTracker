import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class CreateGroupModalWidget extends StatefulWidget {
  final Function(String groupName, List<String> memberEmails) onCreateGroup;

  const CreateGroupModalWidget({
    Key? key,
    required this.onCreateGroup,
  }) : super(key: key);

  @override
  State<CreateGroupModalWidget> createState() => _CreateGroupModalWidgetState();
}

class _CreateGroupModalWidgetState extends State<CreateGroupModalWidget> {
  final _formKey = GlobalKey<FormState>();
  final _groupNameController = TextEditingController();
  final _emailController = TextEditingController();
  final List<String> _memberEmails = [];
  bool _isCreating = false;

  @override
  void dispose() {
    _groupNameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 85.h,
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
                    SizedBox(height: 3.h),
                    _buildGroupNameField(),
                    SizedBox(height: 4.h),
                    _buildMemberSection(),
                    SizedBox(height: 4.h),
                    _buildMembersList(),
                    SizedBox(height: 6.h),
                    _buildCreateButton(),
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
              'Create Group',
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

  Widget _buildGroupNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Group Name',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 1.h),
        TextFormField(
          controller: _groupNameController,
          decoration: InputDecoration(
            hintText: 'Enter group name',
            prefixIcon: Padding(
              padding: EdgeInsets.all(3.w),
              child: CustomIconWidget(
                iconName: 'group',
                color: AppTheme.textSecondaryLight,
                size: 20,
              ),
            ),
          ),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter a group name';
            }
            if (value.trim().length < 3) {
              return 'Group name must be at least 3 characters';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildMemberSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Add Members',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.textPrimaryLight,
                ),
              ),
            ),
            Text(
              'Optional',
              style: TextStyle(
                fontSize: 14.sp,
                color: AppTheme.textSecondaryLight,
              ),
            ),
          ],
        ),
        SizedBox(height: 1.h),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter email address',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(3.w),
                    child: CustomIconWidget(
                      iconName: 'email',
                      color: AppTheme.textSecondaryLight,
                      size: 20,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 3.w),
            ElevatedButton(
              onPressed: _addMember,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryLight,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: CustomIconWidget(
                iconName: 'add',
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMembersList() {
    if (_memberEmails.isEmpty) {
      return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppTheme.textSecondaryLight.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.textSecondaryLight.withValues(alpha: 0.2),
            style: BorderStyle.solid,
          ),
        ),
        child: Row(
          children: [
            CustomIconWidget(
              iconName: 'info',
              color: AppTheme.textSecondaryLight,
              size: 20,
            ),
            SizedBox(width: 3.w),
            Expanded(
              child: Text(
                'You can add members later by sharing the group invite link',
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppTheme.textSecondaryLight,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Members (${_memberEmails.length})',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: AppTheme.textPrimaryLight,
          ),
        ),
        SizedBox(height: 2.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _memberEmails.length,
          separatorBuilder: (context, index) => SizedBox(height: 1.h),
          itemBuilder: (context, index) {
            final email = _memberEmails[index];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              decoration: BoxDecoration(
                color: AppTheme.primaryLight.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppTheme.primaryLight.withValues(alpha: 0.2),
                  style: BorderStyle.solid,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryLight.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: CustomIconWidget(
                      iconName: 'person',
                      color: AppTheme.primaryLight,
                      size: 16,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Text(
                      email,
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: AppTheme.textPrimaryLight,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => _removeMember(index),
                    icon: CustomIconWidget(
                      iconName: 'close',
                      color: AppTheme.errorColor,
                      size: 18,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildCreateButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isCreating ? null : _createGroup,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppTheme.primaryLight,
          foregroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 2.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: _isCreating
            ? SizedBox(
                width: 5.w,
                height: 5.w,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : Text(
                'Create Group',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  void _addMember() {
    final email = _emailController.text.trim();
    if (email.isEmpty) return;

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_memberEmails.contains(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('This email is already added'),
          backgroundColor: AppTheme.warningColor,
        ),
      );
      return;
    }

    setState(() {
      _memberEmails.add(email);
      _emailController.clear();
    });
  }

  void _removeMember(int index) {
    setState(() {
      _memberEmails.removeAt(index);
    });
  }

  void _createGroup() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isCreating = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    final groupName = _groupNameController.text.trim();
    widget.onCreateGroup(groupName, _memberEmails);

    Navigator.pop(context);
  }
}
