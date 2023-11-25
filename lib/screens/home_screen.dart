// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:app_modiriatmali/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hive/hive.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import 'package:app_modiriatmali/constant.dart';
import 'package:app_modiriatmali/models/money.dart';
import 'package:app_modiriatmali/screens/new_transaction_screen.dart';

// import 'package:searchbar_animation/searchbar_animation.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static List<Money> moneys = [];
  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  final TextEditingController searchController = TextEditingController();
  Box<Money> hivebox = Hive.box<Money>('moneyBox');

  @override
  void initState() {
    MyApp.getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        floatingActionButton: fabButton(),
        body: SizedBox(
          width: double.infinity,
          child: Column(
            children: [
              headerWidget(),
              if (HomeScreen.moneys.isEmpty)
                Expanded(
                  child: EmptyWidget(),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: HomeScreen.moneys.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        child: MyList(index: index),
                        onTap: () {
                          NewTransactionScreen.date =
                              HomeScreen.moneys[index].date;
                          NewTransactionScreen.descriptioncontroler.text =
                              HomeScreen.moneys[index].title;
                          NewTransactionScreen.pricecontroler.text =
                              HomeScreen.moneys[index].price;
                          NewTransactionScreen.groupid =
                              HomeScreen.moneys[index].isReceived ? 1 : 2;
                          NewTransactionScreen.isEditing = true;
                          NewTransactionScreen.index =
                              HomeScreen.moneys[index].id;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => NewTransactionScreen()),
                          ).then((value) {
                            MyApp.getData();
                            setState(() {});
                          });
                        },
                        onLongPress: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    title: Center(
                                      child: const Text(
                                        'تراکنشو پاک کنم؟؟؟',
                                      ),
                                    ),
                                    actionsAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    actions: [
                                      TextButton(
                                          onPressed: () {
                                            hivebox.deleteAt(index);
                                            MyApp.getData();
                                            setState(() {});
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'بله',
                                            style: TextStyle(
                                              color: KPurpleColor,
                                              fontSize: 20,
                                            ),
                                          )),
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            'خیر',
                                            style: TextStyle(
                                              color: KPurpleColor,
                                              fontSize: 20,
                                            ),
                                          )),
                                    ],
                                  ));
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  //! FabWidget('clear info in NewTransActionScreen by click FloatingActionButton')
  Widget fabButton() {
    return FloatingActionButton(
        backgroundColor: KPurpleColor,
        elevation: 0,
        onPressed: () {
          NewTransactionScreen.date = 'تاریخ';
          NewTransactionScreen.descriptioncontroler.text = '';
          NewTransactionScreen.pricecontroler.text = '';
          NewTransactionScreen.groupid = 0;
          NewTransactionScreen.isEditing = false;
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const NewTransactionScreen(),
            ),
          ).then((value) {
            setState(() {
              MyApp.getData();
            });
          });
        },
        child: const Icon(Icons.add));
  }

//! Header Widget
  Widget headerWidget() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, top: 20, left: 5),
      child: Row(
        children: [
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: SearchBarAnimation(
              textEditingController: searchController,
              isOriginalAnimation: false,
              hintText: 'جستجو کنید',
              buttonElevation: 0,
              onCollapseComplete: () {
                MyApp.getData();
                setState(() {
                  searchController.text = '';
                });
              },
              buttonShadowColour: Colors.black26,
              buttonBorderColour: Colors.black26,
              buttonWidget: Icon(Icons.search),
              onFieldSubmitted: (String text) {
                List<Money> result = hivebox.values
                    .where((value) =>
                        value.title.contains(text) || value.date.contains(text))
                    .toList();
                HomeScreen.moneys.clear();
                setState(() {
                  for (var value in result) {
                    HomeScreen.moneys.add(value);
                  }
                });
              },
              trailingWidget: Icon(Icons.abc_rounded),
              secondaryButtonWidget: Icon(Icons.arrow_back),
            ),
          ),
          const Text('تراکنش ها'),
        ],
      ),
    );
  }
}

//! List
class MyList extends StatelessWidget {
  final int index;
  const MyList({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor =
        HomeScreen.moneys[index].isReceived ? KGreenColor : KRedColor;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Container(
              width: 50.0,
              height: 50,
              decoration: BoxDecoration(
                color: HomeScreen.moneys[index].isReceived
                    ? KGreenColor
                    : KRedColor,
                borderRadius: BorderRadius.circular(15.0),
              ),
              child: Center(
                child: Icon(
                  HomeScreen.moneys[index].isReceived
                      ? Icons.add
                      : Icons.remove,
                  color: Colors.white,
                  size: 30.0,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(
                HomeScreen.moneys[index].title,
              ),
            ),
            Spacer(),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      'تومان',
                      style: TextStyle(fontSize: 14.0, color: backgroundColor),
                    ),
                    Text(
                      HomeScreen.moneys[index].price,
                      style: TextStyle(fontSize: 14.0, color: backgroundColor),
                    ),
                  ],
                ),
                Text(HomeScreen.moneys[index].date),
              ],
            )
          ],
        ),
      ),
    );
  }
}

//! Floating Action Button

//! Empty Widget
class EmptyWidget extends StatelessWidget {
  const EmptyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(
          'assets/images/empty.svg',
          width: 230,
          height: 230,
        ),
        const SizedBox(height: 10),
        const Text('!تراکنشی موجود نیست'),
        const Spacer(),
      ],
    );
  }
}
