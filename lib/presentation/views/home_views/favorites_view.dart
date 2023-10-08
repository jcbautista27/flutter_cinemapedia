import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoriteView extends ConsumerStatefulWidget {
  const FavoriteView({Key? key}) : super(key: key);
  

  @override
  FavoriteViewState createState() => FavoriteViewState();
}

class FavoriteViewState extends ConsumerState<FavoriteView> {

  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadNextPage();
  }

  void loadNextPage() async{

    if (isLoading || isLastPage) return;

    isLoading = true;

    final movies = await ref.read(favoriteMoviesProvider.notifier).loadNextPage();
    isLoading = false;
    if (movies.isEmpty){
      isLastPage = true;
    }

  }


  @override
  Widget build(BuildContext context) {
    final favoriteMovies = ref.watch(favoriteMoviesProvider).values.toList();


    if(favoriteMovies.isEmpty){
      final colors = Theme.of(context).colorScheme;
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border_rounded, size: 60, color: colors.primary,),
            Text('Ohh nooo!!!', style: TextStyle(fontSize: 30, color: colors.primary),),
            const Text('No tienes pelciulas favoritas', style: TextStyle(fontSize: 20, color: Colors.black45),),

            const SizedBox(height: 20,),

            FilledButton.tonal(
              onPressed: (){
                context.go('/');
              }, 
              child: const Text('Empieza a buscar...')
            )
          ],
        )
      );
    }


    return Scaffold(
      body: MovieMasonry(
        loadNextPage: loadNextPage,
        movies: favoriteMovies
      )
    );
  }
}