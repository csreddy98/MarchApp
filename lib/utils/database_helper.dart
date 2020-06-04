import 'dart:async';
import 'dart:io';
import 'package:march/models/user.dart';
import 'package:march/models/goal.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DataBaseHelper{

  static final DataBaseHelper _instance = new DataBaseHelper.internal();

  factory DataBaseHelper()=>_instance;
  static Database _db;

  final String userTable = "userTable";
  final String columnId = "id";
  final String columnUserId = "userId";
  final String columnUsername = "userName";
  final String columnUserBio = "userBio";
  final String columnUserEmail = "userEmail";
  final String columnUserDob = "userDob";
  final String columnUserGender = "userGender";
  final String columnUserProfession = "userProfession";
  final String columnUserPic = "userPic";
  final String columnUserPhone = "userPhone";

  final String goalTable = "goalTable";
  final String columnGoalName = "goalName";
  final String columnTarget = "target";
  final String columnTimeFrame = "timeFrame";
  final String columnGoalNumber = "goalNumber";

  final String usersTable = "usersTable";
  final String columnOtherUserId = "userId";
  final String columnUserName = "userName";
  final String columnUserDOB = "DOB";
  final String columnprofilePic = "profilePic";
  final String columnSex = "sex";
  final String columnProfession = "profession";
  final String columnRequestSent = "requestSent";
  final String columnRequestReceived = "requestReceived";
  final String columnRequestAccepted = "requestAccepted";


  Future<Database> get db async{


    if(_db!=null){

      return _db;

    }

    _db = await initDb();
    return _db;
  }


  DataBaseHelper.internal();

  initDb() async{

    Directory documentDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentDirectory.path,"client.db");
    var ourDb =await openDatabase(path,version: 1,onCreate: _onCreate);

    return ourDb;
  }

  void _onCreate(Database db, int newVersion) async{


    await db.execute(

   "CREATE TABLE $userTable( $columnId INTEGER PRIMARY KEY,"
       " $columnUserId TEXT,$columnUsername TEXT,"
       " $columnUserBio TEXT,$columnUserEmail TEXT,"
       " $columnUserDob TEXT,$columnUserGender TEXT,"
       " $columnUserProfession TEXT,$columnUserPic TEXT,"
       " $columnUserPhone TEXT"
       ")" );

    await db.execute(

        "CREATE TABLE $goalTable( $columnId INTEGER PRIMARY KEY,"
            " $columnUserId TEXT,$columnGoalName TEXT,"
            " $columnTarget TEXT,$columnTimeFrame TEXT,"
            " $columnGoalNumber TEXT"
            ")" );

    await db.execute(
      "CREATE TABLE $usersTable("
      "id INTEGER AUTO_INCREMENT PRIMARY KEY,"
      "$columnOtherUserId INTEGER,"
      "$columnUserName TEXT,"
      "$columnUserDOB DATE,"
      "$columnSex TEXT,"
      "$columnProfession TEXT,"
      "$columnRequestSent BOOLEAN,"
      "$columnRequestReceived BOOLEAN,"
      "$columnRequestAccepted BOOLEAN"
      ")"
    );
  }


  Future<int> saveUser(User user) async{

  var dbClient = await db;
  int res = await dbClient.insert("$userTable", user.toMap());

   return res;
  }

  Future<List> getAllUsers() async{

    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $userTable");

    return result.toList();
  }

  Future<int> getCount() async{

    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM $userTable"));
   }

   Future<User> getUser(int id) async{

    var dbClient = await db;
    var result = await dbClient.rawQuery(
      "SELECT * FROM $userTable WHERE $columnId =$id"
    );

    if(result.length==0) return null;
    else return new User.fromMap(result.first);
   }


   Future<int> deleteUser(int id) async{

    var dbClient = await db;
    return await dbClient.delete(userTable,where: "$columnId=?",whereArgs: [id]);
   }

   Future<int> updateUser(User user) async{
   var dbClient =await db;
    return await dbClient.update(userTable, user.toMap(),where: "$columnUserId=?",whereArgs: [user.userId]);

   }

  Future<int> saveGoal(Goal goal) async{

    var dbClient = await db;
    int res = await dbClient.insert("$goalTable", goal.toMap());

    return res;
  }

  Future<List> getAllGoals() async{

    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $goalTable");

    return result.toList();
  }

  Future<int> getGoalCount() async{

    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT(*) FROM $goalTable"));
  }

  Future<Goal> getGoal(int id) async{

    var dbClient = await db;
    var result = await dbClient.rawQuery(
        "SELECT * FROM $goalTable WHERE $columnId =$id"
    );

    if(result.length==0) return null;
    else return new Goal.fromMap(result.first);
  }


  Future<int> deleteGoal(int id) async{

    var dbClient = await db;
    return await dbClient.delete(goalTable,where: "$columnId=?",whereArgs: [id]);
  }

  Future<int> updateGoal(Goal goal) async{
    var dbClient =await db;
    return await dbClient.update(goalTable, goal.toMap(),where: "$columnId=?",whereArgs: [goal.goalNumber]);
  }


  Future<int> getUsers(userInfo) async {
    var dbClient = await db;
    return await dbClient.insert(usersTable, userInfo.toMap());
  }


  Future close() async{

    var dbClient = await db;
    return dbClient.close();

   }


}