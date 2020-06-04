
// import 'dart:convert';

// import 'package:flutter_socket_io/flutter_socket_io.dart';
// import 'package:flutter_socket_io/socket_io_manager.dart';

// class SocketHandler{
//   SocketIO socketIO;
  
//   SocketHandler(){
//     socketIO = SocketIOManager().createSocketIO(
//       'https://glacial-waters-33471.herokuapp.com',
//       '/',
//     );
//     socketIO.init();
    
//     socketIO.subscribe('new message', (jsonData) async {
//       // print(jsonData);
//       if (jsonData != "A new user Connected") {
//         var data = jsonDecode(jsonData);
//         print("$data");
//       } else {
//         print("${json.decode(jsonData)}");
//       }
//     });
//     socketIO.sendMessage("chat message", "A new user Connected");
//     socketIO.connect();
//   }

  
// }