import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';

class HomeView extends ConsumerStatefulWidget {
  const HomeView({super.key});

  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends ConsumerState<HomeView> {
  
  @override
  void initState() {
    super.initState();
    ref.read(nowPlayingMoviesProvider.notifier).loadNextProvider();
    ref.read(popularMoviesProvider.notifier).loadNextProvider();
    ref.read(upcomingMoviesProvider.notifier).loadNextProvider();
    ref.read(topRatedMoviesProvider.notifier).loadNextProvider();
    
  }


  @override
  Widget build(BuildContext context) {
    
    final initialLoading = ref.watch(initialLoadingProvider);
    if (initialLoading) return const FullScreenLoader(); 

    final slideShowMovie = ref.watch(moviesSlideShowProvider);
    final nowPlayingMovies = ref.watch(nowPlayingMoviesProvider);
    final popularMovies = ref.watch(popularMoviesProvider);
    final upcomingMovies = ref.watch(upcomingMoviesProvider);
    final topRatedMovies = ref.watch(topRatedMoviesProvider);

    return CustomScrollView(
      slivers: [

        const SliverAppBar(
          floating: true,
          flexibleSpace: FlexibleSpaceBar(
            title: CustomAppbar(),
          ),
        ),



        SliverList(delegate: SliverChildBuilderDelegate(
          (context, index) {
            return Column(
              children: [
          
                // const CustomAppbar(),
          
                MoviesSlidershow(movies: slideShowMovie),
          
                MovieHortizontalListview(
                  movies:  nowPlayingMovies, 
                  title: 'En cines', 
                  subTitle: 'Lunes 20',
                  loadNextPage: () => ref.read(nowPlayingMoviesProvider.notifier).loadNextProvider(),
                ),
          
                MovieHortizontalListview(
                  movies:  upcomingMovies, 
                  title: 'Proximamente', 
                  subTitle: 'solo en cines',
                  loadNextPage: () => ref.read(upcomingMoviesProvider.notifier).loadNextProvider(),
                ),
          
                MovieHortizontalListview(
                  movies:  popularMovies, 
                  title: 'Populares', 
                  // subTitle: '',
                  loadNextPage: () => ref.read(popularMoviesProvider.notifier).loadNextProvider(),
                ),

                MovieHortizontalListview(
                  movies:  topRatedMovies,                                                                                                                                                                                                                                                                                                                                                       
                  title: 'Mejor calificadas', 
                  subTitle: 'Desde siempre',
                  loadNextPage: () => ref.read(topRatedMoviesProvider.notifier).loadNextProvider(),
                ),
          
          
              ],
            );
          },
          childCount: 1,
        ))
      ],
      
    );
  }
}