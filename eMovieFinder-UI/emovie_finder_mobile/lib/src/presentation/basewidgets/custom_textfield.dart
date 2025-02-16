
import 'package:flutter/material.dart';

import 'package:emovie_finder_mobile/src/style/theme/theme.dart';

class MyTextFormField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function? validation;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;

  const MyTextFormField(this.hint, this.icon, this.validation, this.controller, this.keyboardType, {this.readOnly = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        textCapitalization: TextCapitalization.words,
        style: Theme.of(context).textTheme.headlineSmall,
        validator: validation != null ? (value) => validation!(value) : null,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        controller: controller,
        cursorColor: MyTheme.gray,
        keyboardType: keyboardType,
        readOnly: readOnly,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.headlineSmall,
          prefixIcon: Icon(
            icon,
            color: MyTheme.gray,
          ),
          filled: true,
          fillColor: readOnly ? MyTheme.blackThree : MyTheme.blackOne,
          hoverColor: Colors.transparent, // No hover effect
          errorStyle: const TextStyle(
            fontSize: 14,
            color: Colors.red,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.blackOne),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.red),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.blackOne),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.blackOne),
          ),
        ),
      ),
    );
  }
}

class MyPasswordTextFormField extends StatefulWidget {
  final String hint;
  final IconData icon;
  final Function? validation;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const MyPasswordTextFormField(this.hint, this.icon, this.validation, this.controller, this.keyboardType, {super.key});

  @override
  State<MyPasswordTextFormField> createState() => _MyPasswordTextFormFieldState();
}

class _MyPasswordTextFormFieldState extends State<MyPasswordTextFormField> {
  bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        style: Theme.of(context).textTheme.headlineSmall,
        validator: widget.validation != null ? (value) => widget.validation!(value) : null,
        controller: widget.controller,
        obscureText: !showPassword,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        cursorColor: MyTheme.gray,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(15),
          hintText: widget.hint,
          hintStyle: Theme.of(context).textTheme.headlineSmall,
          errorStyle: const TextStyle(
            fontSize: 14,
            color: Colors.red,
          ),
          prefixIcon: Icon(
            widget.icon,
            color: MyTheme.gray,
          ),
          suffixIcon: InkWell(
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              setState(() {
                showPassword = !showPassword;
              });
            },
            child: showPassword
                ? const Icon(Icons.visibility, color: MyTheme.gray)
                : const Icon(Icons.visibility_off, color: MyTheme.gray),
          ),
          filled: true,
          fillColor: MyTheme.blackOne, // Keeps the background the same
          hoverColor: Colors.transparent, // Prevents hover color change
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.blackOne),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.red),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.blackOne),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.red),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: const BorderSide(width: 2, color: MyTheme.blackOne),
          ),
        ),
      ),
    );
  }
}

