-- Headless test for Move Damage Info:
--   luajit tests\move_damage_info_test.lua
-- Real main.lua over fake engine modules: the damage range comes from the
-- stubbed calculator, the drawing is checked through the text the stub Font
-- receives, and each language is exercised once.

local texts = {}

love = { graphics = {
  setColor = function() end,
  rectangle = function() end,
  draw = function() end,
  push = function() end,
  pop = function() end,
} }

local Font = {
  draw = function(text, x, y)
    texts[#texts + 1] = { text = tostring(text), x = x, y = y }
    return #tostring(text) * 8
  end,
  drawCode = function() end,
  drawBox = function() end,
  width = function(text) return #tostring(text) * 8 end,
  split = function(text) local out = {} for i = 1, #text do out[i] = text:sub(i, i) end return out end,
}

local BattleState = {
  drawTextArea = function(self) self.baseDraws = (self.baseDraws or 0) + 1 end,
  update = function(self, dt) self.updates = (self.updates or 0) + 1 end,
}

-- The real calculator: min roll 12 damage, max roll 14.
local Damage = {
  compute = function(ruleset, attacker, defender, move, opts)
    return (opts and opts.rng and opts.rng() == 255) and 14 or 12
  end,
}

local TypeChart = {
  displayName = function(t) return tostring(t) end,
  effectiveness = function() return 20 end,
}

package.loaded["src.battle.BattleState"] = BattleState
package.loaded["src.battle.Damage"] = Damage
package.loaded["src.battle.TypeChart"] = TypeChart

local function makeMod(config)
  config = config or {}
  local events = {}
  local hooks = {}
  local mod
  mod = {
    id = "move_damage_info",
    log = { warn = function() end, error = function() error("mod error") end },
    options = {
      schema = nil,
      define = function(_, schema) mod.options.schema = schema end,
      get = function(_, key) return config[key] end,
    },
    hooks = { wrap = function(_, name, fn) hooks[name] = fn end },
    events = {
      on = function(_, name, fn) events[name] = events[name] or {}; table.insert(events[name], fn) end,
      once = function(_, name, fn) events[name] = events[name] or {}; table.insert(events[name], fn) end,
    },
    ui = {
      Font = Font,
      TextBox = { new = function(game, text, onDone)
        return { pushed = true, text = text, onDone = onDone }
      end },
    },
    exports = {},
  }
  mod.fire = function(name, event)
    for _, fn in ipairs(events[name] or {}) do fn(event) end
  end
  mod.hooks_map = hooks
  return mod
end

local function makeBattle(moveId)
  local pushed = {}
  local battle = {
    game = {
      input = { pressed = {}, wasPressed = function() return false end },
      stack = { push = function(_, state) pushed[#pushed + 1] = state end },
      save = { options = {} },
    },
    phase = "moveSelect",
    moveIndex = 1,
    player = {
      curMoves = { { id = moveId or "EMBER", pp = 12, ppUps = 0 } },
      disabledSlot = nil,
    },
    enemy = { curTypes = { "GRASS" }, mon = { stats = { hp = 40 } } },
    data = { moves = {
      EMBER = { id = "EMBER", name = "EMBER", type = "FIRE", power = 40,
                accuracy = 100, pp = 25, effect = "BURN_SIDE_EFFECT1" },
      GROWL = { id = "GROWL", name = "GROWL", type = "NORMAL", power = 0,
                accuracy = 100, pp = 40, effect = "ATTACK_DOWN1_EFFECT" },
    } },
    ruleset = { randMin = 217, randMax = 255 },
    wideLayout = function() return false end,
  }
  battle.pushed = pushed
  return battle
end

local failures = 0
local function expect(label, actual, wanted)
  if actual == wanted then
    print(("ok   %s"):format(label))
  else
    failures = failures + 1
    print(("FAIL %s: got %s, wanted %s"):format(label, tostring(actual),
                                               tostring(wanted)))
  end
end

local function anyText(pattern)
  for _, row in ipairs(texts) do
    if row.text:find(pattern, 1, true) then return true end
  end
  return false
end

local function install(config)
  BattleState.drawTextArea = function(self) self.baseDraws = (self.baseDraws or 0) + 1 end
  BattleState.update = function(self, dt) self.updates = (self.updates or 0) + 1 end
  local mod = makeMod(config)
  assert(loadfile("main.lua"))()(mod)
  return mod
end

local function toPage(battle, page)
  BattleState.update(battle, 0.016)
  for _ = 1, page do
    battle.game.input.pressed.right = true
    BattleState.update(battle, 0.016)
  end
  texts = {}
  BattleState.drawTextArea(battle)
end

-- 1. English by default
install(nil)
local battle = makeBattle("EMBER")
BattleState.drawTextArea(battle)
expect("base draw still runs", battle.baseDraws, 1)
expect("damage range drawn", anyText("DMG 12-14"), true)
expect("type drawn", anyText("FIRE"), true)
expect("pp drawn", anyText("PP 12/25"), true)

-- 2. Italian keeps the old wording
install({ language = "it" })
texts = {}
BattleState.drawTextArea(makeBattle("EMBER"))
expect("italian damage prefix", anyText("DANNO 12-14"), true)

-- 3. Spanish and Portuguese prefixes
install({ language = "es" })
texts = {}
BattleState.drawTextArea(makeBattle("EMBER"))
expect("spanish damage prefix", anyText("DANO 12-14"), true)

install({ language = "pt" })
texts = {}
BattleState.drawTextArea(makeBattle("EMBER"))
expect("portuguese damage prefix", anyText("DANO 12-14"), true)

-- 4. a status move has no damage number
install(nil)
texts = {}
BattleState.drawTextArea(makeBattle("GROWL"))
expect("status move says --", anyText("DMG --"), true)

-- 5. page 2 is power, accuracy and the matchup
install(nil)
local paged = makeBattle("EMBER")
toPage(paged, 1)
expect("page 2 shows power", anyText("PWR 40"), true)
expect("page 2 shows accuracy", anyText("ACC 100"), true)
expect("right key consumed", paged.game.input.pressed.right, nil)

-- 6. page 3 is the short description, per language
toPage(paged, 1)
expect("english describes the move", anyText("BURN"), true)

install({ language = "it" })
local italian = makeBattle("GROWL")
toPage(italian, 2)
expect("italian growl lowers attack", anyText("ATTACCO"), true)
expect("italian growl says down", anyText("GIU"), true)

install({ language = "es" })
local spanish = makeBattle("GROWL")
toPage(spanish, 2)
expect("spanish growl lowers attack", anyText("ATAQUE"), true)

install({ language = "pt" })
local portuguese = makeBattle("GROWL")
toPage(portuguese, 2)
expect("portuguese growl lowers attack", anyText("ATAQUE"), true)

-- 7. SELECT opens the explanation in the chosen language
install({ language = "it" })
local explained = makeBattle("EMBER")
explained.game.input.wasPressed = function(_, btn) return btn == "select" end
BattleState.update(explained, 0.016)
expect("textbox pushed", #explained.pushed, 1)
expect("explanation names the move", explained.pushed[1].text:find("EMBER", 1, true) ~= nil, true)
expect("explanation explains burn", explained.pushed[1].text:find("BRUCIA", 1, true) ~= nil, true)
expect("explanation has damage", explained.pushed[1].text:find("DANNO 12-14", 1, true) ~= nil, true)

-- 8. option off leaves the vanilla box alone
install({ move_info = "off" })
texts = {}
BattleState.drawTextArea(makeBattle("EMBER"))
expect("option off draws no damage", anyText("DMG"), false)

-- 9. disabled slot is left to the cart
install(nil)
local disabled = makeBattle("EMBER")
disabled.player.disabledSlot = 1
texts = {}
BattleState.drawTextArea(disabled)
expect("disabled slot untouched", #texts, 0)

print(failures == 0 and "ALL TESTS PASSED" or (failures .. " FAILURE(S)"))
os.exit(failures == 0 and 0 or 1)
