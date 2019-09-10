import 'package:flutter/material.dart';
import 'package:nfc_manager/nfc_manager.dart';
import 'package:nfc_manager/nfc_ndef.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BitCard',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'BitCard'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var tagMessage = "空";

  _read() async {
    await NfcManager.instance.startSession(
      onTagDiscovered: (NfcTag tag) async {
        if (tag.ndef == null) {
          print('Tag is not NDEF formattable');
          return;
        }

        if (tag.ndef.cachedNdefMessage == null) {
          print('NDEF is in INITIALIZED state');
          return;
        }

        // Now you can get an NDEF Message that cached at the time of discovery.
        NfcNdefMessage cachedMessage = tag.ndef.cachedNdefMessage;
        tagMessage = cachedMessage.toString();
        // Should stop a session at the appropriate time.
        await NfcManager.instance.stopSession();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '你的NFC卡片信息:',
            ),
            Text(
              '$tagMessage',
              style: Theme.of(context).textTheme.display1,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                child: Text('Read'),
                onPressed: () {
                  _read();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
