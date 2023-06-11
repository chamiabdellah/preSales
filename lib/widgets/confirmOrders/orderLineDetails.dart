import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:proj1/widgets/imageNetworkCached.dart';

import '../../models/order_line.dart';

class OrderLineDetails extends StatefulWidget {
  const OrderLineDetails({Key? key, required this.orderLine,this.onChecked }) : super(key: key);

  final OrderLine orderLine;
  final void Function(String,double)? onChecked;

  @override
  State<OrderLineDetails> createState() => _OrderLineDetailsState();
}

class _OrderLineDetailsState extends State<OrderLineDetails> {
  bool isConfirmed = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      isConfirmed = widget.orderLine.availableQuantity != null && widget.orderLine.availableQuantity != 0;
    });
  }

  void toggleConfirmation(bool? newVal) {
    if(newVal == null) return;
    setState(() {
      isConfirmed = newVal;
    });
    widget.onChecked!(widget.orderLine.index, newVal ? widget.orderLine.quantity : 0);
  }

  void checkArticleScan() async {
    String barcodeScanRes;

    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#0000ff', 'Annuler', true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if(barcodeScanRes == widget.orderLine.article.articleCode){
      toggleConfirmation(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Row(
      children: [
        Checkbox(value: isConfirmed, onChanged: toggleConfirmation),
        ImageNetworkCached(imageUrl: widget.orderLine.article.picture),
        Expanded(
            child: Text(
          widget.orderLine.article.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
          ),
        )),
        Column(
          children: [
            Text(widget.orderLine.quantity.toStringAsFixed(0), style: const TextStyle(fontSize: 30),),
            Text(widget.orderLine.article.unit),
          ],
        ),
        IconButton(onPressed: checkArticleScan, icon: const Icon(Icons.barcode_reader, size: 40,)),
      ],
    ));
  }
}
