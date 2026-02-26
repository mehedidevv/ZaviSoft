import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../../core/utils/appColors.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final double? fontSize;
  final VoidCallback? onTap;
  final bool centerTitle;
  final Color? backgroundColor;
  final bool forceMaterialTransparency;
  final bool? automaticallyImplyLeading;
  final List<Widget>? actions;
  final Widget? leading;

  final String? rightIcon;
  final VoidCallback? onRightIconTap;
  final double iconSize;
  final Color iconBackgroundColor;
  final Color iconBorderColor;

  const CommonAppbar({
    Key? key,
    required this.title,
    this.fontSize,
    this.centerTitle = true,
    this.backgroundColor = Colors.transparent,
    this.forceMaterialTransparency = true,
    this.actions,
    this.leading,
    this.automaticallyImplyLeading,
    this.onTap,
    this.rightIcon,
    this.onRightIconTap,
    this.iconSize = 40,
    this.iconBackgroundColor = Colors.white,
    this.iconBorderColor = const Color(0xFFD9D9D9),
  })  : preferredSize = const Size.fromHeight(kToolbarHeight),
        super(key: key);

  @override
  final Size preferredSize;

  /// Builds a circular container with optional border, background, and centered child
  Widget _buildCircularIcon({
    required Widget child,
    required VoidCallback? onTap,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: iconSize.h,
        width: iconSize.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor ?? iconBackgroundColor,
          border: Border.all(
            color: iconBorderColor,
            width: 1,
          ),
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> finalActions = actions ?? [];

    if (rightIcon != null) {
      finalActions.add(
        Padding(
          padding: EdgeInsets.only(right: 8.w),
          child: _buildCircularIcon(
            onTap: onRightIconTap,
            backgroundColor: const Color(0xFFEAEAEA), // custom notification bg
            child: Image.asset(
              rightIcon!,
              height: (iconSize * 0.5).h,
              width: (iconSize * 0.5).w,
              fit: BoxFit.cover,
            ),
          ),
        ),
      );
    }

    return AppBar(
      automaticallyImplyLeading: automaticallyImplyLeading ?? true,
      backgroundColor: backgroundColor,
      forceMaterialTransparency: true,
      title: Text(
        title,
        style: GoogleFonts.abhayaLibre(
          fontSize: fontSize ?? 18.h,
          fontWeight: FontWeight.w500,
        ),
      ),
      centerTitle: centerTitle,
      actions: finalActions,
      leading: leading ??
          Padding(
            padding: EdgeInsets.only(left: 8.w),
            child: _buildCircularIcon(
              onTap: onTap ??
                      () {
                    if (Get.isSnackbarOpen) Get.closeCurrentSnackbar();
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      if (kDebugMode) print("No routes to pop");
                    }
                  },
              child: Icon(
                Icons.arrow_back_rounded,
                color: AppColors.whiteColor,
                size: (iconSize * 0.4).h,
              ),
            ),
          ),
      elevation: forceMaterialTransparency ? 0 : null,
    );
  }
}