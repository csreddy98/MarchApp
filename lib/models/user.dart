

class User{

  String _userId;
  String _username;
  String _userBio;
  String _userEmail;
  String _userDob;
  String _userGender;
  String _userProfession;
  String _userPic;
  String _userPhone;
  int _id;


  User(
      this._userId,
      this._username,
      this._userBio,
      this._userEmail,
      this._userDob,
      this._userGender,
      this._userProfession,
      this._userPic,
      this._userPhone,
    );

  User.map(dynamic obj){

    this._userId = obj['userId'];
    this._username = obj['userName'];
    this._userBio= obj['userBio'];
    this._userEmail= obj['userEmail'];
    this._userDob= obj['userDob'];
    this._userGender= obj['userGender'];
    this._userProfession= obj['userProfession'];
    this._userPic= obj['userPic'];
    this._userPhone= obj['userPhone'];
    this._id = obj['id'];

  }


    String get userId=>_userId;
    String get username=>_username;
    String get userBio=>_userBio;
    String get userEmail=>_userEmail;
    String get userDob=>_userDob;
    String get userGender=>_userGender;
    String get userProfession=>_userProfession;
    String get userPic=>_userPic;
    String get userPhone=>_userPhone;
    int get id=>_id;

    Map<String, dynamic> toMap(){

      var map = new Map<String,dynamic>();

      map["userId"]=_userId;
      map["userName"]=_username;
      map["userBio"]=_userBio;
      map["userEmail"]=_userEmail;
      map["userDob"]=_userDob;
      map["userGender"]=_userGender;
      map["userProfession"]=_userProfession;
      map["userPic"]=_userPic;
      map["userPhone"]=_userPhone;
      if(id!=null) {
        map["id"] = _id;
      }
      return map;
    }

    User.fromMap(Map<String,dynamic> map){

      this._userId = map['userId'];
      this._username = map['userName'];
      this._userBio= map['userBio'];
      this._userEmail= map['userEmail'];
      this._userDob= map['userDob'];
      this._userGender= map['userGender'];
      this._userProfession= map['userProfession'];
      this._userPic= map['userPic'];
      this._userPhone= map['userPhone'];
      this._id = map["id"];

    }

}