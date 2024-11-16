import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:proj1/screens/createOrder/setArticleQuatityScreen.dart';
import 'package:proj1/utils/DialogMessagesLib.dart';

class ScanArticleScreen extends ConsumerStatefulWidget {
  const ScanArticleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanArticleScreen> createState() => _ScanArticleScreenState();
}

class _ScanArticleScreenState extends ConsumerState<ScanArticleScreen> {
  Article? chosenArticle;

  void readBarCode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#0000ff', 'Annuler', true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }
    if (!mounted) return;

    if(barcodeScanRes == "-1"){
      // the user clicked on cancel => pop the screen.
      Navigator.pop(context);
      return;
    }
    // get the article by code :
    final article = await ref
        .read(listOfArticlesProvider.notifier)
        .getArticleByCodeDB(barcodeScanRes);
    if (article != null) {
      setState(() {
        chosenArticle = article;
      });
      if(mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx) => SetArticleQuantity(article: article,)));
      }
    } else {
      await DialogMessagesLib.showNotFoundArticleMessage(context, 'Article non trouvé sur la base de donnée', barcodeScanRes, readBarCode);
    }
  }

  void showInfoToUser(){
    showDialog(context: context, builder: (ctx){
      return DialogMessagesLib.requestToScanAnArticle;
    });
  }

  @override
  void initState() {
    super.initState();
    readBarCode();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scannez l\'article"),
      ),
      body: const Center(
        child: Icon(
          Icons.barcode_reader,
          size: 32,
        ),
      ),
    );
  }
}
