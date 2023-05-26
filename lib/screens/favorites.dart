import 'package:flutter/material.dart';
import 'package:tmdb/helper/favorites_handler.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
        backgroundColor: Colors.transparent,
      ),
      body: favorites.length == 0
          ? Center(
              child: Text(
                "No movie added to favorites",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            )
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Theme.of(context).errorColor,
                    child: Icon(Icons.delete, color: Colors.white),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20),
                    margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text("Movie Removed from Favourites")));
                    setState(() {
                      removeFavorites(favorites[index]);
                    });
                  },
                  child: Container(
                    height: 120,
                    margin: EdgeInsets.all(5),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(color: Colors.black),
                    child: Row(
                      children: [
                        Image(
                          image: NetworkImage(
                              "https://image.tmdb.org/t/p/w500" +
                                  favorites[index]["posterurl"]),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                favorites[index]["name"],
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              Text(
                                "Released - ${favorites[index]["release"] ?? '--'}",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text(
                                    "⭐ ${favorites[index]["rating"] ?? '--'}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Spacer(),
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
