import 'dart:io';

import 'package:bujuan_music/pages/playlist/provider.dart';
import 'package:bujuan_music/utils/color_utils.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../../common/bujuan_music_handler.dart';
import '../../utils/adaptive_screen_utils.dart';
import '../../widgets/loading.dart';

class PlaylistPage extends ConsumerWidget {
  final int id;

  const PlaylistPage(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool desktop = medium(context) || expanded(context);
    final album = ref.watch(playlistDetailProvider(id));
    return album.when(
      data: (details) =>
          desktop ? DesktopPlayList(details: details) : MobilePlayList(details: details),
      loading: () => const Center(child: LoadingIndicator()),
      error: (_, __) => const Center(child: Text('Oops, something unexpected happened')),
    );
  }
}

class MobilePlayList extends StatelessWidget {
  final PlaylistData details;

  const MobilePlayList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    var scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    var color = ColorUtils.blend(details.color, scaffoldBackgroundColor, .7);
    Color start = color.withAlpha(30);
    Color mid = Color.lerp(start, color, 0.5)!; // 中间颜色
    Color end = color;

    var g = LinearGradient(
      colors: [start, mid, end],
      stops: [0, 0.5, 0.8],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      backgroundColor: color,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: color,
            pinned: true,
            expandedHeight: 305.w,
            flexibleSpace: FlexibleSpaceBar(
              expandedTitleScale: 1,
              collapseMode: CollapseMode.pin, //折叠时效果
              stretchModes: [StretchMode.zoomBackground, StretchMode.fadeTitle], //拉伸时效果
              background: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  CachedImage(
                    imageUrl: details.detail.playlist?.coverImgUrl ?? "",
                    width: double.infinity,
                    height: double.infinity,
                    pWidth: 500,
                    pHeight: 500,
                  ),
                  Container(decoration: BoxDecoration(gradient: g)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      spacing: 12.w,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                details.detail.playlist?.name ?? "",
                                style: TextStyle(fontSize: 24.sp),
                              ),
                            ),
                            SizedBox(width: 20.w),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(HugeIconsSolid.play, size: 25.sp),
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all(ColorUtils.blend(details.color, scaffoldBackgroundColor, .4)),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(onPressed: (){}, icon: Icon(HugeIconsStroke.favourite)),
                            IconButton(onPressed: (){}, icon: Icon(HugeIconsStroke.lookTop)),
                            IconButton(onPressed: (){}, icon: Icon(HugeIconsStroke.message01)),
                            IconButton(onPressed: (){}, icon: Icon(HugeIconsStroke.listSetting)),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverFixedExtentList(
            itemExtent: 75,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return RepaintBoundary(
                  child: MediaItemWidget(
                    mediaItem: details.medias[index],
                    onTap: () => BujuanMusicHandler().updateQueue(
                      details.medias,
                      index: index,
                      queueName: details.detail.playlist?.name ?? "",
                    ),
                  ),
                );
              },
              childCount: details.medias.length,
              addAutomaticKeepAlives: false,
            ),
          ),
          // Add some padding at the bottom (for footer)
          SliverToBoxAdapter(child: SizedBox(height: MediaQuery.paddingOf(context).bottom + 80.w)),
        ],
      ),
    );
  }
}

class DesktopPlayList extends StatelessWidget {
  final PlaylistData details;

  const DesktopPlayList({super.key, required this.details});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: () => context.pop(), icon: Icon(HugeIconsSolid.cancel01)),
        title: Text(details.detail.playlist?.name ?? ''),
        backgroundColor: Colors.transparent,
      ),
      body: Row(
        children: [
          SizedBox(
            width: 260.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 20.w),
              child: Column(
                children: [
                  CachedImage(
                    imageUrl: details.detail.playlist?.coverImgUrl ?? '',
                    width: 200.w,
                    height: 200.w,
                    borderRadius: 100.w,
                  ),
                  SizedBox(height: 20.w),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15.w),
                      child: Text(
                        details.detail.playlist?.description ?? '暂无描述！！',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.only(top: 0, bottom: 45.w),
              itemExtent: 75,
              itemCount: details.medias.length,
              itemBuilder: (context, index) => MediaItemWidget(
                mediaItem: details.medias[index],
                onTap: () => BujuanMusicHandler().updateQueue(details.medias, index: index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
