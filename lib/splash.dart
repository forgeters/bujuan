
import 'package:bujuan_music/common/values/app_config.dart';
import 'package:bujuan_music/common/values/app_images.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music_api/api/user/entity/user_info_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:nb_utils/nb_utils.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () => getUserInfo());
    super.initState();
  }

  void getUserInfo() async {
    try {
      var userInfo = getJSONAsync(AppConfig.userInfoKey, defaultValue: {});
      var bool = (userInfo.isNotEmpty && UserInfoProfile.fromJson(userInfo).userId != null);
      if (mounted) {
        context.replace(bool ? AppRouter.home : AppRouter.login);
      }
    } catch (e) {
      if (mounted) {
        context.replace(AppRouter.login);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AppImages.logo, width: 120.w, height: 120.w),
      ),
    );
  }
}
