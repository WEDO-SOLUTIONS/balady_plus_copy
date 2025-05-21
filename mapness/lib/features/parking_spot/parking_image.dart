import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mapness/app/auto_route/app_routes.dart';
import 'package:mapness/app/auto_route/app_routes.gr.dart';
import 'package:mapness/features/parking_spot/parking_manage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'parking_image.g.dart';

const maxImageResolution = 5000;
const maxImages = 10;
const maxSizeInBytes = 5 * 1024 * 1024; // 5MB

@riverpod
class _ParkingImage extends _$ParkingImage {
  @override
  List<XFile> build({bool isEdit = false}) {
    if (isEdit == false) {
      return stateOrNull ?? <XFile>[];
    }

    final data = ref.read(parkingManageProvider).valueOrNull;

    return data?.imagesPaths.map((e) => XFile(e)).toList() ?? <XFile>[];
  }

  Future<void> onAddImages() async {
    final picked = await ref.read(appRouterProvider).push<List<XFile>>(
          const AddPhotoRoute(),
        );

    if (picked != null) {
      final filtered = await _filterValidImages(picked);
      state = state + filtered;
    }
  }

  void removeImage(XFile file) {
    state = List.of(state)..remove(file);
  }

  Future<List<XFile>> _filterValidImages(List<XFile> images) async {
    final int limit = maxImages - state.length;
    final filtered = <XFile>[];

    for (final image in images) {
      if (filtered.length >= limit) {
        break;
      }

      final isValid = await _isValidImage(image.path);
      if (isValid) {
        filtered.add(image);
      }
    }

    return filtered;
  }

  Future<bool> _isValidImage(String path) async {
    final file = File(path);
    final size = await file.length();
    if (size > maxSizeInBytes) {
      return false;
    }

    final dim = await _getImageDimensions(path);
    return dim.width <= maxImageResolution && dim.height <= maxImageResolution;
  }

  Future<Size> _getImageDimensions(String path) {
    final completer = Completer<Size>();
    final image = Image.file(File(path));
    image.image.resolve(const ImageConfiguration()).addListener(
      ImageStreamListener((imageInfo, _) {
        final img = imageInfo.image;
        completer.complete(Size(img.width.toDouble(), img.height.toDouble()));
      }),
    );
    return completer.future;
  }
}

const parkingImageProvider = _parkingImageProvider;
