import 'dart:math';

import 'package:badges/badges.dart';
import 'package:delivery_food_app_from_behance1/api/api_connections.dart';
import 'package:delivery_food_app_from_behance1/models/category.dart';
import 'package:delivery_food_app_from_behance1/pages/menu_page.dart';
import 'package:delivery_food_app_from_behance1/widgets/category_page_widget.dart';
import 'package:delivery_food_app_from_behance1/widgets/menu_widget.dart';
import 'package:delivery_food_app_from_behance1/widgets/side_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_color/flutter_color.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../state_menagement_provider/cart_provider.dart';
import '../utils/dimension.dart';
import '../utils/shared_prefer.dart';
import 'cart_page.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage({Key? key}) : super(key: key);

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  TextEditingController _searchController = TextEditingController(text: '');
  List<Category> listForSearch = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var cartProvider = Provider.of<CartProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        drawer: SideBar(),
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SizedBox(
              height: Dimensions.size50,
            ),
            Padding(
              padding: EdgeInsets.only(
                  left: Dimensions.size20, right: Dimensions.size10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      _scaffoldKey.currentState?.openDrawer();
                    },
                    child: const MenuWidget(),
                  ),
                  SizedBox(
                    width: Dimensions.size10,
                  ),
                  Expanded(
                      child: Padding(
                    padding: EdgeInsets.only(
                        left: Dimensions.size5, right: Dimensions.size5),
                    child: SizedBox(
                      height: Dimensions.size30 + 5,
                      child: Stack(
                        children: [
                          TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.only(
                                  top: 4,
                                  left: Dimensions.size15,
                                ),
                                prefixIcon: Icon(
                                  Icons.search,
                                  size: Dimensions.size25,
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1.0),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.size20)),
                                enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Colors.white, width: 1.0),
                                    borderRadius: BorderRadius.circular(
                                        Dimensions.size20))),
                            onChanged: (v) {
                              listForSearch.clear();
                              if (_searchController.text.isEmpty) {
                                _searchController.text = '';
                                listForSearch.clear();
                                setState(() {});
                                return;
                              }
                              for (var each in Category.getListOfCategory()) {
                                if (_searchController.text.length <=
                                    each.name!.length) {
                                  if (_searchController.text
                                      .toUpperCase()
                                      .trim()
                                      .contains(each.name!
                                          .trim()
                                          .toUpperCase()
                                          .substring(
                                              0,
                                              _searchController.text
                                                  .trim()
                                                  .length))) {
                                    listForSearch.add(each);
                                  }
                                }
                              }
                              setState(() {});
                            },
                          ),
                          if (_searchController.text.isNotEmpty)
                            Positioned(
                                bottom: -5,
                                right: 0,
                                child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        _searchController.text = '';
                                        listForSearch.clear();
                                      });
                                      FocusManager.instance.primaryFocus!
                                          .unfocus();
                                    },
                                    icon: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: Dimensions.size20,
                                    )))
                        ],
                      ),
                    ),
                  )),
                  Badge(
                    elevation: 0,
                    position: BadgePosition.topEnd(end: 2, top: 0),
                    animationType: BadgeAnimationType.slide,
                    showBadge:
                        cartProvider.cartProductList.isEmpty ? false : true,
                    badgeColor: HexColor("2db45b"),
                    badgeContent: Text(
                      "${cartProvider.cartProductList.length}",
                      style: TextStyle(fontSize: Dimensions.size10),
                    ),
                    child: IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()));
                        },
                        icon: Icon(
                          Icons.shopping_cart,
                          size: Dimensions.size25,
                        )),
                  )
                ],
              ),
            ),
            SizedBox(
              height: Dimensions.size15,
            ),
            if (listForSearch.isNotEmpty)
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: listForSearch.length,
                    itemBuilder: (context, index) {
                      var eachCategory = listForSearch[index];

                      List<String> categoryName = [
                        ...addEachNameToList(eachCategory.countryCuisine!)
                      ];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const MenuPage()));
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                              left: Dimensions.size30,
                              right: Dimensions.size30),
                          child: Column(
                            children: [
                              Container(
                                height: Dimensions.size15 * 11,
                                child: Column(
                                  children: [
                                    Stack(
                                      children: [
                                        Container(
                                          height: (Dimensions.size15 * 11) -
                                              Dimensions.size20,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: AssetImage(
                                                      '${eachCategory.image}'))),
                                        ),
                                        Container(
                                          height: (Dimensions.size15 * 11) -
                                              Dimensions.size20,
                                          color: Colors.black.withOpacity(0.4),
                                        ),
                                        Container(
                                          width: double.maxFinite,
                                          height: (Dimensions.size15 * 11) -
                                              Dimensions.size20,
                                          child: Column(children: [
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  top: Dimensions.size10,
                                                  left: Dimensions.size20,
                                                  right: Dimensions.size20),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.all(
                                                        Dimensions.size5),
                                                    decoration: BoxDecoration(
                                                        color: Colors.white
                                                            .withOpacity(0.8),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    7))),
                                                    child: Text(
                                                      "20-30 min",
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: Dimensions
                                                              .size15),
                                                    ),
                                                  ),
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            HexColor('e3b100'),
                                                        borderRadius:
                                                            BorderRadius.all(
                                                                Radius.circular(
                                                                    1))),
                                                    child: Center(
                                                      child: Text(
                                                        "${eachCategory.discount}%",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: Dimensions
                                                                .size18,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            Center(
                                              child: Text(
                                                "${eachCategory.name}",
                                                style: TextStyle(
                                                    fontSize: Dimensions.size25,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            SizedBox(
                                              height: Dimensions.size10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                for (var each in categoryName)
                                                  Row(
                                                    children: [
                                                      Container(
                                                        padding: EdgeInsets.only(
                                                            left: Dimensions
                                                                .size10,
                                                            right: Dimensions
                                                                .size10),
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    Dimensions
                                                                            .size30 /
                                                                        10)),
                                                            color: Colors.white
                                                                .withOpacity(
                                                                    0.8)),
                                                        child: Center(
                                                          child: Text(
                                                            each,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    Dimensions
                                                                        .size18,
                                                                color: Colors
                                                                    .black,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width:
                                                            Dimensions.size10,
                                                      )
                                                    ],
                                                  )
                                              ],
                                            )
                                          ]),
                                        ),
                                      ],
                                    ),
                                    Expanded(
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            right: Dimensions.size15,
                                            left: Dimensions.size15),
                                        child: Container(
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.star,
                                                    size: Dimensions.size15 + 2,
                                                    color: HexColor('e3b100'),
                                                  ),
                                                  SizedBox(
                                                    width: Dimensions.size7,
                                                  ),
                                                  Text(
                                                    "${eachCategory.rating}",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.size15 +
                                                                2),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Icon(
                                                    Icons.car_rental,
                                                    size: Dimensions.size15 + 2,
                                                    color: HexColor('e3b100'),
                                                  ),
                                                  Text(
                                                    "40 grn",
                                                    style: TextStyle(
                                                        fontSize:
                                                            Dimensions.size15),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: Dimensions.size20,
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              )
            else if (listForSearch.isEmpty && _searchController.text.isNotEmpty)
              const Expanded(
                child: Center(child: Text("Поиск не дал результатов")),
              )
            else
              CategoryPageWidget()
          ],
        ),
      ),
    );
  }

  List<String> addEachNameToList(String getName) {
    List<String> categoryName = [];
    String name = '';
    for (int i = 0; i < getName.length; i++) {
      if (getName[i] == ' ') {
        name += ' ';
        categoryName.add(name);
        name = '';
        continue;
      }
      if (i == getName.length - 1) {
        name += getName[getName.length - 1];
        name.trim();
        categoryName.add(name);
      }
      name += getName[i];
    }
    return categoryName;
  }
}
