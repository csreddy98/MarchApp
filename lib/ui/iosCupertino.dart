//  if (Platform.isIOS) {
//       showModalBottomSheet(
//           context: context,
//             builder: (BuildContext builder) {
//               return Container(
//                   height: MediaQuery.of(context).copyWith().size.height / 3,
//                   child: CupertinoDatePicker(
                    
//                       initialDateTime: new DateTime(1999, 12, 30),
//                       onDateTimeChanged: (DateTime newdate) {
//                         print(newdate);
//                       },
//                       maximumDate: new DateTime(2010, 12, 30),
//                       minimumYear: 1930,
//                       maximumYear: 2010,
//                       mode: CupertinoDatePickerMode.date,
//                   ));
//             });
//     } else if (Platform.isAndroid) {
//         DateTime picked = await showDatePicker(
//         context: context,
//         initialDate: new DateTime.now(),
//         firstDate: new DateTime(1930),
//         lastDate: new DateTime(2022)
//         );
//         if(picked != null) setState(() => _value = picked.toString());
//     }