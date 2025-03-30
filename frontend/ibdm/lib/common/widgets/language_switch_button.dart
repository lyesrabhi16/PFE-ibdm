import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/controllers/locale_controller.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:popover/popover.dart';

class LanguageSwitchButton extends StatelessWidget {
  LanguageSwitchButton({
    super.key,
  });

  final LocaleController localeController = Get.find<LocaleController>();

  @override
  Widget build(BuildContext context) {
    Rx<IconData> dropdownIcon = Icons.arrow_drop_down_rounded.obs;

    return Center(
      child: Container(
        constraints: BoxConstraints.expand(
          height: AppSizes.lg * 1.5,
          width: AppSizes.xl * 2,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppSizes.borderRadius),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 0,
          children: [
            Expanded(
              child: FilledButton.tonal(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.zero,
                  ),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainer),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(AppSizes.borderRadius),
                        bottomLeft: Radius.circular(AppSizes.borderRadius),
                      ),
                    ),
                  ),
                ),
                onPressed: () {
                  // change language
                  // get next language
                  final int nextIndex = (localeController.supportedLocales
                              .indexOf(localeController.locale.value) +
                          1) %
                      localeController.supportedLocales.length;
                  localeController
                      .setLocale(localeController.supportedLocales[nextIndex]);
                },
                child: Text(
                  localeController.locale.value.languageCode,
                ),
              ),
            ),
            VerticalDivider(
              color: Theme.of(context).colorScheme.tertiary,
              width: 1,
              thickness: 1,
              indent: AppSizes.sm,
              endIndent: AppSizes.sm,
            ),
            Expanded(
              child: FilledButton.tonal(
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    EdgeInsets.zero,
                  ),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.surfaceContainer),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(AppSizes.borderRadius),
                        bottomRight: Radius.circular(AppSizes.borderRadius),
                      ),
                    ),
                  ),
                ),
                child: Obx(
                  () => Icon(
                    dropdownIcon.value,
                  ),
                ),
                onPressed: () {
                  // change icon to arrow_drop_up_rounded
                  dropdownIcon.value = Icons.arrow_drop_up_rounded;
                  showPopover(
                    context: context,
                    backgroundColor:
                        Theme.of(context).colorScheme.surfaceContainer,
                    direction: PopoverDirection.bottom,
                    onPop: () {
                      dropdownIcon.value = Icons.arrow_drop_down_rounded;
                    },
                    bodyBuilder: (context) {
                      return ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: AppSizes.xl * 2,
                        ),
                        child: ListView(
                          shrinkWrap: true,
                          children: [
                            for (final locale
                                in localeController.supportedLocales)
                              ListTile(
                                selected:
                                    locale == localeController.locale.value,
                                title: Center(child: Text(locale.languageCode)),
                                onTap: () {
                                  localeController.setLocale(locale);
                                  // close popover
                                  Navigator.of(context).pop();
                                },
                              ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
