-- Move Damage Info (Gen1Recomp mod)
--
-- While the move list is open, the TYPE/PP box on the left has three pages:
-- the damage the highlighted move would deal to the foe right now, its power,
-- accuracy and type matchup, and a short description of what the move does.
-- SELECT opens a text box with the same information spelled out.
--
-- The damage comes from the cart's own calculator (src.battle.Damage), run
-- twice with the lowest and the highest random roll and without a critical
-- hit, so the range is the real one and not an estimate: same stats, same
-- stages, same badge boosts, same Reflect/Light Screen, same type chart.
--
-- Text exists in English, Italian, Spanish and Portuguese; the language is a
-- mod option (default English). Move and type names are the cart's own, so
-- they follow whatever the game (or a translation mod) already shows.

local MOD_ID = "move_damage_info"
local OPTION_KEY = "move_info"
local LANG_KEY = "language"
local PAGE_COUNT = 3

local LANGUAGES = {
  { "ENGLISH", "en" },
  { "ITALIANO", "it" },
  { "ESPANOL", "es" },
  { "PORTUGUES", "pt" },
}

-- 9 characters per line, three lines, one per row of the move-select box.
local SHORT = {
  en = {
    NO_ADDITIONAL_EFFECT = "NO\nEXTRA\nEFFECT",
    SLEEP_EFFECT = "PUTS TO\nSLEEP",
    POISON_EFFECT = "POISONS",
    POISON_SIDE_EFFECT1 = "MAY\nPOISON",
    POISON_SIDE_EFFECT2 = "MAY\nPOISON",
    BURN_SIDE_EFFECT1 = "MAY\nBURN",
    BURN_SIDE_EFFECT2 = "MAY\nBURN",
    PARALYZE_EFFECT = "PARALYZES",
    PARALYZE_SIDE_EFFECT1 = "MAY\nPARALYZE",
    PARALYZE_SIDE_EFFECT2 = "MAY\nPARALYZE",
    FREEZE_SIDE_EFFECT1 = "MAY\nFREEZE",
    CONFUSION_EFFECT = "CONFUSES",
    CONFUSION_SIDE_EFFECT = "MAY\nCONFUSE",
    FLINCH_SIDE_EFFECT1 = "MAY\nFLINCH",
    FLINCH_SIDE_EFFECT2 = "MAY\nFLINCH",
    RECOIL_EFFECT = "HURTS\nYOU",
    DRAIN_HP_EFFECT = "DRAINS\nHP",
    HEAL_EFFECT = "HEALS\nHALF HP",
    TWO_TO_FIVE_ATTACKS_EFFECT = "HITS\n2-5 TIMES",
    ATTACK_TWICE_EFFECT = "HITS\n2 TIMES",
    TWINEEDLE_EFFECT = "2 HITS\nMAY\nPOISON",
    CHARGE_EFFECT = "CHARGES\nTHEN HITS",
    FLY_EFFECT = "JUMPS\nTHEN HITS",
    TRAPPING_EFFECT = "TRAPS\nFOE",
    OHKO_EFFECT = "ONE HIT\nKO",
    SUPER_FANG_EFFECT = "HALVES\nFOE HP",
    SPECIAL_DAMAGE_EFFECT = "FIXED\nDAMAGE",
    EXPLODE_EFFECT = "EXPLODES\nAND FAINTS",
    JUMP_KICK_EFFECT = "MISS\nHURTS YOU",
    SWITCH_AND_TELEPORT_EFFECT = "FOE\nSWITCHES\nOR FLEES",
    ATTACK_UP1_EFFECT = "UP\nATTACK",
    ATTACK_UP2_EFFECT = "UP A LOT\nATTACK",
    DEFENSE_UP1_EFFECT = "UP\nDEFENSE",
    DEFENSE_UP2_EFFECT = "UP A LOT\nDEFENSE",
    SPECIAL_UP1_EFFECT = "UP\nSPECIAL",
    SPECIAL_UP2_EFFECT = "UP A LOT\nSPECIAL",
    SPEED_UP2_EFFECT = "UP A LOT\nSPEED",
    EVASION_UP1_EFFECT = "UP\nEVASION",
    ACCURACY_DOWN1_EFFECT = "LOWERS\nACCURACY",
    ATTACK_DOWN1_EFFECT = "LOWERS\nATTACK",
    ATTACK_DOWN_SIDE_EFFECT = "MAY LOWER\nATTACK",
    DEFENSE_DOWN1_EFFECT = "LOWERS\nDEFENSE",
    DEFENSE_DOWN2_EFFECT = "LOWERS A\nLOT DEF.",
    DEFENSE_DOWN_SIDE_EFFECT = "MAY LOWER\nDEFENSE",
    SPEED_DOWN1_EFFECT = "LOWERS\nSPEED",
    SPEED_DOWN_SIDE_EFFECT = "MAY LOWER\nSPEED",
    SPECIAL_DOWN_SIDE_EFFECT = "MAY LOWER\nSPECIAL",
    REFLECT_EFFECT = "LESS\nPHYSICAL",
    LIGHT_SCREEN_EFFECT = "LESS\nSPECIAL",
    HAZE_EFFECT = "RESETS\nSTATS",
    LEECH_SEED_EFFECT = "DRAINS HP\nEACH TURN",
    SUBSTITUTE_EFFECT = "MAKES A\nCLONE",
    DISABLE_EFFECT = "BLOCKS\nA MOVE",
    MIMIC_EFFECT = "COPIES\nA MOVE",
    METRONOME_EFFECT = "RANDOM\nMOVE",
    MIRROR_MOVE_EFFECT = "COPIES\nLAST MOVE",
    TRANSFORM_EFFECT = "COPIES\nFOE",
    CONVERSION_EFFECT = "CHANGES\nTYPE",
    FOCUS_ENERGY_EFFECT = "MORE\nCRITS",
    BIDE_EFFECT = "TAKES\nHITS THEN\nRETURNS",
    RAGE_EFFECT = "RISES\nWHEN HIT",
    PAY_DAY_EFFECT = "EXTRA\nMONEY",
    SPLASH_EFFECT = "DOES\nNOTHING",
    HYPER_BEAM_EFFECT = "RECHARGE\nNEXT TURN",
    DREAM_EATER_EFFECT = "SLEEPING\nFOE ONLY",
    SWIFT_EFFECT = "NEVER\nMISSES",
    MIST_EFFECT = "BLOCKS\nSTAT DROPS",
    THRASH_PETAL_DANCE_EFFECT = "2-3 TURNS\nTHEN\nCONFUSED",
  },
  it = {
    NO_ADDITIONAL_EFFECT = "NESSUN\nEFFETTO\nEXTRA",
    SLEEP_EFFECT = "FA\nDORMIRE\nIL NEMICO",
    POISON_EFFECT = "AVVELENA\nIL NEMICO",
    POISON_SIDE_EFFECT1 = "A VOLTE\nAVVELENA",
    POISON_SIDE_EFFECT2 = "A VOLTE\nAVVELENA",
    BURN_SIDE_EFFECT1 = "A VOLTE\nBRUCIA",
    BURN_SIDE_EFFECT2 = "A VOLTE\nBRUCIA",
    PARALYZE_EFFECT = "PARALIZZA\nIL NEMICO",
    PARALYZE_SIDE_EFFECT1 = "A VOLTE\nPARALIZZA",
    PARALYZE_SIDE_EFFECT2 = "A VOLTE\nPARALIZZA",
    FREEZE_SIDE_EFFECT1 = "A VOLTE\nCONGELA",
    CONFUSION_EFFECT = "CONFONDE\nIL NEMICO",
    CONFUSION_SIDE_EFFECT = "A VOLTE\nCONFONDE",
    FLINCH_SIDE_EFFECT1 = "PUO FAR\nTREMARE",
    FLINCH_SIDE_EFFECT2 = "PUO FAR\nTREMARE",
    RECOIL_EFFECT = "TI\nFERISCE\nUN PO",
    DRAIN_HP_EFFECT = "CURA\nMETA\nDANNO",
    HEAL_EFFECT = "CURA\nMETA PS",
    TWO_TO_FIVE_ATTACKS_EFFECT = "COLPISCE\n2-5 VOLTE",
    ATTACK_TWICE_EFFECT = "COLPISCE\n2 VOLTE",
    TWINEEDLE_EFFECT = "2 COLPI\nA VOLTE\nAVVELENA",
    CHARGE_EFFECT = "CARICA\nPOI\nCOLPISCE",
    FLY_EFFECT = "SALTA\nPOI\nCOLPISCE",
    TRAPPING_EFFECT = "BLOCCA\nIL NEMICO",
    OHKO_EFFECT = "KO IN UN\nCOLPO",
    SUPER_FANG_EFFECT = "META\nPS DEL\nNEMICO",
    SPECIAL_DAMAGE_EFFECT = "DANNO\nFISSO",
    EXPLODE_EFFECT = "ESPLODE\nE SVIENE",
    JUMP_KICK_EFFECT = "SE\nSBAGLIA\nTI FERISCI",
    SWITCH_AND_TELEPORT_EFFECT = "FA\nCAMBIARE\nO FUGGIRE",
    ATTACK_UP1_EFFECT = "SU\nATTACCO",
    ATTACK_UP2_EFFECT = "SU MOLTO\nATTACCO",
    DEFENSE_UP1_EFFECT = "SU\nDIFESA",
    DEFENSE_UP2_EFFECT = "SU MOLTO\nDIFESA",
    SPECIAL_UP1_EFFECT = "SU\nSPECIAL",
    SPECIAL_UP2_EFFECT = "SU MOLTO\nSPECIAL",
    SPEED_UP2_EFFECT = "SU MOLTO\nVELOCITA",
    EVASION_UP1_EFFECT = "SU\nELUSIONE",
    ACCURACY_DOWN1_EFFECT = "GIU\nPRECIS.",
    ATTACK_DOWN1_EFFECT = "GIU\nATTACCO",
    ATTACK_DOWN_SIDE_EFFECT = "A VOLTE\nGIU\nATTACCO",
    DEFENSE_DOWN1_EFFECT = "GIU\nDIFESA",
    DEFENSE_DOWN2_EFFECT = "GIU MOLTO\nDIFESA",
    DEFENSE_DOWN_SIDE_EFFECT = "A VOLTE\nGIU\nDIFESA",
    SPEED_DOWN1_EFFECT = "GIU\nVELOCITA",
    SPEED_DOWN_SIDE_EFFECT = "A VOLTE\nGIU\nVELOCITA",
    SPECIAL_DOWN_SIDE_EFFECT = "A VOLTE\nGIU\nSPECIAL",
    REFLECT_EFFECT = "MENO\nDANNO\nFISICO",
    LIGHT_SCREEN_EFFECT = "MENO\nDANNO\nSPECIALE",
    HAZE_EFFECT = "ANNULLA\nI CAMBI\nSTAT",
    LEECH_SEED_EFFECT = "RUBA PS\nA OGNI\nTURNO",
    SUBSTITUTE_EFFECT = "CREA UN\nCLONE",
    DISABLE_EFFECT = "BLOCCA\nUNA MOSSA",
    MIMIC_EFFECT = "COPIA\nUNA MOSSA",
    METRONOME_EFFECT = "MOSSA\nA CASO",
    MIRROR_MOVE_EFFECT = "COPIA\nL ULTIMA\nMOSSA",
    TRANSFORM_EFFECT = "COPIA IL\nNEMICO",
    CONVERSION_EFFECT = "CAMBIA\nTIPO",
    FOCUS_ENERGY_EFFECT = "PIU\nFACILE\nCRITICO",
    BIDE_EFFECT = "ASSORBE\nPOI\nRILANCIA",
    RAGE_EFFECT = "SALE SE\nCOLPITO",
    PAY_DAY_EFFECT = "SOLDI\nEXTRA",
    SPLASH_EFFECT = "NON FA\nNULLA",
    HYPER_BEAM_EFFECT = "RICARICA\nDOPO",
    DREAM_EATER_EFFECT = "SOLO SU\nDORMIENTI",
    SWIFT_EFFECT = "NON\nSBAGLIA\nMAI",
    MIST_EFFECT = "BLOCCA I\nCALI STAT",
    THRASH_PETAL_DANCE_EFFECT = "2-3 TURNI\nPOI\nCONFUSO",
  },
  es = {
    NO_ADDITIONAL_EFFECT = "SIN\nEFECTO\nEXTRA",
    SLEEP_EFFECT = "HACE\nDORMIR",
    POISON_EFFECT = "ENVENENA",
    POISON_SIDE_EFFECT1 = "PUEDE\nENVENENAR",
    POISON_SIDE_EFFECT2 = "PUEDE\nENVENENAR",
    BURN_SIDE_EFFECT1 = "PUEDE\nQUEMAR",
    BURN_SIDE_EFFECT2 = "PUEDE\nQUEMAR",
    PARALYZE_EFFECT = "PARALIZA",
    PARALYZE_SIDE_EFFECT1 = "PUEDE\nPARALIZAR",
    PARALYZE_SIDE_EFFECT2 = "PUEDE\nPARALIZAR",
    FREEZE_SIDE_EFFECT1 = "PUEDE\nCONGELAR",
    CONFUSION_EFFECT = "CONFUNDE",
    CONFUSION_SIDE_EFFECT = "PUEDE\nCONFUNDIR",
    FLINCH_SIDE_EFFECT1 = "PUEDE\nASUSTAR",
    FLINCH_SIDE_EFFECT2 = "PUEDE\nASUSTAR",
    RECOIL_EFFECT = "TE\nHIERE",
    DRAIN_HP_EFFECT = "DRENA\nPS",
    HEAL_EFFECT = "CURA\nMITAD PS",
    TWO_TO_FIVE_ATTACKS_EFFECT = "GOLPEA\n2-5 VECES",
    ATTACK_TWICE_EFFECT = "GOLPEA\n2 VECES",
    TWINEEDLE_EFFECT = "2 GOLPES\nPUEDE\nENVENENAR",
    CHARGE_EFFECT = "CARGA Y\nGOLPEA",
    FLY_EFFECT = "SALTA Y\nGOLPEA",
    TRAPPING_EFFECT = "ATRAPA",
    OHKO_EFFECT = "KO EN UN\nGOLPE",
    SUPER_FANG_EFFECT = "MITAD DE\nPS",
    SPECIAL_DAMAGE_EFFECT = "DANO\nFIJO",
    EXPLODE_EFFECT = "EXPLOTA\nY CAE",
    JUMP_KICK_EFFECT = "SI FALLA\nSE HIERE",
    SWITCH_AND_TELEPORT_EFFECT = "CAMBIA\nO HUYE",
    ATTACK_UP1_EFFECT = "SUBE\nATAQUE",
    ATTACK_UP2_EFFECT = "SUBE\nMUCHO\nATAQUE",
    DEFENSE_UP1_EFFECT = "SUBE\nDEFENSA",
    DEFENSE_UP2_EFFECT = "SUBE\nMUCHO\nDEFENSA",
    SPECIAL_UP1_EFFECT = "SUBE\nESPECIAL",
    SPECIAL_UP2_EFFECT = "SUBE\nMUCHO\nESPECIAL",
    SPEED_UP2_EFFECT = "SUBE\nMUCHO\nVELOCIDAD",
    EVASION_UP1_EFFECT = "SUBE\nEVASION",
    ACCURACY_DOWN1_EFFECT = "BAJA\nPRECISION",
    ATTACK_DOWN1_EFFECT = "BAJA\nATAQUE",
    ATTACK_DOWN_SIDE_EFFECT = "PUEDE\nBAJAR\nATAQUE",
    DEFENSE_DOWN1_EFFECT = "BAJA\nDEFENSA",
    DEFENSE_DOWN2_EFFECT = "BAJA\nMUCHO\nDEFENSA",
    DEFENSE_DOWN_SIDE_EFFECT = "PUEDE\nBAJAR\nDEFENSA",
    SPEED_DOWN1_EFFECT = "BAJA\nVELOCIDAD",
    SPEED_DOWN_SIDE_EFFECT = "PUEDE\nBAJAR\nVELOCIDAD",
    SPECIAL_DOWN_SIDE_EFFECT = "PUEDE\nBAJAR\nESPECIAL",
    REFLECT_EFFECT = "MENOS\nFISICO",
    LIGHT_SCREEN_EFFECT = "MENOS\nESPECIAL",
    HAZE_EFFECT = "BORRA\nCAMBIOS",
    LEECH_SEED_EFFECT = "DRENA PS\nCADA\nTURNO",
    SUBSTITUTE_EFFECT = "CREA UN\nCLON",
    DISABLE_EFFECT = "BLOQUEA\nUN MOV.",
    MIMIC_EFFECT = "COPIA\nUN MOV.",
    METRONOME_EFFECT = "MOV.\nAL AZAR",
    MIRROR_MOVE_EFFECT = "COPIA EL\nULTIMO",
    TRANSFORM_EFFECT = "COPIA AL\nRIVAL",
    CONVERSION_EFFECT = "CAMBIA\nTIPO",
    FOCUS_ENERGY_EFFECT = "MAS\nCRITICOS",
    BIDE_EFFECT = "AGUANTA\nY\nDEVUELVE",
    RAGE_EFFECT = "SUBE SI\nLE DAN",
    PAY_DAY_EFFECT = "DINERO\nEXTRA",
    SPLASH_EFFECT = "NO HACE\nNADA",
    HYPER_BEAM_EFFECT = "RECARGA",
    DREAM_EATER_EFFECT = "SOLO SI\nDUERME",
    SWIFT_EFFECT = "NUNCA\nFALLA",
    MIST_EFFECT = "FRENA\nBAJADAS",
    THRASH_PETAL_DANCE_EFFECT = "2-3\nTURNOS\nCONFUSO",
  },
  pt = {
    NO_ADDITIONAL_EFFECT = "SEM\nEFEITO\nEXTRA",
    SLEEP_EFFECT = "FAZ\nDORMIR",
    POISON_EFFECT = "ENVENENA",
    POISON_SIDE_EFFECT1 = "PODE\nENVENENAR",
    POISON_SIDE_EFFECT2 = "PODE\nENVENENAR",
    BURN_SIDE_EFFECT1 = "PODE\nQUEIMAR",
    BURN_SIDE_EFFECT2 = "PODE\nQUEIMAR",
    PARALYZE_EFFECT = "PARALISA",
    PARALYZE_SIDE_EFFECT1 = "PODE\nPARALISAR",
    PARALYZE_SIDE_EFFECT2 = "PODE\nPARALISAR",
    FREEZE_SIDE_EFFECT1 = "PODE\nCONGELAR",
    CONFUSION_EFFECT = "CONFUNDE",
    CONFUSION_SIDE_EFFECT = "PODE\nCONFUNDIR",
    FLINCH_SIDE_EFFECT1 = "PODE\nASSUSTAR",
    FLINCH_SIDE_EFFECT2 = "PODE\nASSUSTAR",
    RECOIL_EFFECT = "TE\nMACHUCA",
    DRAIN_HP_EFFECT = "DRENA\nPS",
    HEAL_EFFECT = "CURA\nMETADE",
    TWO_TO_FIVE_ATTACKS_EFFECT = "ACERTA\n2-5 VEZES",
    ATTACK_TWICE_EFFECT = "ACERTA\n2 VEZES",
    TWINEEDLE_EFFECT = "2 GOLPES\nPODE\nENVENENAR",
    CHARGE_EFFECT = "CARREGA\nE ACERTA",
    FLY_EFFECT = "SALTA E\nACERTA",
    TRAPPING_EFFECT = "PRENDE\nO RIVAL",
    OHKO_EFFECT = "KO EM UM\nGOLPE",
    SUPER_FANG_EFFECT = "METADE\nDOS PS",
    SPECIAL_DAMAGE_EFFECT = "DANO\nFIXO",
    EXPLODE_EFFECT = "EXPLODE\nE CAI",
    JUMP_KICK_EFFECT = "SE ERRA\nSE MACHUCA",
    SWITCH_AND_TELEPORT_EFFECT = "TROCA\nOU FOGE",
    ATTACK_UP1_EFFECT = "SOBE\nATAQUE",
    ATTACK_UP2_EFFECT = "SOBE\nMUITO\nATAQUE",
    DEFENSE_UP1_EFFECT = "SOBE\nDEFESA",
    DEFENSE_UP2_EFFECT = "SOBE\nMUITO\nDEFESA",
    SPECIAL_UP1_EFFECT = "SOBE\nESPECIAL",
    SPECIAL_UP2_EFFECT = "SOBE\nMUITO\nESPECIAL",
    SPEED_UP2_EFFECT = "SOBE\nMUITO\nVELOCID.",
    EVASION_UP1_EFFECT = "SOBE\nEVASAO",
    ACCURACY_DOWN1_EFFECT = "BAIXA\nPRECISAO",
    ATTACK_DOWN1_EFFECT = "BAIXA\nATAQUE",
    ATTACK_DOWN_SIDE_EFFECT = "PODE\nBAIXAR\nATAQUE",
    DEFENSE_DOWN1_EFFECT = "BAIXA\nDEFESA",
    DEFENSE_DOWN2_EFFECT = "BAIXA\nMUITO\nDEFESA",
    DEFENSE_DOWN_SIDE_EFFECT = "PODE\nBAIXAR\nDEFESA",
    SPEED_DOWN1_EFFECT = "BAIXA\nVELOCID.",
    SPEED_DOWN_SIDE_EFFECT = "PODE\nBAIXAR\nVELOCID.",
    SPECIAL_DOWN_SIDE_EFFECT = "PODE\nBAIXAR\nESPECIAL",
    REFLECT_EFFECT = "MENOS\nFISICO",
    LIGHT_SCREEN_EFFECT = "MENOS\nESPECIAL",
    HAZE_EFFECT = "APAGA\nMUDANCAS",
    LEECH_SEED_EFFECT = "DRENA PS\nPOR TURNO",
    SUBSTITUTE_EFFECT = "CRIA UM\nCLONE",
    DISABLE_EFFECT = "BLOQUEIA\nUM GOLPE",
    MIMIC_EFFECT = "COPIA UM\nGOLPE",
    METRONOME_EFFECT = "GOLPE\nALEATORIO",
    MIRROR_MOVE_EFFECT = "COPIA O\nULTIMO",
    TRANSFORM_EFFECT = "COPIA O\nRIVAL",
    CONVERSION_EFFECT = "MUDA\nTIPO",
    FOCUS_ENERGY_EFFECT = "MAIS\nCRITICOS",
    BIDE_EFFECT = "AGUENTA\nE\nDEVOLVE",
    RAGE_EFFECT = "SOBE SE\nLEVA DANO",
    PAY_DAY_EFFECT = "DINHEIRO\nEXTRA",
    SPLASH_EFFECT = "NAO FA\nNADA",
    HYPER_BEAM_EFFECT = "RECARREGA",
    DREAM_EATER_EFFECT = "SO\nDORMINDO",
    SWIFT_EFFECT = "NUNCA\nERRA",
    MIST_EFFECT = "BLOQUEIA\nQUEDAS",
    THRASH_PETAL_DANCE_EFFECT = "2-3\nTURNOS\nCONFUSO",
  },
}

-- Box and text-box labels per language.  "dmg" is the damage prefix (fits with
-- a two-digit range in the 9-character row), "ofHp" the hit-point line.
local LABELS = {
  en = {
    dmg = "DMG", pwr = "PWR", acc = "ACC", none = "DMG --", zero = "DMG 0",
    over = "DMG %d+", range = "DMG %d-%d", noDesc = "NO\nDESCRIPTION",
    ofHp = "OF %d HP", pct = "(%d-%d%%)", perHit = "DAMAGE PER HIT",
    power = "PWR %s", accuracy = "ACC %s",
    mult = { [0] = "NO EFFECT", [2] = "WEAK X1/4", [5] = "WEAK X1/2",
             [10] = "NORMAL X1", [20] = "SUPER X2", [40] = "SUPER X4" },
  },
  it = {
    dmg = "DANNO", pwr = "POT", acc = "PREC", none = "DANNO --",
    zero = "DANNO 0", over = "DANNO %d+", range = "DANNO %d-%d",
    noDesc = "NESSUNA\nDESCRIZIONE",
    ofHp = "SU %d PS", pct = "(%d-%d%%)", perHit = "DANNO PER COLPO",
    power = "POT %s", accuracy = "PREC %s",
    mult = { [0] = "NESSUN EFFETTO", [2] = "POCO X1/4", [5] = "POCO X1/2",
             [10] = "NORMALE X1", [20] = "SUPER X2", [40] = "SUPER X4" },
  },
  es = {
    dmg = "DANO", pwr = "POT", acc = "PREC", none = "DANO --", zero = "DANO 0",
    over = "DANO %d+", range = "DANO %d-%d", noDesc = "SIN\nDESCRIPCION",
    ofHp = "DE %d PS", pct = "(%d-%d%%)", perHit = "DANO POR GOLPE",
    power = "POT %s", accuracy = "PREC %s",
    mult = { [0] = "SIN EFECTO", [2] = "POCO X1/4", [5] = "POCO X1/2",
             [10] = "NORMAL X1", [20] = "SUPER X2", [40] = "SUPER X4" },
  },
  pt = {
    dmg = "DANO", pwr = "POD", acc = "PREC", none = "DANO --", zero = "DANO 0",
    over = "DANO %d+", range = "DANO %d-%d", noDesc = "SEM\nDESCRICAO",
    ofHp = "DE %d PS", pct = "(%d-%d%%)", perHit = "DANO POR GOLPE",
    power = "POD %s", accuracy = "PREC %s",
    mult = { [0] = "SEM EFEITO", [2] = "FRACO X1/4", [5] = "FRACO X1/2",
             [10] = "NORMAL X1", [20] = "SUPER X2", [40] = "SUPER X4" },
  },
}

local function shortMult(mult)
  if mult == 0 then return "X0" end
  if mult == 2 then return "X1/4" end
  if mult == 5 then return "X1/2" end
  if mult == 10 then return "X1" end
  if mult == 20 then return "X2" end
  if mult == 40 then return "X4" end
  return "X?"
end

return function(mod)
  local Font = mod.ui.Font
  local BattleState = require("src.battle.BattleState")
  local Damage = require("src.battle.Damage")
  local TypeChart = require("src.battle.TypeChart")

  local page = 0
  local cache = {}
  local explaining = false

  -- ---------------------------------------------------------------- options

  local function readOption(key, default)
    local ok, value = pcall(mod.options.get, mod.options, key)
    if ok and value ~= nil then return value end
    return default
  end

  local function truthy(value)
    if value == nil then return true end
    if value == false or value == "off" or value == 0 then return false end
    return true
  end

  local function enabled()
    if cache[OPTION_KEY] == nil then
      cache[OPTION_KEY] = truthy(readOption(OPTION_KEY, true))
    end
    return cache[OPTION_KEY]
  end

  local function language()
    local value = cache[LANG_KEY] or readOption(LANG_KEY, "en")
    if type(value) ~= "string" or not SHORT[value] then return "en" end
    return value
  end

  local function labels()
    return LABELS[language()] or LABELS.en
  end

  local function effects()
    return SHORT[language()] or SHORT.en
  end

  local function persist(game, key, value)
    local options = game and game.save and game.save.options
    if options then
      options.modOptions = options.modOptions or {}
      options.modOptions[MOD_ID] = options.modOptions[MOD_ID] or {}
      options.modOptions[MOD_ID][key] = value
    end
    local loader = game and game.mods
    if loader then
      loader.modOptions = loader.modOptions or {}
      loader.modOptions[MOD_ID] = loader.modOptions[MOD_ID] or {}
      loader.modOptions[MOD_ID][key] = value
    end
    if game and game.writeOptions then pcall(game.writeOptions, game) end
  end

  mod.options:define({
    {
      key = OPTION_KEY,
      type = "toggle",
      label = "MOVE DAMAGE INFO",
      default = true,
      description = "DAMAGE, POWER AND A SHORT\nDESCRIPTION OF THE MOVE YOU\f"
        .. "ARE HIGHLIGHTING IN BATTLE.",
    },
    {
      key = LANG_KEY,
      type = "choice",
      label = "LANGUAGE",
      default = "en",
      choices = LANGUAGES,
      description = "LANGUAGE OF THE MOD TEXT.\nPOKEMON AND MOVE NAMES\f"
        .. "FOLLOW THE GAME.",
    },
  })

  -- ------------------------------------------------------------------ data

  local function selectedMove(battle)
    local moves = battle.player and battle.player.curMoves
    if not moves then return nil, nil end
    local mv = moves[battle.moveIndex]
    if not mv then return nil, nil end
    return mv, battle.data and battle.data.moves and battle.data.moves[mv.id]
  end

  local function typeName(battle, def)
    if not def or not def.type then return "" end
    local ok, name = pcall(TypeChart.displayName, def.type, battle.data)
    if ok and type(name) == "string" then return name end
    return tostring(def.type)
  end

  local function effectiveness(battle, def)
    local types = battle.enemy and battle.enemy.curTypes
    if not (def and def.type and types) then return nil end
    local ok, mult = pcall(TypeChart.effectiveness, def.type, types)
    if ok and type(mult) == "number" then return mult end
    return nil
  end

  -- The cart's own calculator, once with the lowest and once with the highest
  -- random roll, no critical hit: the real range for this turn.
  local function rulesetOf(battle)
    if battle.ruleset then return battle.ruleset end
    local ok, rs = pcall(require, "src.battle.rulesets.gen1_faithful")
    if ok and type(rs) == "table" then return rs end
    return { randMin = 217, randMax = 255 }
  end

  local function damageRange(battle, def)
    local ruleset = rulesetOf(battle)
    if not (ruleset and battle.player and battle.enemy and def) then return nil end
    if (def.power or 0) <= 0 then return nil end
    local low = ruleset.randMin or 217
    local high = ruleset.randMax or 255
    local function roll(value)
      local ok, dealt = pcall(Damage.compute, ruleset, battle.player,
        battle.enemy, def,
        { rng = function() return value end, forceCrit = false })
      if ok and type(dealt) == "number" then return dealt end
      return nil
    end
    local lo, hi = roll(low), roll(high)
    if lo == nil or hi == nil then return nil end
    if lo > hi then lo, hi = hi, lo end
    return lo, hi
  end

  local function rangeText(battle, def)
    local t = labels()
    local lo, hi = damageRange(battle, def)
    if not lo then return t.none end
    if hi <= 0 then return t.zero end
    if hi >= 100 then return t.over:format(lo) end
    return t.range:format(lo, hi)
  end

  local function maxPPOf(def, mv)
    local base = (def and def.pp or 0)
    return base + (mv and mv.ppUps or 0) * math.floor(base / 5)
  end

  -- --------------------------------------------------------------- drawing

  local function drawClassic(battle)
    local mv, def = selectedMove(battle)
    if not mv then return end
    if battle.player.disabledSlot == battle.moveIndex then return end
    if not def then return end

    local t = labels()
    -- The vanilla TYPE/PP box interior, wiped and refilled: the border and the
    -- two replaced corners stay exactly as drawTextArea left them.
    local g = love.graphics
    g.setColor(1, 1, 1, 1)
    g.rectangle("fill", 8, 72, 72, 24)
    g.setColor(0, 0, 0, 1)

    local pp = ("PP %2d/%2d"):format(mv.pp or 0, maxPPOf(def, mv))
    if page == 0 then
      Font.draw(rangeText(battle, def), 8, 72)
      Font.draw(typeName(battle, def), 8, 80)
      Font.draw(pp, 8, 88)
    elseif page == 1 then
      local power = def.power or 0
      Font.draw(t.power:format(power <= 0 and "--" or tostring(power)), 8, 72)
      Font.draw(t.accuracy:format(
        def.accuracy and tostring(def.accuracy) or "--"), 8, 80)
      Font.draw(shortMult(effectiveness(battle, def)), 8, 88)
    else
      local desc = effects()[def.effect] or t.noDesc
      local row = 72
      for line in desc:gmatch("[^\n]+") do
        if row > 88 then break end
        Font.draw(line, 8, row)
        row = row + 8
      end
    end
    g.setColor(0, 0, 0, 1)
  end

  local function drawWide(battle)
    local mv, def = selectedMove(battle)
    if not mv then return end
    local t = labels()
    Font.drawBox(28, 13, 10, 5)
    love.graphics.setColor(0, 0, 0, 1)
    if battle.player.disabledSlot == battle.moveIndex or not def then return end
    Font.draw(rangeText(battle, def), 232, 112)
    Font.draw(t.power:format(def.power and def.power > 0
      and tostring(def.power) or "--"), 232, 120)
    Font.draw(t.accuracy:format(def.accuracy and tostring(def.accuracy) or "--"),
      232, 128)
  end

  -- ---------------------------------------------------------- explanation

  local function longEffect(def)
    local short = effects()[def.effect]
    if not short then return nil end
    return (short:gsub("\n", " "))
  end

  local function explanationFor(battle, mv, def)
    local t = labels()
    local lo, hi = damageRange(battle, def)
    local lines = { def.name or mv.id }
    local effect = longEffect(def)
    if effect then lines[#lines + 1] = effect end

    local power = def.power or 0
    lines[#lines + 1] = ("%s  %s"):format(
      t.power:format(power <= 0 and "--" or tostring(power)),
      t.accuracy:format(def.accuracy and tostring(def.accuracy) or "--"))

    if lo then
      lines[#lines + 1] = t.range:format(lo, hi)
      local hp = battle.enemy and battle.enemy.mon
                 and battle.enemy.mon.stats and battle.enemy.mon.stats.hp
      if hp and hp > 0 then
        lines[#lines + 1] = ("%s %s"):format(t.ofHp:format(hp),
          t.pct:format(math.floor(lo * 100 / hp), math.ceil(hi * 100 / hp)))
      end
    end
    local mult = effectiveness(battle, def)
    if mult and t.mult[mult] then lines[#lines + 1] = t.mult[mult] end
    if def.effect == "TWO_TO_FIVE_ATTACKS_EFFECT" then
      lines[#lines + 1] = t.perHit
    end
    lines[#lines + 1] = ("PP %d/%d"):format(mv.pp or 0, maxPPOf(def, mv))
    return table.concat(lines, "\n")
  end

  local function explain(battle)
    local mv, def = selectedMove(battle)
    if not (mv and def) or explaining then return end
    local stack = battle.game and battle.game.stack
    if not stack then return end
    explaining = true
    stack:push(mod.ui.TextBox.new(battle.game, explanationFor(battle, mv, def),
      function() explaining = false end))
  end

  -- ------------------------------------------------------------ hooks

  local prevDrawTextArea = BattleState.drawTextArea
  BattleState.drawTextArea = function(self, ...)
    local result = prevDrawTextArea(self, ...)
    if enabled() and self.phase == "moveSelect" then
      if self:wideLayout() then
        drawWide(self)
      else
        drawClassic(self)
      end
      love.graphics.setColor(1, 1, 1, 1)
    end
    return result
  end

  local prevUpdate = BattleState.update
  BattleState.update = function(self, dt)
    if enabled() and self.phase == "moveSelect" then
      local input = self.game and self.game.input
      if input and input.pressed then
        if input.pressed.left then
          input.pressed.left = nil
          page = (page - 1) % PAGE_COUNT
        elseif input.pressed.right then
          input.pressed.right = nil
          page = (page + 1) % PAGE_COUNT
        end
      end
      if input and input.wasPressed and input:wasPressed("select") then
        explain(self)
      end
    else
      page = 0
    end
    return prevUpdate(self, dt)
  end

  mod.hooks:wrap("ui.options.rows", function(next, game, rows)
    rows = next(game, rows) or rows or {}
    rows[#rows + 1] = {
      id = MOD_ID .. ":" .. OPTION_KEY,
      label = "MOVE DAMAGE INFO",
      value = function() return enabled() and "ON" or "OFF" end,
      step = function(g)
        cache[OPTION_KEY] = not enabled()
        persist(g, OPTION_KEY, cache[OPTION_KEY])
        return true
      end,
    }
    rows[#rows + 1] = {
      id = MOD_ID .. ":" .. LANG_KEY,
      label = "MOVE INFO LANG",
      value = function()
        local current = language()
        for _, row in ipairs(LANGUAGES) do
          if row[2] == current then return row[1] end
        end
        return "ENGLISH"
      end,
      step = function(g, dir)
        local current, index = language(), 1
        for i, row in ipairs(LANGUAGES) do
          if row[2] == current then index = i break end
        end
        index = (index - 1 + (dir or 1)) % #LANGUAGES + 1
        cache[LANG_KEY] = LANGUAGES[index][2]
        persist(g, LANG_KEY, cache[LANG_KEY])
        return true
      end,
    }
    return rows
  end)

  mod.events:on("mod.options_changed", function(payload)
    if not payload or payload.mod ~= MOD_ID then return end
    cache[payload.key] = payload.value
  end)

  mod.events:on("battle.ended", function()
    page = 0
    explaining = false
  end)

  mod.exports.rangeText = rangeText
  mod.exports.damageRange = damageRange
  mod.exports.language = language
end
