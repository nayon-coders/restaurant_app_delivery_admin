import 'package:flutter/material.dart';
class Payment_detial_button extends StatelessWidget {
  const Payment_detial_button({
    super.key,required this.name,required this.color,required this.onCleck, this.isLoading = false
  });
  final String name;
  final Color color;
  final VoidCallback onCleck;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onCleck,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: 60,
          width: 350,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: color,
          ),
          child: isLoading ? Center(child: CircularProgressIndicator(color: Colors.white,),) : Center(child: Text(name,style: TextStyle(color: Colors.white),)),
        ),
      ),
    );
  }
}