import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/side_menu_container.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';
import 'package:ibdm/utils/helpers/logger.dart';
import 'package:ibdm/utils/helpers/page_index.dart';
import 'package:ibdm/utils/helpers/screen.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class PageNavigation extends StatelessWidget {
  final int currentPage;
  final int nbrTotalPages;
  final int nbrShown;
  final int nbrTotal;
  final String label;
  final Function(int) onPagePress;
  final Function(int) onPrevPress;
  final Function(int) onNextPress;

  PageNavigation({
    super.key,
    required this.currentPage,
    required this.nbrTotalPages,
    required this.nbrShown,
    required this.nbrTotal,
    required this.label,
    required this.onPagePress,
    required this.onPrevPress,
    required this.onNextPress,
  });

  Function? _getContext;
  BuildContext get getContext => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(getContext).colorScheme;

  List<int> getIndexesOfPages(
    int currentPage,
    int totalPages, {
    int nbrAdditionalIndexesShown = 2,
  }) {
    //printMessage("currentPage: $currentPage");
    //printMessage("totalPages: $totalPages");
    List<int> indexes = [];

    indexes.add(1);
    var i = 2;
    var j = 0;
    while (i < currentPage && j < nbrAdditionalIndexesShown) {
      if (i >= (currentPage - nbrAdditionalIndexesShown)) {
        indexes.add(i);
        j++;
      }
      i++;
    }

    if (!indexes.contains(currentPage)) {
      indexes.add(currentPage);
    }

    i = totalPages - 1;
    j = 0;
    while (i > currentPage && j < nbrAdditionalIndexesShown) {
      indexes.add(i);
      i--;
      j++;
    }
    if (!indexes.contains(totalPages)) {
      indexes.add(totalPages);
    }
    indexes.sort();
    i = 1;
    final List<int> fIndexes = [indexes[0]];
    while (i < indexes.length) {
      if (indexes[i] > indexes[i - 1] + 1) {
        fIndexes.add(-1);
      }
      fIndexes.add(indexes[i]);

      i++;
    }
    //printMessage(fIndexes);
    return fIndexes;
  }

  List<Widget> pageIndexesButtons() {
    final strings = getTranslations(getContext).obs;
    List<Widget> pageIndexesButtons = [];
    if (nbrTotal > 0) {
      final indexes = getIndexesOfPages(currentPage, nbrTotalPages,
          nbrAdditionalIndexesShown: (context) {
            if (isAtMostSmallScreen(context)) {
              return 0;
            }
            if (isAtMostMediumScreen(context)) {
              return 1;
            }
            return 2;
          }(getContext));
      pageIndexesButtons = indexes.map(
        (i) {
          if (i < 0) {
            final items = <PageIndex>[];
            for (var index = 1; index <= nbrTotalPages; index++) {
              items.add(
                PageIndex(
                  index: index,
                  button: ShadButton(
                    backgroundColor: colorScheme.surface,
                    foregroundColor: colorScheme.onSurface,
                    onPressed: () => onPagePress(index),
                    child: Text(
                      "$index",
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              );
            }
            // set display to all
            final searchedPageIndexes = items.obs;
            return Obx(() {
              return ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 30,
                  maxWidth: 60,
                  maxHeight: 60,
                ),
                child: ShadSelect.withSearch(
                  decoration: ShadDecoration(
                    color: colorScheme.surface,
                    border: ShadBorder.none,
                    labelStyle: Theme.of(getContext).textTheme.bodyMedium,
                  ),
                  trailing: Icon(
                    Icons.arrow_drop_up,
                    size: AppSizes.md,
                  ),
                  initialValue: "...",
                  selectedOptionBuilder: (context, v) => FittedBox(
                    child: Text(
                      v,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  anchor: ShadAnchorAuto(preferBelow: false),
                  options: [...searchedPageIndexes.map((pi) => pi.button)],
                  searchPlaceholder: Text(strings.value.search),
                  onSearchChanged: (String value) {
                    if (value.isEmpty) {
                      searchedPageIndexes.value = items;
                    } else {
                      searchedPageIndexes.value = items
                          .where((pi) => pi.index == int.tryParse(value))
                          .toList();
                    }
                  },
                ),
              );
            });
          }
          return ShadButton(
            backgroundColor:
                i == currentPage ? colorScheme.primaryContainer : null,
            onPressed: () => onPagePress(i),
            child: Text("$i"),
          );
        },
      ).toList();
    }
    return pageIndexesButtons;
  }

  @override
  Widget build(BuildContext context) {
    _getContext = () => context;
    final strings = getTranslations(context).obs;

    return Container(
      width: context.width,
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSizes.borderRadius)),
      child: Padding(
        padding: EdgeInsets.all(AppSizes.sm),
        child: Obx(() {
          logger.e("isSmallScreen: ${isAtMostSmallScreen(context)}");
          return Wrap(
            alignment: WrapAlignment.spaceBetween,
            direction: Axis.horizontal,
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: [
              if (isAtLeastMediumScreen(context) && !SideMenuContainer.open)
                Text(
                  "${strings.value.page} : $currentPage", // if it is at least a small screen show it in this position
                ),
              Row(
                mainAxisSize:
                    isAtLeastMediumScreen(context) && !SideMenuContainer.open
                        ? MainAxisSize.min
                        : MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAtLeastMediumScreen(context))
                    ShadButton(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      enabled: currentPage > 1,
                      onPressed: () => onPrevPress(currentPage - 1),
                      child: Text(strings.value.prevPage),
                    ),
                  ...pageIndexesButtons(),
                  if (isAtLeastMediumScreen(context))
                    ShadButton(
                      backgroundColor: colorScheme.surface,
                      foregroundColor: colorScheme.onSurface,
                      enabled: currentPage < nbrTotalPages,
                      onPressed: () => onNextPress(currentPage + 1),
                      child: Text(strings.value.nextPage),
                    ),
                ],
              ),
              if (isAtMostSmallScreen(context) || SideMenuContainer.open)
                Text(
                    "${strings.value.page} : $currentPage"), // if it is at most a small screen show it in this position
              Text("$label: $nbrShown/$nbrTotal")
            ],
          );
        }),
      ),
    );
  }
}
