import 'dart:convert';

class PendingActionsModel {
  final int? id;
  final String actionType;
  final Map<String, dynamic> payload;

  const PendingActionsModel({
    this.id,
    required this.actionType,
    required this.payload,
  });

  factory PendingActionsModel.fromJson(Map<String, dynamic> json) {
    return PendingActionsModel(
      actionType: json['action_type'],
      payload: jsonDecode(json['payload']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'action_type': actionType, 'payload': payload};
  }
}
