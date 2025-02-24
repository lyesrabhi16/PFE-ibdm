import 'package:elegant_notification/resources/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibdm/common/widgets/app_custom_container.dart';
import 'package:ibdm/common/widgets/cuve.dart';
import 'package:ibdm/utils/constants/sizes.dart';
import 'package:ibdm/utils/helpers/localization.dart';

class FiltrationPage extends StatelessWidget {
  FiltrationPage({super.key});

  Function? _getContext;
  BuildContext get context => _getContext!.call()!;
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  late final strings = getTranslations(context).obs;
  @override
  Widget build(BuildContext context) {
    _getContext = () => context;

    return AppCustomContainer(
        child: Padding(
      padding: EdgeInsets.all(AppSizes.sm),
      child: Column(
        children: [
          Text(
            strings.value.filtrationTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(
            height: AppSizes.sm,
          ),
          Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.85,
            ),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(25),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: Container(
                          color: colorScheme.surfaceContainer,
                          child: _eauBrute(),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          color: colorScheme.secondaryContainer,
                          child: _eauFiltrer(),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    color: successColor,
                    child: _eauOsmosee(),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            child: Text("hi"),
          )
        ],
      ),
    ));
  }

  _eauBrute() {
    return Column(
      children: [
        Text(
          strings.value.eauBrute,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          children: [
            Cuve(
              title: "Cuve 1",
            ),
            Cuve(
              title: "Cuve 2",
            ),
          ],
        )
      ],
    );
  }

  _eauFiltrer() {
    return Column(
      children: [
        Text(
          strings.value.eauFiltrer,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          children: [
            Cuve(
              title: "Cuve 1",
            ),
            Cuve(
              title: "Cuve 2",
            ),
          ],
        )
      ],
    );
  }

  _eauOsmosee() {
    return Column(
      children: [
        Text(
          strings.value.eauOsmose,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          runAlignment: WrapAlignment.center,
          spacing: 10,
          runSpacing: 10,
          children: [
            Cuve(
              title: "Cuve 1",
              okColor: colorScheme.primary,
              value: 67,
            ),
            Cuve(
              title: "Cuve 2",
            ),
            Cuve(
              title: "Cuve 3",
              okColor: colorScheme.primary,
              value: 37,
            ),
            Cuve(
              title: "Cuve 4",
            ),
            Cuve(
              title: "Cuve 5",
            ),
            Cuve(
              title: "Cuve 6",
              okColor: colorScheme.primary,
              value: 100,
            ),
            Cuve(
              title: "Cuve 7",
              okColor: colorScheme.primary,
              value: 47,
            ),
            Cuve(
              title: "Cuve 8",
              okColor: colorScheme.primary,
              value: 82,
            ),
            Cuve(
              title: "Cuve 9",
            ),
            Cuve(
              title: "Cuve 10",
            ),
            Cuve(
              title: "Cuve 11",
            ),
            Cuve(
              title: "Cuve 12",
            ),
            Cuve(
              title: "Cuve 13",
            ),
            Cuve(
              title: "Cuve 14",
            ),
            Cuve(
              title: "Cuve 15",
            ),
          ],
        )
      ],
    );
  }
}
