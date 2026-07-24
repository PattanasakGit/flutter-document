// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TaskListController)
final taskListControllerProvider = TaskListControllerProvider._();

final class TaskListControllerProvider
    extends $NotifierProvider<TaskListController, TaskListState> {
  TaskListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskListControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskListControllerHash();

  @$internal
  @override
  TaskListController create() => TaskListController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskListState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskListState>(value),
    );
  }
}

String _$taskListControllerHash() =>
    r'2f1504dd1415cbdbb063704579b5b836484786fe';

abstract class _$TaskListController extends $Notifier<TaskListState> {
  TaskListState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<TaskListState, TaskListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TaskListState, TaskListState>,
              TaskListState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
