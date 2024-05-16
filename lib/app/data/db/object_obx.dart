import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../../../objectbox.g.dart';
import '../user_model.dart';

class ObjectBox {
  /// The Store of this app.
  late final Store _store;

  /// A Box of notes.
  late final Box<User> _userBox;

  ObjectBox._create(this._store) {
    _userBox = Box<User>(_store);
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    final store = await openStore(
        directory:
            p.join((await getApplicationDocumentsDirectory()).path, "obx-user"),
        macosApplicationGroup: "objectbox.user");
    return ObjectBox._create(store);
  }

  void putDemoData() {
    final demoNotes = [
      User(fullName: "", age: 0),
    ];
    _userBox.putManyAsync(demoNotes);
  }

  saveData(List<User>? data) {
    if (data != null && data.isNotEmpty) {
      _userBox.putMany(data);
    }
  }

  Future<List<User>?> getTwoYoungestUsers() async {
    final query = _userBox.query().order(User_.age,).build();
    final results = query.find();
    return results.take(2).toList();
  }

  Stream<List<User>> getSelectedUsers() {
    final builder = _userBox
        .query(User_.isSelected.equals(true) // Use equals() instead of equal
            );
    return builder.watch(triggerImmediately: true).map((query) => query.find());
  }

  int getSelectedUsersCount() {
    final query = _userBox.query(User_.isSelected.equals(true)).build();
    final count = query.count();
    return count;
  }

  clearAllData() {
    int count = _userBox.removeAll();
    debugPrint(">>>>>>>>>>>>>>>>>>>deleteCount$count");
  }

  Stream<List<User>> getUsers() {
    final builder =
        _userBox.query().order(User_.fullName, flags: Order.descending);
    return builder
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  Future<List<User>> getAllUser() async {
    try {
      List<User> allUsers = await _userBox.getAllAsync();
      return allUsers;
    } catch (e) {
      return [];
    }
  }

  deleteUserById(dynamic id) {
    _userBox.remove(id);
  }


  Future<bool> isDataAvailable() async {
    final count = _userBox.count();
    debugPrint(">>>>>>>>>>>>>>>>count$count");
    return count > 0;
  }
}
