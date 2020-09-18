import 'dart:convert';

abstract class ResponseMappable {
  factory ResponseMappable(ResponseMappable type, String data) {
    if (type is BaseMappable) {
      Map<String, dynamic> mappingData = json.decode(data);
      return type.fromJson(mappingData);
    } else if (type is ListMappable) {
      Iterable iterableData = json.decode(data);
      return type.fromJsonList(iterableData);
    }

    return null;
  }
}

abstract class BaseMappable<T> implements ResponseMappable {
  ResponseMappable fromJson(Map<String, dynamic> json);
}

abstract class ListMappable<T> implements ResponseMappable {
  ResponseMappable fromJsonList(List<dynamic> json);
}