class CommunityModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final String campus;
  final String coverImageUrl;
  final String iconUrl;
  final int memberCount;
  final bool isJoined;
  final String leaderId;
  final String leaderName;

  CommunityModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.campus,
    required this.coverImageUrl,
    required this.iconUrl,
    required this.memberCount,
    this.isJoined = false,
    required this.leaderId,
    required this.leaderName,
  });

  CommunityModel copyWith({bool? isJoined, int? memberCount}) {
    return CommunityModel(
      id: id,
      name: name,
      description: description,
      category: category,
      campus: campus,
      coverImageUrl: coverImageUrl,
      iconUrl: iconUrl,
      memberCount: memberCount ?? this.memberCount,
      isJoined: isJoined ?? this.isJoined,
      leaderId: leaderId,
      leaderName: leaderName,
    );
  }
}
