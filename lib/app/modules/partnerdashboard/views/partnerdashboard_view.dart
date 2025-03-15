import 'package:flutter/material.dart';
import 'package:free_y_fi/app/modules/webview/adwebview.dart';

import 'package:get/get.dart';

import '../controllers/partnerdashboard_controller.dart';
// import 'package:free_y_fi/app/modules/popupmenu/popupmenu.dart';

class PartnerdashboardView extends GetView<PartnerdashboardController> {
  const PartnerdashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
  
      body: Container(
        margin: EdgeInsets.only(top:kToolbarHeight),
        width: Get.width,
        height: Get.height -
           
            kToolbarHeight,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: Get.width * 0.01,
              children: [
                Text('Venu', style: TextStyle(fontSize: Get.width * 0.08)),
                Text(
                  'Y-Fi',
                  style: TextStyle(
                      fontSize: Get.width * 0.08,
                      color: Colors.lightGreen,
                      fontStyle: FontStyle.italic),
                ),
                Text('List', style: TextStyle(fontSize: Get.width * 0.08)),
              ],
            ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(Icons.add, color: Colors.white,size: Get.width*.05,),
                    onPressed:controller.addVenueWifi,
                  ),
                ],
               ),
              ),
            Expanded(
              child: Stack(
                children: [
                
                  SingleChildScrollView(
                    child: Obx(
                      () => Column(
                        children: [
                          controller.venuedata.isEmpty
                              ? SizedBox(
                                  height: Get.height -
                                      MediaQuery.of(context).padding.top -
                                      kToolbarHeight,
                                  child: Center(
                                    child: Text('No data found'),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: controller.venuedata.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.white),
                                        color: Colors.lightGreen,
                                      ),
                                      padding: EdgeInsets.only(left: 10),
                                      margin: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      clipBehavior: Clip.antiAlias,
                                      child:  Row(
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    controller.venuedata[index]
                                                            ['ssid']
                                                        .toString(),
                                                    style: TextStyle(color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Expanded(
                                              child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.qr_code),
                                                onPressed: () {
                                                  controller.downloadQr(index);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.edit),
                                                onPressed: () {
                                                  controller.editVenueWifi(index);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete),
                                                onPressed: () {
                                                  controller.deleteVenue(index);
                                                },
                                              ),
                                            ],
                                          ))
                                        ],
                                      ),
                                    );
                                  }),
                        ],
                      ),
                    ),
                  ),
                
                    Positioned(
                    bottom: 0,
                    left: (Get.width - 300) / 2, // Centering the ad
                    child: AnimatedOpacity(
                      opacity: (MediaQuery.of(context).viewInsets.bottom > 0) ? 0 : 1,
                      duration: Duration(
                          milliseconds:
                              MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : 200),
                      child: AdBanner(
                          width: 300,
                          height: 250,
                          content:
                              'https://creatives.reachableads.com/gozayan/300x250',
                          adUrl: 'https://google.com'),
                    ),
                  ),
              ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
