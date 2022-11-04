import 'package:flutter/material.dart';
import 'package:smooth_flutter/constant.dart';

class DetailPage extends StatefulWidget {
  String? tag;
  String? image;
  Color color;

  DetailPage({this.tag, required this.color, this.image});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: widget.color,
              child: Column(
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Card(
                      margin: const EdgeInsets.all(0),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.arrow_back_ios),
                                  onPressed: () => Navigator.pop(context),
                                  color: Colors.black,
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.more_vert,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          const Center(
                            child: Text(
                              "\$ 2.99",
                              style: TextStyle(
                                fontSize: 60,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const Center(
                            child: Text(
                              'Cappuccino',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(loemIpsum, style: TextStyle(color: Colors.white, fontSize: 20),),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: -250,
              right: -80,
              child: Hero(
                tag: widget.tag!,
                child: Image.asset(
                  widget.image!,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  fit: BoxFit.fill,
                ),
              ),
            )
          ],
        ));
  }
}
