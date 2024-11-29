import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Favorites extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  Favorites() {
    _loadFromPreferences();
  }

  Future<void> _loadFromPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? storedItems = prefs.getStringList('favorites');
      if (storedItems != null) {
        _items.addAll(storedItems);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveToPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorites', _items);
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  void addItem(String item) {
    if (!_items.contains(item)) {
      _items.add(item);
      _saveToPreferences();
      notifyListeners();
    }
  }

  void removeItem(String item) {
    if (_items.contains(item)) {
      _items.remove(item);
      _saveToPreferences();
      notifyListeners();
    }
  }
}
