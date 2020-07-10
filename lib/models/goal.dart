

class Goal{

  String _userId;
  String _goalName;
  String _level;
  String _shouldRemind;
  String _remindTime;
  String _goalNumber;
  int _id;


  Goal(this._userId,
      this._goalName,
      this._level,
      this._shouldRemind,
      this._remindTime,
      this._goalNumber);

  Goal.map(dynamic obj){

    this._userId = obj['userId'];
    this._goalName = obj['goalName'];
    this._level= obj['level'];
    this._shouldRemind= obj['shouldRemind'];
    this._remindTime= obj['remindTime'];
    this._goalNumber= obj['goalNumber'];
    this._id = obj['id'];

  }


  String get userId=>_userId;
  String get goalName=>_goalName;
  String get level=>_level;
  String get shouldRemind=>_shouldRemind;
  String get remindTime=>_remindTime;
  String get goalNumber=>_goalNumber;
  int get id=>_id;

  Map<String, dynamic> toMap(){

    var map = new Map<String,dynamic>();

    map["userId"]=_userId;
    map["goalName"]=_goalName;
    map["level"]=_level;
    map["shouldRemind"]=_shouldRemind;
    map["remindTime"]=_remindTime;
    map["goalNumber"]=_goalNumber;

    if(id!=null) {
      map["id"] = _id;
    }
    return map;
  }

  Goal.fromMap(Map<String,dynamic> map){

    this._userId = map['userId'];
    this._goalName = map['goalName'];
    this._level= map['level'];
    this._shouldRemind= map['shouldRemind'];
    this._remindTime= map['remindTime'];
    this._goalNumber= map['goalNumber'];
    this._id = map["id"];

  }

}