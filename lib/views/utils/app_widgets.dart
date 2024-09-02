import 'package:flutter/material.dart';

class AppWidgets{

  Widget textFormFieldView({required TextEditingController? controller,bool? enabled,String? Function(String?)? validator, String? hintText,int? maxLines,String? labelText,TextStyle? labelStyle}){
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        validator: validator,
        maxLines: maxLines,
        style:const TextStyle(color: Colors.white) ,
        decoration: InputDecoration(
            hintText: hintText,
            labelText: labelText,
            hintStyle: const TextStyle(color: Colors.white),
            labelStyle: labelStyle,
            border: const OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white30),
          ),
        ),
      ),
    );
  }
  Widget elevatedButtonView({required void Function()? onPressed,required Widget? child,Color? backgroundColor}){
    return ElevatedButton(onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ), child: child,);
  }
  Widget sizedBoxView({Widget? child,double? width,double? height}){
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
  Widget checkBoxListTile({required String title,bool selected = false,required bool? value,required void Function(bool?)? onChanged}){
    return CheckboxListTile(
      title: Text(title, style: const TextStyle(color: Colors.white),),
      autofocus: false,
      selected: selected,
      value: value,
      onChanged: onChanged,
    );
  }
}