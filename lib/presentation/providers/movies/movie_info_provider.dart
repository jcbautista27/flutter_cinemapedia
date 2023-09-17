import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final movieInfoProvider = StateNotifierProvider<MovieMapNotifier,Map<String,Movie>>((ref) {
  final movieRepository = ref.watch(movieRepositoryProvider).getMovieById;
  return MovieMapNotifier(getMovie: movieRepository);
});


/*
  '2323232' : Movie()
  '2323232' : Movie()
  '2323232' : Movie()
*/

typedef GetMovieCallBack = Future<Movie>Function(String movieId);

class MovieMapNotifier extends StateNotifier<Map<String, Movie>>{

  final GetMovieCallBack getMovie;

  MovieMapNotifier({
    required this.getMovie
  }):super({});

  Future<void> loadMovie(String movieId)async {
    if(state[movieId] != null) return;
    final movie = await getMovie(movieId);

    state = {...state, movieId: movie};
    

  }

}