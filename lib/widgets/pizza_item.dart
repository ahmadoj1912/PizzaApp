import 'package:flutter/material.dart';
import 'package:pizza/screens/home.dart';
import '../controllers/pizza_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PizzaItem extends StatelessWidget {
  final Pizza item;
  PizzaItem(this.item);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                width: double.infinity,
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: item.image,
                    fit: BoxFit.fill,
                    height: 250,
                    placeholder: (context, url) =>
                        Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                )),
            Positioned(
              bottom: 10,
              left: 10,
              right: 10,
              child: Container(
                color: Colors.black54,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.headline4,
                  ),
                ),
              ),
            ),
          ],
        ),
        Container(
          width: double.infinity,
          child: Card(
              margin: EdgeInsets.all(0),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          top: 10, left: 10, right: 10, bottom: 10),
                      child: Container(
                        width: double.infinity,
                        child: Text(
                          item.desc,
                          style: Theme.of(context).textTheme.headline3,
                          textAlign: TextAlign.justify,
                        ),
                      )),
                  Divider(
                    thickness: 2,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 5),
                                  child: FittedBox(
                                    child: Text(
                                      'Small',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.smallSize != 0.0
                                      ? '\$${item.smallSize}'
                                      : "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 5),
                                  child: Text(
                                    'Med',
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    textAlign: TextAlign.center,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.meduimSize != 0.0
                                      ? '\$${item.meduimSize}'
                                      : "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  margin: EdgeInsets.only(right: 5),
                                  child: FittedBox(
                                    child: Text(
                                      'Large',
                                      style:
                                          Theme.of(context).textTheme.headline1,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Theme.of(context).accentColor),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.largeSize != 0.0
                                      ? '\$${item.largeSize}'
                                      : "N/A",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.headline3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Row(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.2,
                          margin: EdgeInsets.only(top: 10, bottom: 10),
                          child: Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Theme.of(context).accentColor,
                                borderRadius: BorderRadius.circular(10)),
                            child: FittedBox(
                              child: Text(
                                'Toppings',
                                style: Theme.of(context).textTheme.headline1,
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            height: 50,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: item.toppings.length,
                              itemBuilder: (context, index) => Card(
                                  child: Align(
                                alignment: Alignment.center,
                                child: Padding(
                                  padding: EdgeInsets.all(5),
                                  child: Text(
                                    pizzaController
                                        .toppingToValue(item.toppings[index]),
                                    style:
                                        Theme.of(context).textTheme.headline3,
                                  ),
                                ),
                              )),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
        Divider()
      ],
    );
  }
}
