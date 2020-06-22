import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:march/ui/select.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:march/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Register extends StatefulWidget {

  final String phone;
  Register(this.phone);
  @override
  _RegisterState createState() => _RegisterState(phone);
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

class _RegisterState extends State<Register> {

  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();

  _RegisterState(this.phone);

  String dob="";
  String phone;
  String name="";
  String bio="";
  String gender="Male";
  String uid="";
  String email="";
  var now = new DateTime.now();
  String profession="";
  File _image;
  String _uploadedFileURL;


  Future _loadFromGallery() async {
    File _galleryImage;
    _galleryImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = _galleryImage;
    });
  }

  Future _captureImage() async {
    File _caturedImage;

    _caturedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = _caturedImage;
    });
  }

  List<Gender> _gender=Gender.getGender();
  List<DropdownMenuItem<Gender>> _dropdownMenuItems;
  Gender _selectedGender;



  String _value = '';

  Future _selectDate() async {
    DateTime picked = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(1930),
        lastDate: new DateTime(2022)
    );
    if(picked != null) setState(() => _value = picked.toString());
  }

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val){
     setState(() {
       uid=val.uid;
     });
    });

    _dropdownMenuItems =buildDropDownMenuItems(_gender);
    _selectedGender=_dropdownMenuItems[0].value;
    super.initState();
  }

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
  }





  @override
  Widget build(BuildContext context) {

    Widget showImage() {

      if(_image!=null)
      {

        return new Container(
            width: 80.0,
            height: 80.0,
            decoration: new BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              shape: BoxShape.rectangle,
              image: new DecorationImage(
                image:new FileImage(_image),
                fit: BoxFit.cover,
              ),
            ));

      }
      else{

        return  new  Container(
          height: 80,
          width: 80,
          margin: const EdgeInsets.only(bottom: 6.0), //Same as `blurRadius` i guess
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(60.0),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              ),
            ],
          ),
          child: Icon(Icons.camera_alt,size: 50,),
        );

      }

    }

    return Scaffold(
      key:_sk,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text("Registration",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
           child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:15.0),
                child: GestureDetector(
                  onTap: (){
                    _showDialog();
                  },
                  child:showImage(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:5.0),
                child: Center(child: Text("Upload Profile Picture",style: TextStyle(fontSize: 14),)),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                child: TextField(
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                      labelText:"Name",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                  onChanged: (String value) {
                    try {
                      name = value;
                    } catch (exception) {
                      name ="";
                    }
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                child: TextField(
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                      labelText:" Email",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                  onChanged: (String value) {
                    try {
                      email = value;
                    } catch (exception) {
                      email ="";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                child: TextField(
                  maxLines: 1,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                      labelText:"Profession",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                  onChanged: (String value) {
                    try {
                      profession = value;
                    } catch (exception) {
                      profession ="";
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0),
                child: TextField(
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                      labelText:"Bio",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                  onChanged: (String value) {
                    try {
                      bio = value;
                    } catch (exception) {
                      bio ="";
                    }
                  },
                ),
              ),

              /*Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0),
                child: TextField(
                  maxLines: 2,
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black
                  ),
                  decoration: InputDecoration(
                      labelText:"Date of birth",
                      hintText: "dd-mm-yyyy",
                      hintStyle: TextStyle(color: Colors.black26, fontSize: 15.0)),
                  onChanged: (String value) {
                    try {
                      dob = value;
                    } catch (exception) {
                      dob ="";
                    }
                  },
                ),
              ),
*/

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0),
                child: Row(
                  children: <Widget>[
                    _value==''?
                    Expanded(
                      flex: 1,
                      child:SizedBox(
                        width: 100,
                        child: GestureDetector(
                          onTap: (){
                            _selectDate();
                          },
                          child: Text('Date of birth',
                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                            ),),
                        ),
                      ),
                    )
                    :Row(
                    children: <Widget>[
                      Text(_value.substring(8,10)+"-"+_value.substring(5,7)+"-"+_value.substring(0,4)),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: (){
                          _selectDate();
                        },
                      ),
                    ],
                  ),

                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0,10,20.0,0),
                        child: Row(
                          children: <Widget>[
                            Text('Gender: ',style: TextStyle(fontSize: 15),),
                            SizedBox(width: 20,),
                            DropdownButton(
                              value: _selectedGender,
                              items: _dropdownMenuItems,
                              onChanged: onChangeDropDownItem,
                            ),
                          ],
                        ),
                      ),

                    ),



                  ],
                ),

              ),







              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                    child: FlatButton(
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'montserrat'
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.all(15),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
                        onPressed: () async{
                          dob=_value.substring(8,10)+"-"+_value.substring(5,7)+"-"+_value.substring(0,4);
                          print(dob);
                          if(_image==null||name==""||bio==""||dob==""||gender==""||email==""||profession==""){

                            _sk.currentState.showSnackBar(SnackBar(
                              content: Text("All the fields should be filled",
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
                          else{

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
                              /*var url= 'http://march.lbits.co/app/api/index.php';
                                var resp=await http.post(url,body: jsonEncode(<String, dynamic>{
                                  'uid':uid,
                                  'fullName':name,
                                  'email': email,
                                  'phone': Phone,
                                  'bio':  bio,
                                  'dob':dob,
                                  'sex': gender,
                                  'profile_pic': fileURL,
                                  'status':'1',
                                  'subscriptionType':'1',
                                  'createdAt':now.toString(),
                                  'LastModifiedAt':now.toString(),
                                  'token':{
                                    'tokenData':'Random',
                                    'Date' : now.toString(),
                                  }
                                }));
                                   print(resp.body);
*/


                              _uploadedFileURL = fileURL;
                              var url= 'https://march.lbits.co/api/worker.php';
                              var resp=await http.post(url,
                                headers: {
                                  'Content-Type':
                                  'application/json',
                                },
                                body: json.encode(<String, dynamic>
                                {
                                  'serviceName': "generatetoken",
                                  'work': "add user",
                                  'uid':uid,
                                  'userName': name,
                                  'userBio': bio,
                                  'email':email,
                                  'dob':dob,
                                  'gender':gender,
                                  'profession':profession,
                                  'userPic':fileURL,
                                  'phoneNumber': phone,
                                }),
                              );

                              print(resp.body.toString());
                              var result = json.decode(resp.body);
                              if (result['response'] == 200) {

                                var db = new DataBaseHelper();

                                int savedUser =
                                await db.saveUser(new User(uid,name,bio,email,dob,gender,profession,_uploadedFileURL,phone));

                                SharedPreferences prefs = await SharedPreferences.getInstance();
                                prefs.setString('token',result['result']['token']);
                                prefs.setString('id', result['result']['user_info']['id']);
                                prefs.setString('age', result['result']['user_info']['age']);
                                print("user saved :$savedUser");

                                Navigator.pushAndRemoveUntil(context,
                                    MaterialPageRoute(builder: (context) => Select()),
                                        (Route<dynamic> route) => false);

                              }
                              else{

                                Navigator.pop(context);
                                _sk.currentState.showSnackBar(SnackBar(
                                  content: Text(result['response']+result['result'].toString(),
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

                        }
                    ),
                  ),
                ],
              ),




            ],
          ),
        ),
      ),
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

  void _onLoading() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: new Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                new CircularProgressIndicator(),
                new Text("Loading"),
              ],
            ),
          ),
        );
      },
    );
  }

}
