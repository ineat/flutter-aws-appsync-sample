import 'dart:async';

import 'package:appsync/message.dart';
import 'package:appsync/message_service.dart';
import 'package:flutter/material.dart';

void main() => runApp(new App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'AppSync Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TchatPage(title: 'AWS AppSync Demo'),
    );
  }
}

class TchatPage extends StatefulWidget {
  TchatPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TchatPageState createState() => new _TchatPageState();
}

class _TchatPageState extends State<TchatPage> {
  String _sender;

  final textEditingController = new TextEditingController();

  final messageService = new MessageService();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    messageService.subscribeNewMessage();
    _messages.addAll(await messageService.getAllMessages());
    if (mounted) {
      setState(() {
        // refresh
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
          title: new Text(widget.title),
        ),
        body: (_sender == null) ? _buildConfigurationSender() : _buildTchat());
  }

  Widget _buildConfigurationSender() {
    return new Padding(
      padding: const EdgeInsets.all(32.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          new TextFormField(
            controller: textEditingController,
            decoration: InputDecoration(
              hintText: 'Enter your sender name',
            ),
          ),
          new SizedBox(height: 16.0),
          new RaisedButton(
            child: new Text("Validate"),
            onPressed: () {
              setState(() {
                if (textEditingController.text.isEmpty) {
                  final snackBar = SnackBar(
                      content: Text('Error, your sender name is empty'));
                  _scaffoldKey.currentState.showSnackBar(snackBar);
                  return;
                }
                _sender = textEditingController.text;
                textEditingController.clear();
              });
            },
          ),
        ],
      ),
    );
  }

  StreamSubscription<Message> _streamSubscription;

  List<Message> _messages = [];

  final GlobalKey<AnimatedListState> _animateListKey =
      new GlobalKey<AnimatedListState>();

  Widget _buildTchat() {
    if (_streamSubscription == null) {
      _streamSubscription =
          messageService.messageBroadcast.stream.listen((message) {
        _messages.insert(0, message);
        _animateListKey.currentState?.insertItem(0);
      }, cancelOnError: false, onError: (e) => debugPrint(e));
    }

    return new Column(
      children: <Widget>[
        new Expanded(
          child: _buildList(),
        ),
        new Container(
          color: Colors.grey[200],
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: new Row(
            children: <Widget>[
              new Expanded(
                child: new TextFormField(
                  controller: textEditingController,
                  decoration: const InputDecoration(
                    hintText: 'Saisir votre message',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              new IconButton(
                icon: new Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _sendMessage() {
    final content = textEditingController.text;
    if (content.trim().isEmpty) {
      final snackBar = SnackBar(content: Text('Error, your message is empty'));
      _scaffoldKey.currentState.showSnackBar(snackBar);
      return;
    }
    messageService.sendMessage(content, _sender);
    textEditingController.clear();
  }

  Widget _buildList() {
    return new AnimatedList(
      key: _animateListKey,
      reverse: true,
      initialItemCount: _messages.length,
      itemBuilder:
          (BuildContext context, int index, Animation<double> animation) {
        final message = _messages[index];
        return new Directionality(
          textDirection:
              message.sender == _sender ? TextDirection.rtl : TextDirection.ltr,
          child: new SizeTransition(
            axis: Axis.vertical,
            sizeFactor: animation,
            child: _buildMessageItem(message),
          ),
        );
      },
    );
  }

  Widget _buildMessageItem(Message message) {
    return new ListTile(
      title: new Text(message.content),
      subtitle: new Text(message.sender),
    );
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    textEditingController.dispose();
    super.dispose();
  }
}
