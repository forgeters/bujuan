import 'package:bujuan_music/pages/home/home_page.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../pages/main/main_page.dart';
import '../../router/app_router.dart';

class AppConfig {
  static const String isDarkTheme = 'isDarkTheme';
  static const String isFloatBottom = 'isFloatBottom';
  static const String backgroundPath = 'backgroundPath';

  static final List<BottomData> bottomItems = [
    BottomData(HugeIconsStroke.home01, HugeIconsSolid.home01, AppRouter.home, '首页'),
    BottomData(HugeIconsStroke.lookTop, HugeIconsSolid.lookTop, AppRouter.user, '我的'),
    BottomData(HugeIconsStroke.search01, HugeIconsSolid.search01, AppRouter.setting, '搜索'),
    BottomData(HugeIconsStroke.settings02, HugeIconsSolid.settings02, AppRouter.setting, '设置'),
  ];

  static final List<HomeTop> tops = [
    HomeTop('每日推荐', '', 'tag')
  ];


  static const String userInfoKey = 'USER_INFO_KEY';
}
