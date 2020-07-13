import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:march/ui/select.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:march/utils/database_helper.dart';
import 'package:march/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GRegister extends StatefulWidget {

  @override
  _GRegisterState createState() => _GRegisterState();
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

class _GRegisterState extends State<GRegister> {

  final GlobalKey<ScaffoldState> _sk=GlobalKey<ScaffoldState>();



  String dob="";
  String phone="";
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

  var _controllername = TextEditingController();
  var _controllerph = TextEditingController();
  var _controlleremail = TextEditingController();


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

  Color nameColor,emailColor,phoneColor,proColor,bioColor;
  Color c=Colors.grey[100];
  Color x=Colors.grey;
  Color nc,ec,phc,prc,bc;

  @override
  void initState() {
    FirebaseAuth.instance.currentUser().then((val){
      setState(() {
        uid=val.uid;
        bioColor=c;
        proColor=c;
        nameColor=c;
        emailColor=c;
        phoneColor=c;
        nc=c;ec=c;phc=c;
        prc=c;bc=c;
        if((val.email!="" && val.email!=null) && (val.displayName!="" && val.displayName!=null)) {
          email=val.email;
          name=val.displayName;
          emailColor=Colors.white;
          nameColor=Colors.white;
          ec=x;
          nc=x;
        }
        if(val.phoneNumber!=""&& val.phoneNumber!=null){
          phone=val.phoneNumber;
          phoneColor=Colors.white;
          phc=x;
        }
        _controlleremail.text=email;
        _controllername.text=name;
        _controllerph.text=phone;
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
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.white,
            border: Border.all(
              color: Colors.grey[300],
              width: 2
            )
          ),
          child: Icon(Feather.camera,size: 30,color:Colors.grey[300]),
        );

      }

    }

    return Scaffold(
      key:_sk,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text('Create Profile', style: TextStyle(fontWeight: FontWeight.w600,letterSpacing: 0)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top:5.0),
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
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        nameColor=Colors.white;
                        nc=x;
                      });
                    },
                    child: TextFormField(
                      controller: _controllername,
                      maxLines: 1,
                      textCapitalization: TextCapitalization.words,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: nameColor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: nc!=null?nc:c, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          border: OutlineInputBorder(),
                          hintText:"Full Name",
                          hintStyle: TextStyle(color: Colors.black26, fontSize: 16.0)),
                      onChanged: (String value) {
                        try {
                          name = value;
                        } catch (exception) {
                          name ="";
                        }
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                child:FocusScope(
                  onFocusChange: (focus) {
                    setState(() {
                      emailColor=Colors.white;
                      ec=x;
                    });
                  },
                  child: TextFormField(
                    maxLines: 1,
                    controller: _controlleremail,
                    keyboardType: TextInputType.emailAddress, 
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.w400
                    ),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor:emailColor,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: ec!=null?ec:c, width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        border: OutlineInputBorder(),
                        hintText:"Email",
                        hintStyle: TextStyle(color: Colors.black26, fontSize: 16.0)),
                    onChanged: (String value) {
                      try {
                        email = value;
                      } catch (exception) {
                        email ="";
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,20,0),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        phoneColor=Colors.white;
                        phc=x;
                      });
                    },
                    child: TextFormField(
                      maxLines: 1,
                      controller: _controllerph,
                      keyboardType: TextInputType.phone,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                      decoration: InputDecoration(
                         filled: true,
                          fillColor: phoneColor,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: phc!=null?phc:c, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          border: OutlineInputBorder(),
                          hintText:"Phone Number",
                          hintStyle: TextStyle(color: Colors.black26, fontSize: 16.0)),
                      onChanged: (String value) {
                        try {
                          phone = value;
                        } catch (exception) {
                          phone ="";
                        }
                      },
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,20,20,20),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        proColor=Colors.white;
                        prc=x;
                      });
                    },
                    child: TextField(
                      maxLines: 1,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: proColor,
                          hintText:"What do you do",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: prc!=null?prc:c, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          border: OutlineInputBorder(),
                          hintStyle: TextStyle(color: Colors.black26, fontSize: 16.0)),
                      onChanged: (String value) {
                        try {
                          profession = value;
                        } catch (exception) {
                          profession ="";
                        }
                      },
                    ),
                  ),
                ),
              ),


              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0.0,20.0,0),
                child: FocusScope(
                  child: Focus(
                    onFocusChange: (focus) {
                      setState(() {
                        bioColor=Colors.white;
                        bc=x;
                      });
                    },
                    child: TextField(
                      maxLines: 3,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                          fontWeight: FontWeight.w400
                      ),
                      decoration: InputDecoration(
                          fillColor: bioColor,
                          filled: true,
                          hintText: "Tell us something about you",
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: bc!=null?bc:c, width: 1.0),
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          ),
                          border: OutlineInputBorder(),
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
                ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(20.0,0.0,0,0),
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
                              fontSize: 16,
                              decoration: TextDecoration.underline,
                            ),),
                        ),
                      ),
                    )
                        :Row(
                      children: <Widget>[
                        Text('DOB: ' + _value.substring(8,10)+"-"+_value.substring(5,7)+"-"+_value.substring(0,4) , style: TextStyle(fontSize: 16),),
                        IconButton(
                          icon: Icon(Icons.edit,size: 16,),
                          onPressed: (){
                            _selectDate();
                          },
                        ),
                      ],
                    ),
                    SizedBox(width: 20,),
                    Expanded(
                      flex: 2,
                      child: Row(
                        children: <Widget>[
                          Text('Gender: ',style: TextStyle(fontSize: 16),),
                          SizedBox(width: 10,),
                          DropdownButton(
                            value: _selectedGender,
                            items: _dropdownMenuItems,
                            onChanged: onChangeDropDownItem,
                          ),
                        ],
                      ),

                    ),



                  ],
                ),

              ),


              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0,20,20,20),
                    child: FlatButton(
                        child: Text(
                          'NEXT',
                          style: Theme.of(context).textTheme.button,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        padding: const EdgeInsets.all(15),
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        onPressed: () async{
                          name=_controllername.text;
                          email=_controlleremail.text;
                          phone=_controllerph.text;
                          dob=_value.substring(8,10)+"-"+_value.substring(5,7)+"-"+_value.substring(0,4);
                          print(dob);
                          if(_image==null||name==""||bio==""||dob==""||gender==""||email==""||phone==""||profession==""){

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

                              print(profession+" "+fileURL);
                              // print(resp.body.toString());

                              var result = json.decode(resp.body);
                              if (result['response'] == 200) {
                                print("This is json decoded result: $result");
                                var db = new DataBaseHelper();
                                int savedUser = await db.saveUser(new User(uid,name,bio,email, dob, gender,profession,_uploadedFileURL,phone));

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

/*
onTap: () async{


                          if(_image==null||name==""||bio==""||dob==""||gender==""||email==""||phone==""||profession==""){

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

                              print(profession+" "+fileURL);
                              // print(resp.body.toString());

                              var result = json.decode(resp.body);
                              if (result['response'] == 200) {
                                print("This is json decoded result: $result");
                                var db = new DataBaseHelper();
                               int savedUser = await db.saveUser(new User(uid,name,bio,email, dob, gender,profession,_uploadedFileURL,phone));

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

                                _sk.currentState.showSnackBar(SnackBar(
                                  content: Text("There is Some Technical Problem Submit again",
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
 */


  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(10.0)),
            child: Container(
              height: 200,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(child: Text("Choose Image",style: TextStyle(fontSize: 20.0,color: Colors.black),)),
                    Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: Center(
                        child: SizedBox(
                          width: 150.0,
                          child: RaisedButton(
                            onPressed: () {
                              _captureImage();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Camera",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                            color: const Color(0xffFFBF46),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:10.0),
                      child: Center(
                        child: SizedBox(
                          width: 150.0,
                          child: RaisedButton(
                            onPressed: (){
                              _loadFromGallery();
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Gallery",
                              style: TextStyle(color: Colors.black, fontWeight: FontWeight.w500),
                            ),
                            color: const Color(0xffFFBF46),
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
