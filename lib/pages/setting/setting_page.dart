import 'package:bujuan_music/pages/setting/provider.dart';
import 'package:bujuan_music/widgets/main_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: mainAppBar(title: '设置'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Consumer(
              builder: (context, ref, child) {
                var isFloat = ref.watch(floatBottomBarProvider);
                return SwitchListTile(
                  title: Text('悬浮底部栏'),
                  subtitle: Text(isFloat ? '开启' : '关闭'), value: isFloat, onChanged: (bool value) {
                    ref.read(floatBottomBarProvider.notifier).toggleTheme();
                },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
