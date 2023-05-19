// import 'dart:convert';
// import 'dart:ffi';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// import '../utils/globalVariables.dart';
// import '../features/mnemonic/ui/mnemonicWordList.dart';
//
// class walletState with ChangeNotifier {
//   static var urlPrefix = GlobalVariables.urlPrefix;
//
//   // List get mnemonicVals=>mnemonicList;
//
//   walletState();
//
//   Future<void> generateMnemonic(BuildContext context) async {
//     final url = Uri.parse('$urlPrefix/create-mnemonic');
//     print("url##: " + url.toString());
//
//     final headers = {"Content-type": "application/json"};
//     final json = jsonEncode({
//       "entropy": "256",
//     });
//     final response = await http.post(url, headers: headers, body: json);
//     if (kDebugMode) {
//       print("url##: " + url.toString());
//       print("jsonData##: " + json.toString());
//       print('Status code: ${response.statusCode}');
//       print('Body: ${response.body}');
//     }
//
//     var mnemonic=response.body;
//     var cleanString=mnemonic.replaceAll('"', '');
//     var mnemonicList =  cleanString.split(' ');
//     print("mnemonicList"+mnemonicList.toString());
//     // notifyListeners();
//
//     Navigator.push(
//       context,
//       MaterialPageRoute(builder: (
//           context) => WordList(mnemonicList)),
//     );
//
//   }
// }
