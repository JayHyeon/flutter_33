import 'package:flutter/material.dart';
import 'package:flutter_33/dimens.dart';
import 'package:flutter_33/screen/mainPage/searchPage.dart';
import 'package:flutter_33/screen/mainPage/wishPage.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  MainScreenState createState() => MainScreenState();
}

class WishController {
  late void Function() wishUpdate;
  late void Function() getWishList;
}

class MainScreenState extends State<MainScreen> {
  final WishController wishController = WishController();
  int selectedIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      label: 'Search',
      icon: Icon(Icons.image_search_outlined),
    ),
    const BottomNavigationBarItem(
      label: 'Wish',
      icon: Icon(Icons.favorite),
    )
  ];

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      SearchPage(wishController: wishController),
      WishPage(wishController: wishController)
    ];

    void changeTabIndex(index) {
      setState(() {
        selectedIndex = index;
      });
      if (index == 0) {
        wishController.wishUpdate();
      } else if (index == 1) {
        wishController.getWishList();
      }
    }

    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey.withOpacity(.60),
          selectedFontSize: selected_text_size,
          unselectedFontSize: unselected_text_size,
          currentIndex: selectedIndex,
          onTap: (int index) {
            changeTabIndex(index);
          },
          items: bottomItems,
        ),
        body: IndexedStack(
          index: selectedIndex,
          children: screens,
        ));
  }
}
