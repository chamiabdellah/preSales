import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/providers/list_of_articles_provider.dart';
import 'package:proj1/screens/createOrder/setArticleQuatityScreen.dart';

class ScanArticleScreen extends ConsumerStatefulWidget {
  const ScanArticleScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ScanArticleScreen> createState() => _ScanArticleScreenState();
}

class _ScanArticleScreenState extends ConsumerState<ScanArticleScreen> {
  Article? scannedArticle;
  String scanArticleMessage = "Scanner Un Article";

  void _handleBarcode(BarcodeCapture barcodes) async {
    String? barecodeValue = barcodes.barcodes.firstOrNull?.displayValue;
    if (mounted && barecodeValue != null && barecodeValue.isNotEmpty ) {

      final article = await ref
          .read(listOfArticlesProvider.notifier)
          .getArticleByCodeDB(barecodeValue);

      if (article != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SetArticleQuantity(article: article),
          ),
        );
      } else {
        setState(() {
          scanArticleMessage = "Article non trouvé sur la base de donnée";
        });
        // await DialogMessagesLib.showNotFoundArticleMessage(context, 'Article non trouvé sur la base de donnée', barecodeValue, () => {});
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Scannez l\'article"),
      ),
      body: Stack(
        children: [
          MobileScanner(onDetect: _handleBarcode, ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              alignment: Alignment.bottomCenter,
              height: 200,
              color: const Color.fromRGBO(0, 0, 0, 0.4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(child: Center(child: Text(
                    scanArticleMessage,
                    overflow: TextOverflow.fade,
                    style: const TextStyle(color: Colors.white),)
                  )
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
