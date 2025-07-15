import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class AddCategoryModalWidget extends StatefulWidget {
  final Function(Map<String, dynamic>) onCategoryAdded;

  const AddCategoryModalWidget({
    Key? key,
    required this.onCategoryAdded,
  }) : super(key: key);

  @override
  State<AddCategoryModalWidget> createState() => _AddCategoryModalWidgetState();
}

class _AddCategoryModalWidgetState extends State<AddCategoryModalWidget> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _budgetController = TextEditingController();
  String _selectedIcon = 'category';
  Color _selectedColor = const Color(0xFF4CAF50);

  final List<String> _availableIcons = [
    'category',
    'restaurant',
    'directions_car',
    'movie',
    'shopping_bag',
    'local_hospital',
    'school',
    'fitness_center',
    'pets',
    'home',
    'flight',
    'phone',
    'computer',
    'music_note',
    'sports_soccer',
    'book',
  ];

  final List<Color> _availableColors = [
    Color(0xFF4CAF50),
    Color(0xFF2196F3),
    Color(0xFFFF9800),
    Color(0xFF9C27B0),
    Color(0xFFE91E63),
    Color(0xFF00BCD4),
    Color(0xFFFF5722),
    Color(0xFF795548),
    Color(0xFF607D8B),
    Color(0xFFFFC107),
    Color(0xFF8BC34A),
    Color(0xFF3F51B5),
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _budgetController.dispose();
    super.dispose();
  }

  void _addCategory() {
    if (_nameController.text.trim().isEmpty ||
        _budgetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: AppTheme.errorColor));
      return;
    }

    final budgetAmount = double.tryParse(_budgetController.text);
    if (budgetAmount == null || budgetAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please enter a valid budget amount'),
          backgroundColor: AppTheme.errorColor));
      return;
    }

    final newCategory = {
      "name": _nameController.text.trim(),
      "icon": _selectedIcon,
      "budgetAmount": budgetAmount,
      "color": _selectedColor.value,
    };

    widget.onCategoryAdded(newCategory);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 85.h,
        decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        child: Column(children: [
          Container(
              width: 40.w,
              height: 0.5.h,
              margin: EdgeInsets.symmetric(vertical: 1.h),
              decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor,
                  borderRadius: BorderRadius.circular(2))),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Category',
                        style: Theme.of(context)
                            .textTheme
                            .headlineSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: CustomIconWidget(
                            iconName: 'close',
                            color:
                                Theme.of(context).colorScheme.onSurfaceVariant,
                            size: 24)),
                  ])),
          Expanded(
              child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 6.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionTitle('Category Name'),
                        SizedBox(height: 1.h),
                        TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                                hintText: 'Enter category name')),
                        SizedBox(height: 3.h),
                        _buildSectionTitle('Budget Amount'),
                        SizedBox(height: 1.h),
                        TextField(
                            controller: _budgetController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                                hintText: 'Enter budget amount',
                                prefixText: '\$ ')),
                        SizedBox(height: 3.h),
                        _buildSectionTitle('Choose Icon'),
                        SizedBox(height: 2.h),
                        _buildIconSelector(),
                        SizedBox(height: 3.h),
                        _buildSectionTitle('Choose Color'),
                        SizedBox(height: 2.h),
                        _buildColorSelector(),
                        SizedBox(height: 4.h),
                        _buildPreview(),
                        SizedBox(height: 4.h),
                      ]))),
          Container(
              padding: EdgeInsets.all(6.w),
              child: Row(children: [
                Expanded(
                    child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Cancel'))),
                SizedBox(width: 4.w),
                Expanded(
                    child: ElevatedButton(
                        onPressed: _addCategory, child: Text('Add Category'))),
              ])),
        ]));
  }

  Widget _buildSectionTitle(String title) {
    return Text(title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w600));
  }

  Widget _buildIconSelector() {
    return Container(
        height: 20.h,
        child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 3.w, mainAxisSpacing: 2.h),
            itemBuilder: (context, index) {
              final iconName = _availableIcons[index];
              final isSelected = iconName == _selectedIcon;

              return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIcon = iconName;
                    });
                  },
                  child: Container(
                      decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withValues(alpha: 0.1)
                              : Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: Theme.of(context).colorScheme.primary,
                                  width: 2)
                              : Border.all(
                                  color: Theme.of(context).dividerColor,
                                  width: 1)),
                      child: Center(
                          child: CustomIconWidget(
                              iconName: iconName,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                              size: 24))));
            }));
  }

  Widget _buildColorSelector() {
    return Wrap(
        spacing: 3.w,
        runSpacing: 2.h,
        children: _availableColors.map((color) {
          final isSelected = color == _selectedColor;

          return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedColor = color;
                });
              },
              child: Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: isSelected
                          ? Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 3)
                          : null),
                  child: isSelected
                      ? Center(
                          child: CustomIconWidget(
                              iconName: 'check', color: Colors.white, size: 16))
                      : null));
        }).toList());
  }

  Widget _buildPreview() {
    return Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: Theme.of(context).dividerColor, width: 1)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('Preview',
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(fontWeight: FontWeight.w600)),
          SizedBox(height: 2.h),
          Row(children: [
            Container(
                width: 12.w,
                height: 12.w,
                decoration: BoxDecoration(
                    color: _selectedColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8)),
                child: Center(
                    child: CustomIconWidget(
                        iconName: _selectedIcon,
                        color: _selectedColor,
                        size: 24))),
            SizedBox(width: 3.w),
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  Text(
                      _nameController.text.isEmpty
                          ? 'Category Name'
                          : _nameController.text,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  SizedBox(height: 0.5.h),
                  Text('\$0 spent',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onSurfaceVariant)),
                ])),
            Text(
                _budgetController.text.isEmpty
                    ? '\$0'
                    : '\$${_budgetController.text}',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(fontWeight: FontWeight.w600)),
          ]),
        ]));
  }
}
