import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';
import 'package:spacex/src/core/core.dart';
import 'package:spacex/src/features/launces/data/models/models.dart';
import 'package:spacex/src/features/launces/domain/repository/launch_repository.dart';

part 'launch_bloc.freezed.dart';
part 'launch_event.dart';
part 'launch_state.dart';

@injectable
class LaunchBloc extends Bloc<LaunchEvent, LaunchState> with CompleterMixin {
  LaunchBloc(this._repository) : super(const LaunchState.initial()) {
    on<_Get>(_handleGet, transformer: sequential());
    on<_Search>(_handleSearch, transformer: debounceRestartable(const Duration(milliseconds: 600)));
    on<_Sort>(_handleSort, transformer: sequential());
    on<_FetchMore>(_handleFetchMore, transformer: sequential());
  }

  final LaunchRepository _repository;

  bool _hasNextPage = false;

  int? _nextPage;
  String _sort = 'asc';
  String _keyword = '';

  String get sortString => _sort;

  final TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  /// helper method to get the initial data
  void get() {
    add(const LaunchEvent.get());
  }

  /// helper method to search the data
  void search(String keyword) {
    add(LaunchEvent.search(keyword: keyword));
  }

  /// helper method to sort the data
  void sort(String sort) {
    add(LaunchEvent.sort(sort: sort));
  }

  /// helper method to fetch more data
  void fetchMore() {
    add(const LaunchEvent.fetchMore());
  }

  /// helper method to refresh the data this will clear search bar and sort
  Future<void> refresh() async {
    _searchController.clear();
    _keyword = '';
    _sort = 'asc';
    add(const LaunchEvent.get(refresh: true));
    return future;
  }

  FutureOr<void> _handleGet(_Get event, Emitter<LaunchState> emit) async {
    if (!event.refresh) emit(const LaunchState.loading());
    final result = await _repository.getLaunches().run();
    _handleEmit(emit, result);
  }

  FutureOr<void> _handleSearch(_Search event, Emitter<LaunchState> emit) async {
    _keyword = event.keyword;
    emit(const LaunchState.loading());
    final result = await _repository
        .getLaunches(
          keyword: _keyword,
          page: 1,
          sort: _sort,
        )
        .run();
    _handleEmit(emit, result);
  }

  FutureOr<void> _handleSort(_Sort event, Emitter<LaunchState> emit) async {
    _sort = event.sort;
    emit(const LaunchState.loading());
    final result = await _repository
        .getLaunches(
          keyword: _keyword,
          page: 1,
          sort: _sort,
        )
        .run();
    _handleEmit(emit, result);
  }

  FutureOr<void> _handleFetchMore(_FetchMore event, Emitter<LaunchState> emit) async {
    if (state is _Success) {
      final currentState = state as _Success;
      final currentData = currentState.launches.toList();
      if (_nextPage != null && _hasNextPage) {
        emit(currentState.copyWith(isFetching: true));
        final result = await _repository
            .getLaunches(
              keyword: _keyword,
              page: _nextPage!,
              sort: _sort,
            )
            .run();
        _handleEmit(emit, result, currentData);
      }
    }
  }

  void _handleEmit(
    Emitter<LaunchState> emit,
    Either<AppError, PaginatedResource> result, [
    List<LaunchModel>? currentData,
  ]) {
    emit(result.fold(
      (error) {
        complete();
        return LaunchState.error(message: error.toString());
      },
      (apiResponse) {
        complete();
        _hasNextPage = apiResponse.hasNextPage;
        _nextPage = apiResponse.nextPage;
        final updatedData = [...?currentData, ...apiResponse.docs].toList();
        return LaunchState.success(
          launches: updatedData,
          isFetching: false,
        );
      },
    ));
  }

  @override
  Future<void> close() {
    _searchController.dispose();
    return super.close();
  }
}
