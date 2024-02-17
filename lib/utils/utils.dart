import 'dart:async';
import 'package:ficonsax/ficonsax.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants/colors.dart';

class Utils {
  static ImagePicker picker = ImagePicker();

  static showSnackbar(String message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        // backgroundColor: Colors.purple,
        backgroundColor: primaryColor,

        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                color: Colors.white,
              ),
        ),
      ),
    );
  }


  static to12Hour(int hour) => hour > 12 ? hour - 12 : hour;

  static Future<String?> getImage(ImageSource source) async {
    XFile? file = await picker.pickImage(source: source);
    return file?.path;
  }

  static Future<String?> showImagePickerSheet(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Choose Upload Method',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              getImage(ImageSource.camera).then(
                                  (value) => Navigator.pop(context, value));
                            },
                            icon: const Icon(
                              IconsaxBold.camera,
                              color: primaryColor,
                            )),
                        const Text('Camera')
                      ],
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                            onPressed: () {
                              getImage(ImageSource.gallery).then(
                                  (value) => Navigator.pop(context, value));
                            },
                            icon: const Icon(
                              IconsaxBold.image,
                              color: primaryColor,
                            )),
                        const Text('Gallery')
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  static String get dayTimeString=>DateTime.now().hour<12?'Morning':DateTime.now().hour<17?'Afternoon':'Evening';

  static showFullScreenLoading(
      BuildContext context, Completer<BuildContext> dialogContextCompleter) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black45,
      transitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (
        BuildContext buildContext,
        Animation animation,
        Animation secondaryAnimation,
      ) {
        if (!dialogContextCompleter.isCompleted) {
          dialogContextCompleter.complete(context);
        }
        return Center(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.all(20),
            color: Colors.white.withOpacity(0),
            child: const Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        );
      },
    );
  }

  static formatDate(DateTime dateTime) =>
      '${dateTime.day} ${months[dateTime.month - 1]}, ${dateTime.year}';

  static List<String> months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  static List<String> daysOfTheWeek = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday',
  ];
}
