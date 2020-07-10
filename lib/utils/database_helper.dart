import 'dart:async';
import 'dart:io';
import 'package:march/models/user.dart';
import 'package:march/models/goal.dart';
import 'package:march/ui/peopleFinder.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseHelper {
  static final DataBaseHelper _instance = new DataBaseHelper.internal();

  factory DataBaseHelper() => _instance;
  static Database _db;

  final String userTable = "userTable";
  final String columnId = "id";
  final String columnUserId = "userId";
  final String columnUsername = "userName";
  final String columnUserBio = "userBio";
  final String columnUserEmail = "userEmail";
  final String columnUserDob = "userDob";
  final String columnUserAge = "userAge";
  final String columnUserGender = "userGender";
  final String columnUserProfession = "userProfession";
  final String columnUserPic = "userPic";
  final String columnUserPhone = "userPhone";

  final String goalTable = "goalTable";
  final String columnGoalName = "goalName";
  final String columnLevel = "level";
  final String columnShouldRemind = "shouldRemind";
  final String remindTime = "remindTime";
  final String columnGoalNumber = "goalNumber";

  final String friendsTable = "myFriends";
  final String friendRowId = "id";
  static String friendId = "user_id";
  static String friendName = "name";
  static String friendSmallPic = "smallPic";
  static String friendNetworkPic = "networkPic";
  static String friendPic = "profile_pic";
  static String friendLastMessage = "lastMessage";
  static String friendLastMessageTime = "LastMessageTime";

  final String messagesTable = "messages";
  final messageId = "messageId";
  static String messageOtherId = "otherId";
  static String messageSentBy = "sentBy";
  static String messageText = "message";
  static String messageContainsImage = "containsImage";
  static String messageImage = "ImageUrl";
  static String seenStatus = "seenStatus";
  static String messageTime = "time";
  static String messageTransportStatus = "msgTransportStatus";
  static String messageCode = "msgCode";

  static String peopleFinderTable = "peopleFinderTable";
  static String peopleFinderRowId = "rowId";
  static String peopleFinderid = "personId";
  static String peopleFinderName = "personName";
  static String peopleFinderAge = "personAge";
  static String peopleFinderGender = "personGender";
  static String peopleFinderBio = "personBio";
  static String peopleFinderProfession = "personProfession";
  static String peopleFinderLocation = "personLocation";
  static String peopleFinderPic = "personPic";

  static String peopleFinderGoalsTable = "peopleFinderGoalsTable";
  static String peopleFinderGoalId = "goalId";
  static String peopleFinderPersonId = "personGoalId";
  static String peopleFinderGoalName = "personGoalName";
  static String peopleFinderGoalLevel = "personGoalLevel";

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }

    _db = await initDb();
    return _db;
  }

  DataBaseHelper.internal();

  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path, "client.db");
    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);

    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute("CREATE TABLE $userTable( $columnId INTEGER PRIMARY KEY,"
        " $columnUserId TEXT,$columnUsername TEXT,"
        " $columnUserBio TEXT,$columnUserEmail TEXT,"
        " $columnUserDob TEXT, $columnUserAge TEXT,$columnUserGender TEXT,"
        " $columnUserProfession TEXT,$columnUserPic TEXT,"
        " $columnUserPhone TEXT"
        ")");

    await db.execute("CREATE TABLE $goalTable( $columnId INTEGER PRIMARY KEY,"
        " $columnUserId TEXT,$columnGoalName TEXT,"
        " $columnLevel TEXT,$columnShouldRemind BOOLEAN,"
        " $remindTime TEXT, $columnGoalNumber TEXT"
        ")");

    await db.execute("CREATE TABLE $friendsTable("
        " $friendRowId INTEGER PRIMARY KEY,"
        " $friendId TEXT, $friendName TEXT, $friendSmallPic TEXT, "
        " $friendPic TEXT, $friendNetworkPic TEXT, $friendLastMessage TEXT,"
        " $friendLastMessageTime TEXT"
        ")");

    await db.execute("CREATE TABLE $messagesTable("
        "$messageId INTEGER PRIMARY KEY AUTOINCREMENT,"
        "$messageCode TEXT UNIQUE NOT NULL,"
        "$messageOtherId TEXT,"
        "$messageSentBy TEXT,"
        "$messageText DATE,"
        "$messageContainsImage BOOLEAN,"
        "$messageImage TEXT,"
        "$seenStatus TEXT,"
        "$messageTransportStatus TEXT, "
        "$messageTime TEXT"
        ")");

    await db.execute("CREATE TABLE $peopleFinderTable("
        "$peopleFinderRowId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$peopleFinderid TEXT NOT NULL, "
        "$peopleFinderName TEXT NOT NULL, "
        "$peopleFinderAge TEXT NOT NULL, "
        "$peopleFinderPic TEXT NOT NULL, "
        "$peopleFinderGender TEXT NOT NULL, "
        "$peopleFinderLocation TEXT NOT NULL, "
        "$peopleFinderProfession TEXT NOT NULL, "
        "$peopleFinderBio TEXT NOT NULL "
        ")");

    await db.execute("CREATE TABLE $peopleFinderGoalsTable("
        "$peopleFinderGoalId INTEGER PRIMARY KEY AUTOINCREMENT, "
        "$peopleFinderPersonId TEXT NOT NULL, "
        "$peopleFinderGoalName TEXT NOT NULL, "
        "$peopleFinderGoalLevel TEXT NOT NULL "
        ")");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$userTable", user.toMap());

    return res;
  }

  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $userTable");

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $userTable"));
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $userTable WHERE $columnId =$id");

    if (result.length == 0)
      return null;
    else
      return new User.fromMap(result.first);
  }

  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(userTable, where: "$columnId=?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(userTable, user.toMap(),
        where: "$columnUserId=?", whereArgs: [user.userId]);
  }

  Future<int> saveGoal(Goal goal) async {
    var dbClient = await db;
    int res = await dbClient.insert("$goalTable", goal.toMap());

    return res;
  }

  Future<List> getAllGoals() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $goalTable");

    return result.toList();
  }

  Future<List> getGoalsName() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT goalName FROM $goalTable");

    return result.toList();
  }

  Future<int> getGoalCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $goalTable"));
  }

  Future<List> getGoal(int id) async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $goalTable");
    return result;
  }

  Future<int> deleteGoal(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(goalTable, where: "$columnId=?", whereArgs: [id]);
  }

  Future<int> updateGoal(Goal goal) async {
    var dbClient = await db;
    return await dbClient.update(goalTable, goal.toMap(),
        where: "$columnId=?", whereArgs: [goal.goalNumber]);
  }

  Future<int> addUser(Map userInfo) async {
    var dbClient = await db;
    return await dbClient.insert(friendsTable, userInfo);
  }

  Future<int> updateLastMessage(Map messageInfo) async {
    var dbClient = await db;
    return await dbClient.rawUpdate(
        "UPDATE $friendsTable SET $friendLastMessage='${messageInfo['message']}', $friendLastMessageTime='${messageInfo['messageTime']}' WHERE $friendId = '${messageInfo['otherId']}'");
  }

  Future<List> checkMessage(String msgCode) async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT COUNT(1) AS msgCount FROM $messagesTable WHERE $messageCode = '$msgCode'");
  }

  Future<int> updateTransportStatus(Map msgInfo) async {
    var dbClient = await db;
    return await dbClient.rawUpdate(
        "UPDATE $messagesTable SET $messageTransportStatus = '${msgInfo['status']}' WHERE $messageCode = '${msgInfo['msgCode']}'");
  }

  Future<int> updateNamePic(Map currentUserInfo) async {
    var dbClient = await db;
    return await dbClient.rawUpdate(
        "UPDATE $friendsTable SET $friendName = '${currentUserInfo['userName']}', $friendPic = '${currentUserInfo['profile_pic']}', $friendSmallPic = '${currentUserInfo['small_pic']}', $friendNetworkPic = '${currentUserInfo['networkImage']}' WHERE $friendId = '${currentUserInfo['userId']}'");
  }

  Future<List> getSingleUser(String userId) async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT COUNT(1) AS user_count, * FROM $friendsTable WHERE $friendId = $userId");
  }

  Future<List> getUsersList() async {
    var dbClient = await db;
    var x = await dbClient.rawQuery(
        "SELECT COUNT(1) as msgCount, $messageOtherId FROM $messagesTable WHERE $seenStatus = 'unseen' GROUP BY $messageOtherId");

    var y = await dbClient.rawQuery(
        "SELECT * FROM $friendsTable ORDER BY $friendLastMessageTime DESC");
    return [x, y];
  }

  Future<int> markAsSeen(userId) async {
    var dbClient = await db;
    return await dbClient.rawUpdate(
        "UPDATE $messagesTable SET $seenStatus = 'seen' WHERE $messageOtherId = $userId");
  }

  Future<List> totalUnseenMsgs() async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT COUNT(1) AS msgCount FROM $messagesTable WHERE $seenStatus = 'unseen'");
  }

  Future<int> addMessage(Map<String, dynamic> messageInfo) async {
    var dbClient = await db;
    return await dbClient.insert(messagesTable, messageInfo);
  }

  Future<List<Map>> getMessage(String userId) async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT * FROM $messagesTable WHERE $messageOtherId = $userId");
  }

  Future deleteUserInfo() async {
    var dbClient = await db;
    return await dbClient.rawDelete("DELETE FROM $userTable");
  }

  Future deleteGoalsInfo() async {
    var dbClient = await db;
    return await dbClient.rawDelete("DELETE FROM $goalTable");
  }

  Future deleteFriendsInfo() async {
    var dbClient = await db;
    return await dbClient.rawDelete("DELETE FROM $friendsTable");
  }

  Future deleteMessages() async {
    var dbClient = await db;
    return await dbClient.rawDelete("DELETE FROM $messagesTable");
  }

  Future<int> deleteMessage(delMessageId) async {
    var dbClient = await db;
    return await dbClient.rawDelete(
        "DELETE FROM $messagesTable WHERE $messageId = $delMessageId");
  }

  Future<int> deletePersonMessages(delUserId) async {
    var dbClient = await db;
    return await dbClient.rawDelete(
        "DELETE FROM $messagesTable WHERE $messageOtherId = $delUserId");
  }

  Future<List> getUnseenMessages(String userId) async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT COUNT(1) as newMessages FROM $messagesTable WHERE $messageOtherId = $userId AND $seenStatus = 'unseen'");
  }

  Future<int> insertPersonForPeopleFinder(peopleFinderInfo) async {
    var dbClient = await db;
    return await dbClient.insert(peopleFinderTable, peopleFinderInfo);
  }

  Future<List<Map>> getPeopleFinderPeople() async {
    var dbClient = await db;
    return await dbClient.rawQuery("SELECT * FROM $peopleFinderTable");
  }

  Future<List> getPersonWithId(personId) async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT COUNT(1) as personCount FROM $peopleFinderTable WHERE $peopleFinderid = '$personId'");
  }

  Future<int> addPersonGoal(goalInfo) async {
    var dbClient = await db;
    return await dbClient.insert(peopleFinderGoalsTable, goalInfo);
  }

  Future<int> peopleFinderRemovePerson(personId) async {
    var dbClient = await db;
    return await dbClient.rawDelete(
        "DELETE FROM $peopleFinderTable WHERE $peopleFinderid = '$personId'");
  }

  Future<List> selectGoals(personId) async {
    var dbClient = await db;
    return await dbClient.rawQuery(
        "SELECT * FROM $peopleFinderGoalsTable WHERE $peopleFinderPersonId = '$personId'");
  }

  Future<int> removePersonGoals(personId) async {
    var dbClient = await db;
    return await dbClient.rawDelete(
        "DELETE FROM $peopleFinderGoalsTable WHERE $peopleFinderPersonId = '$personId'");
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
