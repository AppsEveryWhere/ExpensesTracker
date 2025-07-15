import 'package:expensetracker_pro/presentation/add_expense/add_expense.dart';
import 'package:expensetracker_pro/presentation/budget_planner/budget_planner.dart';
import 'package:expensetracker_pro/presentation/groups_dashboard/groups_dashboard.dart';
import 'package:expensetracker_pro/presentation/user_profile_settings/user_profile_settings.dart';
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

class _HomeDashboardState extends State<HomeDashboard> {
  int _currentIndex = 0;

  // Dummy data and logic reused from your previous code
  final Map<String, dynamic> _dashboardData = {
    "user": {
      "name": "Sarah Johnson",
      "avatar": "https://images.unsplash.com/photo-1494790108755-2616b612b786?w=400&h=400&fit=crop&crop=face",
      "currentMonth": "July 2025",
    },
    "monthlySummary": {
      "totalSpent": 2847.50,
      "budget": 3500.00,
      "percentage": 0.81,
      "status": "warning",
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
    ],
  };

  final List<Map<String, dynamic>> _categories = [
    {"id": 1,'name': 'Food', 'icon': 'restaurant', 'color': Colors.orange},
    {"id": 2,'name': 'Transport', 'icon': 'directions_car', 'color': Colors.blue},
    {"id": 3,'name': 'Shopping', 'icon': 'shopping_bag', 'color': Colors.purple},
    {"id": 4,'name': 'Entertainment', 'icon': 'movie', 'color': Colors.red},
    {"id": 5,'name': 'Health', 'icon': 'local_hospital', 'color': Colors.green},
    {"id": 6,'name': 'Bills', 'icon': 'receipt', 'color': Colors.grey},
    {"id": 7,'name': 'Education', 'icon': 'school', 'color': Colors.indigo},
    {"id": 8,'name': 'Travel', 'icon': 'flight', 'color': Colors.teal},
  ];

   // Mock budget data
  final List<Map<String, dynamic>> _budgetCategories = [

    {
      "id": 1,
      "name": "Food & Dining",
      "icon": "restaurant",
      "budgetAmount": 800.0,
      "spentAmount": 650.0,
      "color": 0xFF4CAF50,
      "isEditing": false,
    },
    {
      "id": 2,
      "name": "Transportation",
      "icon": "directions_car",
      "budgetAmount": 400.0,
      "spentAmount": 320.0,
      "color": 0xFF2196F3,
      "isEditing": false,
    },
    {
      "id": 3,
      "name": "Entertainment",
      "icon": "movie",
      "budgetAmount": 300.0,
      "spentAmount": 380.0,
      "color": 0xFFFF9800,
      "isEditing": false,
    },
    {
      "id": 4,
      "name": "Shopping",
      "icon": "shopping_bag",
      "budgetAmount": 500.0,
      "spentAmount": 245.0,
      "color": 0xFF9C27B0,
      "isEditing": false,
    },
    {
      "id": 5,
      "name": "Healthcare",
      "icon": "local_hospital",
      "budgetAmount": 200.0,
      "spentAmount": 150.0,
      "color": 0xFFE91E63,
      "isEditing": false,
    },

  ];
  void _addToBudgetCategories(Map<String, dynamic> newCategory) {
    setState(() {
      _budgetCategories.add({
        ...newCategory,
        "id": _budgetCategories.length + 1,
        "isEditing": false,
      });
    });
  }
  
  void _onAddExpense() {
    Navigator.pushNamed(context, '/add-expense');
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // 👇 Render the screen based on selected index
  List<Widget> get _screens => [
        _buildHomeContent(),
        AddExpense(categories: _categories, onCategoryAdded: _addToBudgetCategories,),
        BudgetPlanner(
          currentIndex: _currentIndex,
          onIndexChanged: _onBottomNavTap, budgetCategories: _budgetCategories, // callback here
        ),
        GroupsDashboard(),
        UserProfileSettings()
      ];

  Widget _buildHomeContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          GreetingHeaderWidget(userData: _dashboardData["user"]),
          SizedBox(height: 2.h),
          MonthlySummaryCardWidget(
            summaryData: _dashboardData["monthlySummary"],
            onTap: () => setState(() => _currentIndex = 2),
          ),
          SizedBox(height: 2.h),
          QuickStatsRowWidget(
            statsData: _dashboardData["quickStats"],
            onStatTap: (type) {
              if (type == 'budget') {
                setState(() => _currentIndex = 2);;
              }
            },
          ),
          SizedBox(height: 2.h),
          RecentTransactionsWidget(
            transactions: _dashboardData["recentTransactions"]
                as List<Map<String, dynamic>>,
            onTransactionEdit: (id) {
              Navigator.pushNamed(context, '/add-expense');
            },
            onTransactionDelete: (id) {
              setState(() {
                (_dashboardData["recentTransactions"] as List)
                    .removeWhere((tx) => tx["id"] == id);
              });
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Transaction deleted'),
              ));
            },
            onViewAll: () {},
          ),
          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: _currentIndex,
          children: _screens,
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
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle_outline',
            color: _currentIndex == 1
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Add',
        ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'pie_chart',
              size: 6.w,
              color: _currentIndex == 2
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Budget',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'group',
              size: 6.w,
              color: _currentIndex == 3
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Groups',
          ),
          BottomNavigationBarItem(
            icon: CustomIconWidget(
              iconName: 'person',
              size: 6.w,
              color: _currentIndex == 4
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
