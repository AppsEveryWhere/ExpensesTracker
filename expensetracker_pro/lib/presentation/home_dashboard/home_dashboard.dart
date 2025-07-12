import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/greeting_header_widget.dart';
import './widgets/monthly_summary_card_widget.dart';
import './widgets/quick_stats_row_widget.dart';
import './widgets/recent_transactions_widget.dart';

class HomeDashboard extends StatefulWidget {
  const HomeDashboard({super.key});

  @override
  State<HomeDashboard> createState() => _HomeDashboardState();
}

class _HomeDashboardState extends State<HomeDashboard>
    with TickerProviderStateMixin {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  bool _isLoading = false;
  bool _isOffline = false;
  int _currentIndex = 0;

  // Mock data for the dashboard
  final Map<String, dynamic> _dashboardData = {
    "user": {
      "name": "Sarah Johnson",
      "avatar":
          "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "currentMonth": "July 2025",
    },
    "monthlySummary": {
      "totalSpent": 2847.50,
      "budget": 3500.00,
      "percentage": 0.81,
      "status": "warning", // success, warning, error
    },
    "quickStats": {
      "expensesCount": 47,
      "remainingBudget": 652.50,
      "topCategory": "Food & Dining",
    },
    "recentTransactions": [
      {
        "id": 1,
        "title": "Starbucks Coffee",
        "category": "Food & Dining",
        "amount": 12.50,
        "date": "2025-07-12",
        "icon": "local_cafe",
        "color": "#FF6B35",
      },
      {
        "id": 2,
        "title": "Uber Ride",
        "category": "Transportation",
        "amount": 18.75,
        "date": "2025-07-12",
        "icon": "directions_car",
        "color": "#4A90E2",
      },
      {
        "id": 3,
        "title": "Grocery Shopping",
        "category": "Food & Dining",
        "amount": 89.32,
        "date": "2025-07-11",
        "icon": "shopping_cart",
        "color": "#FF6B35",
      },
      {
        "id": 4,
        "title": "Netflix Subscription",
        "category": "Entertainment",
        "amount": 15.99,
        "date": "2025-07-11",
        "icon": "movie",
        "color": "#2E7D32",
      },
      {
        "id": 5,
        "title": "Gas Station",
        "category": "Transportation",
        "amount": 45.00,
        "date": "2025-07-10",
        "icon": "local_gas_station",
        "color": "#4A90E2",
      },
    ],
  };

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() {
    // Simulate connectivity check
    setState(() {
      _isOffline = false; // Mock online status
    });
  }

  Future<void> _onRefresh() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call delay
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Provide haptic feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Data refreshed successfully'),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        // Already on Home
        break;
      case 1:
        Navigator.pushNamed(context, '/budget-planner');
        break;
      case 2:
        Navigator.pushNamed(context, '/groups-dashboard');
        break;
      case 3:
        Navigator.pushNamed(context, '/user-profile-settings');
        break;
    }
  }

  void _onAddExpense() {
    Navigator.pushNamed(context, '/add-expense');
  }

  void _onSummaryCardTap() {
    // Navigate to detailed monthly breakdown
    Navigator.pushNamed(context, '/budget-planner');
  }

  void _onQuickStatTap(String statType) {
    switch (statType) {
      case 'expenses':
        // Navigate to full expense history
        break;
      case 'budget':
        Navigator.pushNamed(context, '/budget-planner');
        break;
      case 'category':
        // Navigate to category breakdown
        break;
    }
  }

  void _onTransactionEdit(int transactionId) {
    Navigator.pushNamed(context, '/add-expense');
  }

  void _onTransactionDelete(int transactionId) {
    setState(() {
      (_dashboardData["recentTransactions"] as List)
          .removeWhere((transaction) => transaction["id"] == transactionId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Transaction deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            // Implement undo functionality
          },
        ),
      ),
    );
  }

  void _onViewAllTransactions() {
    // Navigate to full transaction history
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'account_balance_wallet',
              size: 20.w,
              color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
            ),
            SizedBox(height: 3.h),
            Text(
              'No expenses yet',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurface,
                  ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Start tracking your expenses to get insights into your spending habits',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                  ),
            ),
            SizedBox(height: 4.h),
            ElevatedButton.icon(
              onPressed: _onAddExpense,
              icon: CustomIconWidget(
                iconName: 'add',
                size: 5.w,
                color: Colors.white,
              ),
              label: Text('Add Your First Expense'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSyncStatusIndicator() {
    if (!_isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 1.h),
      color: AppTheme.warningColor.withValues(alpha: 0.1),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CustomIconWidget(
            iconName: 'cloud_off',
            size: 4.w,
            color: AppTheme.warningColor,
          ),
          SizedBox(width: 2.w),
          Text(
            'Offline - Data will sync when connected',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.warningColor,
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasTransactions =
        (_dashboardData["recentTransactions"] as List).isNotEmpty;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildSyncStatusIndicator(),
            Expanded(
              child: hasTransactions
                  ? RefreshIndicator(
                      key: _refreshIndicatorKey,
                      onRefresh: _onRefresh,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GreetingHeaderWidget(
                              userData: _dashboardData["user"]
                                  as Map<String, dynamic>,
                            ),
                            SizedBox(height: 2.h),
                            MonthlySummaryCardWidget(
                              summaryData: _dashboardData["monthlySummary"]
                                  as Map<String, dynamic>,
                              onTap: _onSummaryCardTap,
                            ),
                            SizedBox(height: 2.h),
                            QuickStatsRowWidget(
                              statsData: _dashboardData["quickStats"]
                                  as Map<String, dynamic>,
                              onStatTap: _onQuickStatTap,
                            ),
                            SizedBox(height: 2.h),
                            RecentTransactionsWidget(
                              transactions: _dashboardData["recentTransactions"]
                                  as List<Map<String, dynamic>>,
                              onTransactionEdit: _onTransactionEdit,
                              onTransactionDelete: _onTransactionDelete,
                              onViewAll: _onViewAllTransactions,
                            ),
                            SizedBox(height: 10.h), // Space for FAB
                          ],
                        ),
                      ),
                    )
                  : _buildEmptyState(),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onAddExpense,
        child: CustomIconWidget(
          iconName: 'add',
          size: 6.w,
          color: Colors.white,
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'home',
              size: 6.w,
              color: _currentIndex == 0
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'pie_chart',
              size: 6.w,
              color: _currentIndex == 1
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'group',
              size: 6.w,
              color: _currentIndex == 2
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              size: 6.w,
              color: _currentIndex == 3
                  ? Theme.of(context).bottomNavigationBarTheme.selectedItemColor
                  : Theme.of(context)
                      .bottomNavigationBarTheme
                      .unselectedItemColor,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
