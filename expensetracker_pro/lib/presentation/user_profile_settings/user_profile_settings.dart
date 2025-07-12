import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/logout_button_widget.dart';
import './widgets/profile_header_widget.dart';
import './widgets/setting_item_widget.dart';
import './widgets/settings_section_widget.dart';
import './widgets/theme_toggle_widget.dart';

class UserProfileSettings extends StatefulWidget {
  const UserProfileSettings({Key? key}) : super(key: key);

  @override
  State<UserProfileSettings> createState() => _UserProfileSettingsState();
}

class _UserProfileSettingsState extends State<UserProfileSettings> {
  bool _notificationsEnabled = true;
  bool _isDarkMode = false;
  String _selectedCurrency = 'USD';
  String _lastSyncTime = '2025-07-12 21:10:00';
  bool _isPremiumUser = false;

  // Mock user data
  final Map<String, dynamic> _userData = {
    "id": 1,
    "name": "Sarah Johnson",
    "email": "sarah.johnson@email.com",
    "avatar":
        "https://images.unsplash.com/photo-1494790108755-2616b612b786?fm=jpg&q=60&w=400&h=400&fit=crop",
    "joinDate": "2024-01-15",
    "isPremium": false,
    "preferences": {
      "currency": "USD",
      "notifications": true,
      "darkMode": false,
      "biometricAuth": true
    }
  };

  final List<String> _currencies = [
    'USD',
    'EUR',
    'GBP',
    'JPY',
    'CAD',
    'AUD',
    'CHF',
    'CNY',
    'INR',
    'BRL'
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  void _loadUserPreferences() {
    final preferences = _userData["preferences"] as Map<String, dynamic>;
    setState(() {
      _notificationsEnabled = preferences["notifications"] as bool;
      _isDarkMode = preferences["darkMode"] as bool;
      _selectedCurrency = preferences["currency"] as String;
      _isPremiumUser = _userData["isPremium"] as bool;
    });
  }

  void _showCurrencyPicker() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        height: 50.h,
        padding: EdgeInsets.all(4.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 12.w,
                height: 0.5.h,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Select Currency',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 2.h),
            Expanded(
              child: ListView.builder(
                itemCount: _currencies.length,
                itemBuilder: (context, index) {
                  final currency = _currencies[index];
                  final isSelected = currency == _selectedCurrency;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? AppTheme.lightTheme.primaryColor
                          : Colors.grey[200],
                      child: Text(
                        currency,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    title: Text(currency),
                    trailing: isSelected
                        ? CustomIconWidget(
                            iconName: 'check',
                            color: AppTheme.lightTheme.primaryColor,
                            size: 20,
                          )
                        : null,
                    onTap: () {
                      setState(() {
                        _selectedCurrency = currency;
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text(
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Account deletion requires email verification'),
                  backgroundColor: AppTheme.warningColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // Navigate to login screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged out successfully')),
              );
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Generating PDF report...'),
        duration: Duration(seconds: 2),
      ),
    );

    // Simulate export process
    Future.delayed(Duration(seconds: 2), () {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Report exported successfully'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    });
  }

  void _syncData() {
    setState(() {
      _lastSyncTime = DateTime.now().toString().substring(0, 19);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Data synced successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Profile & Settings'),
        centerTitle: true,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: Theme.of(context).appBarTheme.foregroundColor!,
            size: 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            ProfileHeaderWidget(
              userData: _userData,
              onEditProfile: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Edit profile feature coming soon')),
                );
              },
              onAvatarTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Photo selection feature coming soon')),
                );
              },
            ),

            SizedBox(height: 3.h),

            // Account Section
            SettingsSectionWidget(
              title: 'Account',
              children: [
                SettingItemWidget(
                  iconName: 'person',
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Edit profile feature coming soon')),
                    );
                  },
                ),
                SettingItemWidget(
                  iconName: 'lock',
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Change password feature coming soon')),
                    );
                  },
                ),
                SettingItemWidget(
                  iconName: 'delete_forever',
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  titleColor: AppTheme.errorColor,
                  onTap: _showDeleteAccountDialog,
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Preferences Section
            SettingsSectionWidget(
              title: 'Preferences',
              children: [
                SettingItemWidget(
                  iconName: 'attach_money',
                  title: 'Currency',
                  subtitle: _selectedCurrency,
                  onTap: _showCurrencyPicker,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CustomIconWidget(
                        iconName: 'notifications',
                        color: Theme.of(context).colorScheme.primary,
                        size: 24,
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Notifications',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Expense alerts and reminders',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      Switch(
                        value: _notificationsEnabled,
                        onChanged: (value) {
                          setState(() {
                            _notificationsEnabled = value;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                ThemeToggleWidget(
                  isDarkMode: _isDarkMode,
                  onToggle: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Data Section
            SettingsSectionWidget(
              title: 'Data',
              children: [
                SettingItemWidget(
                  iconName: 'file_download',
                  title: 'Export Data',
                  subtitle: 'Download your expense reports',
                  onTap: _exportData,
                ),
                SettingItemWidget(
                  iconName: 'sync',
                  title: 'Sync Status',
                  subtitle: 'Last sync: ${_lastSyncTime.substring(0, 16)}',
                  trailing: IconButton(
                    icon: CustomIconWidget(
                      iconName: 'refresh',
                      color: Theme.of(context).colorScheme.primary,
                      size: 20,
                    ),
                    onPressed: _syncData,
                  ),
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Premium Section
            SettingsSectionWidget(
              title: 'Premium',
              children: [
                SettingItemWidget(
                  iconName: 'star',
                  title: _isPremiumUser
                      ? 'Manage Subscription'
                      : 'Upgrade to Premium',
                  subtitle: _isPremiumUser
                      ? 'Active subscription'
                      : 'Unlock AI insights and advanced features',
                  trailing: _isPremiumUser
                      ? Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 2.w, vertical: 0.5.h),
                          decoration: BoxDecoration(
                            color: AppTheme.successColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'ACTIVE',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        )
                      : null,
                  onTap: () {
                    Navigator.pushNamed(context, '/premium-upgrade');
                  },
                ),
                SettingItemWidget(
                  iconName: 'restore',
                  title: 'Restore Purchases',
                  subtitle: 'Restore previous premium purchases',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Checking for previous purchases...')),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 2.h),

            // Support Section
            SettingsSectionWidget(
              title: 'Support',
              children: [
                SettingItemWidget(
                  iconName: 'help',
                  title: 'Help Center',
                  subtitle: 'FAQs and user guides',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Help center feature coming soon')),
                    );
                  },
                ),
                SettingItemWidget(
                  iconName: 'email',
                  title: 'Contact Us',
                  subtitle: 'Get support from our team',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Contact support feature coming soon')),
                    );
                  },
                ),
                SettingItemWidget(
                  iconName: 'star_rate',
                  title: 'Rate App',
                  subtitle: 'Share your feedback',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Rate app feature coming soon')),
                    );
                  },
                ),
              ],
            ),

            SizedBox(height: 3.h),

            // Logout Button
            LogoutButtonWidget(
              onLogout: _showLogoutDialog,
            ),

            SizedBox(height: 2.h),

            // Footer Information
            Container(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Column(
                children: [
                  Text(
                    'ExpenseTracker Pro v1.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content:
                                    Text('Privacy policy feature coming soon')),
                          );
                        },
                        child: Text(
                          'Privacy Policy',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ),
                      Text('•', style: Theme.of(context).textTheme.bodySmall),
                      TextButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: Text(
                                    'Terms of service feature coming soon')),
                          );
                        },
                        child: Text(
                          'Terms of Service',
                          style: TextStyle(fontSize: 10.sp),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }
}
