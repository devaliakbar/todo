import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String id;
  final String fullName;
  final String? profilePic;

  const UserInfo(
      {required this.id, required this.fullName, required this.profilePic});

  @override
  List<Object?> get props => [id, fullName, profilePic];
}
