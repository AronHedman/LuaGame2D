local Raycast = { list = {} }
Raycast.__index = Raycast

Raycast.testDuration = 100
Raycast.defRayAmount = 64

-- Constructor
function Raycast:new(source, angle, radius, dVec, duration, rayAmount, onHit)
    if not source.body then return nil end

    local len = math.sqrt(dVec.x * dVec.x + dVec.y * dVec.y)
    if len == 0 then return nil end

    local nx, ny      = dVec.x / len, dVec.y / len
    local baseAngle   = math.atan2(ny, nx)
    local startAngle  = baseAngle - angle / 2
    local finishAngle = baseAngle + angle / 2
    local steps       = math.ceil(angle / (pi / rayAmount))

    local obj         = setmetatable({}, Raycast)

    obj.source        = source
    obj.sx, obj.sy    = source.body:getPosition()
    obj.radius        = radius
    obj.angle         = angle
    obj.startAngle    = startAngle
    obj.endAngle      = finishAngle
    obj.centerAngle   = baseAngle
    obj.currentAngle  = startAngle

    obj.duration      = duration
    obj.elapsed       = 0

    obj.totalSteps    = steps
    obj.currentStep   = 0

    obj.onHit         = onHit
    obj.hits          = {}
    obj.hitSet        = {}
    obj.active        = true

    return obj
end

function Raycast:update(dt)
    self.sx, self.sy = self.source.body:getPosition()
    if not self.active then return end

    self.elapsed = self.elapsed + dt

    -- small-angle mode (straight ray)
    if self.angle < pi / 16 then
        self.currentAngle = self.centerAngle

        local dx, dy = math.cos(self.currentAngle), math.sin(self.currentAngle)
        local ex, ey = self.sx + dx * self.radius, self.sy + dy * self.radius

        world:rayCast(self.sx, self.sy, ex, ey, function(fix, x, y, xn, yn, fraction)
            local hit = {
                fixture = fix,
                data = fix:getUserData(),
                x = x,
                y = y,
                rl = self.currentStep / self.totalSteps, -- relative to center ray, greater than .5 is to the right of center
                dx = x - self.sx,
                dy = y - self.sy,
                nx = xn,
                ny = yn,
                fraction = fraction
            }

            local id = fix -- or fix:getUserData() if unique
            if not self.hitSet[id] then
                self.hitSet[id] = true
                table.insert(self.hits, hit)
                if self.onHit then self.onHit(hit) end
            end
            return 1
        end)
    else
        local timePerStep = self.duration / self.totalSteps
        local targetStep = math.floor(self.elapsed / timePerStep)
        targetStep = math.min(targetStep, self.totalSteps - 1)

        if targetStep > self.currentStep then
            self.currentStep = targetStep

            local t = self.currentStep / (self.totalSteps - 1)
            self.currentAngle = self.startAngle + (self.endAngle - self.startAngle) * t

            local dx, dy = math.cos(self.currentAngle), math.sin(self.currentAngle)
            local ex, ey = self.sx + dx * self.radius, self.sy + dy * self.radius

            world:rayCast(self.sx, self.sy, ex, ey, function(fix, x, y, xn, yn, fraction)
                local hit = {
                    fixture = fix,
                    data = fix:getUserData(),
                    x = x,
                    y = y,
                    rl = self.currentStep / self.totalSteps, -- relative to center ray, greater than .5 is to the right of center
                    dx = x - self.sx,
                    dy = y - self.sy,
                    nx = xn,
                    ny = yn,
                    fraction = fraction
                }

                local id = fix -- or fix:getUserData() if unique
                if not self.hitSet[id] then
                    self.hitSet[id] = true
                    table.insert(self.hits, hit)
                    if self.onHit then self.onHit(hit) end
                end

                return 1
            end)
        end
    end

    if self.elapsed >= self.duration then
        self.active = false
    end
end

function Raycast:draw()
    -- center ray
    local cdx, cdy = math.cos(self.centerAngle), math.sin(self.centerAngle)
    local cex, cey = self.sx + cdx * self.radius, self.sy + cdy * self.radius
    g.setColor(0, 1, 0, 0.5)
    g.line(self.sx, self.sy, cex, cey)

    -- active ray
    local dx, dy = math.cos(self.currentAngle), math.sin(self.currentAngle)
    local ex, ey = self.sx + dx * self.radius, self.sy + dy * self.radius
    g.setColor(1, 1, 1)
    g.line(self.sx, self.sy, ex, ey)
    g.setColor(1, 0, 0, 0.5)
    g.line(self.sx, self.sy, ex, ey)
    g.setColor(1, 1, 1)
end

-----------------------------

function Raycast:raycast(angle, radius, dVec, duration, rayAmount, onHit)
    local sx, sy = self.body:getPosition()
    local mx, my = cam:mousePosition()

    angle        = angle or pi / 4
    radius       = radius or 100
    duration     = duration or Raycast.testDuration
    rayAmount    = rayAmount or Raycast.defRayAmount
    dVec         = dVec or { x = mx - sx, y = my - sy }

    if not self.raycaster then
        self.raycaster = Raycast:new(self, angle, radius, dVec, duration, rayAmount, onHit)
        if self.raycaster then
            table.insert(Raycast.list, self.raycaster)
        end
        return
    end

    if not self.raycaster.active then
        local len = math.sqrt(dVec.x * dVec.x + dVec.y * dVec.y)
        if len == 0 then return end

        local nx, ny      = dVec.x / len, dVec.y / len
        local baseAngle   = math.atan2(ny, nx)
        local startAngle  = baseAngle - angle / 2
        local finishAngle = baseAngle + angle / 2
        local steps       = math.ceil(angle / (pi / rayAmount))

        local rc          = self.raycaster

        rc.angle          = angle
        rc.radius         = radius
        rc.duration       = duration

        rc.startAngle     = startAngle
        rc.endAngle       = finishAngle
        rc.centerAngle    = baseAngle
        rc.currentAngle   = startAngle

        rc.totalSteps     = steps
        rc.currentStep    = 0

        rc.elapsed        = 0
        rc.onHit          = onHit
        rc.hits           = {}
        rc.hitSet         = {}
        rc.active         = true

        table.insert(Raycast.list, rc)
    end
end

function Raycast:hasLOS(goalX, goalY) --Add parameter for ignoring certein stuff

end

-----------------------------

function Raycast.updateRaycasters(dt)
    for i = #Raycast.list, 1, -1 do
        local rc = Raycast.list[i]
        rc:update(dt)
        if not rc.active then
            table.remove(Raycast.list, i)
        end
    end
end

function Raycast.drawRaycasters()
    if not debugMode then return end
    for _, rc in ipairs(Raycast.list) do
        rc:draw()
    end
end

function Raycast:getHits() -- Use to retrive information on all hits in a scan instead of just executing the onHit function
    return self.hits
end

return Raycast
