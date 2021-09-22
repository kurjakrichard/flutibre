import 'package:flutter/material.dart';

// ignore: use_key_in_widget_constructors
class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: Alignment.center,
      color: Colors.deepPurple,
      margin: const EdgeInsets.all(10.0),
      padding: const EdgeInsets.all(10.0),
      child: Row(
        children: [
          Column(
            children: const [
              Text(
                'Első',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: 'Raleway',
                    fontSize: 55.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange),
              ),
              Expanded(
                  child: Text(
                'Második',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: 'Roboto Slab',
                    fontSize: 55.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange),
              )),
              Expanded(
                  child: Text(
                'Ez egy hosszabb szöveg tesztelésre',
                textDirection: TextDirection.ltr,
                style: TextStyle(
                    decoration: TextDecoration.none,
                    fontFamily: 'Roboto Slab',
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: Colors.deepOrange),
              )),
            ],
          ),
          const HommImageAsset(),
          const HommButton()
        ],
      ),
    ));
  }
}

class HommImageAsset extends StatelessWidget {
  const HommImageAsset({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = const AssetImage('images/48884.png');
    Image image = Image(image: assetImage, width: 50, height: 50);
    return Container(child: image);
  }
}

class HommButton extends StatelessWidget {
  const HommButton({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: 110,
        height: 50,
        child: ElevatedButton(
            onPressed: () {
              alertDialog(context);
            },
            child: const Text(
              'Enabled',
              style: TextStyle(fontSize: 20, color: Colors.cyanAccent),
            )));
  }

  void alertDialog(BuildContext context) {
    var alertDialog = const AlertDialog(
      title: Text('Siker'),
      content: Text('Sikerült'),
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        });
  }
}
