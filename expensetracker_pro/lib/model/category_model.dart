import 'package:flutter/material.dart';

class CategoryModel {
  final int id;
  final String name;
  final String icon; // Store icon name as String (e.g., 'restaurant')
  final Color color;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  // Factory constructor to create CategoryModel from a map
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      color: map['color'],
    );
  }

  // Convert CategoryModel to a map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color': color,
    };
  }
}
