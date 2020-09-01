import 'package:bloc/bloc.dart';
import 'package:flutter_news_app/src/api/api_repository.dart';
import 'package:flutter_news_app/src/model/company_stock_data/company_stock_data.dart';


abstract class CompanyState {}

class CompanyInitial extends CompanyState {}

class CompanyLoading extends CompanyState {}

class CompanySuccess extends CompanyState {
  final List<Company> data;
  
  CompanySuccess(this.data);
}

class CompanySuggestionSuccess extends CompanyState {
  final List<Company> data;
  
  CompanySuggestionSuccess(this.data);
}

class CompanyFailed extends CompanyState {
  final String errorMessage;

  CompanyFailed(this.errorMessage);
}

abstract class CompanyEvent {}

class CompanyEventList extends CompanyEvent {
  final String userId;

  CompanyEventList(this.userId);
}

class CompanyEventStore extends CompanyEvent {
  final String data;
  final String userId;

  CompanyEventStore({this.data, this.userId});
}

class CompanyEventRecommend extends CompanyEvent {
  final String userId;

  CompanyEventRecommend(this.userId);
}

class CompanySingleEventRecommend extends CompanyEvent {
  final Company company;

  CompanySingleEventRecommend(this.company);
}

class CompanyBloc extends Bloc<CompanyEvent, CompanyState> {
  var companies;
  var _suggestedCompaniesList;
  var _companies;

  @override
  CompanyState get initialState => CompanyInitial();

  @override
  Stream<CompanyState> mapEventToState(CompanyEvent event) async* {
    yield CompanyLoading();
    final apiRepository = ApiRepository();

    if (event is CompanyEventStore) {
      final userId = event.userId;
      await apiRepository.fetchCompany(event.data).then((company) async {
        await apiRepository.storeCompany(userId, company).then((code) async*{
          if (code == 200) {
            print('Company stored');
          } else {
            print('Something wrong happened with code: $code');
          }
        });
      });
      // Force step after adding company
      final data = await apiRepository.fetchCompanies(userId);
      if (data != null) {
        companies = data;
        yield CompanySuccess(data);
      } else {
        yield CompanyFailed('Failed to fetch data');
      }

    } else if (event is CompanyEventRecommend) {
      if (_suggestedCompaniesList == null || !_suggestedCompaniesList.isNotEmpty) {
        List<Company> suggestedCompanies = [];
        final userId = event.userId;
        _companies = companies ?? await apiRepository.fetchCompanies(userId);

        for (var company in _companies) {
          var actualSuggestedCompanies = await apiRepository.recommendCompany(company.domain);
          suggestedCompanies.addAll(actualSuggestedCompanies);
        }
        final excludedCompanies = _companies.map((company) => company.commonName);
        _suggestedCompaniesList = filterCompanies(excludedCompanies, suggestedCompanies);
      }
      yield CompanySuggestionSuccess(_suggestedCompaniesList);

    } else if (event is CompanySingleEventRecommend ) {
      _companies.add(event.company);
      final suggestedCompanies = await apiRepository.recommendCompany(event.company.domain);
      final excludedCompanies = _companies.map((company) => company.commonName);
      _suggestedCompaniesList = filterCompanies(excludedCompanies, suggestedCompanies);
      yield CompanySuggestionSuccess(_suggestedCompaniesList);

    } else if (event is CompanyEventList){
      final userId = event.userId;
      final data = await apiRepository.fetchCompanies(userId);
      if (data != null) {
        companies = data;
        yield CompanySuccess(data);
      } else {
        yield CompanyFailed('Failed to fetch data');
      }
    }
  }

  List<Company> filterCompanies(var excludedCompanies, List<Company> suggestedCompanies) {
    var dictOfCompanies = {};
    final nonRepeatedCompanies = suggestedCompanies.map<Company>((company) {
      if (dictOfCompanies.containsKey(company.commonName)) {
        return null;
      }
      dictOfCompanies.putIfAbsent(company.commonName, () => company);
      return company;
    }).where((company) => company != null)
      .where((company) => !excludedCompanies.contains(company.commonName))
      .toList();

      return nonRepeatedCompanies;
  }
}
