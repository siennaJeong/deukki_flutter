import 'package:json_annotation/json_annotation.dart';

part 'common_result_vo.g.dart';

@JsonSerializable()
class CommonResultVO {
  @JsonKey(name: 'responseCode')
  final int responseCode;

  @JsonKey(name: 'result')
  final bool result;

  @JsonKey(name: 'resultMessage')
  final String resultMessage;

  CommonResultVO(this.responseCode, this.result, this.resultMessage);

  factory CommonResultVO.fromJson(Map<String, dynamic> json) => _$CommonResultVOFromJson(json);

}