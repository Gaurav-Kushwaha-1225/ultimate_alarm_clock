import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultimate_alarm_clock/app/modules/addOrUpdateAlarm/controllers/add_or_update_alarm_controller.dart';
import 'package:ultimate_alarm_clock/app/modules/settings/controllers/theme_controller.dart';
import 'package:ultimate_alarm_clock/app/utils/constants.dart';
import 'package:ultimate_alarm_clock/app/utils/utils.dart';

class TilesChallenge extends StatelessWidget {
  const TilesChallenge({
    super.key,
    required this.controller,
    required this.themeController,
  });

  final AddOrUpdateAlarmController controller;
  final ThemeController themeController;

  @override
  Widget build(BuildContext context) {
    var width = Get.width;
    var height = Get.height;
    Difficulty levelOfDifficulty = controller.tilesDifficulty.value;
    bool isTilesEnabled;
    return Obx(
      () => ListTile(
        title: Row(
          children: [
            Text(
              'Tiles'.tr,
              style: TextStyle(
                color: themeController.primaryTextColor.value,
              ),
            ),
            IconButton(
              icon: Icon(
                Icons.info_sharp,
                size: 21,
                color: themeController.primaryTextColor.value.withOpacity(0.3),
              ),
              onPressed: () {
                Utils.showModal(
                  context: context,
                  title: 'Tiles'.tr,
                  description: 'tilesDescription'.tr,
                  iconData: Icons.games_rounded,
                  isLightMode:
                      themeController.currentTheme.value == ThemeMode.light,
                );
              },
            ),
          ],
        ),
        onTap: () {
          Utils.hapticFeedback();
          // saving initial values of drop down widget
          levelOfDifficulty = controller.tilesDifficulty.value;
          isTilesEnabled = controller.isMatchTilesEnabled.value;
          Get.defaultDialog(
            onWillPop: () async {
              Utils.hapticFeedback();
              // // presetting values to initial state
              _presetToInitial(levelOfDifficulty, isTilesEnabled);
              return true;
            },
            titlePadding: const EdgeInsets.only(top: 20),
            backgroundColor: themeController.secondaryBackgroundColor.value,
            title: 'Difficulty Level of Tiles\nChallenge'.tr,
            titleStyle: Theme.of(context).textTheme.displaySmall,
            content: Obx(
              () => Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: double.infinity,
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton(
                            value: controller.tilesDifficulty.value,
                            items: Difficulty.values
                                .map(
                                  (Difficulty level) => DropdownMenuItem(
                                    value: level,
                                    child: Text(
                                      level
                                          .toString()
                                          .toString()
                                          .replaceAll('Difficulty.', ''),
                                    ),
                                  ),
                                )
                                .toList(),
                            onChanged: (Difficulty? level) {
                              // print(level);
                              Utils.hapticFeedback();
                              controller.tilesDifficulty.value =
                                  level ?? Difficulty.Easy;
                              levelOfDifficulty = level ?? Difficulty.Easy;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(kprimaryColor),
                        ),
                        child: Text(
                          'Save'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.secondaryTextColor.value,
                              ),
                        ),
                        onPressed: () async {
                          Utils.hapticFeedback();
                          controller.isMatchTilesEnabled.value = true;
                          controller.tilesDifficulty.value = levelOfDifficulty;
                          Get.back();
                        },
                      ),
                      SizedBox(
                        width: width * 0.05,
                      ),
                      TextButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            themeController.primaryTextColor.value
                                .withOpacity(0.5),
                          ),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(
                                color: themeController.primaryTextColor.value,
                              ),
                        ),
                        onPressed: () {
                          Utils.hapticFeedback();
                          controller.isMatchTilesEnabled.value = false;
                          controller.tilesDifficulty.value = Difficulty.Easy;
                          Get.back();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
        trailing: InkWell(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Obx(
                () => Text(
                  controller.isMatchTilesEnabled.value == true
                      ? Utils.getDifficultyLabel(
                          controller.tilesDifficulty.value,
                        ).tr
                      : 'Off'.tr,
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: (controller.isMatchTilesEnabled.value == false)
                            ? themeController.primaryDisabledTextColor.value
                            : themeController.primaryTextColor.value,
                      ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: themeController.primaryDisabledTextColor.value,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _presetToInitial(Difficulty levelOfDifficulty, bool isTilesEnabled) {
    controller.tilesDifficulty.value = levelOfDifficulty;
    controller.isPedometerEnabled.value = isTilesEnabled;
  }
}
