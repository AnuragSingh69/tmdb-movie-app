import 'package:flutter/material.dart';

class TV extends StatelessWidget {
  final List tvshows;

  const TV(this.tvshows);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Popular TV Shows',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          SizedBox(height: 10),
          Container(
              height: 270,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: tvshows.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed("/description", arguments: {
                          "name": tvshows[index]["original_name"],
                          "description": tvshows[index]["overview"],
                          "posterurl": 'https://image.tmdb.org/t/p/w500' +
                              tvshows[index]["poster_path"],
                          "rating": tvshows[index]["vote_average"],
                          "release": tvshows[index]["release_date"].toString(),
                          "bannerurl": 'https://image.tmdb.org/t/p/w500' +
                              tvshows[index]["backdrop_path"],
                          "id": tvshows[index]["id"]
                        });
                      },
                      child: tvshows[index]["original_name"] != null
                          ? Container(
                              width: 140,
                              child: Column(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                            'https://image.tmdb.org/t/p/w500' +
                                                tvshows[index]['poster_path']),
                                      ),
                                    ),
                                    height: 200,
                                  ),
                                  SizedBox(height: 5),
                                  Container(
                                      child: Text(
                                    tvshows[index]['original_name'] != null
                                        ? tvshows[index]['original_name']
                                        : 'Loading',
                                    style: TextStyle(color: Colors.white),
                                  ))
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
