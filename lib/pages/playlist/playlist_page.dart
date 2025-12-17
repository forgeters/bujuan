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
import 'package:image_pixels/image_pixels.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';

import '../../common/bujuan_music_handler_mediakit.dart';
import '../../utils/adaptive_screen_utils.dart';

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
      loading: () => const Center(child: LoadingIndicatorM3E()),
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
    var of = MediaQuery.of(context);
    return Stack(
      children: [
        ImagePixels(
          builder: (context, img) {
            var color = img.pixelColorAtAlignment!(Alignment.centerLeft).withAlpha(180);
            var blend = ColorUtils.blend(color, scaffoldBackgroundColor, .7);
            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [blend, scaffoldBackgroundColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            );
          },
          imageProvider: CachedNetworkImageProvider(
            '${details.detail.playlist?.coverImgUrl ?? ''}?param=100y100',
          ),
        ),
        NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 260.w,
              pinned: true,
              floating: false,
              stretch: true,
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: false,
                collapseMode: CollapseMode.parallax,
                titlePadding: EdgeInsets.only(left: 50.w, bottom: 16),
                expandedTitleScale: 1,
                title: Text(
                  details.detail.playlist?.name ?? '',
                  maxLines: 1,
                  style: TextStyle(fontSize: 18.sp, color: IconTheme.of(context).color),
                ),
                background: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // SizedBox(height: of.padding.top ),
                    CachedImage(
                      imageUrl: details.detail.playlist?.coverImgUrl ?? '',
                      width: 180.w,
                      height: 180.w,
                      borderRadius: 30.w,
                      pWidth: 300,
                      pHeight: 300,
                    ),
                  ],
                ),
              ),
            ),
          ],
          body: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.only(
              bottom: 68.w + of.padding.bottom / (Platform.isAndroid ? 1 : 1.5),
            ),
            itemCount: details.medias.length,
            itemExtent: 75,
            itemBuilder: (context, index) => MediaItemWidget(
              mediaItem: details.medias[index],
              onTap: () => BujuanMusicHandler().updateQueue(
                details.medias,
                index: index,
                queueName: details.detail.playlist?.name ?? "",
              ),
            ),
          ),
        ),
      ],
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
