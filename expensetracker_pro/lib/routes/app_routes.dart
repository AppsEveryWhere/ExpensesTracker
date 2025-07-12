import 'package:flutter/material.dart';
import '../presentation/home_dashboard/home_dashboard.dart';
import '../presentation/add_expense/add_expense.dart';
import '../presentation/user_profile_settings/user_profile_settings.dart';
import '../presentation/premium_upgrade/premium_upgrade.dart';
import '../presentation/budget_planner/budget_planner.dart';
import '../presentation/groups_dashboard/groups_dashboard.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String homeDashboard = '/home-dashboard';
  static const String addExpense = '/add-expense';
  static const String userProfileSettings = '/user-profile-settings';
  static const String premiumUpgrade = '/premium-upgrade';
  static const String budgetPlanner = '/budget-planner';
  static const String groupsDashboard = '/groups-dashboard';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const HomeDashboard(),
    homeDashboard: (context) => const HomeDashboard(),
    addExpense: (context) => const AddExpense(),
    userProfileSettings: (context) => const UserProfileSettings(),
    premiumUpgrade: (context) => const PremiumUpgrade(),
    budgetPlanner: (context) => const BudgetPlanner(),
    groupsDashboard: (context) => const GroupsDashboard(),
    // TODO: Add your other routes here
  };
}
