import 'package:driver/utilitys/colors.dart';
import 'package:driver/view/paymment_detials/widget/payment_detial_button.dart';
import 'package:driver/widgets/app_tost.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../firebase/controller/paymnet_controller.dart';
import '../../generated/assets.dart';

class Payment_Detial extends StatefulWidget {
  final dynamic data;
  const Payment_Detial({super.key, this.data});

  @override
  State<Payment_Detial> createState() => _Payment_DetialState();
}

class _Payment_DetialState extends State<Payment_Detial> {

  bool _isRejected = false;
  bool _isPaid = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black,),

        ),
        title: Text("Historial de pagos",style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black),),
        backgroundColor: AppColors.aapbg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Date: ${widget.data["date"]}"),
            SizedBox(height: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Cantidad de la solicitud",style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20),),
                Icon(Icons.cancel_presentation,size: 20,color: Colors.grey,)
              ],
            ),
            SizedBox(height: 5,),
            Text("\$ ${widget.data["amount"]}",style: TextStyle(fontSize: 35,fontWeight: FontWeight.w500),),
            SizedBox(height: 5,),
            RichText(text: TextSpan(
                text: "Status : ",
              style: TextStyle(color: Colors.black,fontWeight: FontWeight.w400),
              children: [
                TextSpan(
                  text:"${widget.data["status"]}",
                  style: TextStyle(color: AppColors.oblue,fontWeight: FontWeight.w400)
                )
              ]
            ),),

            SizedBox(height: 20,),
            Container(
              padding: EdgeInsets.all(10),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0,top: 10),
                    child: Text("Detalles del método de pago"),
                  ),
                  ListTile(
                    title: Text("Account No. ${widget.data["number"]}"),
                    trailing: IconButton(
                        onPressed: ( ){
                          Clipboard.setData(ClipboardData(text: widget.data["number"])).then((value) {
                            AppToast.showToast("Account number copied", Colors.green);
                          });

                        },
                        icon: Icon(Icons.copy)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Text("Driver Info",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 17
              ),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
              ),
              child: ListTile(
                title: Text("Name: ${widget.data["name"]}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                subtitle: Text("Email: ${widget.data["email"]}",
                  style: TextStyle(color: AppColors.bblue),),
              ),
            ),
            SizedBox(height: 30,),
            widget.data["status"] == "Pending" ? Payment_detial_button(
              isLoading: _isRejected,
                name: "Reject", color: AppColors.bred,
                onCleck: ()async{
                  setState(() => _isRejected = true);
                  await PaymentController.rejectWithdrawRequest(
                      context: context,
                      id: widget.data.id,
                      amount: widget.data["amount"],
                      email: widget.data["email"]
                  );
                  setState(() => _isRejected = false);
                }
            ) :Center(),
            widget.data["status"] == "Cancel" ? Payment_detial_button(
                name: "Cancel", color: AppColors.red, onCleck: (){})
                : Center(),
            widget.data["status"] == "Pending" ? Payment_detial_button(
                name: "Paid", color: AppColors.dgreen, isLoading: _isPaid, onCleck: (){
              setState(() => _isPaid = true);
              PaymentController.paidWithdrawRequest(
                  context: context,
                  id: widget.data.id,
                  amount: widget.data["amount"],
                  email: widget.data["email"]
              ).then((value) => setState(() => _isPaid = false));
            }) : Center(),
            widget.data["status"] == "Approved" ? Payment_detial_button(
                name: "Payment done", color: AppColors.dgreen, onCleck: (){})
                : Center(),

          ],
        ),
      ),
    );
  }
}


