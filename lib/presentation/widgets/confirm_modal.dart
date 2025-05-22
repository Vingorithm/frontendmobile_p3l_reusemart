import 'package:flutter/material.dart';
import '../../core/theme/color_pallete.dart';

class ConfirmationModal extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final Color? iconColor;
  final Color? confirmButtonColor;
  final Color? confirmTextColor;
  final bool isDangerous;

  const ConfirmationModal({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText = 'Cancel',
    this.onCancel,
    this.iconColor,
    this.confirmButtonColor,
    this.confirmTextColor,
    this.isDangerous = false,
  });

  // Factory constructor untuk logout confirmation
  factory ConfirmationModal.logout({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationModal(
      icon: Icons.logout_outlined,
      title: 'Logout',
      message: 'Are you sure you want to logout from your account?',
      confirmText: 'Logout',
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: true,
    );
  }

  // Factory constructor untuk delete confirmation
  factory ConfirmationModal.delete({
    required String itemName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationModal(
      icon: Icons.delete_outline,
      title: 'Delete $itemName',
      message: 'Are you sure you want to delete this $itemName? This action cannot be undone.',
      confirmText: 'Delete',
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: true,
    );
  }

  // Factory constructor untuk save changes confirmation
  factory ConfirmationModal.saveChanges({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationModal(
      icon: Icons.save_outlined,
      title: 'Save Changes',
      message: 'Do you want to save the changes you made?',
      confirmText: 'Save',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.primary,
    );
  }

  // Factory constructor untuk discard changes confirmation
  factory ConfirmationModal.discardChanges({
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationModal(
      icon: Icons.cancel_outlined,
      title: 'Discard Changes',
      message: 'Are you sure you want to discard your changes? All unsaved changes will be lost.',
      confirmText: 'Discard',
      onConfirm: onConfirm,
      onCancel: onCancel,
      isDangerous: true,
    );
  }

  // Factory constructor untuk submit confirmation
  factory ConfirmationModal.submit({
    required String action,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return ConfirmationModal(
      icon: Icons.send_outlined,
      title: 'Submit $action',
      message: 'Are you ready to submit this $action?',
      confirmText: 'Submit',
      onConfirm: onConfirm,
      onCancel: onCancel,
      confirmButtonColor: AppColors.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIconColor = iconColor ?? (isDangerous ? Colors.red : AppColors.primary);
    final effectiveConfirmButtonColor = confirmButtonColor ?? (isDangerous ? Colors.red : AppColors.primary);
    final effectiveConfirmTextColor = confirmTextColor ?? Colors.white;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      contentPadding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
      titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      actionsPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      title: Row(
        children: [
          Icon(
            icon,
            color: effectiveIconColor,
            size: 28,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 20,
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          color: AppColors.textPrimary,
          fontSize: 16,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            if (onCancel != null) {
              onCancel!();
            }
          },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            cancelText,
            style: TextStyle(
              color: AppColors.textPrimary.withOpacity(0.6),
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: effectiveConfirmButtonColor,
            foregroundColor: effectiveConfirmTextColor,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 12,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: Text(
            confirmText,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Static method untuk menampilkan modal
  static Future<void> show(
    BuildContext context,
    ConfirmationModal modal,
  ) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => modal,
    );
  }

  // Static method untuk logout confirmation dengan shortcut
  static Future<void> showLogout(
    BuildContext context, {
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      ConfirmationModal.logout(
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  // Static method untuk delete confirmation dengan shortcut
  static Future<void> showDelete(
    BuildContext context, {
    required String itemName,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      ConfirmationModal.delete(
        itemName: itemName,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  // Static method untuk save changes confirmation dengan shortcut
  static Future<void> showSaveChanges(
    BuildContext context, {
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      ConfirmationModal.saveChanges(
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  // Static method untuk discard changes confirmation dengan shortcut
  static Future<void> showDiscardChanges(
    BuildContext context, {
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      ConfirmationModal.discardChanges(
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  // Static method untuk submit confirmation dengan shortcut
  static Future<void> showSubmit(
    BuildContext context, {
    required String action,
    required VoidCallback onConfirm,
    VoidCallback? onCancel,
  }) {
    return show(
      context,
      ConfirmationModal.submit(
        action: action,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }
}