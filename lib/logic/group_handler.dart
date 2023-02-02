// import 'dart:convert';

// import '/logic/file_handler.dart';
// import '/model/my_group.dart';

// class GroupHandler {
//   final FileHandler _fileHandler = FileHandler();
//   Future<void> addFlowDeviceToGroup(String deviceId, int groupId, int index) async {
//     List<MyGroup> groups = await getGroups();

//     int groupIndex = groups.indexWhere((element) => element.id == groupId);
//     if (groupIndex != -1) {
//       try {
//         groups[groupIndex].flowDeviceIds[index] = deviceId;
//       } catch (e) {
//         print('Error $e');
//       }
//       await _fileHandler.writeFile(JsonFileName.groupsJsonFile, jsonEncode(groups));
//     }
//   }

//   Future<void> addEnergyDeviceToGroup(String deviceId, int groupId, int index) async {
//     List<MyGroup> groups = await getGroups();

//     int groupIndex = groups.indexWhere((element) => element.id == groupId);
//     if (groupIndex != -1) {
//       try {
//         groups[groupIndex].energyDeviceIds[index] = deviceId;
//       } catch (e) {
//         print('Error $e');
//       }
//       print(groups.map((e) => '${e.title}, ${e.energyDeviceIds}, ${e.flowDeviceIds} '));
//       await _fileHandler.writeFile(JsonFileName.groupsJsonFile, jsonEncode(groups));
//     }
//   }

//   Future<void> removeFlowDeviceFromGroup(String deviceId, int groupId) async {
//     List<MyGroup> groups = await getGroups();

//     int groupIndex = groups.indexWhere((element) => element.id == groupId);
//     if (groupIndex != -1) {
//       try {
//         int index = groups[groupIndex].flowDeviceIds.indexWhere((element) => element == deviceId);
//         if (index != -1) groups[groupIndex].flowDeviceIds[index] = '';
//       } catch (e) {
//         print('Error $e');
//       }
//       await _fileHandler.writeFile(JsonFileName.groupsJsonFile, jsonEncode(groups));
//     }
//   }

//   Future<void> removeEnergyDeviceFromGroup(String deviceId, int groupId) async {
//     List<MyGroup> groups = await getGroups();

//     int groupIndex = groups.indexWhere((element) => element.id == groupId);
//     if (groupIndex != -1) {
//       try {
//         int index = groups[groupIndex].energyDeviceIds.indexWhere((element) => element == deviceId);
//         if (index != -1) groups[groupIndex].energyDeviceIds[index] = '';
//       } catch (e) {
//         print('Error $e');
//       }
//       await _fileHandler.writeFile(JsonFileName.groupsJsonFile, jsonEncode(groups));
//     }
//   }

//   Future<void> editGroup(MyGroup newGroup) async {
//     List<MyGroup> groups = await getGroups();

//     int groupIndex = groups.indexWhere((element) => element.id == newGroup.id);
//     if (groupIndex != -1) {
//       groups[groupIndex] = newGroup;
//       await _fileHandler.writeFile(JsonFileName.groupsJsonFile, jsonEncode(groups));
//     }
//   }

//   Future<List<MyGroup>> getGroups() async {
//     String jsonString = await _fileHandler.readFile(JsonFileName.groupsJsonFile);

//     List<dynamic> jsonData = jsonDecode(jsonString);
//     List<MyGroup> groups = jsonData.map<MyGroup>((e) => MyGroup.fromJson(e)).toList();
//     return groups;
//   }

//   Future<MyGroup?> getGroup(int groupId) async {
//     String jsonString = await _fileHandler.readFile(JsonFileName.groupsJsonFile);

//     List<dynamic> jsonData = jsonDecode(jsonString);
//     List<MyGroup> groups = jsonData.map<MyGroup>((e) => MyGroup.fromJson(e)).toList();
//     int groupIndex = groups.indexWhere((element) => element.id == groupId);
//     if (groupIndex != -1) {
//       return groups[groupIndex];
//     }
//     return null;
//   }

//   Future<void> deleteGroup(int groupId) async {
//     List<MyGroup> groups = await getGroups();

//     int groupIndex = groups.indexWhere((element) => element.id == groupId);
//     if (groupIndex != -1) {
//       groups.removeAt(groupIndex);
//       await _fileHandler.writeFile(JsonFileName.groupsJsonFile, jsonEncode(groups));
//     }
//   }
// }
