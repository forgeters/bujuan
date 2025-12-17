import 'package:bujuan_music/common/values/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hugeicons_pro/hugeicons.dart';

class BackgroundSettingDialog extends StatefulWidget {
  const BackgroundSettingDialog({super.key});

  @override
  State<BackgroundSettingDialog> createState() => _BackgroundSettingDialogState();
}

class _BackgroundSettingDialogState extends State<BackgroundSettingDialog> {
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      child: SizedBox(
        width: 600.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 400.w,
              child: PageView(
                controller: pageController,
                children: [
                  BackgroundEnums.happy,
                  BackgroundEnums.dragon,
                  BackgroundEnums.littleBoy,
                  BackgroundEnums.boy,
                  BackgroundEnums.girl,
                ]
                    .map((background) => Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                    onPressed: () => pageController.previousPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.decelerate),
                                    icon: Icon(
                                      HugeIconsSolid.arrowLeft01,
                                      size: 32.sp,
                                    )),
                                SizedBox(width: 30.w),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(150.w),
                                  child: Container(
                                    decoration: BoxDecoration(),
                                    width: 300.w,
                                    height: 300.w,
                                    // child: RivePlayer(
                                    //   asset: background.background,
                                    //   fit: rive.Fit.cover,
                                    // ),
                                  ),
                                ),
                                SizedBox(width: 30.w),
                                IconButton(
                                    onPressed: () => pageController.nextPage(
                                        duration: Duration(milliseconds: 300),
                                        curve: Curves.decelerate),
                                    icon: Icon(
                                      HugeIconsSolid.arrowRight01,
                                      size: 32.sp,
                                    )),
                              ],
                            ),
                            SizedBox(height: 20.w),
                          ],
                        ))
                    .toList(),
              ),
            ),
            // IconButton(
            //     onPressed: () => context.pop(),
            //     icon: Icon(
            //       HugeIcons.strokeRoundedCancelCircleHalfDot,
            //       size: 30.sp,
            //     )),
          ],
        ),
      ),
    );
  }
}

enum BackgroundEnums {
  happy(AppImages.happy, ThemeMode.light),
  dragon(AppImages.dagger, ThemeMode.light),
  girl(AppImages.girl, ThemeMode.dark),
  littleBoy(AppImages.littleBoy, ThemeMode.dark),
  boy(AppImages.boy, ThemeMode.light);

  final String background;
  final ThemeMode themeMode;

  const BackgroundEnums(this.background, this.themeMode);
}
