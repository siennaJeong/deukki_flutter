import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StageQuiz extends StatefulWidget {
  @override
  _StageQuizState createState() => _StageQuizState();
}

class _StageQuizState extends State<StageQuiz> {
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context);
    super.didChangeDependencies();
  }

  Widget _header() {

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text('${categoryProvider.getSentenceTitle()}'),
        ),
      ),
    );
  }
}
