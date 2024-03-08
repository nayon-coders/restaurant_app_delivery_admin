import 'package:driver/firebase/controller/paymnet_controller.dart';
import 'package:driver/utilitys/colors.dart';
import 'package:driver/view/payment_histori/widget/pay_button.dart';
import 'package:driver/view/paymment_detials/Payment_Detial.dart';
import 'package:driver/widgets/app_inputs.dart';
import 'package:flutter/material.dart';

import '../../generated/assets.dart';

class Payment_Histori extends StatefulWidget {
  const Payment_Histori({super.key});

  @override
  State<Payment_Histori> createState() => _Payment_HistoriState();
}

class _Payment_HistoriState extends State<Payment_Histori> {


  List _status = ["Pending","Approved","Cancel"];

  List _selectedStatus = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedStatus.add( _status[0]);
  }


  final _payment=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.babg,
      appBar: AppBar(
        leading: IconButton(
          onPressed: ()=>Navigator.pop(context),
          icon: Icon(Icons.arrow_back, color: Colors.black,),

        ),
        title: Text("Historial de pagos",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500, color: Colors.black),),
        backgroundColor: AppColors.aapbg,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
              child: ListView.builder(
                itemCount: _status.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_,index){
                  return  Pay_Button(
                    onTap: (){
                      _selectedStatus.clear();
                      setState(() {
                        _selectedStatus.add(_status[index]);
                      });

                    },

                      text: "${_status[index]}",
                      color:_selectedStatus.contains(_status[index]) ? AppColors.white : Colors.grey
                  );
                },
              ),
            ),
            SizedBox(height: 10,),
            // AppInput(
            //     title: "",
            //     hintText: "búsqueda de fecha",
            //     prefixIcon: Icon(Icons.calendar_today,color: Colors.grey,),
            //     controller: _payment,
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Lista de retiros pendientes",style: TextStyle(fontWeight: FontWeight.w500,color: Colors.black),),
            ),
            StreamBuilder(
              stream: PaymentController.getWithdrawRequest(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator(),);
                }else if(snapshot.hasData){

                  List _data = [];

                  //check the status of the payment
                  //if the status is pending then show the list of the payment
                  snapshot.data.docs.forEach((element) {
                    if( element.data()["status"] == _selectedStatus[0]){
                      _data.add(element);
                    }else if( element.data()["status"] == _selectedStatus[0]){
                      _data.add(element);
                    }else if(element.data()["status"] == _selectedStatus[0]){
                      _data.add(element);
                    }
                  });

                  //if the status is approved then show the list of the payment
                  //if the status is cancel then show the list of the payment

                  return _data.isNotEmpty ? Expanded(
                      child: ListView.builder(
                          itemCount: _data.length,
                          itemBuilder: (_,index){
                            var data = _data[index];
                            return InkWell(
                              onTap: (){
                                Navigator.push(context,MaterialPageRoute(builder: (context)=>Payment_Detial(data: _data[index],)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: 180,
                                padding: EdgeInsets.all(5),
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),

                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15.0, top: 10),
                                      child: Text("Date: ${data["date"]}",),
                                    ),
                                    ListTile(
                                      title: Text("Name: ${data["name"]}",style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
                                      subtitle: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text("Email: ${data["email"]}",
                                            style: TextStyle(color: AppColors.bblue),),
                                          SizedBox(height: 5,),
                                          RichText(text: TextSpan(
                                              text: "Status : ",
                                              style: TextStyle(color: Colors.black),
                                              children: [
                                                TextSpan(
                                                  text:"${data["status"]}",
                                                  style: TextStyle(color:AppColors.oblue),
                                                )
                                              ]
                                          )),
                                        ],
                                      ),
                                      trailing: Icon(Icons.keyboard_double_arrow_down,color: AppColors.abgreen,size: 30,),
                                    ),
                                    ListTile(

                                      title: Text("Total:"),
                                      trailing: Text("\$${double.parse(data["amount"].toString()).toStringAsFixed(2)}",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          })) : Center(child: Text("No data found"),);
                }else{
                  return Center(child: Text("No data found"),);
                }
              }
            )



          ],
        ),
      ),
    );
  }
}


