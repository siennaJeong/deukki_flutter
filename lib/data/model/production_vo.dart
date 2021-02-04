
import 'package:json_annotation/json_annotation.dart';

part 'production_vo.g.dart';

@JsonSerializable(explicitToJson: true)
class ProductionVO {
  @JsonKey(name: 'idx')
  int idx;

  @JsonKey(name: 'title')
  String title;

  @JsonKey(name: 'price')
  int price;

  @JsonKey(name: 'discountPrice')
  int discountPrice;

  @JsonKey(name: 'discountRate')
  int discountRate;

  @JsonKey(name: 'monthlyPrice')
  int monthlyPrice;

  @JsonKey(name: 'iapId')
  String iapId;

  @JsonKey(name: 'iapGoogle')
  String iapGoogle;

  @JsonKey(name: 'iapApple')
  String iapApple;

  @JsonKey(name: 'trial')
  bool trial;


  ProductionVO(
      this.idx,
      this.title,
      this.price,
      this.discountPrice,
      this.discountRate,
      this.monthlyPrice,
      this.iapId,
      this.iapGoogle,
      this.iapApple,
      this.trial);

  factory ProductionVO.fromJson(Map<String, dynamic> json) => _$ProductionVOFromJson(json);
  Map<String, dynamic> toJson() => _$ProductionVOToJson(this);

  @override
  String toString() {
    return 'ProductionVO{idx: $idx, title: $title, price: $price, discountPrice: $discountPrice, discountRate: $discountRate, monthlyPrice: $monthlyPrice, iapId: $iapId, trial : $trial}';
  }
}