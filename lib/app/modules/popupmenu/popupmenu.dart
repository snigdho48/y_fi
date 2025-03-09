

import 'package:flutter/material.dart';
import 'package:free_y_fi/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

Widget buildPopupMenu(BuildContext context, addVenueWifi) {
  final storage = GetStorage();
  return PopupMenuButton(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all(Colors.transparent),
    ),
    constraints: BoxConstraints(

      maxWidth: 50,
      
    ),
    padding: EdgeInsets.zero,
    position: PopupMenuPosition.under,
    icon: Icon(Icons.more_vert),
      offset: Offset(-20, 0),
      color: Colors.black,
    itemBuilder: (context) => [
      PopupMenuItem(
        child: Icon(Icons.person_2_rounded),
        value: 1,
      ),
      PopupMenuItem(
        child: Icon(Icons.add),
        value: 2,
      ),
      PopupMenuItem(
        child: Icon(Icons.logout),
        value: 3,
      ),
    ],
    onSelected: (value) {
      switch (value) {
        case 1:
         Get.toNamed('/profile');
          break;
        case 2:
          addVenueWifi();
          break;
        case 3:
          storage.erase();
          Get.offAllNamed(Routes.USERLOGIN);
          break;
      }
    },
  );
}