import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants.dart';
import 'custom_font.dart';

Future<void> customDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false, // user must tap Okay
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: FB_DARK_PRIMARY,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // completes the Future
            },
            child: const Text('Okay'),
          ),
        ],
      );
    },
  );
}

customOptionDialog(
  BuildContext context, {
  required title,
  required content,
  required Function onYes,
}) {
  AlertDialog alertDialog = AlertDialog(
    title: CustomFont(text: title, fontSize: 30.sp, color: Colors.black),
    content: CustomFont(text: content, fontSize: 30.sp, color: Colors.black),
    actions: <Widget>[
      OutlinedButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: CustomFont(
          text: 'No',
          fontSize: 30.sp,
          color: FB_TEXT_COLOR_WHITE,
        ),
      ),
      ElevatedButton(
        child: CustomFont(
          text: 'Yes',
          fontSize: 30.sp,
          color: FB_TEXT_COLOR_WHITE,
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: FB_DARK_PRIMARY,
          foregroundColor: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
          onYes();
        },
      ),
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alertDialog;
    },
  );
}

Future<void> CustomShowImageDialog(
  BuildContext context, {
  required String imageUrl,
  bool isAsset = false,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        contentPadding: EdgeInsets.zero,
        content: Stack(
          children: [
            Container(
              width: double.maxFinite,
              constraints: BoxConstraints(maxHeight: 400.h),
              child: Center(
                child: isAsset
                    ? Image.asset(imageUrl, fit: BoxFit.contain)
                    : CachedNetworkImage(
                        imageUrl: imageUrl,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) =>
                                CircularProgressIndicator(
                                  color: FB_DARK_PRIMARY,
                                  value: downloadProgress.progress,
                                ),
                        errorWidget: (context, url, error) =>
                            Icon(Icons.error, size: 100.sp),
                      ),
              ),
            ),
            Positioned(
              right: 8.w,
              top: 8.h,
              child: InkWell(
                onTap: () => Navigator.of(context).pop(),
                borderRadius: BorderRadius.circular(20.r),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(6.w),
                  child: Icon(Icons.close, color: Colors.white, size: 22.sp),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
