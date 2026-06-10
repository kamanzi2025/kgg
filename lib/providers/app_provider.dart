import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../models/post_model.dart';
import '../models/community_model.dart';
import '../models/chat_message_model.dart';
import '../data/mock_users.dart';
import '../data/mock_posts.dart';
import '../data/mock_communities.dart';
import '../data/mock_chats.dart';
import '../services/prefs_service.dart';

class AppProvider extends ChangeNotifier {
  UserModel? _currentUser;
  final List<PostModel> _posts = List.from(mockPosts);
  final List<CommunityModel> _communities = List.from(mockCommunities);
  final List<ChatRoom> _chatRooms = List.from(mockChatRooms);
  String _selectedCategory = 'All';
  String _selectedCampusFilter = 'All';
  int _currentNavIndex = 0;

  UserModel? get currentUser => _currentUser;
  List<PostModel> get posts => _posts;
  List<CommunityModel> get communities => _communities;
  List<ChatRoom> get chatRooms => _chatRooms;
  String get selectedCategory => _selectedCategory;
  String get selectedCampusFilter => _selectedCampusFilter;
  int get currentNavIndex => _currentNavIndex;

  void setNavIndex(int index) {
    _currentNavIndex = index;
    notifyListeners();
  }

  void loadUser() {
    _currentUser = PrefsService.getUser() ?? defaultUser;
    // Sync saved/rsvp lists from prefs
    _syncUserEngagement();
    notifyListeners();
  }

  void _syncUserEngagement() {
    final saved = PrefsService.getSavedPosts();
    final rsvps = PrefsService.getRsvpPosts();
    _currentUser = _currentUser!.copyWith(
      savedPostIds: saved,
      rsvpPostIds: rsvps,
    );
    // Sync joined communities
    for (int i = 0; i < _communities.length; i++) {
      final joined = PrefsService.isCommunityJoined(_communities[i].id);
      _communities[i] = _communities[i].copyWith(isJoined: joined);
    }
  }

  Future<void> login(String name, String email, String role, String campus) async {
    _currentUser = UserModel(
      id: 'user_local',
      name: name,
      email: email,
      role: role,
      campus: campus,
      avatarUrl: 'https://i.pravatar.cc/150?img=20',
      eventsAttended: 0,
      communitiesJoined: 0,
      connections: 0,
    );
    await PrefsService.saveUser(_currentUser!);
    await PrefsService.setLoggedIn(true);
    notifyListeners();
  }

  Future<void> logout() async {
    await PrefsService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setCampusFilter(String campus) {
    _selectedCampusFilter = campus;
    notifyListeners();
  }

  List<PostModel> get filteredPosts {
    return _posts.where((p) {
      final catMatch = _selectedCategory == 'All' || p.category == _selectedCategory;
      final campusMatch = _selectedCampusFilter == 'All' || p.campus == _selectedCampusFilter;
      return catMatch && campusMatch;
    }).toList();
  }

  List<PostModel> get featuredPosts => _posts.where((p) => p.isFeatured).toList();

  // Toggle RSVP
  Future<void> toggleRsvp(String postId) async {
    await PrefsService.toggleRsvp(postId);
    final isRsvpd = PrefsService.isRsvpd(postId);
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      _posts[idx] = _posts[idx].copyWith(
        rsvpCount: _posts[idx].rsvpCount + (isRsvpd ? 1 : -1),
      );
    }
    _currentUser = _currentUser!.copyWith(
      rsvpPostIds: PrefsService.getRsvpPosts(),
    );
    notifyListeners();
  }

  // Toggle save
  Future<void> toggleSave(String postId) async {
    await PrefsService.toggleSavedPost(postId);
    _currentUser = _currentUser!.copyWith(
      savedPostIds: PrefsService.getSavedPosts(),
    );
    notifyListeners();
  }

  bool isRsvpd(String postId) => PrefsService.isRsvpd(postId);
  bool isSaved(String postId) => PrefsService.isPostSaved(postId);

  // Toggle interested
  Future<void> toggleInterested(String postId) async {
    await PrefsService.toggleInterested(postId);
    final active = PrefsService.isInterested(postId);
    final idx = _posts.indexWhere((p) => p.id == postId);
    if (idx != -1) {
      _posts[idx] = _posts[idx].copyWith(
        interestedCount: _posts[idx].interestedCount + (active ? 1 : -1),
      );
    }
    notifyListeners();
  }

  bool isInterested(String postId) => PrefsService.isInterested(postId);

  // Toggle community join
  Future<void> toggleJoin(String communityId) async {
    await PrefsService.toggleJoinCommunity(communityId);
    final joined = PrefsService.isCommunityJoined(communityId);
    final idx = _communities.indexWhere((c) => c.id == communityId);
    if (idx != -1) {
      _communities[idx] = _communities[idx].copyWith(
        isJoined: joined,
        memberCount: _communities[idx].memberCount + (joined ? 1 : -1),
      );
    }
    notifyListeners();
  }

  bool isCommunityJoined(String communityId) =>
      PrefsService.isCommunityJoined(communityId);

  List<CommunityModel> get joinedCommunities =>
      _communities.where((c) => isCommunityJoined(c.id)).toList();

  // Add a new post
  void addPost(PostModel post) {
    _posts.insert(0, post);
    notifyListeners();
  }

  // Send chat message
  void sendMessage(String chatRoomId, String content) {
    final idx = _chatRooms.indexWhere((r) => r.id == chatRoomId);
    if (idx == -1 || _currentUser == null) return;
    final msg = ChatMessageModel(
      id: 'msg_${DateTime.now().millisecondsSinceEpoch}',
      senderId: _currentUser!.id,
      senderName: _currentUser!.name,
      senderAvatar: _currentUser!.avatarUrl,
      content: content,
      timestamp: DateTime.now(),
      isRead: true,
    );
    _chatRooms[idx].messages.add(msg);
    notifyListeners();
  }

  ChatRoom? getChatRoom(String id) {
    try {
      return _chatRooms.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  List<PostModel> get savedPosts {
    final saved = PrefsService.getSavedPosts();
    return _posts.where((p) => saved.contains(p.id)).toList();
  }

  List<PostModel> get myPosts =>
      _posts.where((p) => p.organizerId == _currentUser?.id).toList();

  bool get canPost {
    final role = _currentUser?.role ?? '';
    return role == 'Club Leader' ||
        role == 'Event Organizer' ||
        role == 'Entrepreneur';
  }
}
