import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:driver/widgets/app_tost.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PaymentController {

  static final _auth = FirebaseAuth.instance;
  static final _firestore = FirebaseFirestore.instance;

  //get withdraw request
  static Stream getWithdrawRequest() {
    try {
      return _firestore.collection("withdraw_request").snapshots();
    } catch (e) {
      print("Error in getWithdrawRequest: $e");
      return Stream.empty();
    }
  }

  //reject withdraw request and get back the amount to user account
  static Future<void> rejectWithdrawRequest(
      {required BuildContext context, required String id, required String amount, required String email}) async {
    try {
      //get user info
      await _firestore.collection("withdraw_request").doc(id).get().then((
          value) async {
        if (value.exists) {
          //change status to rejected in withdraw request
          await _firestore.collection("withdraw_request").doc(id).update(
              {"status": "Cancel"}).then((value) {
          });
          //get user info
          await _firestore.collection("delivery_boys").doc(
              value.data()!["email"])
              .get()
              .then((value) async {
            if (value.exists) {
              //get user balance
              double balance = double.parse(value.get("total_earning"));
              //add amount to user balance
              balance = balance + double.parse(amount);
              //update user balance
              await _firestore.collection("delivery_boys").doc(value.id).update(
                  {"total_earning": balance.toString()});
            }
          });
          AppToast.showToast("Withdraw request rejected", Colors.green);
          Navigator.pop(context);
        }
      });
    } catch (e) {
      print("Error in rejectWithdrawRequest: $e");
    }
  }

  //paid withdraw request
  static Future<void> paidWithdrawRequest(
      {required BuildContext context, required String id, required String amount, required String email}) async {
    try {
      //get user info
      await _firestore.collection("withdraw_request").doc(id).get().then((
          value) async {
        if (value.exists) {
          //change status to paid in withdraw request
          await _firestore.collection("withdraw_request").doc(id).update(
              {"status": "Approved"}).then((value) {
          });
          AppToast.showToast("Withdraw request paid", Colors.green);
          Navigator.pop(context);
        }
      });
    } catch (e) {
      print("Error in paidWithdrawRequest: $e");
    }
  }
}
