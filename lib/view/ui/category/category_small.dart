import 'package:deukki/data/model/category_vo.dart';
import 'package:deukki/provider/resource/category_provider.dart';
import 'package:deukki/provider/resource/resource_provider_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategorySmall extends StatefulWidget {
  @override
  _CategorySmallState createState() => _CategorySmallState();
}

class _CategorySmallState extends State<CategorySmall> {
  CategoryProvider categoryProvider;
  ResourceProviderModel resourceProviderModel;

  @override
  void didChangeDependencies() {
    categoryProvider = Provider.of<CategoryProvider>(context);
    resourceProviderModel = Provider.of<ResourceProviderModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Selector<CategoryProvider, List<CategoryMediumVO>>(
      selector: (context, categoryProvider) => categoryProvider.categorySmallList,
      builder: (context, smallList, child) {
        return Container(
          child: ListView.builder(
            itemCount: smallList.length,
            itemBuilder: (BuildContext context, index) {
              return Container(
                child: Text(smallList[index].title),
              );
            },
          ),
        );
      },
    );
  }
}
