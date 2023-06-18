

class Unit{

  // the unit is in the following format : portion;unitQuanity unit (e.g. '250;1.0 g' => 250g)
  late String portion;
  late String unit;
  late double unitQuantity;

  Unit({required this.portion,required String unitValue}){
    portion = portion.isEmpty ? '1' : portion;
    unit = unitValue.split(' ')[1];
    unitQuantity = double.parse(unitValue.split(' ')[0]);
  }

  static Unit? fromString(String formattedUnit){
    if(formattedUnit.contains(';')) {
      try{
        return Unit(portion: formattedUnit.split(';')[0], unitValue: formattedUnit.split(';')[1]);
      } catch(e){
        return null;
      }
    }
    return null;
  }

  @override
  String toString(){
    return '$portion;${unitQuantity.toStringAsFixed(1)} $unit';
  }

  String toReadableFormat(){
    return '${double.parse(portion) * unitQuantity} $unit';
  }

  static String toReadableUnit(String unitString){
    try{
      return Unit.fromString(unitString)!.toReadableFormat();
    } catch(e){
      return unitString;
    }

  }

  // all element must respect the same format : 'xx.y UUUU'
  static const List<String> listUnits =  [
    '1.0 g',
    '100.0 g',
    '1.0 Kg',
    '1.0 ml',
    '100.0 ml',
    '1.0 L',
    '1 Pce',
  ];

  static Unit getDefaultUnit(){
    return Unit(portion: '1', unitValue: listUnits.first);
  }
}