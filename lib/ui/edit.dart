import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:march/models/user.dart';
import 'package:march/ui/home.dart';
import 'package:march/utils/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
// import 'dart:convert' as convert;


class Edit_Profile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class Gender{
  int id;
  String gender;

  Gender(this.id,this.gender);

  static List<Gender> getGender(){
    return <Gender> [
      Gender(1,'Male'),
      Gender(2,'Female'),
      Gender(3,'Others'),
    ];
  }
}



class _EditProfileState extends State<Edit_Profile> {

  String name;
  String uid;
  String image;
  String token;
//  String DOB="27-05-1997";
  String description;
  String profession;
//  String gender="Male";
  TextEditingController _controller_name,_controller_bio,_controller_image,_controller_profession;
  String email,gender,dob;
  String phone;

  File _image;
  String _uploadedFileURL;


  Future _loadFromGallery() async {
    final picker=ImagePicker();
    final _galleryImage = await picker.getImage(source: ImageSource.gallery,maxHeight: 1080,maxWidth:1080);

    setState(() {
      _image = File(_galleryImage.path);
    });
  }

  Future _captureImage() async {
    final picker=ImagePicker();
    final _capturedImage = await picker.getImage(source: ImageSource.camera,maxHeight: 1080,maxWidth: 1080);

    setState(() {
      _image = File(_capturedImage.path);
    });
  }

  @override
  void initState() {
     _load();
    super.initState();
  }

/*
  List<Gender> _gender=Gender.getGender();
  List<DropdownMenuItem<Gender>> _dropdownMenuItems;
  Gender _selectedGender;

  List<DropdownMenuItem<Gender>> buildDropDownMenuItems(List genders){
    List<DropdownMenuItem<Gender>> items=List();
    for(Gender gender in genders){
      items.add(DropdownMenuItem(
        value:gender,
        child: Text(gender.gender),
      )
      );
    }
    return items;
  }

  onChangeDropDownItem(Gender selectedGender){
    setState(() {
      _selectedGender=selectedGender;
      gender=selectedGender.gender;
    });
  }*/

  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: _sk,
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text("Edit Profile",
          style: TextStyle(
              color: Colors.black,fontSize: 18,fontFamily: 'Nunito'
          ),),

        centerTitle: true,
        backgroundColor: Colors.white,
      ),

      body: SingleChildScrollView(
        child: Container(
          width: size.width,
          height: size.height,
          color: Colors.grey.withAlpha(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  height: size.height/4.1,
                  width: size.width/2.2,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        alignment: Alignment.center,
                        children: <Widget>[
                          Center(
                           child: Padding(
                            padding: const EdgeInsets.only(bottom: 10,top: 15),
                            child:Container(
                              width: size.width/4,
                              height: size.width/4,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:_image==null? NetworkImage(image!=null?image:"https://w7.pngwing.com/pngs/861/726/png-transparent-computer-icons-professional-avatar-avatar-heroes-public-relations-monochrome.png"):FileImage(_image)
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                                color: Colors.transparent,
                              ),
                            ),

                          ),
                        ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(85,90,0,0),
                            child: GestureDetector(
                              onTap: (){
                                _showDialog();
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle
                                ),
                               child: Image.asset("assets/images/edit.png",height: 18,width: 18,),
                              ),
                            ),
                          )
                        ],
                        overflow: Overflow.visible,)
                    ],
                  ),
                ),
              ),
              Container(
                /*width: size.width/1.2,
                height: size.height/2.8,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),*/
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,12,20,12),
                      child: TextField(
                        maxLines: 1,
                        controller: _controller_name,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),
                          decoration: InputDecoration(
                              hintText: "Name",
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                        onChanged: (String value) {
                          try {
                            name = value;
                          } catch (exception) {
                            name="";
                          }
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,12,20,12),
                      child: TextField(
                        maxLines: 1,
                        controller: _controller_profession,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),
                          decoration: InputDecoration(
                              hintText: "Profession",
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                        onChanged: (String value) {
                          try {
                            profession = value;
                          } catch (exception) {
                            profession="";
                          }
                        },
                      ),
                    ),


                   /* Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: TextField(
                        maxLines: 1,
                        controller: _controller_dob,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18
                        ),
                        decoration: InputDecoration(
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black12),
                          ),
                        ),
                        onChanged: (String value) {
                          try {
                            DOB = value;
                          } catch (exception) {
                            DOB="";
                          }
                        },
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(left: 12,right: 12,top: 15),
                        child: DropdownButton(
                          isExpanded: true,
                          value: _selectedGender,
                          items: _dropdownMenuItems,
                          onChanged: onChangeDropDownItem,
                        ),

                    ),
*/
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20,12,20,12),
                      child: TextField(
                        controller: _controller_bio,
                        maxLines: 2,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 15
                        ),
                          decoration: InputDecoration(
                              hintText: "Bio",
                              border: OutlineInputBorder(),
                              hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                        onChanged: (String value) {
                          try {
                            description = value;
                          } catch (exception) {
                            description="";
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50,),

              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30.0, 20, 30, 0),
                    child: FlatButton(
                      child: Text(
                        'Save Changes',
                        style: Theme.of(context).textTheme.button,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(15),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                      onPressed: () async {

                        if(_image==null){
                          _onLoading();
                          print(image);
                          print(uid+" \n"+description+"\n"+name);


                          var url= 'https://march.lbits.co/api/worker.php';
                          var resp=await http.post(url,
                            headers: {
                              'Content-Type':
                              'application/json',
                              'Authorization':
                              'Bearer $token'
                            },
                            body: json.encode(<String, dynamic>
                            {
                              'serviceName': "",
                              'work': "update user",
                              'uid':uid,
                              'userName': name,
                              'userBio': description,
                              'profession':profession,
                              'userPic': image,
                            }),
                          );

                          print(profession);
                          print(resp.body.toString());

                          var result = json.decode(resp.body);
                          if (result['response'] == 200) {
                            /* var userAge = result['result']['user_info']['age'];
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      prefs.setString('age', userAge);*/
                            var db = new DataBaseHelper();
                            await db.updateUser(User(
                                uid,
                                name,
                                description,
                                email,
                                dob,
                                gender,
                                profession,
                                image,
                                phone));

                            Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => Home('')),
                                    (Route<dynamic> route) => false);

                          }
                          else {

                            _sk.currentState.showSnackBar(SnackBar(
                              content: Text("There is Some Technical Problem Update again",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 15,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(12.0),
                                      topRight: Radius.circular(12.0))),
                              duration: Duration(seconds: 3),
                              backgroundColor: Colors.lightBlueAccent,
                            ));


                          }


                        }
                        else{
                          //here updated img url should be sent
                          print(uid+" \n"+description+"\n"+name);
                          _onLoading();
                          StorageReference storageReference = FirebaseStorage
                              .instance
                              .ref()
                              .child(
                              'profile/${Path.basename(_image.path)}}');
                          StorageUploadTask uploadTask = storageReference
                              .putFile(_image);
                          await uploadTask.onComplete;
                          print('File Uploaded');
                          storageReference.getDownloadURL().then((fileURL) async {
                            _uploadedFileURL = fileURL;

                            var url= 'https://march.lbits.co/api/worker.php';
                            var resp=await http.post(url,
                              headers: {
                                'Content-Type':
                                'application/json',
                                'Authorization':
                                'Bearer $token'
                              },
                              body: json.encode(<String, dynamic>
                              {
                                'serviceName': "",
                                'work': "update user",
                                'uid':uid,
                                'userName': name,
                                'userBio': description,
                                'profession':profession,
                                'userPic': _uploadedFileURL,
                              }),
                            );

                            print(profession);
                            print(resp.body.toString());

                            var result = json.decode(resp.body);
                            if (result['response'] == 200) {
                              var db = new DataBaseHelper();
                              await db.updateUser(User(
                                  uid,
                                  name,
                                  description,
                                  email,
                                  dob,
                                  gender,
                                  profession,
                                  _uploadedFileURL,
                                  phone));

                              Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) => Home('')),
                                      (Route<dynamic> route) => false);

                            }
                            else {

                              _sk.currentState.showSnackBar(SnackBar(
                                content: Text("There is Some Technical Problem Update again",
                                  style: TextStyle(
                                    fontStyle: FontStyle.italic,
                                    fontSize: 15,
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12.0),
                                        topRight: Radius.circular(12.0))),
                                duration: Duration(seconds: 3),
                                backgroundColor: Colors.lightBlueAccent,
                              ));


                            }


                          });


                        }

                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      )
    );
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20.0)),
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("Choose",style: TextStyle(fontSize: 20.0,color: Colors.black),)),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: SizedBox(
                          width: 100.0,
                          child: RaisedButton(
                            onPressed: () {
                              _captureImage();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Camera",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF1BC0C5),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Center(
                        child: SizedBox(
                          width: 100.0,
                          child: RaisedButton(
                            onPressed: (){
                              _loadFromGallery();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Gallery",
                              style: TextStyle(color: Colors.white),
                            ),
                            color: const Color(0xFF1BC0C5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _load() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userToken = prefs.getString('token')??"";

    var db = new DataBaseHelper();
    User user= await db.getUser(1);

    setState(() {
      token=userToken;
      image=user.userPic;
      description=user.userBio;
      name=user.username;
      uid=user.userId;
      profession=user.userProfession;
      email=user.userEmail;
      gender=user.userGender;
      phone=user.userPhone;
      dob=user.userDob;
    });

    _controller_name = new TextEditingController(text: name);
    _controller_bio = new TextEditingController(text: description);
    _controller_image = new TextEditingController(text: image);
    _controller_profession = new TextEditingController(text: profession);

/*
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String profile_pic = prefs.getString('pic')??"";
    String profile_name = prefs.getString('name')??"";
    String profile_bio = prefs.getString('bio')??"";
  //  String profile_dob = prefs.getString('dob')??"";
  //  String profile_gender = prefs.getString('gender')??"";
    String user_uid = prefs.getString('uid')??"";


    if(profile_pic!="" && profile_name!=""&&profile_bio!=""){
      setState(() {
        image=profile_pic;
        description=profile_bio;
        Name=profile_name;
        uid=user_uid;
    */
/*    DOB=profile_dob;
        gender=profile_gender;
    *//*

      });
    }

    _controller_name = new TextEditingController(text: Name);
  //  _controller_dob= new TextEditingController(text: DOB);
    _controller_bio = new TextEditingController(text: description);
    _controller_image = new TextEditingController(text: image);

    _dropdownMenuItems =buildDropDownMenuItems(_gender);
    if(gender=="Male"){
      _selectedGender=_dropdownMenuItems[0].value;
    }
    else if(gender=="Female"){
      _selectedGender=_dropdownMenuItems[1].value;
    }
    else{
      _selectedGender=_dropdownMenuItems[2].value;
    }
*/
  }

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Container(
          color: Colors.white,
          child: Center(
            child: Image.asset(
              "assets/images/animat-rocket-color.gif",
              height: 125.0,
              width: 125.0,
            ),
          ),
        );
      },
    );
  }

}
