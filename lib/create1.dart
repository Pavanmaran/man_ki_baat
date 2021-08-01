import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
 late OverlayEntry overlayEntry =OverlayEntry(builder: (BuildContext context) { return Container(); });
  double overlayWidth = 50;
  Offset offset = Offset.zero;
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.network(
          "https://images.unsplash.com/photo-1487260211189-670c54da558d?ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&ixlib=rb-1.2.1&auto=format&fit=crop&w=634&q=80",
          fit: BoxFit.cover,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _clickShow,
        child: Icon(Icons.add),
      ),
    );
  }

  _clickShow() {

    overlayEntry = _showOverlay();
    Overlay.of(context)!.insert(overlayEntry);
  }

  _removeOverlay() {
    overlayEntry.remove();
  }

  OverlayEntry _showOverlay() {
    OverlayEntry overlayEntry = OverlayEntry(builder: (context) {
      double dx = 0.0;
      double dy = 0.0;

      if ((offset.dx > 0) &&
          ((offset.dx + overlayWidth) < MediaQuery.of(context).size.width)) {
        dx = offset.dx;
      } else if ((offset.dx + overlayWidth) >=
          MediaQuery.of(context).size.width) {
        dx = MediaQuery.of(context).size.width - overlayWidth;
      } else {
        dx = 0;
      }

      if ((offset.dy > 0) &&
          ((offset.dy + overlayWidth) < MediaQuery.of(context).size.height)) {
        dy = offset.dy;
      } else if ((offset.dy + overlayWidth) >=
          MediaQuery.of(context).size.height) {
        dy = MediaQuery.of(context).size.height - overlayWidth;
      } else {
        dy = 0;
      }

      return new Positioned(
        top: dy,
        left: dx,
        child: Draggable(
          feedback: _contentBody(),
          child: _contentBody(),
          childWhenDragging: Container(),
          onDraggableCanceled: (Velocity velocity, Offset offset) {
            setState(() {
              this.offset = offset;
            });
          },
        ),
      );
    });
    return overlayEntry;
  }

  Widget _contentBody() {
    return Material(
      child: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Text('blablabla',style: TextStyle(color:Colors.black),),
        ),
      ),
    );
  }
}