import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';

import 'package:cached_network_image/cached_network_image.dart';

/// 네트워크 이미지를 캐싱하여 표시하는 위젯.
///
/// iOS `AsyncImageView`(Kingfisher 기반) 대응. 로드 실패/대기 시 `black90` 배경을 표시하고,
/// `showGradient`가 true이면 하단에서 상단으로 향하는 `black100` 그라데이션을 덧씌운다.
class AsyncImageView extends StatelessWidget {
  const AsyncImageView({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
    this.showGradient = false,
  });

  final String? url;
  final BoxFit fit;
  final bool showGradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        _image(),
        if (showGradient)
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [LivithColors.black100, Colors.transparent],
              ),
            ),
          ),
      ],
    );
  }

  Widget _image() {
    final imageUrl = url;
    if (imageUrl == null || imageUrl.isEmpty) {
      return const ColoredBox(color: LivithColors.black90);
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      placeholder: (_, _) => const ColoredBox(color: LivithColors.black90),
      errorWidget: (_, _, _) => const ColoredBox(color: LivithColors.black90),
    );
  }
}
