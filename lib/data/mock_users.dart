import '../models/user_model.dart';

final List<UserModel> mockUsers = [
  UserModel(
    id: 'user_1',
    name: 'Amara Diallo',
    email: 'amara.diallo@alustudent.com',
    role: 'Club Leader',
    campus: 'Kigali',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    eventsAttended: 14,
    communitiesJoined: 5,
    connections: 87,
  ),
  UserModel(
    id: 'user_2',
    name: 'Kwame Asante',
    email: 'kwame.asante@alustudent.com',
    role: 'Entrepreneur',
    campus: 'Mauritius',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    eventsAttended: 21,
    communitiesJoined: 7,
    connections: 134,
  ),
  UserModel(
    id: 'user_3',
    name: 'Fatima Nkosi',
    email: 'fatima.nkosi@alustudent.com',
    role: 'Event Organizer',
    campus: 'Kigali',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    eventsAttended: 32,
    communitiesJoined: 9,
    connections: 203,
  ),
  UserModel(
    id: 'user_4',
    name: 'Tolu Adeyemi',
    email: 'tolu.adeyemi@alustudent.com',
    role: 'Student',
    campus: 'Remote',
    avatarUrl: 'https://i.pravatar.cc/150?img=7',
    eventsAttended: 6,
    communitiesJoined: 3,
    connections: 45,
  ),
];

// Default logged-in user (persisted via SharedPreferences in real flow)
final UserModel defaultUser = mockUsers[0];
