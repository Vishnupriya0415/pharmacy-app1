// ignore_for_file: file_names, constant_identifier_names

import 'package:flutter/material.dart';

class OrderTracker1 extends StatefulWidget {
  final Status? status;
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

  const OrderTracker1(
      {Key? key,
      required this.status,
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
  State<OrderTracker1> createState() => _OrderTracker1State();
}

class _OrderTracker1State extends State<OrderTracker1>
    with TickerProviderStateMixin {
  AnimationController? controller;
  AnimationController? controller2;
  AnimationController? controller3;
  bool isFirst = false;
  bool isSecond = false;
  bool isThird = false;
  @override
  void initState() {
    if (widget.status?.name == Status.Pending.name) {
      controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 2),
      )..addListener(() {
          if (controller?.value != null && controller!.value > 0.99) {
            controller?.stop();
          }
          setState(() {});
        });
    } else if (widget.status?.name == Status.Processing.name) {
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
    } else if (widget.status?.name == Status.OutforDelivery.name ||
        widget.status?.name == Status.Delivered.name) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Order Tracking Page",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
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
                                  height: widget.orderTitleAndDateList !=
                                              null &&
                                          widget
                                              .orderTitleAndDateList!.isNotEmpty
                                      ? widget.orderTitleAndDateList!.length *
                                          46
                                      : 60,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: LinearProgressIndicator(
                                      value: controller?.value ?? 0.0,
                                      backgroundColor: widget.inActiveColor ??
                                          Colors.grey[300],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.orderTitleAndDateList?[index]
                                                    .title ??
                                                "",
                                            style: widget.subTitleTextStyle ??
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget.orderTitleAndDateList?[index]
                                                    .date ??
                                                "",
                                            style: widget.subDateTextStyle ??
                                                TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[300]),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount: widget.orderTitleAndDateList !=
                                                null &&
                                            widget.orderTitleAndDateList!
                                                .isNotEmpty
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
                                    color: (widget.status?.name ==
                                                    Status.Processing.name ||
                                                widget.status?.name ==
                                                    Status
                                                        .OutforDelivery.name ||
                                                widget.status?.name ==
                                                    Status.Delivered.name) &&
                                            isFirst == true
                                        ? widget.activeColor ?? Colors.blue
                                        : widget.inActiveColor ??
                                            Colors.grey[300],
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
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
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
                                  height: widget.shippedTitleAndDateList !=
                                              null &&
                                          widget.shippedTitleAndDateList!
                                              .isNotEmpty
                                      ? widget.shippedTitleAndDateList!.length *
                                          56
                                      : 60,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: LinearProgressIndicator(
                                      value: controller2?.value ?? 0.0,
                                      backgroundColor: widget.inActiveColor ??
                                          Colors.grey[300],
                                      color: isFirst == true
                                          ? widget.activeColor ?? Colors.blue
                                          : widget.inActiveColor ??
                                              Colors.grey[300],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget
                                                    .shippedTitleAndDateList?[
                                                        index]
                                                    .title ??
                                                "",
                                            style: widget.subTitleTextStyle ??
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget
                                                    .shippedTitleAndDateList?[
                                                        index]
                                                    .date ??
                                                "",
                                            style: widget.subDateTextStyle ??
                                                TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[300]),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount: widget.shippedTitleAndDateList !=
                                                null &&
                                            widget.shippedTitleAndDateList!
                                                .isNotEmpty
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
                                    color: (widget.status?.name ==
                                                    Status
                                                        .OutforDelivery.name ||
                                                widget.status?.name ==
                                                    Status.Delivered.name) &&
                                            isSecond == true
                                        ? widget.activeColor ?? Colors.blue
                                        : widget.inActiveColor ??
                                            Colors.grey[300],
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
                                        text: "Out for delivery ",
                                        style: widget.headingTitleStyle ??
                                            const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
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
                                  height: widget.outOfDeliveryTitleAndDateList !=
                                              null &&
                                          widget.outOfDeliveryTitleAndDateList!
                                              .isNotEmpty
                                      ? widget.outOfDeliveryTitleAndDateList!
                                              .length *
                                          56
                                      : 60,
                                  child: RotatedBox(
                                    quarterTurns: 1,
                                    child: LinearProgressIndicator(
                                      value: controller3?.value ?? 0.0,
                                      backgroundColor: widget.inActiveColor ??
                                          Colors.grey[300],
                                      color: isSecond == true
                                          ? widget.activeColor ?? Colors.blue
                                          : widget.inActiveColor ??
                                              Colors.grey[300],
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget
                                                    .outOfDeliveryTitleAndDateList?[
                                                        index]
                                                    .title ??
                                                "",
                                            style: widget.subTitleTextStyle ??
                                                const TextStyle(fontSize: 14),
                                          ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Text(
                                            widget
                                                    .outOfDeliveryTitleAndDateList?[
                                                        index]
                                                    .date ??
                                                "",
                                            style: widget.subDateTextStyle ??
                                                TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.grey[300]),
                                          )
                                        ],
                                      );
                                    },
                                    separatorBuilder: (context, index) {
                                      return const SizedBox(
                                        height: 4,
                                      );
                                    },
                                    itemCount:
                                        widget.outOfDeliveryTitleAndDateList !=
                                                    null &&
                                                widget
                                                    .outOfDeliveryTitleAndDateList!
                                                    .isNotEmpty
                                            ? widget
                                                .outOfDeliveryTitleAndDateList!
                                                .length
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
                                    color: widget.status?.name ==
                                                Status.Delivered.name &&
                                            isThird == true
                                        ? widget.activeColor ?? Colors.blue
                                        : widget.inActiveColor ??
                                            Colors.grey[300],
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
                                    if (widget.status?.name ==
                                        Status.Delivered.name)
                                      TextSpan(
                                        text:
                                            "Delivered ", // Replace with the actual delivered date
                                        style: widget.headingDateTextStyle ??
                                            const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
                                      )
                                    else
                                      TextSpan(
                                        text:
                                            "Delivered Soon", // Display "Delivered Soon" for other cases
                                        style: widget.headingDateTextStyle ??
                                            const TextStyle(
                                              fontSize: 16,
                                              color: Colors.grey,
                                            ),
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
                                      widget.deliveredTitleAndDateList?[index]
                                              .title ??
                                          "",
                                      style: widget.subTitleTextStyle ??
                                          const TextStyle(fontSize: 14),
                                    ),
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      widget.deliveredTitleAndDateList?[index]
                                              .date ??
                                          "",
                                      style: widget.subDateTextStyle ??
                                          TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[300]),
                                    )
                                  ],
                                );
                              },
                              separatorBuilder: (context, index) {
                                return const SizedBox(
                                  height: 4,
                                );
                              },
                              itemCount:
                                  widget.deliveredTitleAndDateList != null &&
                                          widget.deliveredTitleAndDateList!
                                              .isNotEmpty
                                      ? widget.deliveredTitleAndDateList!.length
                                      : 0)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
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

enum Status { Pending, Processing, OutforDelivery, Delivered }

extension StatusExtension on Status {
  String get stringValue {
    switch (this) {
      case Status.Pending:
        return 'pending';
      case Status.Processing:
        return 'Processing';
      case Status.OutforDelivery:
        return 'Out for Delivery';
      case Status.Delivered:
        return 'Delivered';
      default:
        return 'Unknown';
    }
  }
}


Status stringToStatus(String statusString) {
  switch (statusString) {
    case 'pending':
      return Status.Pending;
    case 'Accepted':
      return Status.Pending;
    case 'Processing':
      return Status.Processing;
    case 'Out for Delivery':
      return Status.OutforDelivery;
    case 'Delivered':
      return Status.Delivered;
    default:
      throw Exception(
          'Invalid status string: $statusString'); // Default to 'order' if unknown status
  }
}
