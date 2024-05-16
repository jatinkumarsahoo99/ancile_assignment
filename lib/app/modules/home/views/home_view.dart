import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../edit_dialog.dart';

class HomeView extends StatelessWidget {
   HomeView({super.key});

  final HomeController controller = Get.put<HomeController>(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: GetBuilder<HomeController>(
          id: "all",
          builder: (controller) {
            return (controller.users.isNotEmpty)?Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: controller.users.length,
                itemBuilder: (context, index) {
                  final user = controller.users[index];
                  if (index == 0) {
                    return Column(
                      children: [
                        Card(
                          color: Colors.blue,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return InkWell(
                                    onTap: (controller.isUserSelected.value ==
                                        true)
                                        ? () {
                                      controller.deleteUser();
                                    }
                                        : null,
                                    child: Icon(
                                      Icons.delete,
                                      color:
                                      (controller.isUserSelected.value ==
                                          true)
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  );
                                }),
                                InkWell(
                                    onTap: () {
                                      controller.sortUsers();
                                    },
                                    child: const Icon(Icons.sort,
                                        color: Colors.white)),
                                InkWell(
                                  onTap: (){
                                    controller.getYoungestUser();
                                  },
                                  child: const Icon(Icons.filter_list_alt,
                                      color: Colors.white),
                                ),
                                InkWell(
                                    onTap: () {
                                      controller.fetchAllUser();
                                    },
                                    child: const Icon(Icons.filter_list_off,
                                        color: Colors.white)),
                                Obx(() {
                                  return InkWell(
                                    onTap: (controller.isUserSelected.value ==
                                        true)
                                        ? () async {
                                      await showDialog(
                                          context: context,
                                          builder: (context) =>
                                              EditUserDialog(
                                                onSave: (name, age) {
                                                  debugPrint(">>>>>>>>>>>>>>>>$name $age");
                                                  controller.editUser(name,age);
                                                },
                                              ));
                                    }
                                        : null,
                                    child: Icon(
                                      Icons.edit,
                                      color:
                                      (controller.isUserSelected.value ==
                                          true)
                                          ? Colors.white
                                          : Colors.grey,
                                    ),
                                  );
                                }),

                                InkWell(
                                    onTap: () {
                                      controller.getData(apiCallSta: false);
                                    },
                                    child: const Icon(Icons.refresh,
                                        color: Colors.white)),
                              ],
                            ),
                          ),
                        ),
                        Card(
                          child: ListTile(
                            title: Text(user.fullName),
                            subtitle: Text('Age: ${user.age}'),
                            leading: Checkbox(
                              value: user.isSelected,
                              onChanged: (value) =>
                                  controller.toggleSelection(user),
                            ),

                            // onTap: () => controller.toggleSelection(user),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Card(
                      child: ListTile(
                        key: UniqueKey(),
                        title: Text(user.fullName),
                        subtitle: Text('Age: ${user.age}'),
                        leading: Checkbox(
                          value: user.isSelected,
                          onChanged: (value) =>
                              controller.toggleSelection(user),
                        ),
                        // onTap: () => controller.toggleSelection(user),
                      ),
                    );
                  }
                },
              ),
            ):const Center(
              child: Text("Loading............."),
            );
          }),
    );
  }
}
