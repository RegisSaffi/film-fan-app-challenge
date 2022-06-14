import 'package:flutter/material.dart';

class Character{

  String name;
  String character;
  String? profilePath;
  int id;

  Character({required this.name, required this.character, this.profilePath, required this.id});

  factory Character.fromJson(Map<String,dynamic> json)=>Character(
    name:json['name'],
    id:json['id'],
    character:json['character'],
    profilePath:json['profile_path']
  );
}