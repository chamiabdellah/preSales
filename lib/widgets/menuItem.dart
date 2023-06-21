import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem(
      {Key? key,
      required this.title,
      required this.toScreen,
      this.color = Colors.lightBlue,
      this.assetLogo})
      : super(key: key);

  final String title;
  final Widget toScreen;
  final Color color;
  final String? assetLogo;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenSafeArea = MediaQuery.of(context).viewPadding.bottom;
    double itemHeight = (screenHeight / 5 - screenSafeArea) * 0.7;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [color, Color.fromRGBO(color.red, color.green, color.blue, 0.84), color],
              tileMode: TileMode.decal,
              begin: Alignment.topRight,
              end: Alignment.bottomRight,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        width: double.infinity,
        height: itemHeight,
        child: InkWell(
          onTap: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (ctx) => toScreen));
          },
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 70,
                        height: 70,
                        child : assetLogo != null ?  Image(image: AssetImage(assetLogo!)) : const Placeholder(),
                      ),
                      const SizedBox(width: 15,),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.topLeft,
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 25),
                          ),
                        ),
                      )
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
