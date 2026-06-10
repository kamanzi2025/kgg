class PostModel {
  final String id;
  final String title;
  final String description;
  final String organizerName;
  final String organizerId;
  final String organizerAvatar;
  final String category;
  final String type; // 'event' or 'opportunity'
  final String campus;
  final String location;
  final DateTime date;
  final DateTime deadline;
  final String coverImageUrl;
  final int rsvpCount;
  final int interestedCount;
  final int maxParticipants;
  final bool isFeatured;
  final List<String> tags;

  PostModel({
    required this.id,
    required this.title,
    required this.description,
    required this.organizerName,
    required this.organizerId,
    required this.organizerAvatar,
    required this.category,
    required this.type,
    required this.campus,
    required this.location,
    required this.date,
    required this.deadline,
    required this.coverImageUrl,
    this.rsvpCount = 0,
    this.interestedCount = 0,
    this.maxParticipants = 100,
    this.isFeatured = false,
    this.tags = const [],
  });

  PostModel copyWith({
    int? rsvpCount,
    int? interestedCount,
  }) {
    return PostModel(
      id: id,
      title: title,
      description: description,
      organizerName: organizerName,
      organizerId: organizerId,
      organizerAvatar: organizerAvatar,
      category: category,
      type: type,
      campus: campus,
      location: location,
      date: date,
      deadline: deadline,
      coverImageUrl: coverImageUrl,
      rsvpCount: rsvpCount ?? this.rsvpCount,
      interestedCount: interestedCount ?? this.interestedCount,
      maxParticipants: maxParticipants,
      isFeatured: isFeatured,
      tags: tags,
    );
  }

  // Days until deadline
  int get daysUntilDeadline => deadline.difference(DateTime.now()).inDays;

  bool get isUrgent => daysUntilDeadline <= 3 && daysUntilDeadline >= 0;
  bool get isExpired => daysUntilDeadline < 0;
}
