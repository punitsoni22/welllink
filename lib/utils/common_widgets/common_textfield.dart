import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:welllink/utils/constant/extensions/text_style_extensions.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController? controller;
  final Color? textFieldColor;
  final String hintText;
  final String? label;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;
  final EdgeInsets? contentPadding;
  final Function(String)? onChanged;
  final bool? readOnly;
  final bool initialObscure;
  final IconData? leadingIcon;

  const CommonTextField({
    super.key,
    this.controller,
    this.textFieldColor,
    required this.hintText,
    this.label,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.contentPadding,
    this.onChanged,
    this.readOnly,
    this.initialObscure = false,
    this.leadingIcon,
  });

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.initialObscure;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Add GestureDetector at the root level
      onTap: () {
        // Do nothing here, just prevent tap from going through
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          widget.label == null || widget.label == ''
              ? const SizedBox()
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 2.h),
            child: Text(
              widget.label ?? '',
              style: context.smallTitleText(),
            ),
          ),
          GestureDetector(
            // Wrap the container with another GestureDetector
            onTap: () {
              // When tapping outside the text field but within the container
              FocusScope.of(context).unfocus();
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
              decoration: BoxDecoration(
                color: widget.textFieldColor ??
                    Theme.of(context).colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.shadow,
                    blurRadius: 2,
                  )
                ],
              ),
              child: Row(
                children: [
                  widget.leadingIcon == null
                      ? const SizedBox()
                      : Icon(
                    widget.leadingIcon,
                    size: 20.sp,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.6),
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: widget.controller,
                      onChanged: widget.onChanged,
                      readOnly: widget.readOnly ?? false,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.left,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        contentPadding: widget.contentPadding ??
                            EdgeInsets.symmetric(horizontal: 12.w),
                        isDense: true,
                        border: InputBorder.none,
                        hintText: widget.hintText,
                        hintStyle: context.captionText(),
                      ),
                      style: context.smallTitleText(),
                      keyboardType: widget.keyboardType,
                      validator: widget.validator,
                      // Add focus handling
                      onTapOutside: (event) {
                        FocusScope.of(context).unfocus();
                      },
                    ),
                  ),
                  widget.initialObscure
                      ? GestureDetector(
                    onTap: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    child: Icon(
                      _isObscure
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 20.sp,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.6),
                    ),
                  )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}