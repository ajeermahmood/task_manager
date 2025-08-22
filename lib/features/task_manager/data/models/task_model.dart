import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Task extends Equatable {
  final String id;
  final String description;
  final bool isCompleted;

  Task({String? id, this.description = '', this.isCompleted = false})
    : id = id ?? const Uuid().v4();

  Task copyWith({String? id, String? description, bool? isCompleted}) {
    return Task(
      id: id ?? this.id,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object> get props => [id, description, isCompleted];
}
