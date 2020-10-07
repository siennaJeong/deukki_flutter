import 'package:json_annotation/json_annotation.dart';

part 'common_result_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class CommonResultVO {
  @JsonKey(name: 'status')
  final int status;

  @JsonKey(name: 'message')
  final String message;

  @JsonKey(name: 'result')
  final dynamic result;

  CommonResultVO(this.status, this.message, this.result);

  factory CommonResultVO.fromJson(Map<String, dynamic> json) => _$CommonResultVOFromJson(json);



}
