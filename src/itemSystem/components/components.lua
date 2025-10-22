durabilityComponent = {

  onUse = function(self, user)
    self.data.durability = self.data.durability - 1

    if self.data.durability <= 0 then
      -- fire onBreak event so other components can react
      self:call("onBreak", user)
    end
  end,

  onBreak = function(self, user)
    --Add inventory logic, delete or broken
  end
}

axeComponent = {

  onUse = function(self, user, target)
    --Check if target is a tree
    if target.type == "tree" then
      --Chop the tree

      --Reduce durability
      self:call("onUse", user)
    end
  end
}

meleeComponent = {

  onUse = function(self, user, target)
    --Check if target is an enemy
    if target.type == "enemy" then
      --Deal damage to enemy

      --Reduce durability
      self:call("onUse", user)
    end
  end
}
