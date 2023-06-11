import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:http/http.dart' as http;
//import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

import '../providers/list_of_articles_provider.dart';
import '../utils/Paths.dart';
import '../widgets/PickImageCamera.dart';

class AddArticleForm extends ConsumerStatefulWidget {
  const AddArticleForm({Key? key, required this.scaffoldKey, this.baseArticle})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Article? baseArticle;

  @override
  ConsumerState<AddArticleForm> createState() => _AddArticleFormState();
}

class _AddArticleFormState extends ConsumerState<AddArticleForm> {
  final _productFormKey = GlobalKey<FormState>();

  TextEditingController? articleNameController = TextEditingController();
  TextEditingController? articleQuantityController = TextEditingController();
  TextEditingController? articlePriceController = TextEditingController();
  TextEditingController? articleCodeController = TextEditingController();
  TextEditingController? articleUnitController = TextEditingController();
  TextEditingController? articleImageController = TextEditingController();

  bool? isNewCode = true;
  bool isAddMode = true;

  File? _articleImage;

  void setArticleImage(File imageFile) {
    setState(() {
      _articleImage = imageFile;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.baseArticle != null) {
      isAddMode = false;
      articleNameController!.text = widget.baseArticle!.name;
      articleQuantityController!.text = widget.baseArticle!.quantity.toString();
      articlePriceController!.text = widget.baseArticle!.price.toString();
      articleCodeController!.text = widget.baseArticle!.articleCode;
      articleUnitController!.text = widget.baseArticle!.unit;
      articleImageController!.text = widget.baseArticle!.picture;
    }
  }

  void addToDataBase() async {
    if (_productFormKey.currentState == null || (_articleImage == null && isAddMode)) {
      return;
    }

    // 1- validate the fields.
    if (_productFormKey.currentState!.validate()) {
      final String articleCode = articleCodeController!.value.text;
      final isNewCodeI = await ValidationLib.isNewArticleCode(articleCode);
      setState(() {
        isNewCode = isNewCodeI;
      });

      if (!isNewCode! && isAddMode) {
        return;
      }

      String imagePath;
      if(_articleImage != null) {
        // upload the image to the firestore
        imagePath = await uploadImage();
      } else {
        imagePath = widget.baseArticle!.picture;
      }

      final Uri url;
      if (isAddMode) {
        url = Uri.parse(Paths.articlePath);
      } else {
        Article article = ref
            .read(listOfArticlesProvider.notifier)
            .getArticleByCode(articleCode);
        url = Uri.parse(Paths.getArticlePathWithId(article.id));
      }
      // 2- read the values from the fields => will be done using the controllers
      Map<String, dynamic> requestBody = {
        'articleCode': articleCode,
        'articleName': articleNameController!.value.text,
        //'image': articleImageController!.value.text,
        'image': imagePath,
        'price': double.parse(articlePriceController!.value.text),
        'quantity': double.parse(articleQuantityController!.value.text),
        'unit': articleUnitController!.value.text,
      };

      // 3 - send the request to the db
      final http.Response response;
      if (isAddMode) {
        response = await http.post(url, body: json.encode(requestBody));
      } else {
        response = await http.patch(url, body: json.encode(requestBody));
      }

      // 4 - get the save status :
      if (response.statusCode == 200 && mounted) {
        // 5 - on success show a snack bar

        ScaffoldMessenger.of(widget.scaffoldKey.currentState!.context)
            .clearSnackBars();
        //ScaffoldMessenger.of(context).clearSnackBars();
        final snackBar = SnackBar(
          duration: const Duration(seconds: 10),
          content: isAddMode
              ? Text(
                  'L\'article ${articleNameController!.value.text} a été ajouté avec succès')
              : Text(
                  'L\'article ${articleNameController!.value.text} a été modifié avec succès'),
        );
        ScaffoldMessenger.of(widget.scaffoldKey.currentState!.context)
            .showSnackBar(snackBar);
        Navigator.of(widget.scaffoldKey.currentState!.context).pop();

        final extractedData =
            json.decode(response.body) as Map<String, dynamic>;

        final article = Article(
          articleCode: articleCode,
          name: articleNameController!.value.text,
          //picture: articleImageController!.value.text,
          picture: imagePath,
          price: double.parse(articlePriceController!.value.text),
          quantity: double.parse(articleQuantityController!.value.text),
          unit: articleUnitController!.value.text,
          id: isAddMode ? extractedData['name'] : widget.baseArticle!.id,
        );

        if (isAddMode) {
          ref.read(listOfArticlesProvider.notifier).addArticle(article);
        } else {
          ref
              .read(listOfArticlesProvider.notifier)
              .modifyArticle(article, articleCode);
        }

        // 6 - clear the content of hte form
        articleNameController?.clear();
        articleQuantityController?.clear();
        articlePriceController?.clear();
        articleUnitController?.clear();
        articleImageController?.clear();
        articleCodeController?.clear();
      }
    }
    // 4 - treat the exceptions.
    // 4.1 - the product exists already in the db => add the condition to the validation of the code
    // 4.2 - the quantity is negative [DONE]
  }

  void readBarCode() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#0000ff', 'Annuler', true, ScanMode.DEFAULT);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      articleCodeController!.text = barcodeScanRes;
    });
  }

  Future<String> uploadImage() async {
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('article_images')
        .child('${articleCodeController!.value.text}${articleNameController!.value.text}.jpeg');
    await storageRef.putFile(_articleImage!);

    return storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    const double columnSpace = 10;
    return Form(
      key: _productFormKey,
      child: Column(
        children: [
          const SizedBox(height: columnSpace),
          OutlineTextField(
            labelText: 'Nom de l\'article',
            validationFunc: ValidationLib.nonEmptyField,
            controller: articleNameController,
          ),
          const SizedBox(height: columnSpace),
          OutlineTextField(
            labelText: 'Lien de l\'image',
            validationFunc: ValidationLib.nonEmptyField,
            controller: articleImageController,
          ),
          const SizedBox(height: columnSpace),
          Row(
            children: [
              Flexible(
                flex: 2,
                child: OutlineTextField(
                  labelText: 'Quantité disponible',
                  validationFunc: ValidationLib.isPositiveNumber,
                  textInputType: TextInputType.number,
                  controller: articleQuantityController,
                ),
              ),
              Flexible(
                flex: 1,
                child: OutlineTextField(
                  labelText: 'Unité',
                  validationFunc: ValidationLib.nonEmptyField,
                  controller: articleUnitController,
                ),
              ),
            ],
          ),
          const SizedBox(height: columnSpace),
          Row(
            children: [
              Flexible(
                flex: 12,
                child: OutlineTextField(
                  labelText: 'code article',
                  validationFunc: ValidationLib.nonEmptyField,
                  controller: articleCodeController,
                  isEnabled: isAddMode,
                ),
              ),
              Flexible(
                flex: 2,
                child: IconButton(
                  onPressed: isAddMode ? readBarCode : null,
                  icon: const Icon(Icons.barcode_reader, size: 40),
                ),
              ),
            ],
          ),
          const SizedBox(height: columnSpace),
          Builder(builder: (BuildContext context) {
            if (!isNewCode! && isAddMode) {
              return const Text("Ce code est déjà utilisé");
            }
            return const SizedBox.shrink();
          }),
          const SizedBox(height: columnSpace),
          OutlineTextField(
            labelText: 'Prix',
            validationFunc: ValidationLib.isPositiveNumber,
            textInputType: TextInputType.number,
            controller: articlePriceController,
          ),
          PickImageCamera(
            onPick: setArticleImage,
            link: isAddMode ? null : widget.baseArticle?.picture,
          ),
          Flexible(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: ElevatedButton(
                  onPressed: addToDataBase,
                  child: Text(
                    isAddMode ? "Ajouter" : "Modifier",
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
