import 'package:nerajima/models/search_models.dart';

class WhitelistInvitation {
  late final String invitationId;
  late SearchUser? senderProfile, receiverProfile;

  WhitelistInvitation({required this.invitationId, required this.senderProfile, required this.receiverProfile});

  factory WhitelistInvitation.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? sender = json["senderProfile"], receiver = json["receiverProfile"];
    return WhitelistInvitation(
      invitationId: json["invitationId"],
      senderProfile: sender == null ? null : SearchUser.fromJson(sender),
      receiverProfile: receiver == null ? null : SearchUser.fromJson(receiver),
    );
  }
}

class WhitelistRequest {
  late final String requestId;
  late SearchUser? senderProfile, receiverProfile;

  WhitelistRequest({required this.requestId, required this.senderProfile, required this.receiverProfile});

  factory WhitelistRequest.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic>? sender = json["senderProfile"], receiver = json["receiverProfile"];
    return WhitelistRequest(
      requestId: json["requestId"],
      senderProfile: sender == null ? null : SearchUser.fromJson(sender),
      receiverProfile: receiver == null ? null : SearchUser.fromJson(receiver),
    );
  }
}
