import 'package:flutter/material.dart';

enum BookCategory {
  education(Icons.school, Colors.blueGrey),
  health(Icons.favorite, Colors.orange),
  home(Icons.home, Colors.green),
  others(Icons.calendar_month_rounded, Colors.purple),
  personal(Icons.person, Colors.lightBlue),
  shopping(Icons.shopping_bag, Colors.deepOrange),
  social(Icons.people, Colors.brown),
  travel(Icons.flight, Colors.pink),
  work(Icons.work, Colors.amber);

  static BookCategory stringToTaskCategory(String name) {
    try {
      return BookCategory.values.firstWhere(
        (category) => category.name == name,
      );
    } catch (e) {
      return BookCategory.others;
    }
  }

  final IconData icon;
  final Color color;
  const BookCategory(this.icon, this.color);
}
