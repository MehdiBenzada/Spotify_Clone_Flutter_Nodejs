import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:spotify_clone_fr/features/auth/model/shared_prefs.dart';
import 'package:spotify_clone_fr/features/music/models/Album.dart';
import 'package:spotify_clone_fr/features/music/models/Song.dart';

class Spotify {
  static Future<String?> getToken() async {
    return await shared_prefs().printToken();
  }

  static Future<String?> getUsername() async {
    return await shared_prefs().printUser();
  }

  static Future<List<Album>> getAlbums() async {
    final token = await getToken();
    final uri = Uri.parse("http://10.0.2.2:3500/spotify");
    final response = await http.get(headers: {
      'authorization': 'Bearer $token',
    }, uri);
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      List<Album> albums = jsonResponse.map((json) {
        String imageUrl = json['Photo'];
        // Update the image URL format
        if (imageUrl.contains('ibb.co')) {
          imageUrl = '${imageUrl.replaceFirst('ibb.co', 'i.ibb.co')}/image.png';
        }
        return Album(
          name: json['AlbumTitle'],
          artist: json['Artist'],
          image: imageUrl,
        );
      }).toList();
      return albums;
    } else {
      throw Exception('Failed to load album');
    }
  }

  static Future signIn(String email, password) async {
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3500/login'),
        body: {"user": email, "pw": password},
      );

      return response;
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  static Future<Album?> fetchAlbums(String albumTitle) async {
    final token = await getToken();
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:3500/spotify/search/$albumTitle'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      // Log the full response for debugging
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 201) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);

        final albumData = jsonResponse['album'];

        String imageUrl = albumData['Photo'];
        print("Image URL before : $imageUrl");
        imageUrl = '${imageUrl.replaceFirst('ibb.co', 'i.ibb.co')}/image.png';
        print(
            "Image URL after : $imageUrl"); // https://i.ibb.co/Wp59Jrp/image.png does this not work??

        return Album(
          // Include id if needed
          name: albumData['AlbumTitle'],
          artist: albumData['Artist'],
          image: imageUrl,
        );
      }
    } catch (e) {
      print("Error fetching albums: $e");
    }
    return null; // Return null if fetching fails
  }

  static Future signup(String user, String pw) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:3500/register'),
      body: {"user": user, "pw": pw},
    );

    print(response.body);
    print(response.statusCode);
  }

  static Future<bool> checkIfLiked(String albumTitle) async {
    final token = await getToken();
    final username = await getUsername();
    final uri = Uri.parse("http://10.0.2.2:3500/spotify/isliked");
    try {
      final response = await http.post(
        uri,
        body: {"AlbumTitle": albumTitle, "username": username},
        headers: {'authorization': 'Bearer $token'},
      );
      if (response.statusCode == 201) {
         
        return true;
      } else if (response.statusCode == 404) {
        return false;
      }
    } catch (e) {
      print("Error checking if album is liked: $e");
    }
    return false;
  }

  static Future<void> addToFav(String albumTitle) async {
    final token = await getToken();
    final username = await getUsername();
    final uri = Uri.parse("http://10.0.2.2:3500/spotify/liked");
    try {
      final response = await http.post(
        uri,
        body: {"AlbumTitle": albumTitle, "username": username},
        headers: {'authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        print("Album added to favorites successfully");
      } else {
        print(
            "Failed to add album to favorites. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error adding album to favorites: $e");
    }
  }

  static Future<void> removeFromFavAlbum(String albumTitle) async {
    final token = await getToken();
    final username = await getUsername();
    final uri = Uri.parse("http://10.0.2.2:3500/spotify/unlike");
    try {
      final response = await http.post(
        uri,
        body: {"AlbumTitle": albumTitle, "username": username},
        headers: {'authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        print("Album removed from favorites successfully");
      } else {
        print(
            "Failed to remove album from favorites. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error removing album from favorites: $e");
    }
  }

  static Future<List<Song>> getSongs(String albumTitle) async {
    final token = await getToken();
    final uri = Uri.parse("http://10.0.2.2:3500/spotify/$albumTitle/songs");
    try {
      final response = await http.get(uri, headers: {
        'authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final songsJson = jsonDecode(response.body);
        if (songsJson == null || songsJson.isEmpty) {
          return [];
        }
        List<Song> songs =
            songsJson.map<Song>((json) => Song.fromJson(json)).toList();
        return songs;
      } else {
        throw Exception(
            'Failed to load album songs. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print("Error fetching songs: $e");
      throw Exception('Failed to load album songs');
    }
  }

  static Future add_song_to_album(
      String albumTitle, String name, String artist, String url) async {
    final token = await getToken();

    final uri = Uri.parse("http://10.0.2.2:3500/spotify/add-songs");

    try {
      final response = await http.post(
        uri,
        body: jsonEncode({
          "AlbumTitle": albumTitle,
          "Songs": [
            {
              "SongTitle": name,
              "Artist": artist,
              "Photo": "https://ibb.co/f9DLq3X", // Use a valid photo URL
              "url": url
            }
          ]
        }),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Album added to favorites successfully");
      } else {
        print(
            "Failed to add album to favorites. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error adding album to favorites: $e");
    }
  }
}
