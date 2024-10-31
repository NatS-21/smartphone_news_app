import 'package:bloc/bloc.dart';
import 'package:smartphone_news_app/bloc/category_event.dart';
import 'package:smartphone_news_app/bloc/category_state.dart';
import 'package:smartphone_news_app/repo/repo.dart';

class NewsCatsBloc extends Bloc<NewsCatsEvent, NewsCatsState> {
  final NewsRepository newsRepository = NewsRepository();

  NewsCatsBloc() : super(NewsCatsState()) {
    on<NewsCategories>(fetchNewsCategories);
  }

  Future<void> fetchNewsCategories(NewsCategories event, Emitter<NewsCatsState> emit) async {
    emit(state.copyWith(categoriesStatus: Status.initial));

    try {
      final categoriesNewsModel = await newsRepository.fetchNewsCategoires(event.category);

      emit(
        state.copyWith(
          categoriesStatus: Status.success,
          categoriesNewsModel: categoriesNewsModel,
          categoriesMessage: 'ok',
        ),
      );
    } catch (error) {
      print(error);
      emit(
        state.copyWith(
          categoriesStatus: Status.failure,
          categoriesMessage: error.toString(),
        ),
      );
      emit(
        state.copyWith(
          status: Status.failure,
          message: error.toString(),
        ),
      );
    }
  }
}
