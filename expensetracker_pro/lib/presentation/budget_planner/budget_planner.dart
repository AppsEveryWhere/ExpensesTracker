import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/add_category_modal_widget.dart';
import './widgets/budget_category_item_widget.dart';
import './widgets/budget_chart_widget.dart';
import './widgets/total_budget_card_widget.dart';

class BudgetPlanner extends StatefulWidget {
  const BudgetPlanner({Key? key}) : super(key: key);

  @override
  State<BudgetPlanner> createState() => _BudgetPlannerState();
}

class _BudgetPlannerState extends State<BudgetPlanner>
    with TickerProviderStateMixin {
  int _currentBottomIndex = 2; // Budget tab active
  DateTime _selectedMonth = DateTime.now();
  bool _isChartExpanded = false;
  bool _isPieChart = true;
  late TabController _chartTabController;

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

  double get _totalBudget => (_budgetCategories as List)
      .fold(0.0, (sum, category) => sum + (category["budgetAmount"] as double));

  double get _totalSpent => (_budgetCategories as List)
      .fold(0.0, (sum, category) => sum + (category["spentAmount"] as double));

  double get _remainingBudget => _totalBudget - _totalSpent;

  @override
  void initState() {
    super.initState();
    _chartTabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _chartTabController.dispose();
    super.dispose();
  }

  void _navigateMonth(bool isNext) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + (isNext ? 1 : -1),
        1,
      );
    });
  }

  void _onBottomNavTap(int index) {
    setState(() {
      _currentBottomIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushNamed(context, '/home-dashboard');
        break;
      case 1:
        Navigator.pushNamed(context, '/add-expense');
        break;
      case 2:
        // Current screen - Budget Planner
        break;
      case 3:
        Navigator.pushNamed(context, '/groups-dashboard');
        break;
      case 4:
        Navigator.pushNamed(context, '/user-profile-settings');
        break;
    }
  }

  void _showAddCategoryModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddCategoryModalWidget(
        onCategoryAdded: (Map<String, dynamic> newCategory) {
          setState(() {
            _budgetCategories.add({
              ...newCategory,
              "id": _budgetCategories.length + 1,
              "spentAmount": 0.0,
              "isEditing": false,
            });
          });
        },
      ),
    );
  }

  void _updateCategoryBudget(int categoryId, double newAmount) {
    setState(() {
      final categoryIndex = _budgetCategories
          .indexWhere((category) => category["id"] == categoryId);
      if (categoryIndex != -1) {
        _budgetCategories[categoryIndex]["budgetAmount"] = newAmount;
      }
    });
  }

  void _showCategoryContextMenu(
      BuildContext context, Map<String, dynamic> category) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'edit',
                color: Theme.of(context).colorScheme.primary,
                size: 24,
              ),
              title: Text('Edit Budget'),
              onTap: () {
                Navigator.pop(context);
                // Edit budget functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'history',
                color: Theme.of(context).colorScheme.secondary,
                size: 24,
              ),
              title: Text('View History'),
              onTap: () {
                Navigator.pop(context);
                // View history functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'notifications',
                color: AppTheme.warningColor,
                size: 24,
              ),
              title: Text('Set Alert'),
              onTap: () {
                Navigator.pop(context);
                // Set alert functionality
              },
            ),
            SizedBox(height: 2.h),
          ],
        ),
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Simulate refresh delay
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // Update spending data
    });
  }

  String _getMonthYearString(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text('Budget Planner'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, '/premium-upgrade'),
            icon: CustomIconWidget(
              iconName: 'star',
              color: AppTheme.warningColor,
              size: 24,
            ),
          ),
        ],
      ),
      body: _budgetCategories.isEmpty
          ? _buildEmptyState()
          : _buildBudgetContent(),
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryModal,
        child: CustomIconWidget(
          iconName: 'add',
          color: Colors.white,
          size: 24,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomImageWidget(
              imageUrl:
                  "https://images.unsplash.com/photo-1554224155-6726b3ff858f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
              width: 60.w,
              height: 25.h,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 4.h),
            Text(
              'Create Your First Budget',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 2.h),
            Text(
              'Start managing your finances by setting up budget categories and tracking your spending.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            ElevatedButton(
              onPressed: _showAddCategoryModal,
              child: Text('Get Started'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetContent() {
    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: _buildMonthSelector()),
          SliverToBoxAdapter(child: _buildTotalBudgetCard()),
          SliverToBoxAdapter(child: _buildChartSection()),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
              child: Text(
                'Budget Categories',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final category =
                    _budgetCategories[index];
                return BudgetCategoryItemWidget(
                  category: category,
                  onTap: () => _showCategoryContextMenu(context, category),
                  onLongPress: () =>
                      _showCategoryContextMenu(context, category),
                  onBudgetUpdate: (newAmount) =>
                      _updateCategoryBudget(category["id"] as int, newAmount),
                );
              },
              childCount: _budgetCategories.length,
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10.h)),
        ],
      ),
    );
  }

  Widget _buildMonthSelector() {
    return Container(
      margin: EdgeInsets.all(4.w),
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _navigateMonth(false),
            icon: CustomIconWidget(
              iconName: 'chevron_left',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              _getMonthYearString(_selectedMonth),
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _navigateMonth(true),
            icon: CustomIconWidget(
              iconName: 'chevron_right',
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalBudgetCard() {
    return TotalBudgetCardWidget(
      totalBudget: _totalBudget,
      totalSpent: _totalSpent,
      remainingBudget: _remainingBudget,
    );
  }

  Widget _buildChartSection() {
    return Container(
      margin: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          TabBar(
            controller: _chartTabController,
            tabs: [
              Tab(text: 'Distribution'),
              Tab(text: 'Comparison'),
            ],
          ),
          Container(
            height: 30.h,
            child: TabBarView(
              controller: _chartTabController,
              children: [
                BudgetChartWidget(
                  categories: _budgetCategories,
                  chartType: 'pie',
                ),
                BudgetChartWidget(
                  categories: _budgetCategories,
                  chartType: 'bar',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentBottomIndex,
      onTap: _onBottomNavTap,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'home',
            color: _currentBottomIndex == 0
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'add_circle_outline',
            color: _currentBottomIndex == 1
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Add',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'account_balance_wallet',
            color: _currentBottomIndex == 2
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Budget',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'group',
            color: _currentBottomIndex == 3
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Groups',
        ),
        BottomNavigationBarItem(
          icon: CustomIconWidget(
            iconName: 'person',
            color: _currentBottomIndex == 4
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.onSurfaceVariant,
            size: 24,
          ),
          label: 'Profile',
        ),
      ],
    );
  }
}
