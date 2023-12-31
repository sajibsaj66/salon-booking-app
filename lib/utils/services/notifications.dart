import 'package:elegant_notification/elegant_notification.dart';
import 'package:elegant_notification/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:salon_app/utils/ui/styles.dart';
import 'package:salon_app/utils/ui/text.dart';

class ToastManager {
  static void showErrorToast(BuildContext context, String message) {
    ElegantNotification.error(
        height: 80,
        showProgressIndicator: false,
        notificationPosition: NotificationPosition.bottomCenter,
        animation: AnimationType.fromBottom,
        displayCloseButton: false,
        description: Text(
          message,
          style: AppTextStyles.bodyExtraSmall.copyWith(color: Styles.gray100),
        )).show(context);
  }

  static void showSuccessToast(BuildContext context, String message) {
    ElegantNotification.success(
        height: 80,
        showProgressIndicator: false,
        notificationPosition: NotificationPosition.bottomCenter,
        animation: AnimationType.fromBottom,
        displayCloseButton: false,
        description: Text(
          message,
          style: AppTextStyles.bodyExtraSmall.copyWith(color: Styles.gray100),
        )).show(context);
  }
}
