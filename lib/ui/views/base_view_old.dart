import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:radio_app/core/viewmodels/base_model.dart';
import 'package:radio_app/locator.dart';

class BaseView<T extends BaseModel> extends StatefulWidget {

  final Widget Function (BuildContext context, T model, Widget child) builder;
  final Function(T) onModelReady;
  
  BaseView({this.builder, this.onModelReady});

  @override
  _BaseViewState createState() => _BaseViewState();
}

class _BaseViewState<T extends BaseModel> extends State<BaseView<T>> {
  
  T model = locator<T>();

  @override
  void initState(){
    if(widget.onModelReady != null){
      widget.onModelReady(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<T>(
      create: (context)=>model,
      child: Consumer<T>(
        builder: widget.builder,
      ),
    );
  }
}