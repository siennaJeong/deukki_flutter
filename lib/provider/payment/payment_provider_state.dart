
import 'package:deukki/data/model/common_result_vo.dart';
import 'package:deukki/provider/provider_model_result.dart';

class PaymentProviderState {
  final paymentPreRequest = ProviderModelResult<String>();
  final couponRegistration = ProviderModelResult<int>();
  final paymentValidation = ProviderModelResult<CommonResultVO>();
}