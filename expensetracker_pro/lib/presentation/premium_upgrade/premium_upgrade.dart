import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/feature_comparison_widget.dart';
import './widgets/premium_header_widget.dart';
import './widgets/pricing_section_widget.dart';
import './widgets/social_proof_widget.dart';

class PremiumUpgrade extends StatefulWidget {
  const PremiumUpgrade({super.key});

  @override
  State<PremiumUpgrade> createState() => _PremiumUpgradeState();
}

class _PremiumUpgradeState extends State<PremiumUpgrade>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  bool _isLoading = false;
  String _selectedPlan = 'yearly';

  // Mock subscription data
  final List<Map<String, dynamic>> _subscriptionPlans = [
    {
      "id": "monthly",
      "name": "Monthly",
      "price": "\$9.99",
      "period": "per month",
      "savings": null,
      "description": "Full access to all premium features",
    },
    {
      "id": "yearly",
      "name": "Yearly",
      "price": "\$79.99",
      "period": "per year",
      "savings": "Save 33%",
      "description": "Best value - 2 months free!",
    },
  ];

  // Mock premium features data
  final List<Map<String, dynamic>> _premiumFeatures = [
    {
      "icon": "psychology",
      "title": "AI Budget Optimization",
      "description":
          "Smart suggestions powered by machine learning to optimize your spending patterns and maximize savings",
      "isPremium": true,
    },
    {
      "icon": "analytics",
      "title": "Advanced Analytics",
      "description":
          "Detailed charts, trends analysis, and comprehensive financial insights with export capabilities",
      "isPremium": true,
    },
    {
      "icon": "group",
      "title": "Unlimited Group Sharing",
      "description":
          "Create and manage unlimited expense groups with real-time collaboration features",
      "isPremium": true,
    },
    {
      "icon": "support_agent",
      "title": "Priority Support",
      "description":
          "24/7 customer support with priority response times and dedicated assistance",
      "isPremium": true,
    },
    {
      "icon": "block",
      "title": "Ad-Free Experience",
      "description":
          "Enjoy uninterrupted expense tracking without any advertisements or promotional content",
      "isPremium": true,
    },
  ];

  // Mock testimonials data
  final List<Map<String, dynamic>> _testimonials = [
    {
      "name": "Sarah Johnson",
      "rating": 5,
      "comment":
          "The AI suggestions helped me save \$500 last month! Amazing app.",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "name": "Mike Chen",
      "rating": 5,
      "comment":
          "Group sharing made splitting expenses with roommates so much easier.",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
    {
      "name": "Emily Rodriguez",
      "rating": 5,
      "comment": "The analytics are incredibly detailed. Worth every penny!",
      "avatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleStartFreeTrial() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate purchase flow
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      // Show success animation
      _showPurchaseSuccessDialog();
    }
  }

  void _handleRestorePurchases() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate restore purchases
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No previous purchases found',
            style: AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
          ),
          backgroundColor: AppTheme.warningColor,
        ),
      );
    }
  }

  void _showPurchaseSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            padding: EdgeInsets.all(6.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'check_circle',
                    color: AppTheme.successColor,
                    size: 10.w,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  'Welcome to Premium!',
                  style: AppTheme.lightTheme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  'You now have access to all premium features including AI optimization and advanced analytics.',
                  style: AppTheme.lightTheme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4.h),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                    child: Text('Get Started'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openTermsOfService() {
    // In a real app, this would open an in-app browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Terms of Service would open here'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _openPrivacyPolicy() {
    // In a real app, this would open an in-app browser
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Privacy Policy would open here'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              // Header with close button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 10.w),
                    Text(
                      'Upgrade to Premium',
                      style: AppTheme.lightTheme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .surface
                              .withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'close',
                          color: Theme.of(context).colorScheme.onSurface,
                          size: 6.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Premium header with badge
                      PremiumHeaderWidget(),
                      SizedBox(height: 4.h),

                      // Feature comparison
                      FeatureComparisonWidget(features: _premiumFeatures),
                      SizedBox(height: 4.h),

                      // Pricing section
                      PricingSectionWidget(
                        plans: _subscriptionPlans,
                        selectedPlan: _selectedPlan,
                        onPlanSelected: (planId) {
                          setState(() {
                            _selectedPlan = planId;
                          });
                        },
                      ),
                      SizedBox(height: 4.h),

                      // Social proof
                      SocialProofWidget(testimonials: _testimonials),
                      SizedBox(height: 4.h),

                      // Action buttons
                      Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 6.h,
                            child: ElevatedButton(
                              onPressed:
                                  _isLoading ? null : _handleStartFreeTrial,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.accentColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: _isLoading
                                  ? SizedBox(
                                      width: 5.w,
                                      height: 5.w,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          Colors.white,
                                        ),
                                      ),
                                    )
                                  : Text(
                                      'Start Free Trial',
                                      style: AppTheme
                                          .lightTheme.textTheme.titleMedium
                                          ?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          TextButton(
                            onPressed:
                                _isLoading ? null : _handleRestorePurchases,
                            child: Text(
                              'Restore Purchases',
                              style: AppTheme.lightTheme.textTheme.bodyMedium
                                  ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 3.h),

                      // Terms and Privacy
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: _openTermsOfService,
                            child: Text(
                              'Terms of Service',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                          Text(
                            ' • ',
                            style: AppTheme.lightTheme.textTheme.bodySmall,
                          ),
                          GestureDetector(
                            onTap: _openPrivacyPolicy,
                            child: Text(
                              'Privacy Policy',
                              style: AppTheme.lightTheme.textTheme.bodySmall
                                  ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4.h),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
