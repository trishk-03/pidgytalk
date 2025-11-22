class ChatRoomModel {
  String chatroomid;
  Map<String, dynamic> participants;
  String lastMessage;

  ChatRoomModel({
    required this.chatroomid,
    required this.participants,
    required this.lastMessage,
  });

  ChatRoomModel.fromMap(Map<String, dynamic> map)
      : chatroomid = map['chatroomid'],
        participants = Map<String, dynamic>.from(map['participants']),
        lastMessage = map['lastMessage'];

  Map<String, dynamic> toMap() {
    return {
      'chatroomid': chatroomid,
      'participants': participants,
      'lastMessage': lastMessage,
    };
  }
}
