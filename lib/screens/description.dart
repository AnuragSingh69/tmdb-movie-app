import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:tmdb/helper/favorites_handler.dart';
import './home.dart';
import 'package:http/http.dart' as http;
import 'package:tmdb_api/tmdb_api.dart';
import 'package:url_launcher/url_launcher.dart';

class Description extends StatelessWidget {
  final String name, description, posterurl, rating, release, bannerurl;
  final String id, keys;
  const Description(this.name, this.description, this.posterurl, this.rating,
      this.release, this.bannerurl, this.id, this.keys);

  @override
  Widget build(BuildContext context) {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final name = routeArgs["name"];
    final description = routeArgs["description"];
    final posterurl = routeArgs["posterurl"];
    final rating = routeArgs["rating"];
    final release = routeArgs["release"];
    final bannerurl = routeArgs["bannerurl"];
    final id = routeArgs["id"];
    final keys = routeArgs["key"];
    // final video = routeArgs["video"];
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: ListView(
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  Positioned(
                      child: Container(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child: Image.network(
                            bannerurl.toString(),
                            fit: BoxFit.cover,
                          ))),
                  Positioned(
                      bottom: 10,
                      child: Text(
                        "  ⭐ Average Rating - " + rating.toString(),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                name != null ? name : "Not Found",
                style: TextStyle(fontSize: 24),
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 10),
              child: Text(
                "Releasing on - " + release.toString(),
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  height: 200,
                  width: 100,
                  child: Image.network(posterurl),
                ),
                SizedBox(
                  width: 5,
                ),
                Flexible(
                  child: Container(
                      child: Text(
                    description,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  )),
                )
              ],
            ),
            SizedBox(height: 40),
            Center(
              child: InkWell(
                onTap: () {
                  String message = addFavorites(routeArgs);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(message),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Container(
                      height: 40,
                      width: 180,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          "+ Add to favorites",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                        onPressed: () async {
                          final String apikey =
                              "d0896e27de2adef1a51256072ad32558";
                          final String readaccesstoken =
                              "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJkMDg5NmUyN2RlMmFkZWYxYTUxMjU2MDcyYWQzMjU1OCIsInN1YiI6IjYxMmYwNmVjOTNkYjkyMDA4OGFmN2FjYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.XPQVu_yqBoZnnJO2OGh95108de5uRckZAY74zE80bro";
                          TMDB tmdbWithCustomLogs =
                              TMDB(ApiKeys(apikey, readaccesstoken));
                          Map video =
                              await tmdbWithCustomLogs.v3.movies.getVideos(id);

                          if (video['results'].isNotEmpty) {
                            final trailers = [];
                            for (int i = 0; i < video['results'].length; i++) {
                              final v = video['results'][i];
                              if (!v["type"]
                                  .toLowerCase()
                                  .contains('trailer')) {
                                continue;
                              }
                              trailers.add(v);
                              break;
                            }
                            final videokey = trailers[0]['key'];
                            print(videokey);
                            launchUrl(Uri.parse(
                                'https://www.youtube.com/watch?v=$videokey'));
                          }
                        },
                        child: Text("Watch Trailer"))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
