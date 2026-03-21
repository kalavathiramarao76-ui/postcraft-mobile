import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:postcraft_ai/models/post_model.dart';

class FavoritesService extends ChangeNotifier {
  late SharedPreferences _prefs;
  List<PostModel> _favorites = [];

  List<PostModel> get favorites => _favorites;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _loadFavorites();
  }

  void _loadFavorites() {
    final data = _prefs.getString('favorites');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      _favorites = decoded.map((e) => PostModel.fromJson(e)).toList();
      _favorites.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
    notifyListeners();
  }

  Future<void> addFavorite(PostModel post) async {
    post.isFavorite = true;
    _favorites.insert(0, post);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((p) => p.id == id);
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String id) {
    return _favorites.any((p) => p.id == id);
  }

  Future<void> toggleFavorite(PostModel post) async {
    if (isFavorite(post.id)) {
      await removeFavorite(post.id);
    } else {
      await addFavorite(post);
    }
  }

  List<PostModel> getByStyle(String style) {
    if (style == 'All') return _favorites;
    return _favorites.where((p) => p.style == style).toList();
  }

  Future<void> _saveFavorites() async {
    final data = jsonEncode(_favorites.map((e) => e.toJson()).toList());
    await _prefs.setString('favorites', data);
  }

  Future<void> clearAll() async {
    _favorites.clear();
    await _prefs.remove('favorites');
    notifyListeners();
  }
}
