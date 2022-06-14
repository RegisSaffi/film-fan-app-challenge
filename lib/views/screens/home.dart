import 'package:film_fan/views/pages/account_page.dart';
import 'package:film_fan/views/pages/favorites_page.dart';
import 'package:film_fan/views/pages/movies_page.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget{
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  var page=0;
  PageController pageController=PageController(initialPage: 0);

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Text("Film Fan"),),
      body: PageView(
        onPageChanged: (p){
          setState(() {
            page=p;
          });
        },
        controller: pageController,
        children: [
          MoviesPage(),
          FavoritesPage(),
          AccountPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (i){
          if(i==2){

          }
         pageController.animateToPage(i, duration: Duration(milliseconds: 300), curve: Curves.ease);
        },
        currentIndex: page,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite),label: "Favorites"),
          BottomNavigationBarItem(icon: Icon(Icons.person),label: "Account"),
        ],
      ),
    );
  }
}