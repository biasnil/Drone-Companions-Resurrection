public static func DCO_IsRobot(obj: wref<GameObject>) -> Bool {
  if !IsDefined(obj) { return false; }
  let puppet = obj as ScriptedPuppet;
  if puppet == null { return false; }

  let recId: TweakDBID = puppet.GetRecordID();
  let rec = TweakDBInterface.GetCharacterRecord(recId);
  return IsDefined(rec) && rec.TagsContains(n"Robot");
}
