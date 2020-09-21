import 'dart:ui';
import 'package:async/async.dart';

class ProviderModelResult<T> {
  Future<void> set(Future<Result<T>> futureResult, VoidCallback isLoadingChange) async {
    _isLoading = true;
    result = await futureResult;
    _isLoading = false;
    isLoadingChange();
  }

  bool get hasData => !_isLoading || result != null;
  Result<T> result;
  bool _isLoading = false;

}