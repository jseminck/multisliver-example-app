import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart' as c;
import 'package:sliver_example_app/header.dart';
import 'package:sliver_example_app/sliver_fill_remaining_custom.dart';
import 'package:sliver_tools/sliver_tools.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  GlobalKey sliverListKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        height: 30,
        decoration: BoxDecoration(color: Colors.red.shade100),
        child: Center(
          child: Text("bottomNavigationBar"),
        ),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        slivers: [
          Header(),
          c.CupertinoSliverRefreshControl(
            refreshTriggerPullDistance: 100,
            onRefresh: () async {
              print("onRefresh!");
            },
          ),
          SliverList(
            key: sliverListKey,
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Padding(
                  padding: c.EdgeInsets.all(10),
                  child: Text(
                    "SliverList Items",
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                );
              },
              childCount: 3,
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom,
            ),
          ),
          SliverFillRemainingCustomWidget(
            offset: Header.collapsedHeight + MediaQuery.of(context).padding.top,
            sliverListKey: sliverListKey,
            child: Container(color: Colors.orange),
          ),
        ],
      ),
    );
  }
}
