import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class Utils{

  static showLoadingDialog([String? text]) {
    if (Get.isSnackbarOpen) {
      Get.closeAllSnackbars();
    }
    if (!Get.isDialogOpen!) {
      Get.dialog(
        WillPopScope(
          onWillPop: () async => true,
          child: CustomLoadingDialog(
            title: text ?? 'Loading ...',
          ),
        ),
        barrierDismissible: false,
        useSafeArea: false,
      );
    }
  }
  static void hideLoadingDialog() {
    if (Get.isDialogOpen!) {
      Get.back();
    }
  }

  static Future<List<PlatformFile>> pickImages({bool allowMultiple = true, FileType type = FileType.image, List<String>? allowedExtensions}) async {
    try {
      var pickFiles = await FilePicker.platform.pickFiles(
        allowMultiple: allowMultiple,
        type: type,
        allowedExtensions: allowedExtensions,
        withData: true,
        onFileLoading: (FilePickerStatus status) => log(status.toString()),
      );
      return pickFiles?.files ?? [];
    } on PlatformException catch (e) {
      log('Unsupported operation $e');
    } catch (e) {
      log(e.toString());
    }
    return [];
  }



}

class CustomLoadingDialog extends StatelessWidget {
  final String title;

  const CustomLoadingDialog({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size deviceSize = MediaQuery.of(context).size;
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          constraints: const BoxConstraints(
            maxHeight: 250,
            maxWidth: 250,
          ),
          height: 0.1 * deviceSize.height,
          width: 0.8 * deviceSize.width,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.light ? Colors.white : Colors.grey[600],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              const CircularProgressIndicator(),
              Expanded(
                child: Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(
                    title,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
