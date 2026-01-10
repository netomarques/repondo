// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ItemModel {
  String? get id;
  String get name;
  double get quantity;
  String get category;
  String get unit;
  String get addedBy;
  DateTime? get createdAt;
  DateTime? get updatedAt;

  /// Create a copy of ItemModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ItemModelCopyWith<ItemModel> get copyWith =>
      _$ItemModelCopyWithImpl<ItemModel>(this as ItemModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, category,
      unit, addedBy, createdAt, updatedAt);

  @override
  String toString() {
    return 'ItemModel(id: $id, name: $name, quantity: $quantity, category: $category, unit: $unit, addedBy: $addedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class $ItemModelCopyWith<$Res> {
  factory $ItemModelCopyWith(ItemModel value, $Res Function(ItemModel) _then) =
      _$ItemModelCopyWithImpl;
  @useResult
  $Res call(
      {String? id,
      String name,
      double quantity,
      String category,
      String unit,
      String addedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class _$ItemModelCopyWithImpl<$Res> implements $ItemModelCopyWith<$Res> {
  _$ItemModelCopyWithImpl(this._self, this._then);

  final ItemModel _self;
  final $Res Function(ItemModel) _then;

  /// Create a copy of ItemModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? quantity = null,
    Object? category = null,
    Object? unit = null,
    Object? addedBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_self.copyWith(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      addedBy: null == addedBy
          ? _self.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc

class _ItemModel extends ItemModel {
  const _ItemModel(
      {this.id,
      required this.name,
      required this.quantity,
      required this.category,
      required this.unit,
      required this.addedBy,
      this.createdAt,
      this.updatedAt})
      : super._();

  @override
  final String? id;
  @override
  final String name;
  @override
  final double quantity;
  @override
  final String category;
  @override
  final String unit;
  @override
  final String addedBy;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;

  /// Create a copy of ItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ItemModelCopyWith<_ItemModel> get copyWith =>
      __$ItemModelCopyWithImpl<_ItemModel>(this, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ItemModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.addedBy, addedBy) || other.addedBy == addedBy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, name, quantity, category,
      unit, addedBy, createdAt, updatedAt);

  @override
  String toString() {
    return 'ItemModel(id: $id, name: $name, quantity: $quantity, category: $category, unit: $unit, addedBy: $addedBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}

/// @nodoc
abstract mixin class _$ItemModelCopyWith<$Res>
    implements $ItemModelCopyWith<$Res> {
  factory _$ItemModelCopyWith(
          _ItemModel value, $Res Function(_ItemModel) _then) =
      __$ItemModelCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String? id,
      String name,
      double quantity,
      String category,
      String unit,
      String addedBy,
      DateTime? createdAt,
      DateTime? updatedAt});
}

/// @nodoc
class __$ItemModelCopyWithImpl<$Res> implements _$ItemModelCopyWith<$Res> {
  __$ItemModelCopyWithImpl(this._self, this._then);

  final _ItemModel _self;
  final $Res Function(_ItemModel) _then;

  /// Create a copy of ItemModel
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = freezed,
    Object? name = null,
    Object? quantity = null,
    Object? category = null,
    Object? unit = null,
    Object? addedBy = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(_ItemModel(
      id: freezed == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String?,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _self.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as double,
      category: null == category
          ? _self.category
          : category // ignore: cast_nullable_to_non_nullable
              as String,
      unit: null == unit
          ? _self.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String,
      addedBy: null == addedBy
          ? _self.addedBy
          : addedBy // ignore: cast_nullable_to_non_nullable
              as String,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      updatedAt: freezed == updatedAt
          ? _self.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
