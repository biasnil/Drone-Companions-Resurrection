@wrapMethod(CyberdeckTooltip)
protected final func UpdateDescription(const description: script_ref<String>) -> Void {
  if Equals(Deref(description), "LocKey#49555") {
    inkWidgetRef.SetVisible(this.m_descriptionContainer, false);
    return;
  };

  wrappedMethod(description);
}
