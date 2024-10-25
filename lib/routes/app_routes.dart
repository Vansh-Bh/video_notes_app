part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const VIDEO_PLAYER = _Paths.VIDEO_PLAYER;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const VIDEO_PLAYER = '/video-player';
}