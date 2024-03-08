import 'package:flutter/material.dart';
class Pay_Button extends StatelessWidget {
  const Pay_Button({
    super.key,required this.text,required this.color, this.onTap,
  });
  final Color color;
  final String text;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(right: 10),
        height: 50,
        width: 100,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Center(child: Text(text,style: TextStyle(color: Colors.black,fontSize: 15),)),
      ),
    );
  }
}