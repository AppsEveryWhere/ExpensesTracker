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
  static const String userProfileSettings = '/user-profile-settings';
  static const String premiumUpgrade = '/premium-upgrade';
  static const String groupsDashboard = '/groups-dashboard';
  static late VoidCallback toggleTheme;

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => HomeDashboard(toggleTheme: toggleTheme),
    homeDashboard: (context) => HomeDashboard(toggleTheme: toggleTheme),
    premiumUpgrade: (context) => const PremiumUpgrade(),
    groupsDashboard: (context) => const GroupsDashboard(),
    // TODO: Add your other routes here
  };
}
