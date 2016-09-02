// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class Cafe {
  Cafe({ this.name, this.address, this.phone, this.email, this.reviews, this.isFavorite: false });
  final String name;
  final List<String> address;
  final String phone;
  final String email;
  final List<CafeReview> reviews;
  bool isFavorite;
}

class CafeReview {
  CafeReview({ this.text, this.isHelpful: false });
  final String text;
  bool isHelpful;
}

enum CafeDemoAction {
  writeReview,
  checkIn,
}

class CafeReviewItem extends StatelessWidget {
  CafeReviewItem({ Key key, this.review, this.onIsHelpful }) : super(key: key);

  final CafeReview review;
  final ValueChanged<bool> onIsHelpful;

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        new Text(review.text),
        new ListItem(
          dense: true,
          leading: new Checkbox(value: review.isHelpful, onChanged: onIsHelpful),
          title: new Text('I found this review helpful'),
        ),
        new Divider(),
      ]
    );
  }
}

class CafeDemo extends StatefulWidget {
  CafeDemo({ Key key, this.cafe }) : super(key: key);

  final Cafe cafe;

  @override
  CafeDemoState createState() => new CafeDemoState();
}

class CafeDemoState extends State<CafeDemo> {
  static final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ThemeData themeData = Theme.of(context);

    final List<Widget> children = [
      new Card(
        child: new Column(
          children: <Widget>[
            new ListItem(
              title: new Text('${config.cafe.address[0]}'),
              subtitle: new Text('${config.cafe.address[1]}'),
              // leading: new SizedBox(width: 24.0, height: 24.0),
              leading: new Icon(Icons.local_dining, color: themeData.primaryColor),
            ),
            new Divider(),
            new ListItem(
              title: new Text('${config.cafe.phone}'),
              leading: new Icon(Icons.contact_phone, color: themeData.primaryColor),
            ),
            new ListItem(
              title: new Text('${config.cafe.email}'),
              leading: new Icon(Icons.contact_mail, color: themeData.primaryColor),
            ),
          ]
        )
      )
    ];

    children.addAll(config.cafe.reviews.map((CafeReview review) {
      return new CafeReviewItem(
        review: review,
        onIsHelpful: (bool isHelpful) {
          setState(() {
            review.isHelpful = isHelpful;
          });
          scaffoldKey.currentState.showSnackBar(new SnackBar(
            content: new Text('Thank you for voting!')
          ));
        }
      );
    }).toList());

    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: new Text('Cafe details: ${config.cafe.name}',
          softWrap: false,
          overflow: TextOverflow.ellipsis
        ),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(config.cafe.isFavorite ? Icons.favorite : Icons.favorite_border),
            tooltip: 'Favorite',
            onPressed: () {
              setState(() {
                config.cafe.isFavorite = !config.cafe.isFavorite;
              });
            }
          )
        ]
      ),
      body: new Block(
        children: children.map((Widget child) {
          return new Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
            child: child,
          );
        }).toList()
      )
    );
  }
}

void main() {
  final String dummyReviewText = 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris porta consectetur nisl. Sed at vehicula justo. Nulla ac fermentum lorem. Etiam et auctor ligula, vel tincidunt felis.';

  final Cafe cafe = new Cafe(
    name: "Costa",
    address: <String>[
      "1625 Charleston Road",
      "Mountain View, CA 94043"
    ],
    phone: "(408) 555 1212",
    email: "costa@google.com",
    reviews: <CafeReview>[
      new CafeReview(text: dummyReviewText),
      new CafeReview(text: dummyReviewText),
      new CafeReview(text: dummyReviewText),
      new CafeReview(text: dummyReviewText),
      new CafeReview(text: dummyReviewText),
      new CafeReview(text: dummyReviewText),
    ]
  );

  runApp(new MaterialApp(
    title: 'CafeDemo',
    home: new CafeDemo(cafe: cafe)
  ));
}
