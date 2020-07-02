import 'dart:ui';

import 'package:image/image.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

Future<Map> imageSaver(url) async {
  var resp = await http.get(url);
  var documentDirectory = await getApplicationDocumentsDirectory();
  var userProfilePicsDir = documentDirectory.path + "/images/profile_pics";
  var userSmallProfilePicsDir =
      documentDirectory.path + "/images/small_profile_pics";
  var imagepath = userProfilePicsDir + "/${DateTime.now()}.jpg";
  var smallImagepath = userSmallProfilePicsDir + '/${DateTime.now()}.jpg';
  await Directory(userProfilePicsDir).create(recursive: true);
  await Directory(userSmallProfilePicsDir).create(recursive: true);
  File image = new File(imagepath);
  image.writeAsBytesSync(resp.bodyBytes);

  Image imageEncoded = decodeImage(image.readAsBytesSync());
  Image thumbNail = copyResize(imageEncoded, width: 100, height: 100);
  File('$smallImagepath')..writeAsBytesSync(encodeJpg(thumbNail));
  return {'image': '$imagepath', 'small_image': '$smallImagepath'};
}
