// ignore_for_file: library_private_types_in_public_api

import 'package:attendify_lite/app/shared/widgets/decoration.dart';
import 'package:attendify_lite/core/utils/widgets/custom_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustDropDown<T> extends StatefulWidget {
  final List<CustDropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String hintText;
  final double borderRadius;
  final double maxListHeight;
  final double overlayWidth;
  final double borderWidth;
  final double margin;
  final int defaultSelectedIndex;
  final bool enabled;
  final String Function(T) displayStringForItem;

  const CustDropDown({
    required this.items,
    required this.onChanged,
    required this.displayStringForItem,
    this.hintText = "",
    this.borderRadius = 20,
    this.borderWidth = 1,
    this.maxListHeight = 150,
    this.overlayWidth = 335,
    this.defaultSelectedIndex = -1,
    super.key,
    this.enabled = true,
    this.margin = 8.0,
  });

  @override
  _CustDropDownState<T> createState() => _CustDropDownState<T>();
}

class _CustDropDownState<T> extends State<CustDropDown<T>>
    with WidgetsBindingObserver {
  final controller = TextEditingController();
  bool _isOpen = false, _isReverse = false;
  late OverlayEntry _overlayEntry;
  T? _itemSelected;
  late Offset dropDownOffset;
  final LayerLink _layerLink = LayerLink();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          dropDownOffset = getOffset();
        });
      }
      if (widget.defaultSelectedIndex > -1) {
        if (widget.defaultSelectedIndex < widget.items.length) {
          if (mounted) {
            setState(() {
              _itemSelected = widget.items[widget.defaultSelectedIndex].value;
              controller.text = widget.displayStringForItem(_itemSelected as T);
              widget.onChanged(widget.items[widget.defaultSelectedIndex].value);
            });
          }
        }
      }
    });
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  void _addOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = true;
      });
    }

    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry);
  }

  void _removeOverlay() {
    if (mounted) {
      setState(() {
        _isOpen = false;
      });
      _overlayEntry.remove();
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    controller.dispose();
    super.dispose();
  }

  OverlayEntry _createOverlayEntry() {
    dropDownOffset = getOffset();

    return OverlayEntry(
      maintainState: false,
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: () {
              _removeOverlay();
            },
            child: Container(
              color: Colors.transparent,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
          ),
          CompositedTransformFollower(
            link: _layerLink,
            showWhenUnlinked: false,
            offset: dropDownOffset,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              height: widget.maxListHeight,
              width: widget.overlayWidth,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: _isReverse
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(
                        maxHeight: widget.maxListHeight,
                        maxWidth: widget.overlayWidth),
                    decoration: dropShadowDecoration(context),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(widget.borderRadius),
                      ),
                      child: Material(
                        elevation: 10,
                        child: ListView(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.r, vertical: 10.r),
                          shrinkWrap: true,
                          children: widget.items
                              .map((item) => GestureDetector(
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.all(widget.margin.r),
                                      child: item.child,
                                    ),
                                    onTap: () {
                                      if (mounted) {
                                        setState(() {
                                          _itemSelected = item.value;
                                          controller.text = widget
                                              .displayStringForItem(item.value);
                                          _removeOverlay();
                                          widget.onChanged(item.value);
                                        });
                                      }
                                    },
                                  ))
                              .toList(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Offset getOffset() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    double y = renderBox.localToGlobal(Offset.zero).dy;
    double spaceAvailable = _getAvailableSpace(y + renderBox.size.height);
    if (spaceAvailable > widget.maxListHeight) {
      _isReverse = false;
      return Offset(0, renderBox.size.height + 2);
    } else {
      _isReverse = true;
      return Offset(
          0,
          renderBox.size.height -
              (widget.maxListHeight + renderBox.size.height + 2));
    }
  }

  double _getAvailableSpace(double offsetY) {
    double safePaddingTop = MediaQuery.of(context).padding.top;
    double safePaddingBottom = MediaQuery.of(context).padding.bottom;

    double screenHeight =
        MediaQuery.of(context).size.height - safePaddingBottom - safePaddingTop;

    return screenHeight - offsetY;
  }

  @override
  Widget build(BuildContext buildContext) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: CustomTextFormField(
        onTap: () {
          if (widget.enabled) {
            if (_isOpen) {
              _removeOverlay();
            } else {
              _addOverlay();
            }
          }
        },
        hintText: widget.hintText,
        labelText: widget.hintText,
        maxLines: 1,
        controller: controller,
        readOnly: true,
        suffixIcon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          size: 24,
          color: Color(0xff666666),
        ),
      ),
    );
  }
}

class CustDropdownMenuItem<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const CustDropdownMenuItem({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
