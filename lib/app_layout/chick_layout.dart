import 'package:chick_game_prototype/widgets/progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChickLayout extends StatefulWidget {
  final Widget? child;
  final bool showProgressBar;
  final double progress;
  final int chickShow;

  const ChickLayout({
    super.key,
    this.child,
    this.showProgressBar = false,
    this.progress = 0,
    required this.chickShow,
  });

  @override
  State<ChickLayout> createState() => _ChickLayoutState();
}

class _ChickLayoutState extends State<ChickLayout> {
  Future<void>? _precacheFuture;
  bool _assetsReady = false; // Не показуємо сцену, доки картинки не закешовано.

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _startPrecaching();
  }

  @override
  void didUpdateWidget(covariant ChickLayout oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.chickShow != widget.chickShow) {
      _assetsReady = false;
      _precacheFuture = null;
      _startPrecaching();
    }
  }

  void _startPrecaching() {
    if (_precacheFuture != null) return;
    // Попередньо підвантажуємо фон і курку, аби уникнути мерехтіння.
    _precacheFuture = _precacheAssets().then((_) {
      if (mounted) {
        setState(() {
          _assetsReady = true;
        });
      }
    });
  }

  Future<void> _precacheAssets() async {
    final futures = <Future<void>>[
      precacheImage(
        const AssetImage('assets/background_webp/loading_bg.webp'),
        context,
      ),
    ];
    final chickAsset = _chickAssetPath(widget.chickShow);
    if (chickAsset != null) {
      // Підвантажуємо саме ту курку, яку треба показати на цьому екрані.
      futures.add(precacheImage(AssetImage(chickAsset), context));
    }

    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = 1.sw;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned.fill(
              child: Image.asset(
                'assets/background_webp/loading_bg.webp',
                fit: BoxFit.cover,
                cacheWidth: screenWidth.toInt(),
                filterQuality: FilterQuality.low,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: screenWidth * 0.22,
                  left: screenWidth * 0.13,
                  right: screenWidth * 0.013,
                ),
                child: Transform.translate(
                  offset: const Offset(-10, 0),
                  child: _buildChickImage(screenWidth),
                ),
              ),
            ),
            if (widget.child != null) widget.child!,
            if (widget.showProgressBar)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: screenWidth * 0.12),
                  child: ProgressBarWithPercent(progress: widget.progress),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildChickImage(double screenWidth) {
    final chickAsset = _chickAssetPath(widget.chickShow);
    if (chickAsset == null) {
      return const SizedBox.shrink();
    }

    final widthFactor = widget.chickShow == 1 ? 0.8 : 1.0;

    return Image.asset(
      chickAsset,
      width: screenWidth * widthFactor,
      cacheWidth: (screenWidth * widthFactor).toInt(),
      filterQuality: FilterQuality.low,
    );
  }

  String? _chickAssetPath(int chickShow) {
    switch (chickShow) {
      case 1:
        return 'assets/chick_webp/chick.webp';
      case 2:
        return 'assets/chick_webp/little_chick.webp';
      default:
        return null;
    }
  }
}
