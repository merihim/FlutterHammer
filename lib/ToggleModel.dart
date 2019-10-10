import 'package:flutter/material.dart';

class ToggleModel{
  bool valueToChange;
  bool valueTinverseValueToChange;
  Widget widget;

  ToggleModel(bool valueToChange, bool valueTinverseValueToChange, Widget widget)
  {
    this.widget = widget;
    this.valueToChange = valueToChange;
    this.valueTinverseValueToChange = valueTinverseValueToChange;
  }
}