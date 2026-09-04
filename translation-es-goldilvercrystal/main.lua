-- translation-es-goldilvercrystal v0.1.0: traducción al español de Pokemon Gold, Silver y Crystal.
--
-- Detects the running version and applies the appropriate dialogue layer.
-- Shared catalogs (items, moves, dex, engine strings, etc.) are identical
-- across Gold, Silver and Crystal (Gen 2).  Dialogue is version-specific
-- because each game's ROM stores it at different offsets.
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

  -- Shared catalogs (same for Gold, Silver and Crystal)
  counts.strings = each("strings", function(source, value)
    mod.content.strings:override(source, value)
  end)
  counts.species = each("species_names", function(id, value)
    mod.content.pokemon:patch(id, { name = value })
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
  local vid = GameVersion.get()
  local versionName
  local dialogueLayer
  if vid == "gold" then
    dialogueLayer, versionName = "gold_dialogue", "Gold"
  elseif vid == "crystal" then
    dialogueLayer, versionName = "crystal_dialogue", "Crystal"
  else
    dialogueLayer, versionName = "silver_dialogue", "Silver"
  end

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

  -- ---- Oak speech intro (Gen 2) ------------------------------------
  -- The opening Oak monologue lives in src/ui/gen2/OakSpeech.lua (FALLBACKS)
  -- and is NOT part of the dialogue/strings catalogs, so it needs its own
  -- override.  `intro.oak_speech.started` fires before the first beat runs,
  -- so mutating speech.texts here takes effect for the whole speech.
  local OAK_TEXTS = {
    _OakText1 = "¡Hola! ¡Perdona\npor la espera!\012¡Bienvenido\nal mundo de\011los POKéMON!\012Me llamo OAK.\012Pero me llaman\nPROFESOR POKéMON.",
    _OakText2 = "Este mundo está\nhabitado por unas\012criaturas llamadas\nPOKéMON.",
    _OakText4 = "La gente y los\nPOKéMON conviven\012ayudándose unos\na otros.\012Algunos juegan con\nlos POKéMON, otros\011luchan con ellos.",
    _OakText5 = "Pero aún hay\nmuchas cosas que\011no sabemos.\012Quedan muchos\nmisterios por\011resolver. Por eso\012estudio a diario\na los POKéMON.",
    _OakText6 = "¿Cómo has dicho\nque te llamas?",
    _OakText7 = "{PLAYER},\n¿estás preparado?\012Tu propia historia\nPOKéMON está a\011punto de empezar.\012Te divertirás y\nte enfrentarás a\011duros desafíos.\012¡Te espera un\nmundo de sueños y\012aventuras con\nPOKéMON! ¡Vamos!\012¡Nos vemos!",
  }
  mod.events:on("intro.oak_speech.started", function(payload)
    local speech = payload and payload.speech
    if speech and speech.texts then
      for k, v in pairs(OAK_TEXTS) do speech.texts[k] = v end
    end
  end)

  mod.events:on("game.ready", function()
    local total = 0
    for _, n in pairs(counts) do total = total + n end
    mod.log:info("Spanish (%s v0.1.0): %d strings translated", versionName, total)
  end)
end
