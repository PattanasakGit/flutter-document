// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'authenticated_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthenticatedUser {

 String get id; String get email; String get displayName;
/// Create a copy of AuthenticatedUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthenticatedUserCopyWith<AuthenticatedUser> get copyWith => _$AuthenticatedUserCopyWithImpl<AuthenticatedUser>(this as AuthenticatedUser, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthenticatedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,displayName);

@override
String toString() {
  return 'AuthenticatedUser(id: $id, email: $email, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class $AuthenticatedUserCopyWith<$Res>  {
  factory $AuthenticatedUserCopyWith(AuthenticatedUser value, $Res Function(AuthenticatedUser) _then) = _$AuthenticatedUserCopyWithImpl;
@useResult
$Res call({
 String id, String email, String displayName
});




}
/// @nodoc
class _$AuthenticatedUserCopyWithImpl<$Res>
    implements $AuthenticatedUserCopyWith<$Res> {
  _$AuthenticatedUserCopyWithImpl(this._self, this._then);

  final AuthenticatedUser _self;
  final $Res Function(AuthenticatedUser) _then;

/// Create a copy of AuthenticatedUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = null,Object? displayName = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthenticatedUser].
extension AuthenticatedUserPatterns on AuthenticatedUser {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthenticatedUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthenticatedUser() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthenticatedUser value)  $default,){
final _that = this;
switch (_that) {
case _AuthenticatedUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthenticatedUser value)?  $default,){
final _that = this;
switch (_that) {
case _AuthenticatedUser() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String email,  String displayName)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthenticatedUser() when $default != null:
return $default(_that.id,_that.email,_that.displayName);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String email,  String displayName)  $default,) {final _that = this;
switch (_that) {
case _AuthenticatedUser():
return $default(_that.id,_that.email,_that.displayName);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String email,  String displayName)?  $default,) {final _that = this;
switch (_that) {
case _AuthenticatedUser() when $default != null:
return $default(_that.id,_that.email,_that.displayName);case _:
  return null;

}
}

}

/// @nodoc


class _AuthenticatedUser implements AuthenticatedUser {
  const _AuthenticatedUser({required this.id, required this.email, required this.displayName});
  

@override final  String id;
@override final  String email;
@override final  String displayName;

/// Create a copy of AuthenticatedUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthenticatedUserCopyWith<_AuthenticatedUser> get copyWith => __$AuthenticatedUserCopyWithImpl<_AuthenticatedUser>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthenticatedUser&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.displayName, displayName) || other.displayName == displayName));
}


@override
int get hashCode => Object.hash(runtimeType,id,email,displayName);

@override
String toString() {
  return 'AuthenticatedUser(id: $id, email: $email, displayName: $displayName)';
}


}

/// @nodoc
abstract mixin class _$AuthenticatedUserCopyWith<$Res> implements $AuthenticatedUserCopyWith<$Res> {
  factory _$AuthenticatedUserCopyWith(_AuthenticatedUser value, $Res Function(_AuthenticatedUser) _then) = __$AuthenticatedUserCopyWithImpl;
@override @useResult
$Res call({
 String id, String email, String displayName
});




}
/// @nodoc
class __$AuthenticatedUserCopyWithImpl<$Res>
    implements _$AuthenticatedUserCopyWith<$Res> {
  __$AuthenticatedUserCopyWithImpl(this._self, this._then);

  final _AuthenticatedUser _self;
  final $Res Function(_AuthenticatedUser) _then;

/// Create a copy of AuthenticatedUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = null,Object? displayName = null,}) {
  return _then(_AuthenticatedUser(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,displayName: null == displayName ? _self.displayName : displayName // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
