import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class PrefsService {
  static const String _keyUser = 'current_user';
  static const String _keyOnboarded = 'has_onboarded';
  static const String _keyLoggedIn = 'is_logged_in';
  static const String _keySavedPosts = 'saved_posts';
  static const String _keyRsvpPosts = 'rsvp_posts';
  static const String _keyInterestedPosts = 'interested_posts';
  static const String _keyJoinedCommunities = 'joined_communities';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Session
  static bool get isLoggedIn => _prefs.getBool(_keyLoggedIn) ?? false;
  static bool get hasOnboarded => _prefs.getBool(_keyOnboarded) ?? false;

  static Future<void> setLoggedIn(bool value) =>
      _prefs.setBool(_keyLoggedIn, value);

  static Future<void> setOnboarded() =>
      _prefs.setBool(_keyOnboarded, true);

  // User persistence
  static Future<void> saveUser(UserModel user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toMap()));
  }

  static UserModel? getUser() {
    final raw = _prefs.getString(_keyUser);
    if (raw == null) return null;
    return UserModel.fromMap(jsonDecode(raw));
  }

  // Saved posts
  static List<String> getSavedPosts() =>
      _prefs.getStringList(_keySavedPosts) ?? [];

  static Future<void> toggleSavedPost(String postId) async {
    final saved = getSavedPosts();
    if (saved.contains(postId)) {
      saved.remove(postId);
    } else {
      saved.add(postId);
    }
    await _prefs.setStringList(_keySavedPosts, saved);
  }

  static bool isPostSaved(String postId) => getSavedPosts().contains(postId);

  // RSVP posts
  static List<String> getRsvpPosts() =>
      _prefs.getStringList(_keyRsvpPosts) ?? [];

  static Future<void> toggleRsvp(String postId) async {
    final rsvps = getRsvpPosts();
    if (rsvps.contains(postId)) {
      rsvps.remove(postId);
    } else {
      rsvps.add(postId);
    }
    await _prefs.setStringList(_keyRsvpPosts, rsvps);
  }

  static bool isRsvpd(String postId) => getRsvpPosts().contains(postId);

  // Interested posts
  static List<String> getInterestedPosts() =>
      _prefs.getStringList(_keyInterestedPosts) ?? [];

  static Future<void> toggleInterested(String postId) async {
    final list = getInterestedPosts();
    if (list.contains(postId)) {
      list.remove(postId);
    } else {
      list.add(postId);
    }
    await _prefs.setStringList(_keyInterestedPosts, list);
  }

  static bool isInterested(String postId) =>
      getInterestedPosts().contains(postId);

  // Joined communities
  static List<String> getJoinedCommunities() =>
      _prefs.getStringList(_keyJoinedCommunities) ?? [];

  static Future<void> toggleJoinCommunity(String communityId) async {
    final joined = getJoinedCommunities();
    if (joined.contains(communityId)) {
      joined.remove(communityId);
    } else {
      joined.add(communityId);
    }
    await _prefs.setStringList(_keyJoinedCommunities, joined);
  }

  static bool isCommunityJoined(String communityId) =>
      getJoinedCommunities().contains(communityId);

  static Future<void> logout() async {
    await _prefs.setBool(_keyLoggedIn, false);
    await _prefs.remove(_keyUser);
  }
}
