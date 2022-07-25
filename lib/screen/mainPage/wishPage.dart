import 'package:flutter_33/db/dbHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_33/dimens.dart';
import 'package:flutter_33/models/searchDataModel.dart';
import 'package:flutter_33/screen/imageDetailScreen.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum SearchType { BEGIN, MORE }

class WishPage extends StatefulWidget {
  const WishPage({Key? key, this.wishController}) : super(key: key);
  final wishController;

  @override
  WishPageState createState() => WishPageState(wishController);
}

class WishPageState extends State<WishPage> {
  WishPageState(wishController) {
    wishController.getWishList = getWishList;
  }

  DBHelper dbHelper = DBHelper();
  final searchController = TextEditingController();

  List<SearchData> imageList = [];
  int page = 1;
  final int size = 20;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  void getWishList() {
    imageList.clear();
    page = 1;

    requestWishList();
  }

  void requestWishList() {
    List<SearchData> tmpList = imageList;
    dbHelper.getAllWish(page, size).then((value) => {
          if (value != null)
            {
              value.forEach((element) {
                if (element.docUrl != null) {
                  setState(() => element.wish = true);
                }

                tmpList.add(element);
              })
            },
        });

    setState(() {
      imageList = tmpList;
      page++;
    });
  }

  void deleteWish(int index) {
    dbHelper.getWish(imageList[index].docUrl!).then((value) => {
          if (value != null)
            {
              dbHelper.deleteWish(value[0]['doc_url']),
              setState(() => imageList = List.from(imageList)..removeAt(index))
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    void moveToImageDetailScreen(index) {
      Get.to(() => ImageDetailScreen(imageList[index]));
    }

    return Column(
      children: [
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(out_margin),
              child: MasonryGridView.count(
                itemCount: imageList.length,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  if (index > imageList.length - 5) {
                    if (!isLoading) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => {
                            setState(() {
                              isLoading = true;
                            }),
                            requestWishList(),
                            setState(() {
                              isLoading = false;
                            })
                          });
                    }
                  }
                  return GestureDetector(
                      onTap: () => {moveToImageDetailScreen(index)},
                      child: Card(
                          child: Container(
                        padding: const EdgeInsets.all(out_margin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            AspectRatio(
                              aspectRatio: (imageList[index].width!) /
                                  imageList[index].height!,
                              child: Stack(children: [
                                SizedBox(
                                    height: double.infinity,
                                    width: double.infinity,
                                    child: Image.network(
                                        imageList[index].thumbnailUrl!,
                                        fit: BoxFit.fill)),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: GestureDetector(
                                      onTap: () => {deleteWish(index)},
                                      child: imageList[index].wish == true
                                          ? const Icon(Icons.favorite,
                                              size: icon_normal,
                                              color: Colors.redAccent)
                                          : const Icon(Icons.favorite_outline,
                                              size: icon_normal,
                                              color: Colors.redAccent)),
                                )
                              ]),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: out_margin),
                                child: Text(imageList[index].displaySitename!))
                          ],
                        ),
                      )));
                },
              )),
        )
      ],
    );
  }
}
