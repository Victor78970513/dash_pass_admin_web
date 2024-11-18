import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapCubit extends Cubit<LatLng> {
  MapCubit() : super(const LatLng(-16.52356, -68.172563));

  void changeLatLng(LatLng value) {
    emit(value);
  }
}
