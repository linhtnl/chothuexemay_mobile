import 'package:chothuexemay_mobile/models/order_model.dart';
import 'package:chothuexemay_mobile/models/price_model.dart';
import 'package:chothuexemay_mobile/models/motor_type_model.dart';
import 'package:chothuexemay_mobile/utils/constants.dart';
import 'package:chothuexemay_mobile/view_model/customer_view_model.dart';
import 'package:chothuexemay_mobile/views/Booking/Voucher/voucher_view.dart';
import 'package:chothuexemay_mobile/views/Booking/Waiting/waiting_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class BodyBookingDetail extends StatefulWidget {
  OrderModel order;

  BodyBookingDetail({required this.order});

  @override
  State<BodyBookingDetail> createState() => _BodyBookingDetailState();
}

class _BodyBookingDetailState extends State<BodyBookingDetail> {
  //Format currency number
  RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
  String Function(Match) mathFunc = (Match match) => '${match[1]}.';

  String selectedMethod = "Tiền mặt";
  List<String> listPayMethod = ["Tiền mặt", "Momo", "Visa"];
  String address = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String dateRent = widget.order.dateRent.day.toString() +
        "/" +
        widget.order.dateRent.month.toString() +
        "/" +
        widget.order.dateRent.year.toString() +
        " - " +
        widget.order.dateRent.hour.toString() +
        ":" +
        widget.order.dateRent.minute.toString();
    String dateReturn = widget.order.dateReturn.day.toString() +
        "/" +
        widget.order.dateReturn.month.toString() +
        "/" +
        widget.order.dateReturn.year.toString() +
        " - " +
        widget.order.dateReturn.hour.toString() +
        ":" +
        widget.order.dateReturn.minute.toString();
    double price = 0;
    Duration duration =
        widget.order.dateReturn.difference(widget.order.dateRent);
    if (widget.order.rentMethod == "day") {
      price = (duration.inDays * widget.order.cateBike.price).toDouble();
    } else {
      price = duration.inHours * widget.order.cateBike.price * 1.1 / 24;
    }
    CustomerViewModel _customerViewModel =
        Provider.of<CustomerViewModel>(context);

    address = Provider.of<CustomerViewModel>(context).address;
    //_customerViewModel.booking(widget.dateRent, widget.dateReturn);
    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        "XÁC NHẬN THÔNG TIN",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Container(
                          width: size.width * 0.4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text("Ngày thuê:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Ngày trả:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                              Text("Loại xe:",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(dateRent,
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Text(dateReturn,
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                              Text(widget.order.cateBike.bikeType,
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              SizedBox(
                                height: 15,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    const Text("Địa chỉ của bạn:",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(widget.order.address,
                        style: const TextStyle(
                          fontSize: 18,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                )),
            Container(
              width: double.infinity,
              color: Colors.grey[300],
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              child: const Text("Phương thức thanh toán",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  top: 10, left: 15, right: 15, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        StringConstants.iconDirectory + "price.png",
                        width: 30,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      dropDownPayMethod(size)
                    ],
                  ),
                  const Text(
                    "|",
                    style: TextStyle(fontSize: 18),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) {
                            return VoucherView();
                          },
                        ));
                      },
                      child: const Text(
                        "Thêm ưu đãi",
                        style: TextStyle(fontSize: 18),
                      ))
                ],
              ),
            ),
            Container(
              color: Colors.grey[300],
              padding:
                  EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tổng cộng",
                          style: TextStyle(
                            fontSize: 18,
                          )),
                      Text(price.round().toString() + '.000 đ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        Container(
          padding: EdgeInsets.only(right: 15, bottom: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              RaisedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return WaitingView();
                    },
                  ));
                },
                color: Colors.orange,
                child: Text(
                  "Xác nhận",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget dropDownPayMethod(Size size) {
    return DropdownButton(
        underline: const SizedBox(),
        value: selectedMethod,
        onChanged: (String? x) {
          setState(() {
            selectedMethod = x!;
          });
        },
        iconSize: 12,
        icon: Image.asset(
          "assets/icons/dropDown.png",
          color: Colors.grey,
          width: 10,
        ),
        items: listPayMethod.map((String method) {
          return DropdownMenuItem(
              value: method,
              child: SizedBox(
                width: size.width * 0.35,
                child: Text(
                  method,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ));
        }).toList());
  }
}
