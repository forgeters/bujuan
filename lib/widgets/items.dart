import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music_api/api/recommend/entity/recommend_resource_entity.dart';
import 'package:bujuan_music_api/api/top/entity/top_artist_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons_pro/hugeicons.dart';

import '../common/bujuan_music_handler_mediakit.dart';
import '../router/app_router.dart';

class MediaItemWidget extends StatelessWidget {
  final MediaItem mediaItem;
  final VoidCallback? onTap;

  const MediaItemWidget({super.key, required this.mediaItem, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.w),
        leading: CachedImage(
          imageUrl: mediaItem.artUri?.toString() ?? '',
          width: 42.w,
          height: 42.w,
          borderRadius: 21.w,
          pWidth: 100,
          pHeight: 100,
        ),
        title: Text(
          mediaItem.title,
          style: TextStyle(fontSize: 14.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          mediaItem.artist ?? '',
          style: TextStyle(fontSize: 12.sp),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: mediaItem.extras?['mv'] != 0
            ? IconButton(
                onPressed: () {
                  BujuanMusicHandler().pause();
                  context.push(AppRouter.mv, extra: mediaItem.extras?['mv']);
                },
                icon: Icon(HugeIconsStroke.tv01, size: 20.sp),
              )
            : null,
        onTap: () => onTap?.call(),
      ),
    );
  }
}

class AlbumItem extends StatelessWidget {
  final RecommendResourceRecommend album;
  final VoidCallback onTap;

  const AlbumItem({super.key, required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 138.w,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImage(
                imageUrl: album.picUrl ?? '',
                width: 138,
                height: 138,
                pWidth: 300,
                pHeight: 300,
                borderRadius: 20,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 3),
              Text(
                album.name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ArtistItem extends StatelessWidget {
  final TopArtistArtists album;
  final VoidCallback onTap;

  const ArtistItem({super.key, required this.album, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: Container(
        margin: const EdgeInsets.only(right: 15),
        width: 138,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CachedImage(
                imageUrl: album.picUrl ?? '',
                width: 88.w,
                height: 88.w,
                pHeight: 200,
                pWidth: 200,
                borderRadius: 44.w,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 3),
              Text(
                album.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:  TextStyle(fontWeight: FontWeight.w600, fontSize: 14.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
