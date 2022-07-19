import 'package:nerajima/models/search_models.dart';

class WhitelistInvitation {
  late final String invitationId;
  late SearchUser? senderProfile, receiverProfile;

  WhitelistInvitation({required this.invitationId, required this.senderProfile, required this.receiverProfile});

  factory WhitelistInvitation.fromJson(Map<String, dynamic> json) {
    return WhitelistInvitation(
      invitationId: json["invitationId"],
      senderProfile: json["senderProfile"],
      receiverProfile: json["receiverProfile"],
    );
  }
}

class WhitelistRequest {
  late final String requestId;
  late SearchUser? senderProfile, receiverProfile;

  WhitelistRequest({required this.requestId, required this.senderProfile, required this.receiverProfile});

  factory WhitelistRequest.fromJson(Map<String, dynamic> json) {
    return WhitelistRequest(
      requestId: json["requestId"],
      senderProfile: json["senderProfile"],
      receiverProfile: json["receiverProfile"],
    );
  }
}
