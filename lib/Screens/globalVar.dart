import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_getx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

String address = "";
double lat = 22.572646, long = 88.363895;

class calculator extends GetxController {
  var totalbookings = 0.obs;
  var totalperday = 0.obs;
  var totalpackages = 0.obs;
  var totalconfirm = 0.obs;
  var totalactive = 0.obs;
  var totalcomplete = 0.obs;
  var totalupcoming = 0.obs;
  var totalcancelled = 0.obs;
  var totalamount = 0.obs;
  var cash = 0.obs;
  var online = 0.obs;
  var totalpaid = 0.obs;
  var totalcash_p = 0.obs;
  var totalo_p = 0.obs;
  var total_due = 0.obs;
}
