
abstract class SearchStates {}

class SearchInitialState extends SearchStates {}

// Post Search from api
class SearchLoadingState extends SearchStates {}

class SearchSuccessState extends SearchStates {}

class SearchErrorState extends SearchStates {}