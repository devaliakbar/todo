import 'package:equatable/equatable.dart';

class UserInfo extends Equatable {
  final String id;
  final String fullName;

  const UserInfo({required this.id, required this.fullName});

  @override
  List<Object?> get props => [id, fullName];
}
