Map<String, dynamic> processData(Map<String, dynamic> data) {
  var result = <String, dynamic>{};
  data.forEach((key, value) {
    if (value is Map) {
      //add support value is a Map
      //transform key
      var entries = value.entries.map((e) => MapEntry('${key}_${e.key}', e.value));
      var innerMap = Map.fromEntries(entries);
      result.addAll(processData(innerMap));
    } else {
      result[key] = value;
    }
  });
  return result;
}
