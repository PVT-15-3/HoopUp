import 'package:flutter/material.dart';

class BasketballSlider extends StatefulWidget {
  final double min;
  final double max;
  final double value;
  final ValueChanged<double>? onChanged;

  const BasketballSlider({super.key, 
    required this.min,
    required this.max,
    required this.value,
    this.onChanged,
  });

  @override
  _BasketballSliderState createState() => _BasketballSliderState();
}

class _BasketballSliderState extends State<BasketballSlider> {
  double _currentValue = 0.0;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: _onPanDown,
      onPanUpdate: _onPanUpdate,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            height: 40,
            width: 220,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white,
            ),
          ),
          Container(
            height: 15,
            width: 320,
            color: const Color(0xFFEAEAEA),
          ),
          Positioned(
            left: _calculateSliderPosition() - 22,
            child: const Icon(
              Icons.sports_basketball_sharp,
              color: Colors.orange,
              size: 44,
            ),
          ),
        ],
      ),
    );
  }

  void _onPanDown(DragDownDetails details) {
    _updateSliderPosition(details.localPosition.dx);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _updateSliderPosition(details.localPosition.dx);
  }

  void _updateSliderPosition(double dx) {
    const sliderWidth = 320;
    final position = dx.clamp(0, sliderWidth);
    final percentage = position / sliderWidth;
    final range = widget.max - widget.min;

    final currentValue = (widget.min + (percentage * range)).roundToDouble();

    if (widget.onChanged != null) {
      setState(() {
        _currentValue = currentValue;
      });
      widget.onChanged!(currentValue);
    }
  }

  double _calculateSliderPosition() {
    const sliderWidth = 320;
    final range = widget.max - widget.min;
    final percentage = (_currentValue - widget.min) / range;

    return (sliderWidth) * percentage;
  }
}
