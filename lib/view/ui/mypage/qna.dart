import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:deukki/provider/user/user_provider_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class QnA extends StatefulWidget {
  @override
  _QnAState createState() => _QnAState();
}

class _QnAState extends State<QnA> {
  ResourceProviderModel resourceProviderModel;

  @override
  void didChangeDependencies() {
    resourceProviderModel = Provider.of<ResourceProviderModel>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
