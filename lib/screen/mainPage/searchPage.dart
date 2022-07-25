import 'dart:io';
import 'dart:convert';
import 'package:flutter_33/db/dbHelper.dart';
import 'package:flutter_33/global.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_33/dimens.dart';
import 'package:flutter_33/models/searchDataModel.dart';
import 'package:flutter_33/screen/imageDetailScreen.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

enum SearchType { BEGIN, MORE }

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key, this.wishController}) : super(key: key);
  final wishController;

  @override
  SearchPageState createState() => SearchPageState(wishController);
}

class SearchPageState extends State<SearchPage> {
  SearchPageState(wishController) {
    wishController.wishUpdate = wishUpdate;
  }

  DBHelper dbHelper = DBHelper();
  final searchController = TextEditingController();

  List<SearchData> imageList = [];
  int page = 1;
  final int size = 20;
  bool isLoading = false;

  void search(type) async {
    if (type == SearchType.BEGIN) setState(() => page = 1);

    var url = Uri.https(kakao_dapi, kakao_image_request,
        {'query': searchController.text, 'page': "$page", 'size': "$size"});

    var response = await http.get(url,
        headers: {HttpHeaders.authorizationHeader: "KakaoAK $rest_api_key"});
    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var responseBody = json.decode(utf8.decode(response.bodyBytes));
      if (type == SearchType.BEGIN) {
        imageList.clear();
      }

      List<SearchData> tmpList = imageList;
      responseBody["documents"].forEach((element) {
        SearchData data = SearchData.fromJson(element);
        data.wish = false;
        if (data.docUrl != null) {
          dbHelper.getWish(data.docUrl!).then((value) => {
                if (value != null) {setState(() => data.wish = true)},
              });
        }

        tmpList.add(data);
      });

      setState(() {
        imageList = tmpList;
        page++;
      });
    } else {
      print('error : $statusCode');
    }
  }

  void toggleWish(int index) {
    dbHelper.getWish(imageList[index].docUrl!).then((value) => {
          if (value != null)
            {
              dbHelper.deleteWish(value[0]['doc_url']),
              setState(() => imageList[index].wish = false)
            }
          else
            {
              dbHelper.insertWish(imageList[index]),
              setState(() => imageList[index].wish = true)
            },
        });
  }

  void wishUpdate() {
    List<SearchData> tmpList = imageList;
    for (var index = 0; index < tmpList.length; index++) {
      dbHelper.getWish(tmpList[index].docUrl!).then((value) => {
            if (value != null)
              {tmpList[index].wish = true}
            else
              {tmpList[index].wish = false},
          });
    }

    setState(() {
      imageList = tmpList;
    });
  }

  @override
  Widget build(BuildContext context) {
    void moveToImageDetailScreen(index) {
      Get.to(() => ImageDetailScreen(imageList[index]));
    }

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(out_margin),
                child: TextField(
                  textInputAction: TextInputAction.go,
                  onSubmitted: (value) => {search(SearchType.BEGIN)},
                  controller: searchController,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(), labelText: "이미지 검색"),
                  style: const TextStyle(
                      fontSize: text_size,
                      height: 0.8,
                      color: Color(0xff666666)),
                ),
              )),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: out_margin),
                  child: GestureDetector(
                    onTap: () => {
                      FocusScope.of(context).unfocus(),
                      search(SearchType.BEGIN)
                    },
                    child: const Icon(Icons.search_outlined, size: icon_normal),
                  ))
            ],
          ),
        ),
        Expanded(
          child: Padding(
              padding: const EdgeInsets.all(out_margin),
              child: MasonryGridView.count(
                itemCount: imageList.length,
                crossAxisCount: 2,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemBuilder: (context, index) {
                  if (index != 0 && index > imageList.length - 5) {
                    if (!isLoading) {
                      WidgetsBinding.instance.addPostFrameCallback((_) => {
                            setState(() {
                              isLoading = true;
                            }),
                            search(SearchType.MORE),
                            setState(() {
                              isLoading = false;
                            })
                          });
                    }
                  }
                  return imageList.length > 1
                      ? GestureDetector(
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
                                          onTap: () => {toggleWish(index)},
                                          child: imageList[index].wish == true
                                              ? const Icon(Icons.favorite,
                                                  size: icon_normal,
                                                  color: Colors.redAccent)
                                              : const Icon(
                                                  Icons.favorite_outline,
                                                  size: icon_normal,
                                                  color: Colors.redAccent)),
                                    )
                                  ]),
                                ),
                                Padding(
                                    padding:
                                        const EdgeInsets.only(top: out_margin),
                                    child:
                                        Text(imageList[index].displaySitename!))
                              ],
                            ),
                          )))
                      : Container();
                },
              )),
        )
      ],
    );
  }
}
