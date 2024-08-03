import 'package:flutter/material.dart';

import '../entities/near_by_place.dart';

class NearbyPlaceItem extends StatelessWidget {
  final NearbyPlace nearbyPlace;
  final VoidCallback onTap;

  const NearbyPlaceItem(this.nearbyPlace, this.onTap, {super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: <Widget>[
              Image.network(nearbyPlace.icon!, width: 16),
              const SizedBox(width: 24),
              Expanded(
                  child: Text("${nearbyPlace.name}",
                      style: const TextStyle(fontSize: 16)))
            ],
          ),
        ),
      ),
    );
  }
}
