part of 'loader_bloc.dart';

abstract class LoaderEvent {}

class LoaderInitEvent extends LoaderEvent {}

class CheckPermissionEvent extends LoaderEvent {}// Added: By MG:

class LoaderGetLocalDataEvent extends LoaderEvent {}

class UpdateUserLocationEvent extends LoaderEvent {}


