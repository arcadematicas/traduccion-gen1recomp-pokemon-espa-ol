-- translation-es-goldsilver v0.1.0: traduccion espanola completa de Pokemon Gold y Silver.
--
-- Detects the running version and applies the appropriate dialogue layer.
-- Shared catalogs (items, moves, dex, etc.) are identical between Gold and Silver.
return function(mod)
  local function catalog(name)
    local rel = "lang/" .. name .. ".lua"
    local body = mod:read(rel)
    if not body then return {} end
    local chunk, err = loadstring(body, rel)
    if not chunk then
      mod.log:warn("%s has a syntax error: %s", rel, tostring(err))
      return {}
    end
    local ok, table_ = pcall(chunk)
    if not ok or type(table_) ~= "table" then
      mod.log:warn("%s did not return a table: %s", rel, tostring(table_))
      return {}
    end
    return table_
  end

  local function each(name, apply)
    local n = 0
    for key, value in pairs(catalog(name)) do
      if type(value) == "string" and value ~= "" then
        apply(key, value)
        n = n + 1
      end
    end
    return n
  end

  -- ---- glyphs -------------------------------------------------------
  for id, page in pairs(catalog("font")) do
    if type(page) == "table" and type(page.image) == "string"
        and mod:read(page.image) then
      page.image = mod.assets:path(page.image)
    end
    mod.content.font:register(id, page)
  end
  for seq, code in pairs(catalog("charmap")) do
    mod.content.font:register("charmap:" .. seq, { seq = seq, code = code })
  end

  -- ---- text / names -------------------------------------------------
  local counts = {}
  
  -- Shared catalogs (same for Gold and Silver)
  counts.strings = each("strings", function(source, value)
    mod.content.strings:override(source, value)
  end)
  counts.items = each("item_names", function(id, value)
    mod.content.items:patch(id, { name = value })
  end)
  counts.moves = each("move_names", function(id, value)
    mod.content.moves:patch(id, { name = value })
  end)
  counts.trainers = each("trainer_names", function(id, value)
    mod.content.trainers:patch(id, { name = value })
  end)
  counts.statuses = each("status_labels", function(id, value)
    mod.content.statuses:patch(id, { label = value })
  end)

  -- ---- Gen 2-only registries ----------------------------------------
  counts.radio = each("radio_channels", function(id, value)
    mod.content.radio_channels:patch(id, { name = value })
  end)
  counts.landmarks = each("landmarks", function(id, value)
    mod.content.landmarks:patch(id, { name = value })
  end)
  counts.decorations = each("decorations", function(id, value)
    mod.content.decorations:patch(id, { name = value })
  end)

  -- ---- Version-specific dialogue ------------------------------------
  local GameVersion = require("src.core.GameVersion")
  local isGold = GameVersion.isGold()
  local dialogueLayer = isGold and "gold_dialogue" or "silver_dialogue"
  
  counts.dialogue = each(dialogueLayer, function(id, value)
    mod.content.text:override(id, value)
  end)

  -- ---- naming screen ------------------------------------------------
  local grid = catalog("naming")
  if grid.upper then
    mod.hooks:wrap("ui.naming.grid", function(next, base, ctx)
      local want = ctx.lower and grid.lower or grid.upper
      return want or base
    end)
  end

  mod.events:on("game.ready", function()
    local total = 0
    for _, n in pairs(counts) do total = total + n end
    local version = isGold and "Gold" or "Silver"
    mod.log:info("Spanish (%s v0.1.0): %d strings translated", version, total)
  end)
end
