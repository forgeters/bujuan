import 'dart:math';

import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/pages/home/provider.dart';
import 'package:bujuan_music/pages/main/phone/widgets.dart';
import 'package:bujuan_music/router/app_router.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music/widgets/items.dart';
import 'package:bujuan_music/widgets/main_appbar.dart';
import 'package:bujuan_music_api/api/recommend/entity/recommend_resource_entity.dart';
import 'package:bujuan_music_api/api/top/entity/top_artist_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_indicator_m3e/loading_indicator_m3e.dart';

import '../../common/bujuan_music_handler_mediakit.dart';
import '../../common/values/app_images.dart';
import '../../utils/adaptive_screen_utils.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    bool desktop = medium(context) || expanded(context);
    return Scaffold(
      appBar: desktop ? null : mainAppBar(),
      body: Consumer(
        builder: (context, ref, child) {
          final album = ref.watch(newAlbumProvider);
          return album.when(
            data: (homeData) =>
                desktop ? DesktopHome(homeData: homeData) : MobileHome(homeData: homeData),
            loading: () => const Center(child: LoadingIndicatorM3E()),
            error: (_, __) => const Center(child: Text('Oops, something unexpected happened')),
          );
        },
      ),
    );
  }
}

/// 雷达
class MobileHome extends StatelessWidget {
  final HomeData homeData;

  const MobileHome({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    return _buildContent(homeData, context);
  }

  Widget _buildContent(HomeData homeData, BuildContext context) {
    final aristList = homeData.topArtistEntity.artists;
    final albumList = homeData.recommendResourceEntity.recommend;
    final songList = homeData.medias;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: GestureDetector(
              child: Image.asset(AppImages.banner, width: 345.w, height: 148.w, fit: BoxFit.fill),
              onTap: () => context.push(AppRouter.today),
            ),
          ),
        ),
        SliverToBoxAdapter(child: _buildTitle('推荐歌单', context, onTap: () {})),
        SliverToBoxAdapter(child: AlbumListWidget(albums: albumList)),
        SliverToBoxAdapter(child: _buildTitle('热门歌手', context, onTap: () {})),
        SliverToBoxAdapter(child: ArtistListWidget(artists: aristList)),
        SliverToBoxAdapter(child: _buildTitle('新歌速递', context, onTap: () {})),
        _buildSongList(songList),
        SliverToBoxAdapter(child: DynamicPadding()),
      ],
    );
  }

  Widget _buildSongList(List<MediaItem> songs) {
    return SliverFixedExtentList.builder(
      itemBuilder: (context, index) => RepaintBoundary(
        child: MediaItemWidget(
          mediaItem: songs[index],
          onTap: () {
            DateTime dateTime = DateTime.now();
            BujuanMusicHandler().updateQueue(
              songs,
              index: index,
              queueName: 'NewSong-${dateTime.year}-${dateTime.month}-${dateTime.day}',
            );
          },
        ),
      ),
      itemExtent: 75,
      itemCount: min(songs.length, 30),
    );
  }

  Widget _buildTitle(String title, BuildContext context, {VoidCallback? onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.w),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
          const Spacer(),
          if (onTap != null)
            IconButton(
              onPressed: () {},
              icon: Text('更多',style: TextStyle(fontSize: 12.sp),),
            ),
        ],
      ),
    );
  }
}

class AlbumListWidget extends StatelessWidget {
  final List<RecommendResourceRecommend> albums;

  const AlbumListWidget({super.key, required this.albums});

  @override
  Widget build(BuildContext context) {
    var list = List.generate(min(albums.length, 8), (index) {
      return RepaintBoundary(child: AlbumItem(album: albums[index]));
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 7.w),
      height: 168.w,
      child: CarouselView.weighted(
        padding: EdgeInsets.symmetric(horizontal: 8.w),
        flexWeights: [3, 2, 1],
        onTap: (index) => context.push(AppRouter.playlist, extra: albums[index].id),
        children: list,
      ),
    );
  }
}

class ArtistListWidget extends StatelessWidget {
  final List<TopArtistArtists> artists;

  const ArtistListWidget({super.key, required this.artists});

  @override
  Widget build(BuildContext context) {
    var list = List.generate(artists.length, (index) {
      return RepaintBoundary(child: ArtistItem(album: artists[index]));
    });
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      height: 118.w,
      child: CarouselView(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        scrollDirection: Axis.horizontal,
        itemExtent: 88.w,
        children: list,
        onTap: (index) {},
      ),
    );
  }
}

class DesktopHome extends StatelessWidget {
  final HomeData homeData;

  const DesktopHome({super.key, required this.homeData});

  @override
  Widget build(BuildContext context) {
    var recommend = homeData.recommendResourceEntity.recommend;
    var medias = homeData.medias;
    return SingleChildScrollView(
      padding: EdgeInsets.all(15.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.w),
          Text(
            'Top Recommendation',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.w),
          SizedBox(
            height: 190.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              cacheExtent: 800,
              itemBuilder: (context, index) => GestureDetector(
                child: RepaintBoundary(
                  child: Container(
                    width: 155.w,
                    padding: EdgeInsets.all(5.w),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white.withAlpha(60)),
                      borderRadius: BorderRadius.circular(20.w),
                    ),
                    child: Column(
                      children: [
                        RepaintBoundary(
                          child: CachedImage(
                            imageUrl: recommend[index].picUrl ?? '',
                            width: 150.w,
                            height: 150.w,
                            borderRadius: 20.w,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          '  ${recommend[index].name}',
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  context.push(AppRouter.playlist, extra: recommend[index].id);
                },
              ),
              itemCount: recommend.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10.w),
            ),
          ),
          SizedBox(height: 20.w),
          Text(
            'Recommended daily',
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 20.w),
          SizedBox(
            height: 130.w,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              cacheExtent: 800,
              itemBuilder: (context, index) => GestureDetector(
                child: RepaintBoundary(
                  child: SizedBox(
                    width: 85.w,
                    child: Column(
                      children: [
                        RepaintBoundary(
                          child: CachedImage(
                            imageUrl: medias[index].artUri.toString(),
                            width: 80.w,
                            height: 80.w,
                            borderRadius: 40.w,
                          ),
                        ),
                        SizedBox(height: 5.w),
                        Text(
                          medias[index].title,
                          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2.w),
                        Text(
                          medias[index].artist ?? '',
                          style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w400),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () => BujuanMusicHandler().updateQueue(medias, index: index),
              ),
              itemCount: medias.length,
              separatorBuilder: (BuildContext context, int index) => SizedBox(width: 10.w),
            ),
          ),
        ],
      ),
    );
  }
}
