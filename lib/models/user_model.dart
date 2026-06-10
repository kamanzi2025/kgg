class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String campus;
  final String avatarUrl;
  final int eventsAttended;
  final int communitiesJoined;
  final int connections;
  final List<String> savedPostIds;
  final List<String> rsvpPostIds;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.campus,
    required this.avatarUrl,
    this.eventsAttended = 0,
    this.communitiesJoined = 0,
    this.connections = 0,
    this.savedPostIds = const [],
    this.rsvpPostIds = const [],
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? role,
    String? campus,
    String? avatarUrl,
    int? eventsAttended,
    int? communitiesJoined,
    int? connections,
    List<String>? savedPostIds,
    List<String>? rsvpPostIds,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      campus: campus ?? this.campus,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      eventsAttended: eventsAttended ?? this.eventsAttended,
      communitiesJoined: communitiesJoined ?? this.communitiesJoined,
      connections: connections ?? this.connections,
      savedPostIds: savedPostIds ?? this.savedPostIds,
      rsvpPostIds: rsvpPostIds ?? this.rsvpPostIds,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'campus': campus,
      'avatarUrl': avatarUrl,
      'eventsAttended': eventsAttended,
      'communitiesJoined': communitiesJoined,
      'connections': connections,
      'savedPostIds': savedPostIds,
      'rsvpPostIds': rsvpPostIds,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      role: map['role'] ?? 'Student',
      campus: map['campus'] ?? 'Kigali',
      avatarUrl: map['avatarUrl'] ?? '',
      eventsAttended: map['eventsAttended'] ?? 0,
      communitiesJoined: map['communitiesJoined'] ?? 0,
      connections: map['connections'] ?? 0,
      savedPostIds: List<String>.from(map['savedPostIds'] ?? []),
      rsvpPostIds: List<String>.from(map['rsvpPostIds'] ?? []),
    );
  }
}
