import 'package:equatable/equatable.dart';

abstract class NewsCatsEvent extends Equatable {
    @override
    List<Object> get props => [];
}

class NewsCategories extends NewsCatsEvent {
    final String category ;
    NewsCategories(this.category);
}
