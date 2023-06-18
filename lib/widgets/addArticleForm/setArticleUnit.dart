import 'package:flutter/material.dart';

import '../../models/unit.dart';
import '../../utils/ValidationLib.dart';

class SetArticleUnit extends StatefulWidget {
  const SetArticleUnit({Key? key,
    required this.articleUnitController,
    this.baseUnit,
    required this.setUnit,
  }) : super(key: key);

  final TextEditingController articleUnitController;
  final Unit? baseUnit;
  final Function(Unit) setUnit;

  @override
  State<SetArticleUnit> createState() => _SetArticleUnitState();
}

class _SetArticleUnitState extends State<SetArticleUnit> {

  TextEditingController? articleUnitTextController = TextEditingController();

  String? unitValue;

  Unit? typedUnit;

  @override
  void initState() {
    super.initState();
    unitValue = Unit.listUnits[0];
    if(widget.baseUnit != null){
      typedUnit = widget.baseUnit;
      articleUnitTextController?.text = widget.baseUnit!.portion;
      unitValue = '${widget.baseUnit!.unitQuantity.toStringAsFixed(1)} ${widget.baseUnit!.unit}';
    }
  }

  @override
  void dispose() {
    super.dispose();
    articleUnitTextController?.dispose();
  }

  void showUnitDialogBox(BuildContext context) {

    AlertDialog alertDialog = AlertDialog(
      title: const Text("Unité"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Flexible(
                flex: 2,
                child: TextField(
                  controller: articleUnitTextController,
                ),
              ),
              const Flexible(
                child: Text("portion(s) de"),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            child: DropdownButtonFormField(
              value: unitValue,
              hint: const Text('Unité'),
              items: Unit.listUnits
                  .map((unit) => DropdownMenuItem(value: unit, child: Text(unit),))
                  .toList(),
              onChanged: (val) => {
                setState(() {
                  unitValue = val;
                })
              },
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("annuler"),
        ),
        TextButton(
          onPressed: () {
            Unit unit = Unit(portion: articleUnitTextController!.text, unitValue: unitValue ?? '');
            widget.articleUnitController.text = unit.toReadableFormat();
            widget.setUnit(unit);
            typedUnit = unit;
            Navigator.pop(context);
          },
          child: const Text("enregistrer"),
        ),
      ],
    );


    showDialog(
        context: context,
        builder: (context) {
          return alertDialog;
        });
  }


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Unité',
        border: UnderlineInputBorder(),
      ),
      showCursor: false,
      validator: (_) => ValidationLib.isValidUnit(typedUnit),
      controller: widget.articleUnitController,
      onTap: ()=>{
        showUnitDialogBox(context)
      },
    );
  }
}
