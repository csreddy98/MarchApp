class Person {
  String imageUrl;
  String name;
  String age;
  String gender;
  String location;
  String goals;
  String id;
  String bio;
  String profession;

  Person(
      {this.imageUrl,
      this.name,
      this.age,
      this.gender,
      this.location,
      this.goals,
      this.id,
      this.bio,
      this.profession});
}

class OtherPerson {
  int id;
  String name;
  String age;
  String profilePic;
  String sex;
  String profession;
  bool requestSent;
  bool requestReceived;
  bool requestAccepted;

  OtherPerson(
      {this.id,
      this.name,
      this.age,
      this.profilePic,
      this.sex,
      this.profession,
      this.requestSent,
      this.requestReceived,
      this.requestAccepted});
}

class Message {
  int id;
  String sender;
  String receiver;
  String message;
  String containsImage;
  String imageUrl;
  String seenStatus;
  String time;

  Message(
      {this.id,
      this.sender,
      this.receiver,
      this.message,
      this.containsImage,
      this.imageUrl,
      this.seenStatus,
      this.time});
}
