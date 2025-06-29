import 'package:equatable/equatable.dart';

class CreateDespensaParams extends Equatable {
  final String name;
  final List<String> adminIds;
  final List<String> memberIds;

  const CreateDespensaParams({
    required this.name,
    required this.adminIds,
    required this.memberIds,
  });

  @override
  List<Object?> get props => [name, adminIds, memberIds];
}
