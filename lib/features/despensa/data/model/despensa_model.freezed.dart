// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'despensa_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$DespensaModel {
  String get id;
  String get name;
  String get inviteCode;
  List<String> get adminIds;
  List<String> get memberIds;
  DateTime get createdAt;
  DateTime get updatedAt;

  /// Create a copy of DespensaModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DespensaModelCopyWith<DespensaModel> get copyWith =>
      _$DespensaModelCopyWithImpl<DespensaModel>(
          this as DespensaModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DespensaModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            const DeepCollectionEquality().equals(other.adminIds, adminIds) &&
            const DeepCollectionEquality().equals(other.memberIds, memberIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      inviteCode,
      const DeepCollectionEquality().hash(adminIds),
      const DeepCollectionEquality().hash(memberIds),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'DespensaModel(id: $id, name: $name, inviteCode: $inviteCode, adminIds: $adminIds, memberIds: $memberIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $DespensaModelCopyWith<$Res> {
  factory $DespensaModelCopyWith(
          DespensaModel value, $Res Function(DespensaModel) _then) =
      _$DespensaModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      String inviteCode,
      List<String> adminIds,
      List<String> memberIds,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class _$DespensaModelCopyWithImpl<$Res>
    implements $DespensaModelCopyWith<$Res> {
  _$DespensaModelCopyWithImpl(this._self, this._then);

  final DespensaModel _self;
  final $Res Function(DespensaModel) _then;

  /// Create a copy of DespensaModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = null,
    Object? adminIds = null,
    Object? memberIds = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      adminIds: null == adminIds
          ? _self.adminIds
          : adminIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memberIds: null == memberIds
          ? _self.memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc

class _DespensaModel extends DespensaModel {
  const _DespensaModel(
      {required this.id,
      required this.name,
      required this.inviteCode,
      required final List<String> adminIds,
      required final List<String> memberIds,
      required this.createdAt,
      required this.updatedAt})
      : _adminIds = adminIds,
        _memberIds = memberIds,
        super._();

  @override
  final String id;
  @override
  final String name;
  @override
  final String inviteCode;
  final List<String> _adminIds;
  @override
  List<String> get adminIds {
    if (_adminIds is EqualUnmodifiableListView) return _adminIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adminIds);
  }

  final List<String> _memberIds;
  @override
  List<String> get memberIds {
    if (_memberIds is EqualUnmodifiableListView) return _memberIds;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_memberIds);
  }

  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;

  /// Create a copy of DespensaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DespensaModelCopyWith<_DespensaModel> get copyWith =>
      __$DespensaModelCopyWithImpl<_DespensaModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DespensaModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.inviteCode, inviteCode) ||
                other.inviteCode == inviteCode) &&
            const DeepCollectionEquality().equals(other._adminIds, _adminIds) &&
            const DeepCollectionEquality()
                .equals(other._memberIds, _memberIds) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      name,
      inviteCode,
      const DeepCollectionEquality().hash(_adminIds),
      const DeepCollectionEquality().hash(_memberIds),
      createdAt,
      updatedAt);

  @override
  String toString() {
    return 'DespensaModel(id: $id, name: $name, inviteCode: $inviteCode, adminIds: $adminIds, memberIds: $memberIds, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$DespensaModelCopyWith<$Res>
    implements $DespensaModelCopyWith<$Res> {
  factory _$DespensaModelCopyWith(
          _DespensaModel value, $Res Function(_DespensaModel) _then) =
      __$DespensaModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String name,
      String inviteCode,
      List<String> adminIds,
      List<String> memberIds,
      DateTime createdAt,
      DateTime updatedAt});
}

/// @nodoc
class __$DespensaModelCopyWithImpl<$Res>
    implements _$DespensaModelCopyWith<$Res> {
  __$DespensaModelCopyWithImpl(this._self, this._then);

  final _DespensaModel _self;
  final $Res Function(_DespensaModel) _then;

  /// Create a copy of DespensaModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? inviteCode = null,
    Object? adminIds = null,
    Object? memberIds = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_DespensaModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      inviteCode: null == inviteCode
          ? _self.inviteCode
          : inviteCode // ignore: cast_nullable_to_non_nullable
              as String,
      adminIds: null == adminIds
          ? _self._adminIds
          : adminIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      memberIds: null == memberIds
          ? _self._memberIds
          : memberIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

// dart format on
