--------------------------------------------------------------------------------
--- # SC entity events
-- Event setup for combinator placing, moving, removing etc.
--------------------------------------------------------------------------------

local entity = require("entity")
local sc_config = require("entity-config")

local this = {}

--- Run on every tick
function this.tick()
  if (combinators_listed) then return end
  entity.find_all()
end

--- Creation events
function this.create(ev)
  local sc
  if (ev.name == defines.events.on_built_entity or ev.name == defines.events.on_robot_built_entity) then
    sc = ev.created_entity
  elseif (ev.name == defines.events.on_entity_cloned) then
    sc = ev.destination
  else -- script_raised_built, script_raised_revive
    sc = ev.entity  
  end

  if not (sc and sc.name == SC_ENTITY_NAME) then return end
  entity.build(sc)
end

--- Rotation
function this.rotate(ev)
  if not (ev.entity and ev.entity.name == SC_ENTITY_NAME) then return end
  entity.rotate(ev.entity, game.get_player(ev.player_index))
end

--- Removal events
function this.destroy(event)
  local en = event.entity
  if not (en and en.name == SC_ENTITY_NAME) then return end

  entity.remove(en)
end

--- Chunk/surface removals
function this.purge_missing(ev)
  -- Deleting the combinator list will trigger its recreation on next tick,
  -- which will also remove any leftover configurations.
  global.all_combinators = nil
end

return this
