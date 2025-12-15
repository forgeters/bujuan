// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:audify/audify.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get_it/get_it.dart';
//
// class AlbumWidget1 extends StatelessWidget {
//   final String url;
//   const AlbumWidget1({super.key, required this.url});
//
//   @override
//   Widget build(BuildContext context) {
//     return // Wrap in SizedBox to control size
//       SizedBox(
//         width: 280.w,
//         height: 300.w,
//         child: CircularSpectrumVisualizer(
//           controller: GetIt.I<AudifyController>(),
//           color: Colors.purpleAccent,
//           glowColor: Colors.purple.withValues(alpha: 0.6),
//           barCount: 40,
//           barWidth: 2.0,
//           gap: 2.0,
//           smoothing: 0.7,
//           centerImage: CachedNetworkImageProvider('$url?param=450y450'), // Optional album artwork
//         ),
//       );
//   }
// }
