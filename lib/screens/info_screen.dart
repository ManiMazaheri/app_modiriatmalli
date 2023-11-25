import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding:
                    const EdgeInsets.only(right: 15.0, top: 15.0, left: 5.0),
                child: Text('مدیریت تراکنش ها به تومان'),
              ),
              MoneyInfoWidget(
                firstText: ' : دریافتی امروز',
                firstPrice: '0',
                secondtText: ' : پرداختی امروز',
                secondPrice: '0',
              ),
              MoneyInfoWidget(
                firstText: ' : دریافتی این ماه',
                firstPrice: '0',
                secondtText: ' : پرداختی این ماه',
                secondPrice: '0',
              ),
              MoneyInfoWidget(
                firstText: ' : دریافتی امسال',
                firstPrice: '0',
                secondtText: ' : پرداختی امسال',
                secondPrice: '0',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//! Money Info Widget
class MoneyInfoWidget extends StatelessWidget {
  final String firstText;
  final String secondtText;
  final String firstPrice;
  final String secondPrice;

  const MoneyInfoWidget(
      {required this.firstText,
      required this.secondtText,
      required this.firstPrice,
      required this.secondPrice});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 20.0, top: 20.0, left: 20.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
              child: Text(secondPrice,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12.0))),
          Text(secondtText, style: TextStyle(fontSize: 12.0)),
          Expanded(
              child: Text(firstPrice,
                  textAlign: TextAlign.right,
                  style: TextStyle(fontSize: 12.0))),
          Text(firstText, style: TextStyle(fontSize: 12.0)),
        ],
      ),
    );
  }
}
