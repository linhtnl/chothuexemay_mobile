// ignore_for_file: must_be_immutable, non_constant_identifier_names

import 'dart:convert';
import 'package:chothuexemay_mobile/models/order_model.dart';
import 'package:chothuexemay_mobile/models/owner_model.dart';
import 'package:chothuexemay_mobile/utils/constants.dart';
import 'package:chothuexemay_mobile/view_model/customer_view_model.dart';
import 'package:chothuexemay_mobile/views/Booking/Result/result_view.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BodyWaiting extends StatefulWidget {
  OrderModel order;
  final ownerIds = [];
  BodyWaiting({Key? key, required this.order}) : super(key: key);

  @override
  State<BodyWaiting> createState() => _BodyWaitingState();
}

class _BodyWaitingState extends State<BodyWaiting> {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  CustomerViewModel customerViewModel = CustomerViewModel();

  void firebaseCloudMessaging_Listeners() {
    _fcm.getToken().then((token) async {});

    FirebaseMessaging.onMessage.listen((RemoteMessage evt) async {
      final data = jsonDecode(evt.data["data"]);
      if (evt.data["action"] != "acceptBooking") {
        return;
      }
      bool isAccepted = data["IsAccepted"];
      String ownerId = data["OwnerId"];
      if (owners.isEmpty) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ResultView(),
          ),
          (route) => false,
        );
      }
      Owner owner = owners[0];
      if (isAccepted) {
        OrderModel orderModel = OrderModel.createBooking(
            ownerId: ownerId,
            licensePlate: owner.bike.licensePlate,
            cateName: owner.bike.categoryName,
            dateRent: widget.order.dateRent,
            dateReturn: widget.order.dateReturn,
            imgPath: owner.bike.imgPath,
            address: widget.order.address,
            totalPrice: widget.order.totalPrice,
            typeId: widget.order.typeId,
            bikeId: owner.bike.id,
            categoryId: owner.bike.categoryId,
            voucherCode: widget.order.voucherCode,
            ownerName: owner.fullname);
        if (!widget.ownerIds.contains(owner.id)) {
          widget.ownerIds.add(owner.id);
          await customerViewModel.createBooking(orderModel);
        }

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => ResultView(
              owner: owner,
            ),
          ),
          (route) => false,
        );
        return;
      } else {
        owners.removeWhere((element) {
          return element.id == ownerId;
        });
        if (owners.isEmpty) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<dynamic>(
              builder: (BuildContext context) => ResultView(),
            ),
            (route) => false,
          );
        }
        owner = owners[0];
        OrderModel orderNoti = OrderModel.sendNoti(
            ownerId: owner.id,
            licensePlate: owner.bike.licensePlate,
            cateName: owner.bike.cateName,
            dateRent: widget.order.dateRent,
            dateReturn: widget.order.dateReturn,
            imgPath: owner.bike.imgPath,
            address: widget.order.address,
            totalPrice: widget.order.totalPrice);

        customerViewModel.sendNoti(orderNoti);
      }
    });
  }

  List<Owner> owners = [];

  @override
  void initState() {
    Provider.of<CustomerViewModel>(context, listen: false)
        .findBikes(widget.order, context);
    owners = Provider.of<CustomerViewModel>(context, listen: false).owners;
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              StringConstants.imageDirectory + "loading.gif",
              width: size.width * 0.75,
            ),
            const SizedBox(
              height: 25,
            ),
            Container(
              padding: EdgeInsets.only(
                  left: size.width * 0.12, right: size.width * 0.12),
              child: const Text(
                "H??? th???ng ??ang t??m xe, mong b???n ch??? m???t x??u nh??...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        )
      ],
    );
  }
}
