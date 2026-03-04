import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourRegion extends ConsumerStatefulWidget {
  const YourRegion({super.key});
  @override
  ConsumerState<YourRegion> createState() => _YourRegionState();
}

class _YourRegionState extends ConsumerState<YourRegion> {
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox();
  }
}
