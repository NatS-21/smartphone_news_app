
import 'package:equatable/equatable.dart';

import 'package:smartphone_news_app/models/score.dart';

enum Status { initial, success, failure }

class NewsCatsState extends Equatable {
    NewsCatsState({
        this.status = Status.initial,
        this.categoriesStatus = Status.initial,
        this.categoriesMessage = '' ,
        this.message = '',
        CategoriesNewsModel? categoriesNewsModel ,
    })  
    : newsCategoriesList = categoriesNewsModel ?? CategoriesNewsModel();

    final Status status;
    final String message;
    final Status categoriesStatus  ;
    final String categoriesMessage  ;
    final CategoriesNewsModel? newsCategoriesList ;

    NewsCatsState copyWith({
        Status? status,
        String? message,
        CategoriesNewsModel? categoriesNewsModel,
        String? categoriesMessage,
        Status? categoriesStatus

    }) {
    return NewsCatsState(
        status: status ?? this.status,
        message: message ?? this.message,
        categoriesMessage: message ?? this.categoriesMessage,
        categoriesNewsModel: categoriesNewsModel ?? newsCategoriesList,
        categoriesStatus: categoriesStatus ?? this.categoriesStatus,
    );
    }

    @override
    String toString() {
        return '''PostState { status: $status, hasReachedMax: $message,}''';
    }

    @override
    List<Object?> get props => [status, message,identityHashCode(this) ];
}
