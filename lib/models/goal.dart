

class Goal{

  String _userId;
  String _goalName;
  String _target;
  String _timeFrame;
  String _goalNumber;
  int _id;


  Goal(this._userId,
      this._goalName,
      this._target,
      this._timeFrame,
      this._goalNumber);

  Goal.map(dynamic obj){

    this._userId = obj['userId'];
    this._goalName = obj['goalName'];
    this._target= obj['target'];
    this._timeFrame= obj['timeFrame'];
    this._goalNumber= obj['goalNumber'];
    this._id = obj['id'];

  }


  String get userId=>_userId;
  String get goalName=>_goalName;
  String get target=>_target;
  String get timeFrame=>_timeFrame;
  String get goalNumber=>_goalNumber;
  int get id=>_id;

  Map<String, dynamic> toMap(){

    var map = new Map<String,dynamic>();

    map["userId"]=_userId;
    map["goalName"]=_goalName;
    map["target"]=_target;
    map["timeFrame"]=_timeFrame;
    map["goalNumber"]=_goalNumber;

    if(id!=null) {
      map["id"] = _id;
    }
    return map;
  }

  Goal.fromMap(Map<String,dynamic> map){

    this._userId = map['userId'];
    this._goalName = map['goalName'];
    this._target= map['target'];
    this._timeFrame= map['timeFrame'];
    this._goalNumber= map['goalNumber'];
    this._id = map["id"];

  }

}