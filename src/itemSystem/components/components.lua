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