import 'package:audio_service/audio_service.dart';
import 'package:bujuan_music/widgets/backdrop.dart';
import 'package:bujuan_music/widgets/cache_image.dart';
import 'package:bujuan_music_api/api/recommend/entity/recommend_resource_entity.dart';
import 'package:bujuan_music_api/api/top/entity/top_artist_entity.dart';
import 'package:cached_network_image/cached_network_image.dart';
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
  final VoidCallback? onTap;

  const AlbumItem({super.key, required this.album, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider('${album.picUrl}?param=280y280'),
          fit: BoxFit.cover,
        ),
      ),
      child: BackdropView(
        width: double.infinity,
        color: Theme.of(context).scaffoldBackgroundColor.withAlpha(180),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.w),
        child: Text(
          album.name ?? '',
          maxLines: 1,
          softWrap: false,
          overflow: TextOverflow.clip,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 12.sp),
        ),
      ),
    );
  }
}

class ArtistItem extends StatelessWidget {
  final TopArtistArtists album;

  const ArtistItem({super.key, required this.album});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 88.w, maxHeight: 88.w),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: CachedNetworkImageProvider(
                '${album.picUrl}?param=280y280',
              ),
              fit: BoxFit.cover,
            ),
            borderRadius: BorderRadius.circular(40.w),
          ),
        ),
        SizedBox(height: 3.w),
        Text(
          album.name,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
          softWrap: false,
          style: TextStyle(fontSize: 12.sp),
        ),
      ],
    );
  }
}
