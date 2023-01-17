local Vector = require 'brinevector'

local Vehicle = {}
Vehicle.__index = Vehicle

function Vehicle:new(args)
    local inst = setmetatable(args or {}, Vehicle)
    inst:init()
    return inst
end

function Vehicle:init()
    self.position = self.position or { x = 0, y = 0 }
    self.velocity = self.velocity or { x = 0, y = 0 }
    self.acceleration = self.velocity or { x = 0, y = 0 }

    self.mass = self.mass or 1
    self.max_speed = self.max_speed or 500
    self.max_force = self.max_force or 1

    self.position = Vector(self.position.x, self.position.y)
    self.velocity = Vector(self.velocity.x, self.velocity.y)
    self.acceleration = Vector(self.acceleration.x, self.acceleration.y)

    --self.max_align_force = self.max_al
end

function Vehicle:update(dt)
    self.velocity = self.velocity + self.acceleration
    self.velocity = self.velocity:trim(self.max_speed)
    self.position = self.position + self.velocity * dt
    self.acceleration = self.acceleration * 0
end

function Vehicle:applyForce(force)
    local f = Vector(force.x, force.y)
    self.acceleration = self.acceleration + f/self.mass
end

function Vehicle:seek(target)
    local desired = Vector(target.x, target.y) - self.position
    desired = desired.normalized * self.max_speed
    
    local steer = desired - self.velocity
    steer = steer:trim(self.max_force)
    self:applyForce(steer)
    return steer
end

function Vehicle:persue(target)
    
end

function Vehicle:flee(target)
    local desired = Vector(target.x, target.y) - self.position
    desired = -1 * (desired.normalized * self.max_speed)
    
    local steer = desired - self.velocity
    steer = steer:trim(self.max_force)
    self:applyForce(steer)
    return steer
end

function Vehicle:arrive(target, radius, map)
    local desired = Vector(target.x, target.y) - self.position
    local distance = desired.length
    if distance < radius then
        desired = desired.normalized * self.max_speed * distance/radius
    else
        desired = desired.normalized * self.max_speed
    end

    local steer = desired - self.velocity
    steer = steer:trim(self.max_force)
    self:applyForce(steer)
    return steer
end

function Vehicle:separate(vehicles, radius)
    local radius = 100 or radius
    local sum = Vector(0, 0)
    local count = 0

    for _, other in ipairs(vehicles) do
        local desired = other.position - self.position
        local distance = desired.length

        if distance < radius then
            desired = desired.normalized / distance
            sum = sum + desired
            count = count + 1
        end
    end

    local steer = sum - self.velocity
    steer = steer:trim(self.max_force)
    self:applyForce(steer)
    return steer
end

function Vehicle:align(boids)
    
end


function Vehicle:coordinate(boids)
    
end


return Vehicle