import 'package:bujuan_music/pages/play/provider.dart';
import 'package:bujuan_music/widgets/lyric/widget/bujuan_lyric_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



class LyricWidget extends ConsumerWidget {
  const LyricWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref
        .watch(getMediaLyricProvider)
        .when(
          data: (data) {
            return BujuanLyricWidget(lyrics: data);
          },
          error: (_, __) => SizedBox.shrink(),
          loading: () => SizedBox.shrink(),
        );
  }
}
