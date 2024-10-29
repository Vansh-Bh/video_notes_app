import 'package:get/get.dart';
import '../modules/home/home_binding.dart';
import '../modules/home/home_view.dart';
import '../modules/video_player/video_player_binding.dart';
import '../modules/video_player/video_player_view.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.VIDEO_PLAYER,
      page: () => VideoPlayerView(),
      binding: VideoPlayerBinding(),
    ),
  ];
}

