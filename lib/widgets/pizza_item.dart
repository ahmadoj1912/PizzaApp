import 'package:flutter/material.dart';
import '../controllers/pizza_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PizzaItem extends StatelessWidget {
  final Pizza item;
  PizzaItem(this.item);
  @override
  Widget build(BuildContext context) {
    //print(item.modifiers.map((e) => e['name']).toList());
    return Column(
      children: [
        Stack(children: [
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
        ]),
        Column(
          children: [
            Padding(
                padding:
                    EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 10),
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
            ...item.modifiers
                .map((e) => Column(
                      children: [
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
                                  child: Text(
                                    e.name,
                                    style:
                                        Theme.of(context).textTheme.headline1,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 50,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: e.options!.length,
                                    itemBuilder: (context, index) => Card(
                                        child: Align(
                                      alignment: Alignment.center,
                                      child: Padding(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          e.options![index],
                                          style: Theme.of(context)
                                              .textTheme
                                              .headline3,
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
                    ))
                .toList(),
            Divider(
              thickness: 2,
            ),
          ],
        ),
      ],
    );
  }
}
