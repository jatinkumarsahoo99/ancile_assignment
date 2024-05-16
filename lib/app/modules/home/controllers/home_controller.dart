import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../data/db/object_obx.dart';
import '../../../data/user_model.dart';
import '../../../provider/http_methods.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final count = 0.obs;
  List<User> users = [
    /* User(fullName: "John Doe", age: 30),
    User(fullName: "Jane Smith", age: 25),
    User(fullName: "Michael Brown", age: 40),*/
  ];
  bool isAscending = true; // Sorting order flag
  List<User> selectedUsers = [];


  getYoungestUser(){
    objectBox?.getTwoYoungestUsers().then((value) {
      users = value??[];
      update(['all']);
    });
  }

  void sortUsers() {
    users.sort((a, b) => (isAscending ? a.fullName : b.fullName).toLowerCase()
        .compareTo((isAscending ? b.fullName : a.fullName).toLowerCase()));
    isAscending = !isAscending;
    update(['all']);
  }

  void showYoungest() {
    users.sort((a, b) => a.age.compareTo(b.age));
    selectedUsers = users.sublist(0, 2);
    update(['all']); // Get the two youngest
  }

  void toggleSelection(User user) {
    final index = users.indexOf(user);
    if (index != -1) {
      users[index].isSelected = !users[index].isSelected;
      if (users[index].isSelected) {
        selectedUsers.add(user);
      } else {
        selectedUsers.remove(user);
      }
    }
    objectBox?.saveData([user]);

    update(['all']);
  }



  HttpMethodsDio httpMethodsDio = HttpMethodsDio();

  getData({bool apiCallSta = true}) {
    if (apiCallSta) {
      try {
        ObjectBox.create().then((box) async {
          objectBox = box;

          bool sta = await objectBox?.isDataAvailable() ?? false;

          if (sta == false) {
            callApi();
          } else {
            objectBox?.getAllUser().then((value) {
              users.clear();
              users = value;
              listUser();
              update(['all']);
              debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>$value");
            });
          }
        });
      } catch (e) {
        debugPrint(">>>>>>Exception$e");
      }
    } else {
      callApi();
    }
  }

  callApi() {
    try {
      httpMethodsDio.getMethod(
          api: "https://randomuser.me/api",
          fun: (map) {
            if (map is Map &&
                map['results'] != null &&
                map['results'].length > 0) {
              users.clear();
              map['results'].forEach((e) {
                users.add(User.fromJson(e as Map<String, dynamic>));
                users.addAll([
                  User(fullName: "John Doe", age: 30),
                  User(fullName: "Jane Smith", age: 25),
                  User(fullName: "Michael Brown", age: 40),
                ]);
                objectBox?.clearAllData();
                objectBox?.saveData(users);
                listUser();
                update(['all']);
              });
            }
          });
    } catch (e) {
      debugPrint(">>>>>>Exception$e");
    }
  }

  ObjectBox? objectBox;
  Rx<bool> isUserSelected = Rx<bool>(false);

  listUser() {
    Stream<List<User>> selectedUsersStream = objectBox!.getSelectedUsers();
    selectedUsersStream.listen((users) {
      debugPrint(">>>>>>>>>>>>>>>>>>>users$users");
      if (users.isNotEmpty) {
        isUserSelected.value = true;
        isUserSelected.refresh();
        selectedUsers = users;
      } else {
        isUserSelected.value = false;
        isUserSelected.refresh();
        selectedUsers = users;
      }
    });
  }

  editUser(String name,int age){
    for (var element in selectedUsers) {
      element.fullName = name;
      element.age = age;
    }
    objectBox?.saveData(selectedUsers);

    objectBox?.getAllUser().then((value) {
      users.clear();
      users = value;
      update(['all']);
      debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>$value");
    });
  }

  fetchAllUser(){
    objectBox?.getAllUser().then((value) {
      users.clear();
      users = value;
      update(['all']);
      debugPrint(">>>>>>>>>>>>>>>>>>>>>>>>$value");
    });
  }

  deleteUser(){
    for (var element in selectedUsers) {
      objectBox?.deleteUserById(element.id);
    }
    fetchAllUser();
  }

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
