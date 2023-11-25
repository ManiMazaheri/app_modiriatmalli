import 'dart:math';

import 'package:app_modiriatmali/constant.dart';
import 'package:app_modiriatmali/models/money.dart';
import 'package:app_modiriatmali/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';

class NewTransactionScreen extends StatefulWidget {
  const NewTransactionScreen({super.key});
  static int groupid = 0;
  static TextEditingController descriptioncontroler = TextEditingController();
  static TextEditingController pricecontroler = TextEditingController();
  static bool isEditing = false;
  static String date = 'تاریخ';
  static int index = 0;

  @override
  State<NewTransactionScreen> createState() => _NewTransactionScreenState();
}

class _NewTransactionScreenState extends State<NewTransactionScreen> {
  Box<Money> hivebox = Hive.box<Money>('moneyBox');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          width: double.infinity,
          padding: EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                NewTransactionScreen.isEditing
                    ? 'ویرایش تراکنش'
                    : 'تراکنش جدید',
                style: TextStyle(fontSize: 18),
              ),
              MyTextField(
                hinttext: 'توضیحات',
                controller: NewTransactionScreen.descriptioncontroler,
              ),
              MyTextField(
                hinttext: 'مبلغ',
                type: TextInputType.number,
                controller: NewTransactionScreen.pricecontroler,
              ),
              TypeAndDate(),
              AddButton(
                  text: NewTransactionScreen.isEditing
                      ? 'ویرایش کردن'
                      : 'اضافه کردن',
                  onPressed: () {
                    Money item = Money(
                        id: Random().nextInt(99999),
                        title: NewTransactionScreen.descriptioncontroler.text,
                        price: NewTransactionScreen.pricecontroler.text,
                        date: NewTransactionScreen.date,
                        isReceived:
                            NewTransactionScreen.groupid == 1 ? true : false);
                    if (NewTransactionScreen.isEditing) {
                      int index = 0;
                      for (int i = 0; i < hivebox.values.length; i++) {
                        if (hivebox.values.elementAt(i).id ==
                            NewTransactionScreen.index) {
                          index = i;
                        }
                      }
                      hivebox.putAt(index, item);
                    } else {
                      // HomeScreen.moneys.add(item);
                      hivebox.add(item);
                    }
                    Navigator.pop(context);
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

//! Add Button
class AddButton extends StatelessWidget {
  final String text;
  final Function() onPressed;

  const AddButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(color: Colors.white),
        ),
        style: TextButton.styleFrom(
          backgroundColor: KPurpleColor,
          elevation: 0,
        ),
      ),
    );
  }
}

//! Type & Date Row
class TypeAndDate extends StatefulWidget {
  @override
  State<TypeAndDate> createState() => _TypeAndDateState();
}

class _TypeAndDateState extends State<TypeAndDate> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: MyRadioButton(
            groupvalue: NewTransactionScreen.groupid,
            onchanged: (value) {
              setState(() {
                NewTransactionScreen.groupid = value!;
              });
            },
            text: 'دریافتی',
            value: 1,
          ),
        ),
        Expanded(
          child: MyRadioButton(
            groupvalue: NewTransactionScreen.groupid,
            onchanged: (value) {
              setState(() {
                NewTransactionScreen.groupid = value!;
              });
            },
            text: 'پرداختی',
            value: 2,
          ),
        ),
        SizedBox(width: 20),
        Expanded(
          child: OutlinedButton(
            onPressed: () async {
              var pickedDate = await showPersianDatePicker(
                  context: context,
                  initialDate: Jalali.now(),
                  firstDate: Jalali(1400),
                  lastDate: Jalali(1499));
              setState(() {
                String year = pickedDate!.year.toString();
                String month = pickedDate.month.toString().length == 1
                    ? '0${pickedDate.month.toString()}'
                    : pickedDate.month.toString();
                String day = pickedDate.day.toString().length == 1
                    ? '0${pickedDate.day.toString()}'
                    : pickedDate.day.toString();

                NewTransactionScreen.date = year + '/' + month + '/' + day;
              });
            },
            child: Text(
              NewTransactionScreen.date,
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }
}

//! Radio Button
class MyRadioButton extends StatelessWidget {
  final int value;
  final int groupvalue;
  final Function(int?) onchanged;
  final String text;

  const MyRadioButton(
      {required this.groupvalue,
      required this.onchanged,
      required this.text,
      required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Expanded(
          child: Radio(
            activeColor: KPurpleColor,
            value: value,
            groupValue: groupvalue,
            onChanged: onchanged,
          ),
        ),
        Text(text),
      ],
    );
  }
}

//! Text Field
class MyTextField extends StatelessWidget {
  final String hinttext;
  final TextInputType type;
  final TextEditingController controller;

  const MyTextField(
      {required this.hinttext,
      this.type = TextInputType.text,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: type,
      cursorColor: Colors.black38,
      decoration: InputDecoration(
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        hintText: hinttext,
      ),
    );
  }
}
