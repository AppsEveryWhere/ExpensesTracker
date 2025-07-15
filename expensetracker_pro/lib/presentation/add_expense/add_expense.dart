import 'package:expensetracker_pro/model/category_model.dart';
import 'package:expensetracker_pro/presentation/add_expense/widgets/add_category_modal_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../theme/app_theme.dart';
import './widgets/amount_input_widget.dart';
import './widgets/category_chip_widget.dart';
import './widgets/date_picker_widget.dart';
import './widgets/notes_input_widget.dart';

class AddExpense extends StatefulWidget {
  final List<CategoryModel> categories;
  final ValueChanged<CategoryModel> onCategoryAdded;



  const AddExpense({
    super.key,
    required this.categories,
    required this.onCategoryAdded,
  });

  @override
  State<AddExpense> createState() => _AddExpenseState();
}



class _AddExpenseState extends State<AddExpense> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _scrollController = ScrollController();

  String? _selectedCategory;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  bool _hasUnsavedChanges = false;

  late List<CategoryModel> _categories;

@override
void initState() {
  super.initState();
  _categories = List<CategoryModel>.from(widget.categories);
  _amountController.addListener(_onFormChanged);
  _notesController.addListener(_onFormChanged);
}

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    final hasChanges = _amountController.text.isNotEmpty ||
        _notesController.text.isNotEmpty ||
        _selectedCategory != null;

    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category;
    });
    _onFormChanged();
  }

  void _onDateSelected(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    _onFormChanged();
  }

  bool _isFormValid() {
    return _amountController.text.isNotEmpty &&
        _selectedCategory != null &&
        double.tryParse(_amountController.text) != null &&
        double.parse(_amountController.text) > 0;
  }

  Future<void> _saveExpense() async {
    if (!_isFormValid()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate save operation
      await Future.delayed(const Duration(milliseconds: 1500));

      // Haptic feedback for success
      HapticFeedback.lightImpact();

      if (mounted) {
        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Expense saved successfully'),
            backgroundColor: AppTheme.successColor,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // Navigate back to home dashboard
        Navigator.pushReplacementNamed(context, '/home-dashboard');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save expense. Please try again.'),
            backgroundColor: AppTheme.errorColor,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<bool> _onWillPop() async {
    if (!_hasUnsavedChanges) return true;

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Discard Changes?'),
        content:
            Text('You have unsaved changes. Are you sure you want to leave?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Discard'),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  void _showAddCategoryModal() {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) => AddCategoryModalWidget(
      onCategoryAdded: (p0) => setState(() {
        _categories.add(p0);
        widget.onCategoryAdded(p0);
      }), // Update categories and notify parent
    ),
  );
}



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          
          title: Text(
            'Add Expense',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          centerTitle: true,
          actions: [
            TextButton(
              onPressed: _isFormValid() && !_isLoading ? _saveExpense : null,
              child: _isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Save',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: _isFormValid()
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
            ),
            SizedBox(width: 4.w),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            controller: _scrollController,
            padding: EdgeInsets.all(4.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Input Section
                AmountInputWidget(
                  controller: _amountController,
                  onChanged: (value) => _onFormChanged(),
                ),

                SizedBox(height: 6.h),

                // Category Selection Section
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(
      'Category',
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
    ),
    TextButton.icon(
      onPressed: _showAddCategoryModal,
      icon: Icon(Icons.add, size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(
        'Add',
        style: TextStyle(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size(0, 0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    ),
  ],
),


                SizedBox(height: 2.h),

                SizedBox(
                  height: 12.h,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _categories.length,
                    separatorBuilder: (context, index) => SizedBox(width: 3.w),
                    itemBuilder: (context, index) {
                      final category = _categories[index];
                      return CategoryChipWidget(
                        category: {
                          'name': category.name,
                          'icon': category.icon,
                          'color': category.color,
                        }, // 👈 Only do this if your widget still expects a Map
                        isSelected: _selectedCategory == category.name,
                        onTap: () => _onCategorySelected(category.name),
                      );
                    },
                  ),
                ),


                SizedBox(height: 6.h),

                // Date Selection Section
                DatePickerWidget(
                  selectedDate: _selectedDate,
                  onDateSelected: _onDateSelected,
                ),

                SizedBox(height: 6.h),

                // Notes Input Section
                NotesInputWidget(
                  controller: _notesController,
                  onChanged: (value) => _onFormChanged(),
                ),

                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
