import 'package:flutter/material.dart';

class UserCoordinates extends StatelessWidget {
  const UserCoordinates({Key? key, this.longitude, this.latitude, this.address}) : super(key: key);

  final double? longitude;
  final double? latitude;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(address ?? ""),
        Text("${longitude ?? ""} ; ${latitude ?? ""}"),
      ],
    );
  }
}
