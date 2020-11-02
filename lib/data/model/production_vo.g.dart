// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'production_vo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductionVO _$ProductionVOFromJson(Map<String, dynamic> json) {
  return ProductionVO(
    json['idx'] as int,
    json['title'] as String,
    json['price'] as int,
    json['discountPrice'] as int,
    json['discountRate'] as int,
    json['monthlyPrice'] as int,
    json['iapGoogle'] as String,
    json['iapApple'] as String,
  );
}

Map<String, dynamic> _$ProductionVOToJson(ProductionVO instance) =>
    <String, dynamic>{
      'idx': instance.idx,
      'title': instance.title,
      'price': instance.price,
      'discountPrice': instance.discountPrice,
      'discountRate': instance.discountRate,
      'monthlyPrice': instance.monthlyPrice,
      'iapGoogle': instance.iapGoogle,
      'iapApple': instance.iapApple,
    };
