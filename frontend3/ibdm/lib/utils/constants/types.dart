enum FutureState {
  success,
  error,
  loading,
}

class CheckboxState {
  final bool? value;

  const CheckboxState._(this.value);

  static const CheckboxState checked = CheckboxState._(true);
  static const CheckboxState unchecked = CheckboxState._(false);
  static const CheckboxState indeterminate = CheckboxState._(null);
}
