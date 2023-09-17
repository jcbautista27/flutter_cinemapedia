import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/config/helpers/human_formats.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter/material.dart';

typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchMovieDelegate extends SearchDelegate{
  final SearchMoviesCallback searchMovies;
  List<Movie> initialMovies;

  StreamController<List<Movie>> debouncedMovies = StreamController.broadcast();
  StreamController<bool> isLoadingStream = StreamController.broadcast();

  Timer? _debouncedTimer;

  SearchMovieDelegate({
    required this.searchMovies,
    required this.initialMovies,
  }): super(
    searchFieldLabel: 'Buscar película'
  );

  void clearStreams(){
    debouncedMovies.close();
    isLoadingStream.close();
  }

  void _onQueryChanged (String query){
    
    isLoadingStream.add(true);

    if (_debouncedTimer?.isActive ?? false) _debouncedTimer!.cancel();

    _debouncedTimer = Timer(const Duration(milliseconds: 500), ()  async{ 
      // print('Buscando películas');
      // if (query.isEmpty){
      //   debouncedMovies.add([]);
      //   return;
      // }

      final movies = await searchMovies(query);
      initialMovies = movies;
      debouncedMovies.add(movies);
      isLoadingStream.add(false);
    });
  }

  Widget _buildResultAndSuggestions(){
    return StreamBuilder(
      initialData: initialMovies ,
      stream: debouncedMovies.stream,
      builder: (context, snapshot) {

        final movies = snapshot.data ?? [];

        return ListView.builder(
          itemCount: movies.length,
          itemBuilder: (context, index) {
            final movie = movies[index];
            return _MovieItem(
              movie: movie,
              onMovieselected: (context, movie){
                clearStreams();
                close(context, movie);
              },
            );
          },
        );
      },
    ); 
  }

  // @override
  // String get searchFieldLabel => 'Buscar película';

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [

      StreamBuilder(
        initialData: false,
        stream: isLoadingStream.stream,
        builder: (context, snapshot) {
          if (snapshot.data ?? false){
            return SpinPerfect(
              duration: const Duration(seconds: 20),
              spins: 10,
              infinite: true,
              child: IconButton(
                onPressed: () => query = '', 
                icon: const Icon(Icons.refresh_outlined)
              ),
            );
          }
          return FadeIn(
            animate: query.isNotEmpty,
            duration: const Duration(milliseconds: 200),
            child: IconButton(
              onPressed: () => query = '', 
              icon: const Icon(Icons.clear)
            ),
          );
        },
      )

      


    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed:() {
        clearStreams();
        close(context, null);
      } ,
      icon: const Icon(Icons.arrow_back_ios_new_outlined)
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildResultAndSuggestions();
    
  }

  @override
  Widget buildSuggestions(BuildContext context) {

    _onQueryChanged(query);

    return _buildResultAndSuggestions();
  }

}

class _MovieItem extends StatelessWidget {

  final Movie movie;
  final Function onMovieselected;

  const _MovieItem({required this.movie, required this.onMovieselected});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () {
         onMovieselected(context, movie);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
        child: Row(
          children: [
    
            //Image
            SizedBox(
              width: size.width * 0.2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(movie.posterPath),
              ),
            ),
    
            const SizedBox(width: 10,),
    
            //Description
    
            SizedBox(
              width: size.width * 0.7,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(movie.title, style: textStyle.titleMedium,),
    
                  (movie.overview.length > 100)
                  ? Text('${movie.overview.substring(0,100)}...')
                  : Text(movie.overview),
    
                  Row(
                    children: [
                      Icon(Icons.star_half_rounded, color: Colors.yellow[800],),
                      const SizedBox(width: 3,),
                      Text(
                        HumanFormats.number(movie.voteAverage, 1), 
                        style: textStyle.bodyMedium!.copyWith(color: Colors.yellow[900]),
                      )
                    ],
                  )
                  
    
                ],
              ),
            )
          ],
        )
      ),
    );
  }
}