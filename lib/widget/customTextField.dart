import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/utils/appColors.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool showObscure;
  final bool? readOnly;
  final IconData? prefixIcon;
  final IconData? postfixIcon;
  final VoidCallback? onPostfixTap;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final Color? fillColor;
  final Color? borderColor;
  final Color? cursorColor;
  final int? maxLines;

  /// ✅ NEW
  final bool isError;
  final String? errorText;
  final Function(String)? onChanged;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.showObscure,
    this.keyboardType,
    this.controller,
    this.prefixIcon,
    this.postfixIcon,
    this.onPostfixTap,
    this.fillColor,
    this.borderColor,
    this.cursorColor,
    this.maxLines,
    this.readOnly,
    this.isError = false,
    this.errorText,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() =>
      _CustomTextFieldState();
}

class _CustomTextFieldState
    extends State<CustomTextField> {

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Container(
          decoration: BoxDecoration(
            color:
            widget.fillColor ?? Colors.white,
            borderRadius:
            BorderRadius.circular(10.r),
            border: Border.all(
              color: widget.isError
                  ? Colors.red
                  : Colors.black12,
              width: 1.2,
            ),
          ),
          child: TextField(
            onChanged: widget.onChanged,
            controller: widget.controller,
            readOnly:
            widget.readOnly ?? false,
            obscureText:
            widget.showObscure
                ? _obscureText
                : false,
            keyboardType:
            widget.keyboardType,
            cursorColor:
            widget.cursorColor ??
                Colors.black,
            maxLines:
            widget.maxLines ?? 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding:
              EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 14.h),

              prefixIcon:
              widget.prefixIcon != null
                  ? Icon(
                widget.prefixIcon,
                color: AppColors
                    .mainColor,
              )
                  : null,

              suffixIcon:
              widget.showObscure
                  ? IconButton(
                icon: Icon(
                  _obscureText
                      ? Icons
                      .visibility_off
                      : Icons
                      .visibility,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText =
                    !_obscureText;
                  });
                },
              )
                  : null,

              hintText: widget.hintText,
              hintStyle:
              GoogleFonts.lato(
                fontSize: 14.sp,
                color: Colors.black54,
              ),
            ),
          ),
        ),

        /// ✅ ERROR TEXT
        if (widget.isError &&
            widget.errorText != null)
          Padding(
            padding:
            const EdgeInsets.only(
                left: 6, top: 4),
            child: Text(
              widget.errorText!,
              style: const TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}