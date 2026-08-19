-- translation-es-gold: a Spanish translation of Pokémon Gold.
--
-- Every table under lang/ is a catalog keyed by the English source:
--   dialogue      text.lua ids ("bank:addr")        -> mod.content.text:override
--   item_names    item ids (POTION)                 -> mod.content.items:patch
--   move_names    move ids (THUNDERBOLT)            -> mod.content.moves:patch
--   trainer_names trainer CLASS ids (YOUNGSTER)     -> mod.content.trainers:patch
--   dex_entries   species ids (ALAKAZAM)            -> data.gen2Pokedex
--   font/charmap  Spanish glyph page                -> mod.content.font
--
-- Gold's Pokédex (data.gen2Pokedex) has no content registry, so its entries
-- are patched directly on game.ready; the tables are taken by reference and
-- never copied, so mutating them lands before any menu reads them.
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
  counts.dialogue = each("dialogue", function(id, value)
    mod.content.text:override(id, value)
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

  -- ---- Pokédex (no content registry on Gold) -------------------------
  local dex = catalog("dex_entries")
  counts.dex = 0
  mod.events:on("game.ready", function(payload)
    local game = payload and payload.game or mod.game
    local entries = game and game.data and game.data.gen2Pokedex
      and game.data.gen2Pokedex.entries
    if not entries then
      mod.log:warn("gen2Pokedex.entries not found; dex entries not applied")
      return
    end
    for species, rec in pairs(dex) do
      local target = entries[species]
      if target then
        if rec.text then target.text = rec.text end
        if rec.text2 then target.text2 = rec.text2 end
        counts.dex = counts.dex + 1
      end
    end
  end)

  -- ---- Oak speech (no content registry; patched in place) --------------
  counts.oak = 0
  local oak = catalog("oak_speech")
  mod.events:on("game.ready", function(payload)
    local game = payload and payload.game or mod.game
    local texts = game and game.oakSpeechData and game.oakSpeechData.text
    if not texts then
      mod.log:warn("oakSpeechData.text not found; Oak speech not translated")
      return
    end
    for key, value in pairs(oak) do
      if type(value) == "string" and value ~= "" then
        texts[key] = value
        counts.oak = counts.oak + 1
      end
    end
  end)

  mod.events:on("game.ready", function()
    local total = 0
    for _, n in pairs(counts) do total = total + n end
    mod.log:info("Spanish (Gold): %d strings translated", total)
  end)
end
