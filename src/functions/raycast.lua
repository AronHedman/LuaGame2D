local Raycast = { list = {} }
Raycast.__index = Raycast

----------
---add variable checkType (or something) to chenge between type of world:raycast() returns (-1, 0, 1, fraction)
Raycast.testDuration = 100 --change all instances after testing to a default value
Raycast.defRayAmount = 64  --Change to change base step count (amount in radians of pi/ rayAmount, so 64 = 32 rays per check)

function Raycast:new(source, angle, radius, dVec, duration, rayAmount)
    if not source.body then return end

    local len = math.sqrt(dVec.x ^ 2 + dVec.y ^ 2)
    if len == 0 then return end -- safety check

    local nx, ny = dVec.x / len, dVec.y / len
    local baseAngle = math.atan2(ny, nx)
    local startAngle = baseAngle - angle / 2
    local finishAngle = baseAngle + angle / 2

    local steps = math.ceil(angle / (pi / rayAmount))

    return setmetatable({
        source = source,
        sx = source.body:getX(),
        sy = source.body:getY(),
        radius = radius,
        angle = angle,
        startAngle = startAngle,
        endAngle = finishAngle,
        centerAngle = baseAngle,
        currentAngle = startAngle,
        duration = duration,
        elapsed = 0,
        totalSteps = steps,
        currentStep = 0,
        hits = {},
        active = true
    }, Raycast)
end

function Raycast:update(dt)
    self.sx, self.sy = self.source.body:getPosition()

    if not self.active then return end

    self.elapsed = self.elapsed + dt
    local t = self.elapsed / self.duration

    if self.angle < pi / 16 then
        self.currentAngle = self.centerAngle

        local dx, dy = math.cos(self.currentAngle), math.sin(self.currentAngle)
        local ex, ey = self.sx + dx * self.radius, self.sy + dy * self.radius

        world:rayCast(self.sx, self.sy, ex, ey, function(fixture, x, y, xn, yn, fraction)
            table.insert(self.hits, { fixture = fixture, x = x, y = y, nx = xn, ny = yn, fraction = fraction })
            return 1
        end)
    else
        local timePerStep = self.duration / self.totalSteps
        local targetStep = math.floor(self.elapsed / timePerStep)
        targetStep = math.min(targetStep, self.totalSteps - 1)

        if targetStep > self.currentStep then
            self.currentStep = targetStep

            local stepProgress = self.currentStep / (self.totalSteps - 1) -- 0→1
            self.currentAngle = self.startAngle + (self.endAngle - self.startAngle) * stepProgress

            local dx, dy = math.cos(self.currentAngle), math.sin(self.currentAngle)
            local ex, ey = self.sx + dx * self.radius, self.sy + dy * self.radius

            world:rayCast(self.sx, self.sy, ex, ey, function(fixture, x, y, xn, yn, fraction)
                table.insert(self.hits, { fixture = fixture, x = x, y = y, nx = xn, ny = yn, fraction = fraction })
                return 1
            end)
        end
    end
    if self.elapsed >= self.duration then
        self.active = false
    end
end

function Raycast:draw()
    local cdx, cdy = math.cos(self.centerAngle), math.sin(self.centerAngle)
    local cex, cey = self.sx + cdx * self.radius, self.sy + cdy * self.radius
    g.setColor(0, 1, 0, 0.5) -- Green semi-transparent for center/dVec
    g.line(self.sx, self.sy, cex, cey)

    local dx, dy = math.cos(self.currentAngle), math.sin(self.currentAngle)
    local ex, ey = self.sx + dx * self.radius, self.sy + dy * self.radius
    g.setColor(1, 1, 1, 1)
    g.line(self.sx, self.sy, ex, ey)
    g.setColor(1, 0, 0, 0.5)
    g.line(self.sx, self.sy, ex, ey)
    g.setColor(1, 1, 1, 1)
end

-------------------
---Raycast helper functions

function Raycast:raycast(angle, radius, dVec, duration, rayAmount)
    local sx, sy = self.body:getPosition()
    local mx, my = cam:mousePosition()

    local angle = angle or math.pi / 4                -- Default to 45 degrees
    local radius = radius or 100                      -- Default radius
    local duration = duration or Raycast.testDuration --Change to change speed of sweep
    local rayAmount = rayAmount or Raycast.defRayAmount or 32

    dVec = dVec or { x = mx - sx, y = my - sy }

    if not self.raycaster then
        self.raycaster = Raycast:new(self, angle, radius, dVec, duration, rayAmount)
        table.insert(Raycast.list, self.raycaster)
    else
        if not self.raycaster.active then
            self.raycaster.angle = angle or self.raycaster.angle
            self.raycaster.radius = radius or 100                      -- Default radius
            self.raycaster.duration = duration or Raycast.testDuration -- Default duration of 1 second

            local len = math.sqrt(dVec.x ^ 2 + dVec.y ^ 2)
            local nx, ny = dVec.x / len, dVec.y / len
            local baseAngle = math.atan2(ny, nx)
            local startAngle = baseAngle - angle / 2
            local finishAngle = baseAngle + angle / 2

            self.raycaster.startAngle = startAngle
            self.raycaster.endAngle = finishAngle
            self.raycaster.centerAngle = baseAngle
            self.raycaster.currentAngle = startAngle

            self.raycaster.totalSteps = math.ceil((angle or self.raycaster.angle) / (pi / rayAmount))
            self.raycaster.currentStep = 0

            self.raycaster.active = true
            self.raycaster.elapsed = 0
            self.raycaster.hits = {}
            table.insert(Raycast.list, self.raycaster)
        end
    end
end

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

return Raycast
