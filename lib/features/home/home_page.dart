import 'package:flutter/material.dart';
import 'package:smooth_flutter/constant.dart';
import 'package:smooth_flutter/features/detail/detail_item.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final CategoriesScroller categoriesScroller = CategoriesScroller();
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  List<Widget> itemsData = [];

  void getPostsData() {
    List<dynamic> responseList = FOOD_DATA;
    List<Widget> listItems = [];
    int i = -1;
    for (var post in responseList) {
      i++;
      listItems.add(Container(
          height: 150,
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20.0)),
              color: Colors.white,
              boxShadow: [
                BoxShadow(color: Colors.black.withAlpha(50), blurRadius: 10.0),
              ]),
          child: SizedBox(
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 10, top: 10, bottom: 10),
              child: Stack(
                children: <Widget>[
                  Positioned(
                    right: -30,
                    child: Hero(
                      tag: 'circle$i',
                      child: Container(
                        height: 250,
                        width: 250,
                        decoration: BoxDecoration(
                            color: getColor(i),
                            borderRadius: BorderRadius.circular(100)
                            ),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          post["name"],
                          style: const TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          post["brand"],
                          style:
                              const TextStyle(fontSize: 17, color: Colors.grey),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "\$ ${post["price"]}",
                          style: const TextStyle(
                              fontSize: 25,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    right: -60,
                    top: 10,
                    child: Container(
                      width: 300,
                      height: 200,
                      child: Image.asset(
                        "assets/images/${post["image"]}",
                        height: 350,
                        width: 300,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                ],
              ),
            ),
          )));
    }
    setState(() {
      itemsData = listItems;
    });
  }

  @override
  void initState() {
    super.initState();
    getPostsData();
    controller.addListener(() {
      double value = controller.offset / 119;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final double categoryHeight = size.height * 0.30;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar(),
        body: _body(size, categoryHeight),
      ),
    );
  }

  _appBar() {
    return AppBar(
      // elevation: 0,
      backgroundColor: Colors.white,
      leading: const Icon(
        Icons.menu,
        color: Colors.black,
      ),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.search, color: Colors.black),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.person, color: Colors.black),
          onPressed: () {},
        )
      ],
    );
  }

  _body(Size size, double categoryHeight) {
    return SizedBox(
      height: size.height,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: closeTopContainer ? 0 : 1,
            child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: size.width,
                alignment: Alignment.center,
                height: closeTopContainer ? 0 : categoryHeight,
                child: categoriesScroller),
          ),
          Expanded(
              child: ListView.builder(
                  controller: controller,
                  itemCount: itemsData.length,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    double scale = 1.0;
                    if (topContainer > 0.5) {
                      scale = index + 0.5 - topContainer;
                      if (scale < 0) {
                        scale = 0;
                      } else if (scale > 1) {
                        scale = 1;
                      }
                    }
                    return Opacity(
                      opacity: scale,
                      child: Transform(
                        transform: Matrix4.identity()..scale(scale, 1.0),
                        alignment: Alignment.center,
                        child: Align(
                            heightFactor: 0.7,
                            alignment: Alignment.topCenter,
                            child: InkWell(
                                onTap: () {
                                  Color c = getColor(index, forDetail: true);
                                  if (c != null) {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => DetailPage(
                                              tag: 'circle$index',
                                              image: 'assets/images/${FOOD_DATA[index]["image"]}',
                                              color: c,
                                            )));
                                  }
                                },
                                child: itemsData[index])),
                      ),
                    );
                  })),
        ],
      ),
    );
  }

  getColor(int i, {bool forDetail = false}) {
    if (i % 2 == 0) {
      return Colors.green.withOpacity(forDetail ? 0.5 : 0.2);
    } else if (i % 3 == 0) {
      return Colors.red.withOpacity(forDetail ? 0.5 : 0.2);
    } else if (i % 5 == 0) {
      return Colors.orange.withOpacity(forDetail ? 0.5 : 0.2);
    } else {
      return Colors.blue.withOpacity(forDetail ? 0.5 : 0.2);
    }
  }
}

class CategoriesScroller extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final double categoryHeight = MediaQuery.of(context).size.height / 5;
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.horizontal,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: FittedBox(
          fit: BoxFit.fill,
          alignment: Alignment.topCenter,
          child: Row(
            children: <Widget>[
              Container(
                width: 150,
                margin: const EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.6),
                    borderRadius: const BorderRadius.all(Radius.circular(20.0))),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "Coffee",
                      style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "20 Items",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        Text(
                          "Tea",
                          style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "10 Items",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: 150,
                margin: EdgeInsets.only(right: 20),
                height: categoryHeight,
                decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.6),
                    borderRadius: BorderRadius.all(Radius.circular(20.0))),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        "Food",
                        style: TextStyle(
                            fontSize: 25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "20 Items",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
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
