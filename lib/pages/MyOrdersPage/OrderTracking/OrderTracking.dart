// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:fdottedline_nullsafety/fdottedline__nullsafety.dart';
class OrderTracker extends StatefulWidget {
  final Status? status;
  final Map<int, String> medicineData;
  final int deliveryCharges;
  final List<int> quantity;
  final int taxes;
  final String deliveryAddress;
  final List<String> medicineNames;
  final List<TextDto>? orderTitleAndDateList;
  final List<TextDto>? shippedTitleAndDateList;
  final List<TextDto>? outOfDeliveryTitleAndDateList;
  final List<TextDto>? deliveredTitleAndDateList;
  final Color? activeColor;
  final Color? inActiveColor;
  final TextStyle? headingTitleStyle;
  final TextStyle? headingDateTextStyle;
  final TextStyle? subTitleTextStyle;
  final TextStyle? subDateTextStyle;
  final List<int> medicinePrices;
  final int orderPackingCharges;
  const OrderTracker(
      {Key? key,
        required this.status,
        required this.taxes,
        required this.quantity,
        required this.deliveryAddress,
        required this.orderPackingCharges,
        required this.medicinePrices,
        required this.deliveryCharges,
        required this.medicineData,
        required this.medicineNames,
        this.orderTitleAndDateList,
        this.shippedTitleAndDateList,
        this.outOfDeliveryTitleAndDateList,
        this.deliveredTitleAndDateList,
        this.activeColor,
        this.inActiveColor,
        this.headingTitleStyle,
        this.headingDateTextStyle,
        this.subTitleTextStyle,
        this.subDateTextStyle})
      : super(key: key);

  @override
  State<OrderTracker> createState() => _OrderTrackerState();
}

class _OrderTrackerState extends State<OrderTracker>
    with TickerProviderStateMixin {

  AnimationController? controller;
  AnimationController? controller2;
  AnimationController? controller3;
  bool isFirst = false;
  bool isSecond = false;
  bool isThird = false;
  @override
  void initState() {
    if (widget.status?.name == Status.order.name) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..addListener(() {
        if (controller?.value != null && controller!.value > 0.99) {
          controller?.stop();
        }
        setState(() {});
      });
    } else if (widget.status?.name == Status.shipped.name) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..addListener(() {
        if (controller?.value != null && controller!.value > 0.99) {
          controller?.stop();
          controller2?.stop();
          isFirst = true;
          controller2?.forward(from: 0.0);
        }
        setState(() {});
      });
      controller2 = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4),
      )..addListener(() {
        if (controller2?.value != null && controller2!.value > 0.99) {
          controller2?.stop();
          controller3?.stop();
          isSecond = true;
          controller3?.forward(from: 0.0);
        }
        setState(() {});
      });
    } else if (widget.status?.name == Status.outOfDelivery.name ||
        widget.status?.name == Status.delivered.name) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..addListener(() {
        if (controller?.value != null && controller!.value > 0.99) {
          controller?.stop();
          controller2?.stop();
          controller3?.stop();
          isFirst = true;
          controller2?.forward(from: 0.0);
        }
        setState(() {});
      });
      controller2 = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..addListener(() {
        if (controller2?.value != null && controller2!.value > 0.99) {
          controller2?.stop();
          controller3?.stop();
          isSecond = true;
          controller3?.forward(from: 0.0);
        }
        setState(() {});
      });
      controller3 = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..addListener(() {
        if (controller3?.value != null && controller3!.value > 0.99) {
          controller3?.stop();
          isThird = true;
        }
        setState(() {});
      });
    }
    controller?.repeat(reverse: false);
    controller2?.repeat(reverse: false);
    controller3?.repeat(reverse: false);
    super.initState();
  }
  int calculateTotalCost(
      List<int> medicinePrices, int deliveryCharges, int orderPackingCharges, int taxes) {
    int totalMedicineCost = medicinePrices.reduce((value, element) => value + element);
    return totalMedicineCost + deliveryCharges + orderPackingCharges + taxes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Order Tracking Page", style: TextStyle(color: Colors.black),),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back,
          color: Colors.black,),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {
            },
            icon: const Icon(
              Icons.help_outline,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[100],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: widget.activeColor ?? Colors.blue,
                                    borderRadius: BorderRadius.circular(0)),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),

                              const SizedBox(
                                width: 20,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Order Placed ",
                                        style: widget.headingTitleStyle ??
                                            const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: " 31 Aug 2023",
                                      style: widget.headingDateTextStyle ??
                                          const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: 4,
                                  height: widget.orderTitleAndDateList != null &&
                                      widget.orderTitleAndDateList!.isNotEmpty
                                      ? widget.orderTitleAndDateList!.length * 46
                                      : 60,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: LinearProgressIndicator(
                                      value: controller?.value ?? 0.0,
                                      backgroundColor:
                                      widget.inActiveColor ?? Colors.grey[300],
                                      color: widget.activeColor ?? Colors.blue,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.orderTitleAndDateList?[index].title ?? "",
                                            style: widget.subTitleTextStyle ??
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget.orderTitleAndDateList?[index].date ?? "",
                                            style: widget.subDateTextStyle ??
                                                TextStyle(
                                                    fontSize: 14, color: Colors.grey[300]),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount: widget.orderTitleAndDateList != null &&
                                        widget.orderTitleAndDateList!.isNotEmpty
                                        ? widget.orderTitleAndDateList!.length
                                        : 0),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: (widget.status?.name == Status.shipped.name ||
                                        widget.status?.name ==
                                            Status.outOfDelivery.name ||
                                        widget.status?.name ==
                                            Status.delivered.name) &&
                                        isFirst == true
                                        ? widget.activeColor ?? Colors.blue
                                        : widget.inActiveColor ?? Colors.grey[300],
                                    borderRadius: BorderRadius.circular(0)),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Shipped ",
                                        style: widget.headingTitleStyle ??
                                            const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: "31 Aug '2023",
                                      style: widget.headingDateTextStyle ??
                                          const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: 4,
                                  height: widget.shippedTitleAndDateList != null &&
                                      widget.shippedTitleAndDateList!.isNotEmpty
                                      ? widget.shippedTitleAndDateList!.length * 56
                                      : 60,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: LinearProgressIndicator(
                                      value: controller2?.value ?? 0.0,
                                      backgroundColor:
                                      widget.inActiveColor ?? Colors.grey[300],
                                      color: isFirst == true
                                          ? widget.activeColor ?? Colors.blue
                                          : widget.inActiveColor ?? Colors.grey[300],
                                    ),

                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.shippedTitleAndDateList?[index].title ??
                                                "",
                                            style: widget.subTitleTextStyle ??
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget.shippedTitleAndDateList?[index].date ?? "",
                                            style: widget.subDateTextStyle ??
                                                TextStyle(
                                                    fontSize: 14, color: Colors.grey[300]),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount: widget.shippedTitleAndDateList != null &&
                                        widget.shippedTitleAndDateList!.isNotEmpty
                                        ? widget.shippedTitleAndDateList!.length
                                        : 0),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color:
                                    (widget.status?.name == Status.outOfDelivery.name ||
                                        widget.status?.name ==
                                            Status.delivered.name) &&
                                        isSecond == true
                                        ? widget.activeColor ?? Colors.blue
                                        : widget.inActiveColor ?? Colors.grey[300],
                                    borderRadius: BorderRadius.circular(0)),
                                child:const  Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Out for delivery ",
                                        style: widget.headingTitleStyle ??
                                            const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: " 31 Aug 2023",
                                      style: widget.headingDateTextStyle ??
                                          const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: SizedBox(
                                  width: 4,
                                  height: widget.outOfDeliveryTitleAndDateList != null &&
                                      widget.outOfDeliveryTitleAndDateList!.isNotEmpty
                                      ? widget.outOfDeliveryTitleAndDateList!.length * 56
                                      : 60,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: LinearProgressIndicator(
                                      value: controller3?.value ?? 0.0,
                                      backgroundColor:
                                      widget.inActiveColor ?? Colors.grey[300],
                                      color: isSecond == true
                                          ? widget.activeColor ?? Colors.blue
                                          : widget.inActiveColor ?? Colors.grey[300],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 30,
                              ),
                              Expanded(
                                child: ListView.separated(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    itemBuilder: (context, index) {
                                      return Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.outOfDeliveryTitleAndDateList?[index]
                                                .title ??
                                                "",
                                            style: widget.subTitleTextStyle ??
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget.outOfDeliveryTitleAndDateList?[index]
                                                .date ??
                                                "",
                                            style: widget.subDateTextStyle ??
                                                TextStyle(
                                                    fontSize: 14, color: Colors.grey[300]),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount: widget.outOfDeliveryTitleAndDateList != null &&
                                        widget.outOfDeliveryTitleAndDateList!.isNotEmpty
                                        ? widget.outOfDeliveryTitleAndDateList!.length
                                        : 0),
                              )
                            ],
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 25,
                                width: 25,
                                decoration: BoxDecoration(
                                    color: widget.status?.name == Status.delivered.name &&
                                        isThird == true
                                        ? widget.activeColor ?? Colors.blue
                                        : widget.inActiveColor ?? Colors.grey[300],
                                    borderRadius: BorderRadius.circular(0)),
                                child:const  Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "Delivered ",
                                        style: widget.headingTitleStyle ??
                                            const TextStyle(
                                                fontSize: 16, fontWeight: FontWeight.bold)),
                                    TextSpan(
                                      text: " 31 Aug 2023",
                                      style: widget.headingDateTextStyle ??
                                          const TextStyle(fontSize: 16, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          ListView.separated(
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(left: 40, top: 6),
                              itemBuilder: (context, index) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.deliveredTitleAndDateList?[index].title ?? "",
                                      style: widget.subTitleTextStyle ??
                                          const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      widget.deliveredTitleAndDateList?[index].date ?? "",
                                      style: widget.subDateTextStyle ??
                                          TextStyle(fontSize: 14, color: Colors.grey[300]),
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 4,
                                );
                              },
                              itemCount: widget.deliveredTitleAndDateList != null &&
                                  widget.deliveredTitleAndDateList!.isNotEmpty
                                  ? widget.deliveredTitleAndDateList!.length
                                  : 0)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
               Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const SizedBox(height: 10,),
                      const Row(
                        children: [
                          Text(" Order details:", style: TextStyle(fontWeight: FontWeight.bold),),
                          Spacer(),
                        ],
                      ),
                      const SizedBox(height: 5,),
                      const Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(" Medicine Details: ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                            Spacer(),
                            Text(" Qty:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),),
                            SizedBox(width: 10,),
                            Text(" Cost ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),)
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (int i = 0; i < widget.medicineNames.length; i++)
                            Row(
                              children: [
                                Text(
                                  "${widget.medicineNames[i]}      ",
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const Spacer(),
                                Text('${widget.quantity[i]}'),
                                const SizedBox(width:23),
                                Text('₹${widget.medicinePrices[i]}'),
                                const SizedBox(width: 5,),
                              ],
                            ),
                          const SizedBox(height: 5,),
                          FDottedLine(
                            color: Colors.black,
                            width: 400,
                            strokeWidth: 1.0,
                            dottedLength: 2.0,
                            space: 2.0,
                          ),
                          const SizedBox(height: 5,),
                          Row(
                            children: [
                              const Text(
                                "Delivery Charges: ",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Text('₹${widget.deliveryCharges}'),
                              const SizedBox(width: 5,),
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Other Charges: ",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Text( '₹${widget.orderPackingCharges}'),
                              const SizedBox(width: 5,)
                            ],
                          ),
                          Row(
                            children: [
                              const Text(
                                "Taxes: ",
                                style: TextStyle(fontSize: 14),
                              ),
                              const Spacer(),
                              Text('₹${widget.taxes}'),
                              const SizedBox(width: 5,),
                            ],
                          ),
                          const Divider(), // Adding a line separator
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "Total Cost: "
                                  "₹${calculateTotalCost(widget.medicinePrices, widget.deliveryCharges, widget.orderPackingCharges, widget.taxes)}",
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )

                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.home_outlined),
                          Text(" Delivery address:"),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                          child: Text("  ${widget.deliveryAddress}")),
                      const SizedBox(height: 5,),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TextDto {
  String? title;
  String? date;

  TextDto(this.title, this.date);
}

enum Status { order, shipped, outOfDelivery, delivered }