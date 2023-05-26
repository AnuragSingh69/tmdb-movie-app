import 'package:flutter/material.dart';

class TopRatedMovies extends StatelessWidget {
  final List topratedmovies;

  const TopRatedMovies(this.topratedmovies);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Top Rated Movies',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: topratedmovies.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("/description", arguments: {
                          "name": topratedmovies[index]["title"],
                          "description": topratedmovies[index]["overview"],
                          "posterurl": 'https://image.tmdb.org/t/p/w500' +
                              topratedmovies[index]["poster_path"],
                          "rating": topratedmovies[index]["vote_average"],
                          "release":
                              topratedmovies[index]["release_date"].toString(),
                          "bannerurl": 'https://image.tmdb.org/t/p/w500' +
                              topratedmovies[index]["backdrop_path"],
                          "id": topratedmovies[index]["id"]
                        });
                      },
                      child: topratedmovies[index]["title"] != null
                          ? Container(
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500' +
                                                topratedmovies[index]
                                                    ['poster_path']),
                                      ),
                                    ),
                                    height: 200,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    child: Text(
                                      topratedmovies[index]['title'] != null
                                          ? topratedmovies[index]['title']
                                          : 'Loading',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            )
                          : Container(),
                    );
                  }))
        ],
      ),
    );
  }
}
