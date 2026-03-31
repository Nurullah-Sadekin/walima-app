import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/core/constants/app_colors.dart';
import 'package:flutter_boilerplate/core/global/components/bottom_sheet.dart';

class PickerDialog {
  // image picker dialog
  Future<String?> imagePicker(BuildContext context) async {
    final String? selectedSource = await showImageTypeSelector(context);
    if (selectedSource == null) {
      return null; // user cancelled the selection
    }
    return null;
  }

  Future<String?> showImageTypeSelector(BuildContext context) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: false,
      backgroundColor: Colors.transparent,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(top: 8),
                    decoration: BoxDecoration(
                      color: Colors.black26,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0,),
                    child: Text(
                      'Select Image Source',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context, 'camera'),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: AppColors.primaryVariant,
                                border: Border.all(
                                  color: AppColors.primary,
                                ),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Camera',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Icon(
                                      Icons.camera_alt_rounded,
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => Navigator.pop(context, 'gallery'),
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(Radius.circular(10)),
                                color: AppColors.primaryVariant,
                                border: Border.all(
                                  color: AppColors.primary,
                                ),
                              ),
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Gallery',
                                      style: TextStyle(
                                        color: AppColors.primary,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Icon(
                                      Icons.photo_library_rounded,
                                      color: AppColors.primary,
                                      size: 30,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
    // await BottomSheetUtils.open(
    //   fullHeight: true,
    //   context: context,
    //   child: Padding(
    //     padding: const EdgeInsets.symmetric(horizontal: 20.0),
    //     child: Column(
    //       crossAxisAlignment: CrossAxisAlignment.start,
    //       mainAxisSize: MainAxisSize.min,
    //       children: [
    //         Row(
    //           children: [
    //             Text(
    //               'Select Image Source',
    //               style: Theme.of(context).textTheme.titleMedium,
    //             ),
    //             const Spacer(),
    //             IconButton(
    //               onPressed: () => Navigator.pop(context),
    //               icon: const Icon(Icons.close),
    //             ),
    //           ],
    //         ),
    //         const SizedBox(height: 15),
    //         Row(
    //           children: [
    //             Expanded(
    //               child: Container(
    //                 height: 100,
    //                 decoration: BoxDecoration(
    //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
    //                   color: AppColors.primaryVariant,
    //                   border: Border.all(
    //                     color: AppColors.primary,
    //                   ),
    //                 ),
    //                 child: const Center(
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         'Camera',
    //                         style: TextStyle(
    //                           color: AppColors.primary,
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.w600,
    //                         ),
    //                       ),
    //                       SizedBox(height: 8),
    //                       Icon(
    //                         Icons.camera_alt_rounded,
    //                         color: AppColors.primary,
    //                         size: 30,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //             const SizedBox(width: 20),
    //             Expanded(
    //               child: Container(
    //                 height: 100,
    //                 decoration: BoxDecoration(
    //                   borderRadius: const BorderRadius.all(Radius.circular(10)),
    //                   color: AppColors.primaryVariant,
    //                   border: Border.all(
    //                     color: AppColors.primary,
    //                   ),
    //                 ),
    //                 child: const Center(
    //                   child: Column(
    //                     mainAxisAlignment: MainAxisAlignment.center,
    //                     children: [
    //                       Text(
    //                         'Gallery',
    //                         style: TextStyle(
    //                           color: AppColors.primary,
    //                           fontSize: 16,
    //                           fontWeight: FontWeight.w600,
    //                         ),
    //                       ),
    //                       SizedBox(height: 8),
    //                       Icon(
    //                         Icons.photo_library_rounded,
    //                         color: AppColors.primary,
    //                         size: 30,
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ],
    //     ),
    //   ),
    // );
    return null;
  }

  // audio picker dialog
  // video picker dialog
  // document picker dialog
  // contact picker dialog
  // location picker dialog
  // we can use this dialog to show the options for picking different types of files or data
}
