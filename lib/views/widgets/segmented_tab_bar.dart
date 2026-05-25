import 'package:flutter/material.dart';

import 'package:livith/core/theme/livith_colors.dart';
import 'package:livith/core/theme/livith_typography.dart';

/// 세그먼트 탭 선택기.
///
/// iOS `SegmentedTabBar` 대응. 하단 경계선(`black90`, 3pt) 위에 선택 탭만
/// `white100` 인디케이터(3pt)를 표시한다. 탭별 배지 카운트를 지원한다.
class SegmentedTabBar extends StatelessWidget {
  const SegmentedTabBar({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.badgeCountList,
    this.isScrollable = false,
    this.tabWidth,
  });

  final List<String> tabs;
  final int selectedIndex;
  final ValueChanged<int> onTabSelected;
  final List<int?>? badgeCountList;
  final bool isScrollable;
  final double? tabWidth;

  @override
  Widget build(BuildContext context) {
    final row = Row(
      mainAxisSize: isScrollable ? MainAxisSize.min : MainAxisSize.max,
      children: [
        for (var index = 0; index < tabs.length; index++)
          _buildTab(index),
      ],
    );

    return ColoredBox(
      color: LivithColors.black100,
      child: isScrollable
          ? SingleChildScrollView(scrollDirection: Axis.horizontal, child: row)
          : row,
    );
  }

  Widget _buildTab(int index) {
    final isSelected = index == selectedIndex;
    final badgeCount = badgeCountList != null && index < badgeCountList!.length
        ? badgeCountList![index]
        : null;

    final tab = GestureDetector(
      onTap: () => onTabSelected(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  tabs[index],
                  style: LivithTextStyles.body2Semibold.copyWith(
                    color: isSelected ? LivithColors.white100 : LivithColors.black50,
                  ),
                ),
                if (badgeCount != null) ...[
                  const SizedBox(width: 2),
                  Text(
                    '$badgeCount',
                    style: LivithTextStyles.body2Semibold.copyWith(color: LivithColors.yellow30),
                  ),
                ],
              ],
            ),
          ),
          Container(
            height: 3,
            color: isSelected ? LivithColors.white100 : LivithColors.black90,
          ),
        ],
      ),
    );

    if (isScrollable) {
      return SizedBox(width: tabWidth ?? 106, child: tab);
    }
    return Expanded(child: tab);
  }
}
