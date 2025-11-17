class ChatRoomModel {
  String ? chatroomid;
  List<String> ? participants;

  // default constructor
  ChatRoomModel({this.chatroomid, this.participants});

  // from map constructor
  ChatRoomModel.fromMap(Map<String, dynamic> map){
    chatroomid = map['chatroomid'];
    participants = map['participants'];
  }

  Map<String, dynamic> toMap(){
    return{
      'chatroomid': chatroomid,
      'participants': participants,
    };
    }
}