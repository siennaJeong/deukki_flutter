import 'package:json_annotation/json_annotation.dart';
part 'report_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class ReportVO {
  @JsonKey(name: 'reportIdx')
  int reportIdx;

  @JsonKey(name: 'listeningScore')
  int listeningScore;

  @JsonKey(name: 'speakingScore')
  int speakingScore;

  @JsonKey(name: 'link')
  String link;

  ReportVO(this.reportIdx, this.listeningScore, this.speakingScore, this.link);

  factory ReportVO.fromJson(Map<String, dynamic> json) => _$ReportVOFromJson(json);
  Map<String, dynamic> toJson() => _$ReportVOToJson(this);

  @override
  String toString() {
    return 'ReportVO{reportIdx: $reportIdx, listeningScore: $listeningScore, speakingScore: $speakingScore, link: $link}';
  }
}