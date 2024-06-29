import 'package:flutter/material.dart';

import '../classes/app_color.dart';

class EdtClear extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final FocusNode focusNode;
  final TextEditingController textController;
  final TextInputType textInputType;
  final String hint;
  final int max;

  const EdtClear(
      {super.key,
        required this.onChanged,
        required this.focusNode,
        required this.textController,
        required this.textInputType,
        required this.hint,
        required this.max,
      });

  @override
  State<EdtClear> createState() => _State();
}

class _State extends State<EdtClear> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 2, right: 2, bottom: 4, top: 4),
      child: TextField(
        onChanged: widget.onChanged,
        controller: widget.textController,
        focusNode: widget.focusNode,
        keyboardType: widget.textInputType,
        maxLength: widget.max,
        style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w500, fontFamily: 'Satoshi'),
        cursorColor: Colors.black,
        cursorHeight: 16,
        maxLines: 1,
        autocorrect: false,
        enableSuggestions: true,
        onTapOutside: (v){
          widget.focusNode.unfocus();
        },
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Colors.white,
          hintText: widget.hint,
          hintStyle: const TextStyle(
              color: Colors.black12,
              fontSize: 14
          ),
          isDense: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(right: 4,left: 4),
            child: Icon(Icons.search, size: 24, color: AppColor.colorApp,),
          ),
          prefixIconConstraints: const BoxConstraints(
            minHeight: 2,
            minWidth: 2
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: const BorderSide(
                color: Colors.white),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(
                  color: Colors.white)),
        ),
      ),
    );
  }
}