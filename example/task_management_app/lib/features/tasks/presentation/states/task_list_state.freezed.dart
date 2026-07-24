// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'task_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TaskListState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskListState()';
}


}

/// @nodoc
class $TaskListStateCopyWith<$Res>  {
$TaskListStateCopyWith(TaskListState _, $Res Function(TaskListState) __);
}


/// Adds pattern-matching-related methods to [TaskListState].
extension TaskListStatePatterns on TaskListState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TaskListLoading value)?  loading,TResult Function( TaskListReady value)?  ready,TResult Function( TaskListFailed value)?  failed,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading(_that);case TaskListReady() when ready != null:
return ready(_that);case TaskListFailed() when failed != null:
return failed(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TaskListLoading value)  loading,required TResult Function( TaskListReady value)  ready,required TResult Function( TaskListFailed value)  failed,}){
final _that = this;
switch (_that) {
case TaskListLoading():
return loading(_that);case TaskListReady():
return ready(_that);case TaskListFailed():
return failed(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TaskListLoading value)?  loading,TResult? Function( TaskListReady value)?  ready,TResult? Function( TaskListFailed value)?  failed,}){
final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading(_that);case TaskListReady() when ready != null:
return ready(_that);case TaskListFailed() when failed != null:
return failed(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Task> tasks,  TaskFilter filter,  bool isMutating,  String? actionError)?  ready,TResult Function( Failure failure)?  failed,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading();case TaskListReady() when ready != null:
return ready(_that.tasks,_that.filter,_that.isMutating,_that.actionError);case TaskListFailed() when failed != null:
return failed(_that.failure);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Task> tasks,  TaskFilter filter,  bool isMutating,  String? actionError)  ready,required TResult Function( Failure failure)  failed,}) {final _that = this;
switch (_that) {
case TaskListLoading():
return loading();case TaskListReady():
return ready(_that.tasks,_that.filter,_that.isMutating,_that.actionError);case TaskListFailed():
return failed(_that.failure);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Task> tasks,  TaskFilter filter,  bool isMutating,  String? actionError)?  ready,TResult? Function( Failure failure)?  failed,}) {final _that = this;
switch (_that) {
case TaskListLoading() when loading != null:
return loading();case TaskListReady() when ready != null:
return ready(_that.tasks,_that.filter,_that.isMutating,_that.actionError);case TaskListFailed() when failed != null:
return failed(_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class TaskListLoading implements TaskListState {
  const TaskListLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TaskListState.loading()';
}


}




/// @nodoc


class TaskListReady implements TaskListState {
  const TaskListReady({required final  List<Task> tasks, this.filter = TaskFilter.all, this.isMutating = false, this.actionError}): _tasks = tasks;
  

 final  List<Task> _tasks;
 List<Task> get tasks {
  if (_tasks is EqualUnmodifiableListView) return _tasks;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_tasks);
}

@JsonKey() final  TaskFilter filter;
@JsonKey() final  bool isMutating;
 final  String? actionError;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListReadyCopyWith<TaskListReady> get copyWith => _$TaskListReadyCopyWithImpl<TaskListReady>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListReady&&const DeepCollectionEquality().equals(other._tasks, _tasks)&&(identical(other.filter, filter) || other.filter == filter)&&(identical(other.isMutating, isMutating) || other.isMutating == isMutating)&&(identical(other.actionError, actionError) || other.actionError == actionError));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_tasks),filter,isMutating,actionError);

@override
String toString() {
  return 'TaskListState.ready(tasks: $tasks, filter: $filter, isMutating: $isMutating, actionError: $actionError)';
}


}

/// @nodoc
abstract mixin class $TaskListReadyCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory $TaskListReadyCopyWith(TaskListReady value, $Res Function(TaskListReady) _then) = _$TaskListReadyCopyWithImpl;
@useResult
$Res call({
 List<Task> tasks, TaskFilter filter, bool isMutating, String? actionError
});




}
/// @nodoc
class _$TaskListReadyCopyWithImpl<$Res>
    implements $TaskListReadyCopyWith<$Res> {
  _$TaskListReadyCopyWithImpl(this._self, this._then);

  final TaskListReady _self;
  final $Res Function(TaskListReady) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? tasks = null,Object? filter = null,Object? isMutating = null,Object? actionError = freezed,}) {
  return _then(TaskListReady(
tasks: null == tasks ? _self._tasks : tasks // ignore: cast_nullable_to_non_nullable
as List<Task>,filter: null == filter ? _self.filter : filter // ignore: cast_nullable_to_non_nullable
as TaskFilter,isMutating: null == isMutating ? _self.isMutating : isMutating // ignore: cast_nullable_to_non_nullable
as bool,actionError: freezed == actionError ? _self.actionError : actionError // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class TaskListFailed implements TaskListState {
  const TaskListFailed(this.failure);
  

 final  Failure failure;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskListFailedCopyWith<TaskListFailed> get copyWith => _$TaskListFailedCopyWithImpl<TaskListFailed>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskListFailed&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,failure);

@override
String toString() {
  return 'TaskListState.failed(failure: $failure)';
}


}

/// @nodoc
abstract mixin class $TaskListFailedCopyWith<$Res> implements $TaskListStateCopyWith<$Res> {
  factory $TaskListFailedCopyWith(TaskListFailed value, $Res Function(TaskListFailed) _then) = _$TaskListFailedCopyWithImpl;
@useResult
$Res call({
 Failure failure
});




}
/// @nodoc
class _$TaskListFailedCopyWithImpl<$Res>
    implements $TaskListFailedCopyWith<$Res> {
  _$TaskListFailedCopyWithImpl(this._self, this._then);

  final TaskListFailed _self;
  final $Res Function(TaskListFailed) _then;

/// Create a copy of TaskListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? failure = null,}) {
  return _then(TaskListFailed(
null == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure,
  ));
}


}

// dart format on
