import 'package:get/get.dart';
import 'package:video_notes_app/modules/home/home_controller.dart';

// Binding class to manage HomeController dependency injection
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeController>(HomeController());
  }
}
