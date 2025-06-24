import 'package:equatable/equatable.dart';

class Despensa extends Equatable {
  final String id;
  final String name;
  final String inviteCode;
  final List<String> adminIds;
  final List<String> memberIds;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Despensa({
    required this.id,
    required this.name,
    required this.inviteCode,
    required this.adminIds,
    required this.memberIds,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, name, inviteCode, adminIds, memberIds, createdAt, updatedAt];
}
