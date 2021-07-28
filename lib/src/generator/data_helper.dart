var testArb = <String, dynamic>{
  'login': 'Login',
  '@login': {'description': 'Login page title'},
  'settings': {
    'title': 'Settings',
    '@title': {'description': 'Settings page title'},
    'faq': {
      'title': 'Help',
      '@title': {'description': 'Help page title'}
    }
  }
};

Map<String, dynamic> processData(Map<String, dynamic> data) {
  var result = <String, dynamic>{};
  data.forEach((key, value) {
    if (!key.startsWith('@') && value is Map) {
      var innerMap = Map.fromEntries(value.entries.map((e) {
        if (e.key.toString().startsWith('@')) {
          //process key meta info.
          var newKey = '@${key}_${e.key.toString().replaceFirst('@', '')}';
          return MapEntry(newKey, e.value);
        }
        return MapEntry('${key}_${e.key}', e.value);
      }));
      result.addAll(processData(innerMap));
    } else {
      result[key] = value;
    }
  });
  return result;
}
