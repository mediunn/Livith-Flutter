import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';
import 'package:livith/views/widgets/async_image_view.dart';

/// Livith 콘서트 카드.
///
/// iOS `LivithCard` 대응. 포스터 이미지(108x158, 코너 6) + 제목/부제.
/// 선택 시 `yellow30` 테두리(2pt)를 표시한다.
class LivithCard extends StatelessWidget {
  const LivithCard({
    super.key,
    required this.imageUrl,
    required this.title,
    this.subtitle,
    this.secondaryText,
    this.isSelected = false,
    this.titleLineLimit,
    this.onTap,
  });

  final String? imageUrl;
  final String title;
  final String? subtitle;
  final String? secondaryText;
  final bool isSelected;
  final int? titleLineLimit;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final hasSubtitle = subtitle != null;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 108,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Container(
                width: 108,
                height: 158,
                foregroundDecoration: isSelected
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: LivithColors.yellow30, width: 2),
                      )
                    : null,
                child: AsyncImageView(url: imageUrl),
              ),
            ),
            SizedBox(height: hasSubtitle ? 6 : 8),
            Text(
              title,
              maxLines: titleLineLimit,
              overflow: titleLineLimit == null ? null : TextOverflow.ellipsis,
              style: LivithTextStyles.body2Medium.copyWith(color: LivithColors.white100),
            ),
            if (hasSubtitle) ...[
              const SizedBox(height: 8),
              Text(
                subtitle!,
                style: LivithTextStyles.caption1Semibold.copyWith(color: LivithColors.black50),
              ),
            ],
            if (secondaryText != null)
              Text(
                secondaryText!,
                style: LivithTextStyles.caption1Semibold.copyWith(color: LivithColors.black50),
              ),
          ],
        ),
      ),
    );
  }
}
