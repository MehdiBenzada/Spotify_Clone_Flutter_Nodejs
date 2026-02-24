import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:spotify_clone_fr/core/data/datasources/spotify_api.dart';
 
import 'package:spotify_clone_fr/features/auth/data/datasources/shared_prefs.dart';
import 'package:spotify_clone_fr/features/music/presentation/views/pages/home_page.dart';
import 'package:spotify_clone_fr/features/other/presentation/views/pages/mainpage.dart';

class UploadSong extends StatefulWidget {
  const UploadSong({super.key});

  @override
  State<UploadSong> createState() => _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  bool isLoading = false;
  bool isSuccess = false;
  bool isError = false;
  String? errorMessage;
  final TextEditingController artistController = TextEditingController();
  final TextEditingController songController = TextEditingController();
  final TextEditingController albumController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp3'],
    );

    if (result != null) {
      PlatformFile file = result.files.first;
      print('File Name: ${file.name}');
      print('File Size: ${file.size}');
      print('File Path: ${file.path}');

      final uri = Uri.parse("http://10.0.2.2:3500/upload");
      final token = await shared_prefs().printToken();

      setState(() {
        isLoading = true;
        isSuccess = false;
        isError = false;
        errorMessage = null;
      });

      try {
        if (token == null || token.isEmpty) {
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = "Missing token. Please login again.";
          });
          return;
        }

        var request = http.MultipartRequest('POST', uri);
        request.headers['Authorization'] = 'Bearer $token';

        final bytes = file.bytes ?? File(file.path!).readAsBytesSync();
        request.files.add(http.MultipartFile.fromBytes(
          'filename',
          bytes,
          filename: file.name,
          contentType: MediaType('audio', 'mp3'),
        ));

        var streamedResponse = await request.send();
        var response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 200) {
          try {
            final artist = artistController.text.trim();
            final song = songController.text.trim();
            final album = albumController.text.trim();

            
            if (artist.isEmpty || song.isEmpty || album.isEmpty) {
              print('Please fill all fields: Album, Song, and Artist.');
              setState(() {
                isLoading = false;
                isError = true;
                errorMessage = "Fill album, song and artist fields first.";
              });
              return;
            }

            
            print("Firebase response body: ${response.body}");

            
            final url = jsonDecode(response.body)['downloadURL'];
            print("this the url $url");
            final yurr = await Spotify.add_song_to_album(album, song, artist, url);
            print(
                "Sending album: $album, song: $song, artist: $artist, url: $url");

            if (yurr != null) {
              print(yurr.body);
              if (yurr.statusCode >= 400) {
                setState(() {
                  isLoading = false;
                  isError = true;
                  errorMessage =
                      "Song metadata save failed (${yurr.statusCode}): ${yurr.body}";
                });
                return;
              }
            }
          } catch (e) {
            print(e);
            setState(() {
              isLoading = false;
              isError = true;
              errorMessage = "Upload response parse error: $e";
            });
            return;
          }

          setState(() {
            isLoading = false;
            isSuccess = true;
          });
        } else {
          print("Upload failed: ${response.statusCode}");
          print(response.body);
          String message = "Upload failed (${response.statusCode}).";
          try {
            final body = jsonDecode(response.body);
            if (body is Map && body['message'] != null) {
              message = "${body['message']} (${response.statusCode})";
            }
          } catch (_) {}
          setState(() {
            isLoading = false;
            isError = true;
            errorMessage = message;
          });
        }

        print(response.body);
      } catch (e) {
        setState(() {
          isLoading = false;
          isError = true;
          errorMessage = "Request error: $e";
        });
        print(e);
      }
    } else {
      print('No file selected');
    }
  }

  void goToHomePage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => home_page()));
  }

  Future<void> checkUploadConnection() async {
    final token = await shared_prefs().printToken();
    if (token == null || token.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No token found. Login again first.")),
      );
      return;
    }

    try {
      final response = await http.get(
        Uri.parse("http://10.0.2.2:3500/upload/health"),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Health ${response.statusCode}: ${response.body}")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Health check failed: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MainPage(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text('Upload Song'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Enter artist name'),
            TextBox(
              hintText: 'Artist Name',
              controller: artistController,
            ),
            const Text('Enter song name'),
            TextBox(
              hintText: 'Song Name',
              controller: songController,
            ),
            const Text('Enter album name'),
            TextBox(
              hintText: 'Album Name',
              controller: albumController,
            ),
            if (isLoading)
              const CircularProgressIndicator()  
            else if (isSuccess)
              Column(
                children: [
                  const Icon(Icons.check_circle, color: Colors.green),
                  ElevatedButton(
                    onPressed: goToHomePage,
                    child: const Text('Success! Go to Homepage'),
                  ),
                ],
              )
            else if (isError)
              Column(
                children: [
                  const Icon(Icons.error, color: Colors.red),
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.redAccent),
                      ),
                    ),
                  ElevatedButton(
                    onPressed: pickFile,  
                    child: const Text('Error! Try Again'),
                  ),
                ],
              )
            else
              ElevatedButton(
                onPressed: pickFile,
                child: const Text('Choose Song'),
              ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: checkUploadConnection,
              child: const Text('Check Upload Connection'),
            ),
          ],
        ),
      ),
    );
  }

  
}

class TextBox extends StatelessWidget {
  const TextBox({
    super.key,
    required this.hintText,
    required this.controller,
  });
  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: TextField(
        controller: controller,  
        cursorWidth: 2,
        decoration: const InputDecoration(
          filled: true,
          fillColor: Color.fromARGB(255, 64, 64, 64),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color.fromARGB(255, 64, 64, 64)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Color.fromARGB(255, 211, 211, 211)),
          ),
        ),
      ),
    );
  }
}

