import 'package:flutter/material.dart';

class TrendingMovies extends StatelessWidget {
  final List trendingmovies;

  const TrendingMovies(this.trendingmovies);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Trending Movies',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingmovies.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("/description", arguments: {
                          "name": trendingmovies[index]["title"],
                          "description": trendingmovies[index]["overview"],
                          "posterurl": 'https://image.tmdb.org/t/p/w500' +
                              trendingmovies[index]["poster_path"],
                          "rating": trendingmovies[index]["vote_average"],
                          "release":
                              trendingmovies[index]["release_date"].toString(),
                          "bannerurl": 'https://image.tmdb.org/t/p/w500' +
                              trendingmovies[index]["backdrop_path"],
                          "id": trendingmovies[index]["id"]
                        });
                      },
                      child: trendingmovies[index]["title"] != null
                          ? Container(
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500' +
                                                trendingmovies[index]
                                                    ['poster_path']),
                                      ),
                                    ),
                                    height: 200,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                    child: Text(
                                      trendingmovies[index]['title'] != null
                                          ? trendingmovies[index]['title']
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
