import 'dart:convert';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:proj1/models/Article.dart';
import 'package:proj1/utils/LoadingIndicator.dart';
import 'package:proj1/utils/SecurePath.dart';
import 'package:proj1/utils/ValidationLib.dart';
import 'package:proj1/widgets/OutlineTextField.dart';
import 'package:http/http.dart' as http;
import 'package:proj1/widgets/addArticleForm/setArticleUnit.dart';
import '../models/unit.dart';
import '../providers/list_of_articles_provider.dart';
import '../utils/Paths.dart';
import '../widgets/PickImageCamera.dart';

class AddArticleForm extends ConsumerStatefulWidget {
  const AddArticleForm({Key? key, required this.scaffoldKey, this.baseArticle, this.shouldAddArticle = false})
      : super(key: key);

  final GlobalKey<ScaffoldState> scaffoldKey;
  final Article? baseArticle;
  final bool? shouldAddArticle;

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
  TextEditingController? articleUnitTextController = TextEditingController();

  bool? isNewCode = true;
  bool isAddMode = true;
  bool imageError = false;

  File? _articleImage;

  Unit? selectedUnit;

  void setArticleImage(File imageFile) {
    setState(() {
      _articleImage = imageFile;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.baseArticle != null || (widget.shouldAddArticle != null && widget.shouldAddArticle!)) {
      isAddMode = false;
      articleNameController!.text = widget.baseArticle!.name;
      articleQuantityController!.text = widget.baseArticle!.quantity.toString();
      articlePriceController!.text = widget.baseArticle!.price.toString();
      articleCodeController!.text = widget.baseArticle!.articleCode;
      selectedUnit = Unit.fromString(widget.baseArticle!.unit);
      articleUnitController!.text = selectedUnit?.toReadableFormat() ?? '';
      articleImageController!.text = widget.baseArticle!.picture;
    }
  }

  @override
  void dispose() {
    super.dispose();
    articleNameController?.dispose();
    articleQuantityController?.dispose();
    articlePriceController?.dispose();
    articleCodeController?.dispose();
    articleUnitController?.dispose();
    articleImageController?.dispose();
  }

  void addToDataBaseCaller() async {
    LoadingIndicator.showLoadingIndicator(
        context, isAddMode ? "Création de l'article est en cours" : "Modification de l'article est en cours");
    await addToDataBase();
    if (mounted) {
      LoadingIndicator.hideLoadingIndicator(context);
    }
  }

  Future<void> addToDataBase() async {
    if(_articleImage == null && isAddMode){
      setState(() {
        imageError = true;
      });
      return;
    }
    if (_productFormKey.currentState == null) {
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
      if (_articleImage != null) {
        // upload the image to the firestore
        imagePath = await uploadImage();
      } else {
        imagePath = widget.baseArticle!.picture;
      }

      final Uri url;
      if (isAddMode) {
        final securedPath = await SecurePath.appendToken(Paths.articlePath);
        url = Uri.parse(securedPath);
      } else {
        Article article = ref
            .read(listOfArticlesProvider.notifier)
            .getArticleByCode(articleCode);
        final securePath = await SecurePath.appendToken(Paths.getArticlePathWithId(article.id));
        url = Uri.parse(securePath);
      }
      // 2- read the values from the fields => will be done using the controllers
      Map<String, dynamic> requestBody = {
        'articleCode': articleCode,
        'articleName': articleNameController!.value.text,
        //'image': articleImageController!.value.text,
        'image': imagePath,
        'price': double.parse(articlePriceController!.value.text),
        'quantity': double.parse(articleQuantityController!.value.text),
        //'unit': articleUnitController!.value.text,
        'unit' : selectedUnit.toString(),
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
          unit: selectedUnit.toString(),
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Scanner le code-barres')),
          body: MobileScanner(
            onDetect: (capture) {
              final List<Barcode> barcodes = capture.barcodes;
              if (barcodes.isNotEmpty) {
                setState(() {
                  articleCodeController!.text = barcodes.first.rawValue ?? '';
                });
                Navigator.of(context).pop();
              }
            },
          ),
        ),
      ),
    );
  }

  Future<String> uploadImage() async {
    //File compressedImage = FlutterNativeImage.compressImage()
    Reference storageRef = FirebaseStorage.instance
        .ref()
        .child('article_images')
        .child(
            '${articleCodeController!.value.text}${articleNameController!.value.text}.jpeg');
    await storageRef.putFile(_articleImage!);

    return storageRef.getDownloadURL();
  }

  @override
  Widget build(BuildContext context) {
    const double columnSpace = 10;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
          key: _productFormKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: columnSpace),
              OutlineTextField(
                labelText: 'Nom de l\'article',
                validationFunc: ValidationLib.nonEmptyField,
                controller: articleNameController,
              ),
              const SizedBox(height: columnSpace),
              /*
              OutlineTextField(
                labelText: 'Lien de l\'image',
                validationFunc: null,
                controller: articleImageController,
              ),*/
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
                    child: SetArticleUnit(
                      baseUnit: selectedUnit,
                        articleUnitController: articleUnitController!,
                        setUnit : (unit) => setState((){
                          selectedUnit = unit;
                        }),
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
              imageError ? Text(
                'Prenez une image de l\'article "${articleNameController!.value.text}"',
                style: const TextStyle(
                    color: Colors.red,
                ),
              ) : const SizedBox(),
              Flexible(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: addToDataBaseCaller,
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
        ),
      ),
    );
  }
}
