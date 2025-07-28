import 'package:lynel_app/models/model_album.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<List<Album>> fetchAlbum() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/albums/'),
  );

  if (response.statusCode == 200) {
    List<dynamic> jsonList = jsonDecode(response.body) as List<dynamic>;
    return jsonList
        .map((json) => Album.fromJson(json as Map<String, dynamic>))
        .toList();
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
