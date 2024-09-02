import 'package:flutter/material.dart';

class AppWidgets{

  Widget textFormFieldView({required TextEditingController? controller,bool? enabled,String? Function(String?)? validator,required String? hintText,int? maxLines}){
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
            hintStyle: const TextStyle(color: Colors.white),
            border: const OutlineInputBorder()
        ),
      ),
    );
  }
  Widget elevatedButtonView({required void Function()? onPressed,required Widget? child}){
    return ElevatedButton(onPressed: onPressed,style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        fixedSize: const Size(250, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))
    ), child: child,);
  }
  Widget sizedBoxView({Widget? child,double? width,double? height}){
    return SizedBox(
      width: width,
      height: height,
      child: child,
    );
  }
}