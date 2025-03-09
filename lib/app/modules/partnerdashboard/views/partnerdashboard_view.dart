import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/partnerdashboard_controller.dart';
import 'package:free_y_fi/app/modules/popupmenu/popupmenu.dart';


class PartnerdashboardView extends GetView<PartnerdashboardController> {
  const PartnerdashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        actions: [
          buildPopupMenu(context, controller.addVenueWifi),
        ],
        centerTitle: true,
      ),
      body:SizedBox(
        width: Get.width,
        height: Get.height,
        child: 
        SingleChildScrollView(
          child: Obx(()=>
             Column(
              children: [
               controller.venuedata.isEmpty ? SizedBox(
                height: Get.height - MediaQuery.of(context).padding.top - kToolbarHeight,

                 child: Center(
                   child: Text('No data found'),
                 ),
               ) : ListView.builder(
                 shrinkWrap: true,
                 itemCount: controller.venuedata.length,
                 itemBuilder: (context, index){
                   return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white),
                        color: Colors.lightGreen,
                      ),
                      padding: EdgeInsets.zero,
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      clipBehavior: Clip.antiAlias,
                     child: ExpansionTile(
                              shape: RoundedRectangleBorder(
                                side: BorderSide.none, // Remove the border
                              ),
                      childrenPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                       title: Text(controller.venuedata[index]['ssid']),
                       children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                          children: [
                                            Text('Created At: '),
                                            Text(DateTime.parse(controller
                                                        .venuedata[index]
                                                    ['created_at'].toString()).toLocal().toString().split(' ')[0]),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text('Password: '),
                                            Text(controller.venuedata[index]
                                                ['password'].toString()),
                                          ],
                                        ),
                              ],
                            )
                            ,Expanded(child: 
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: (){
                                    controller.editVenueWifi(index);
                                  },
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: (){
                                    controller.deleteVenue(index);
                                  },
                                ),
                              ],
                            
                            ))
                          ],
                        ),
                       ],
                     ),
                   );
                 }
               ),
              ],
            ),
          ),
        ),
        
      ),
    );
  }
}
