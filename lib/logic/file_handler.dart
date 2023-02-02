// import 'dart:io';
// import 'package:path_provider/path_provider.dart';

// enum JsonFileName {
//   groupsJsonFile,
// }

// class FileHandler {
//   Future<String> get _localPath async {
//     final directory = await getApplicationDocumentsDirectory();

//     return directory.path;
//   }

//   Future<File> _getLocalFile(JsonFileName fileName) async {
//     final path = await _localPath;
//     return File('$path/${fileName.name}.json');
//   }

//   Future<File> addObjectToJsonListFile(JsonFileName fileName, String jsonString) async {
//     String fileJson = await readFile(fileName);
//     var newJsonString = '';
//     if (fileJson.length > 3) {
//       newJsonString = fileJson.substring(0, fileJson.length - 2);
//       newJsonString += '},$jsonString]';
//     } else {
//       newJsonString = '[$jsonString]';
//     }
//     // fileJson.
//     final file = await _getLocalFile(fileName);
//     return file.writeAsString(newJsonString);
//   }

//   Future<File> writeFile(JsonFileName fileName, String jsonString) async {
//     final file = await _getLocalFile(fileName);
//     return file.writeAsString(jsonString);
//   }

//   Future<String> readFile(JsonFileName fileName) async {
//     try {
//       final file = await _getLocalFile(fileName);
//       bool fileExists = await file.exists();
//       String jsonContents;
//       if (fileExists) {
//         jsonContents = await file.readAsString();
//       } else {
//         await writeFile(fileName, '');
//         jsonContents = '';
//       }
//       return jsonContents;
//     } catch (e) {
//       print('Error getting content from ${fileName.name}');
//       return '';
//     }
//   }

//   // exportData(BuildContext context, String ingredientFileName,
//   //     String mealFileName) async {
//   //   final path = await _localPath;
//   //   String mergedJson = '';

//   //   String ingredientJson = await readFile(ingredientFileName);
//   //   String mealJson = await readFile(mealFileName);

//   //   mergedJson = ingredientJson + '&&&' + mealJson;
//   //   writeFile('profitCalculatorBackup', mergedJson);

//   //   await Share.shareFiles(
//   //     ['$path/profitCalculatorBackup.json'],
//   //     subject: 'Profit Calculator Backup',
//   //   );
//   // }

//   // importData() async {
//   //   final String ingredientJsonFile = config.ingredientJsonFile;
//   //   final String mealJsonFile = config.mealJsonFile;

//   //   FilePickerResult result = await FilePicker.platform
//   //       .pickFiles(type: FileType.custom, allowedExtensions: ['json']);
//   //   File file;
//   //   if (result != null) {
//   //     file = File(result.files.single.path);
//   //   //print(file.readAsString());
//   //   } else {
//   //     return;
//   //   }
//   //   String mergedJson = await file.readAsString();
//   //   List<String> splitJson = mergedJson.split('&&&');
//   //   String ingredientJson = splitJson[0];
//   //   String mealJson = splitJson[1];
//   //   writeFile(ingredientJsonFile, ingredientJson);
//   //   writeFile(mealJsonFile, mealJson);
//   // }
// }
