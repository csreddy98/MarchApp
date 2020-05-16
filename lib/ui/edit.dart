import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:march/ui/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path/path.dart' as Path;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Edit_Profile extends StatefulWidget {
  @override
  _Edit_ProfileState createState() => _Edit_ProfileState();
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



class _Edit_ProfileState extends State<Edit_Profile> {

  String Name;
  String uid;
  String image;
//  String DOB="27-05-1997";
  String description;
//  String gender="Male";
  TextEditingController _controller_name,_controller_dob,_controller_bio,_controller_gender,_controller_image;


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
              color: Colors.black,fontSize: 18,fontFamily: 'montserrat'
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
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image:_image==null? NetworkImage(image!=null?image:""):FileImage(_image)
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
                width: size.width/1.2,
                height: size.height/4,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        maxLines: 1,
                        controller: _controller_name,
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
                            Name = value;
                          } catch (exception) {
                            Name="";
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
                      padding: const EdgeInsets.all(12.0),
                      child: TextField(
                        controller: _controller_bio,
                        maxLines: 2,
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

              GestureDetector(
                onTap: () async {

                  if(_image==null){
                    _onLoading();
                    print(image);
                    print(uid+" \n"+description+"\n"+Name);

                  var url = 'https://march.lbits.co/app/api/users/update-user-info.php?uid='+uid+'&fullName='+Name+'&bio='+description+'&profile_pic='+image;
                  var response = await http.get(url);
                  if (response.statusCode == 200) {

                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setString('name', Name);
                    prefs.setString('bio', description);

                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Home()),
                    );

                  } else {
                    print('Request failed with status: ${response.statusCode}.');

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
                    print(uid+" \n"+description+"\n"+Name);
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

                      var url = 'https://march.lbits.co/app/api/users/update-user-info.php?uid='+uid+'&fullName='+Name+'&bio='+description+'&profile_pic='+fileURL;
                      var response = await http.get(url);
                      if (response.statusCode == 200) {

                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('name', Name);
                        prefs.setString('bio', description);
                        prefs.setString('pic', fileURL);

                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );

                      } else {
                        print('Request failed with status: ${response.statusCode}.');

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
                child: Container(
                  width: size.width/3,
                  height: size.height/15,
                  decoration:BoxDecoration(
                      color: Color.fromRGBO(63, 92, 200, 1),
                      borderRadius: BorderRadius.circular(15)
                  ) ,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text("Save Changes",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600
                      ),),
                  ),),
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
    /*    DOB=profile_dob;
        gender=profile_gender;
    */
      });
    }

    _controller_name = new TextEditingController(text: Name);
  //  _controller_dob= new TextEditingController(text: DOB);
    _controller_bio = new TextEditingController(text: description);
    _controller_image = new TextEditingController(text: image);

  /*  _dropdownMenuItems =buildDropDownMenuItems(_gender);
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
