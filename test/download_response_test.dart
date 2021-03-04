import 'dart:typed_data';

import 'package:test/test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart';

import 'package:intl_utils/src/localizely/model/download_response.dart';

import 'download_response_test.mocks.dart';

Uint8List _getEmptyArbFileBytes() => Uint8List.fromList([123, 125]);

Uint8List _getZippedEmptyArbFilesBytes() => Uint8List.fromList([
      80,
      75,
      3,
      4,
      20,
      0,
      8,
      8,
      8,
      0,
      154,
      90,
      50,
      81,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      11,
      0,
      0,
      0,
      105,
      110,
      116,
      108,
      95,
      100,
      101,
      46,
      97,
      114,
      98,
      171,
      174,
      5,
      0,
      80,
      75,
      7,
      8,
      67,
      191,
      166,
      163,
      4,
      0,
      0,
      0,
      2,
      0,
      0,
      0,
      80,
      75,
      3,
      4,
      20,
      0,
      8,
      8,
      8,
      0,
      154,
      90,
      50,
      81,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      11,
      0,
      0,
      0,
      105,
      110,
      116,
      108,
      95,
      101,
      110,
      46,
      97,
      114,
      98,
      171,
      174,
      5,
      0,
      80,
      75,
      7,
      8,
      67,
      191,
      166,
      163,
      4,
      0,
      0,
      0,
      2,
      0,
      0,
      0,
      80,
      75,
      1,
      2,
      20,
      0,
      20,
      0,
      8,
      8,
      8,
      0,
      154,
      90,
      50,
      81,
      67,
      191,
      166,
      163,
      4,
      0,
      0,
      0,
      2,
      0,
      0,
      0,
      11,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      105,
      110,
      116,
      108,
      95,
      100,
      101,
      46,
      97,
      114,
      98,
      80,
      75,
      1,
      2,
      20,
      0,
      20,
      0,
      8,
      8,
      8,
      0,
      154,
      90,
      50,
      81,
      67,
      191,
      166,
      163,
      4,
      0,
      0,
      0,
      2,
      0,
      0,
      0,
      11,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      0,
      61,
      0,
      0,
      0,
      105,
      110,
      116,
      108,
      95,
      101,
      110,
      46,
      97,
      114,
      98,
      80,
      75,
      5,
      6,
      0,
      0,
      0,
      0,
      2,
      0,
      2,
      0,
      114,
      0,
      0,
      0,
      122,
      0,
      0,
      0,
      0,
      0
    ]);

@GenerateMocks([Response])
void main() {
  group('Create an instance from a response with an arb file', () {
    test(
        'Test instantiation with the http response, which contains an arb file for the en locale code',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn(
          {'content-disposition': 'attachment; filename="intl_en.arb"'});
      when(mockedResponse.bodyBytes).thenReturn(_getEmptyArbFileBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(1));
      expect(downloadResponse.files[0].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains an arb file for the fr_FR locale code',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn(
          {'content-disposition': 'attachment; filename="intl_fr_FR.arb"'});
      when(mockedResponse.bodyBytes).thenReturn(_getEmptyArbFileBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(1));
      expect(downloadResponse.files[0].name, equals('intl_fr_FR.arb'));
    });

    test(
        'Test instantiation with the http response, which contains an arb file for the zh_Hans locale code',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn(
          {'content-disposition': 'attachment; filename="intl_zh_Hans.arb"'});
      when(mockedResponse.bodyBytes).thenReturn(_getEmptyArbFileBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(1));
      expect(downloadResponse.files[0].name, equals('intl_zh_Hans.arb'));
    });

    test(
        'Test instantiation with the http response, which contains an arb file for the zh_Hans_CN locale code',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn({
        'content-disposition': 'attachment; filename="intl_zh_Hans_CN.arb"'
      });
      when(mockedResponse.bodyBytes).thenReturn(_getEmptyArbFileBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(1));
      expect(downloadResponse.files[0].name, equals('intl_zh_Hans_CN.arb'));
    });
  });

  group('Create an instance from a response with a zip file', () {
    test(
        'Test instantiation with the http response, which contains a zip file with the simple name',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn(
          {'content-disposition': 'attachment; filename="Project name.zip"'});
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains a zip file with the name with dashes',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn({
        'content-disposition':
            'attachment; filename="Project-name-with-dashes.zip"'
      });
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains a zip file with the name with underscores',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn({
        'content-disposition':
            'attachment; filename="Project_name_with_underscores.zip"'
      });
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains a zip file with the name with numbers',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn(
          {'content-disposition': 'attachment; filename="0123456789.zip"'});
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains a zip file with the name with double quote signs',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn(
          {'content-disposition': 'attachment; filename="Project "name".zip"'});
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains a zip file with the name with uncommon letters',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn({
        'content-disposition':
            'attachment; filename="Nom du projet avec caractères spéciaux.zip"'
      });
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });

    test(
        'Test instantiation with the http response, which contains a zip file with the name with special characters',
        () {
      var mockedResponse = MockResponse();
      when(mockedResponse.headers).thenReturn({
        'content-disposition':
            'attachment; filename="Project `~!@#\$%^&*()_+-=[]{}\'\\:"|,./<>?name.zip"'
      });
      when(mockedResponse.bodyBytes).thenReturn(_getZippedEmptyArbFilesBytes());

      var downloadResponse = DownloadResponse.fromResponse(mockedResponse);

      expect(downloadResponse.files.length, equals(2));
      expect(downloadResponse.files[0].name, equals('intl_de.arb'));
      expect(downloadResponse.files[1].name, equals('intl_en.arb'));
    });
  });
}
