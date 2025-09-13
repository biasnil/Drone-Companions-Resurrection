DCO = { description = "DCO" }

function DCO:new()
  addToList("DroneActions.TargetUnreachableRepositionActivationCondition_inline0.AND", "DCO.RepositionCond")
  addToList("DroneActions.WaitWhileTargetUnreachable_inline1.AND", "DCO.RepositionCond")
  addToList("DroneActions.CatchUpSharedVisibilityTargetUnreachable_inline8.AND", "DCO.RepositionCond")
  addToList("DroneActions.CatchUpSprintVisibility_inline6.AND", "DCO.RepositionCond")
end

return DCO:new()
