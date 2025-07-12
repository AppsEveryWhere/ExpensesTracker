import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/create_group_modal_widget.dart';
import './widgets/empty_groups_widget.dart';
import './widgets/group_card_widget.dart';
import './widgets/join_group_modal_widget.dart';

class GroupsDashboard extends StatefulWidget {
  const GroupsDashboard({Key? key}) : super(key: key);

  @override
  State<GroupsDashboard> createState() => _GroupsDashboardState();
}

class _GroupsDashboardState extends State<GroupsDashboard>
    with TickerProviderStateMixin {
  int _currentIndex = 3; // Groups tab active
  bool _isLoading = false;

  // Mock data for groups
  final List<Map<String, dynamic>> _groupsData = [
    {
      "id": "grp_001",
      "name": "Family Budget",
      "memberCount": 4,
      "totalExpenses": 2450.75,
      "unreadCount": 3,
      "isAdmin": true,
      "recentActivity": "Sarah added groceries expense",
      "lastUpdated": DateTime.now().subtract(Duration(hours: 2)),
      "members": [
        {
          "name": "John Doe",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Sarah Smith",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Mike Johnson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Emma Wilson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        }
      ]
    },
    {
      "id": "grp_002",
      "name": "Roommates Expenses",
      "memberCount": 3,
      "totalExpenses": 1875.50,
      "unreadCount": 0,
      "isAdmin": false,
      "recentActivity": "Alex paid utilities bill",
      "lastUpdated": DateTime.now().subtract(Duration(days: 1)),
      "members": [
        {
          "name": "Alex Chen",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Lisa Park",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "David Kim",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        }
      ]
    },
    {
      "id": "grp_003",
      "name": "Weekend Trip",
      "memberCount": 6,
      "totalExpenses": 3200.25,
      "unreadCount": 7,
      "isAdmin": true,
      "recentActivity": "Tom added hotel booking",
      "lastUpdated": DateTime.now().subtract(Duration(hours: 5)),
      "members": [
        {
          "name": "Tom Brown",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Jenny Lee",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Mark Davis",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Anna Taylor",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Chris Wilson",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Maya Patel",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        }
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Text(
        'My Groups',
        style: Theme.of(context).appBarTheme.titleTextStyle,
      ),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 4.w),
          child: TextButton.icon(
            onPressed: _showCreateGroupModal,
            icon: CustomIconWidget(
              iconName: 'add',
              color: AppTheme.primaryLight,
              size: 20,
            ),
            label: Text(
              'Create',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: AppTheme.primaryLight,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBody() {
    return _groupsData.isEmpty ? _buildEmptyState() : _buildGroupsList();
  }

  Widget _buildEmptyState() {
    return EmptyGroupsWidget(
      onCreateGroup: _showCreateGroupModal,
      onJoinGroup: _showJoinGroupModal,
    );
  }

  Widget _buildGroupsList() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: AppTheme.primaryLight,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final group = _groupsData[index];
                  return Padding(
                    padding: EdgeInsets.only(bottom: 2.h),
                    child: GroupCardWidget(
                      groupData: group,
                      onTap: () => _navigateToGroupDetail(group),
                      onLongPress: () => _showGroupContextMenu(group),
                      onSwipeLeft: () => _showQuickActions(group),
                    ),
                  );
                },
                childCount: _groupsData.length,
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(bottom: 10.h),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      type: BottomNavigationBarType.fixed,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      selectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      selectedLabelStyle:
          Theme.of(context).bottomNavigationBarTheme.selectedLabelStyle,
      unselectedLabelStyle:
          Theme.of(context).bottomNavigationBarTheme.unselectedLabelStyle,
      onTap: _onBottomNavTap,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'dashboard',
            color: _currentIndex == 0
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle_outline',
            color: _currentIndex == 1
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'pie_chart',
            color: _currentIndex == 2
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'group',
            color: _currentIndex == 3
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'star',
            color: _currentIndex == 4
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'Premium',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentIndex == 5
                ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor!
                : Theme.of(context)
                    .bottomNavigationBarTheme
                    .unselectedItemColor!,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton.extended(
      onPressed: _showJoinGroupModal,
      backgroundColor: AppTheme.accentColor,
      foregroundColor: Colors.white,
      icon: CustomIconWidget(
        iconName: 'group_add',
        color: Colors.white,
        size: 20,
      ),
      label: Text(
        'Join Group',
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  void _onBottomNavTap(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/add-expense');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/budget-planner');
        break;
      case 3:
        // Current screen - do nothing
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/premium-upgrade');
        break;
      case 5:
        Navigator.pushReplacementNamed(context, '/user-profile-settings');
        break;
    }
  }

  Future<void> _handleRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Groups synced successfully'),
        backgroundColor: AppTheme.successColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showCreateGroupModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateGroupModalWidget(
        onCreateGroup: _handleCreateGroup,
      ),
    );
  }

  void _showJoinGroupModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => JoinGroupModalWidget(
        onJoinGroup: _handleJoinGroup,
      ),
    );
  }

  void _handleCreateGroup(String groupName, List<String> memberEmails) {
    // Simulate group creation
    final newGroup = {
      "id": "grp_${DateTime.now().millisecondsSinceEpoch}",
      "name": groupName,
      "memberCount": memberEmails.length + 1, // +1 for current user
      "totalExpenses": 0.0,
      "unreadCount": 0,
      "isAdmin": true,
      "recentActivity": "Group created",
      "lastUpdated": DateTime.now(),
      "members": [
        {
          "name": "You",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        }
      ]
    };

    setState(() {
      _groupsData.insert(0, newGroup);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Group "$groupName" created successfully'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _handleJoinGroup(String groupId) {
    // Simulate group joining validation
    if (groupId.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid group ID. Please check and try again.'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    // Simulate successful join
    final joinedGroup = {
      "id": groupId,
      "name": "New Joined Group",
      "memberCount": 5,
      "totalExpenses": 1250.00,
      "unreadCount": 2,
      "isAdmin": false,
      "recentActivity": "You joined the group",
      "lastUpdated": DateTime.now(),
      "members": [
        {
          "name": "Group Admin",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        },
        {
          "name": "Member 1",
          "avatar":
              "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png"
        }
      ]
    };

    setState(() {
      _groupsData.insert(0, joinedGroup);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Successfully joined group!'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _navigateToGroupDetail(Map<String, dynamic> group) {
    // Navigate to group detail screen
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening ${group["name"]} details...'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _showGroupContextMenu(Map<String, dynamic> group) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              group["name"],
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: 'exit_to_app',
              title: 'Leave Group',
              onTap: () => _handleLeaveGroup(group),
              isDestructive: true,
            ),
            _buildContextMenuItem(
              icon: 'notifications_off',
              title: 'Mute Notifications',
              onTap: () => _handleMuteNotifications(group),
            ),
            _buildContextMenuItem(
              icon: 'share',
              title: 'Share Invite',
              onTap: () => _handleShareInvite(group),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContextMenuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: CustomIconWidget(
        iconName: icon,
        color: isDestructive
            ? AppTheme.errorColor
            : Theme.of(context).iconTheme.color!,
        size: 24,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isDestructive ? AppTheme.errorColor : null,
            ),
      ),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  void _showQuickActions(Map<String, dynamic> group) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 3.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 12.w,
              height: 0.5.h,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 3.h),
            _buildContextMenuItem(
              icon: 'pie_chart',
              title: 'View Budget',
              onTap: () => _handleViewBudget(group),
            ),
            _buildContextMenuItem(
              icon: 'add',
              title: 'Add Expense',
              onTap: () => _handleAddExpense(group),
            ),
            _buildContextMenuItem(
              icon: 'settings',
              title: 'Settings',
              onTap: () => _handleGroupSettings(group),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLeaveGroup(Map<String, dynamic> group) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Leave Group'),
        content: Text('Are you sure you want to leave "${group["name"]}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _groupsData.removeWhere((g) => g["id"] == group["id"]);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Left group "${group["name"]}"'),
                  backgroundColor: AppTheme.warningColor,
                ),
              );
            },
            child: Text(
              'Leave',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
  }

  void _handleMuteNotifications(Map<String, dynamic> group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Notifications muted for "${group["name"]}"'),
      ),
    );
  }

  void _handleShareInvite(Map<String, dynamic> group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Invite link copied to clipboard'),
        backgroundColor: AppTheme.successColor,
      ),
    );
  }

  void _handleViewBudget(Map<String, dynamic> group) {
    Navigator.pushNamed(context, '/budget-planner');
  }

  void _handleAddExpense(Map<String, dynamic> group) {
    Navigator.pushNamed(context, '/add-expense');
  }

  void _handleGroupSettings(Map<String, dynamic> group) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Opening group settings...'),
      ),
    );
  }
}
