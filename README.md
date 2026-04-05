# ESP API — Documentation complète

> Exécutez le script ESP une seule fois. Une fois chargé, le script s'enregistre dans la variable globale `getgenv().ESPAPI`.

### Installation / Chargement

```lua
local ESPAPI = loadstring(game:HttpGet("https://raw.githubusercontent.com/brskofdp/EspApi/refs/heads/main/esp.lua"))()

-- ============================================
-- Utilisation (via getgenv() ou la variable locale)
-- ============================================
getgenv().ESPAPI.SetEnabled(true)
getgenv().ESPAPI.SetTeamCheck(true)
getgenv().ESPAPI.SetMaxDistance(300)
getgenv().ESPAPI.SetFontSize(13)
```

---

## Sommaire

- [Global](#global)
- [FadeOut](#fadeout)
- [Options](#options)
- [Chams](#chams)
- [Names](#names)
- [Healthbar](#healthbar)
- [Distances](#distances)
- [Weapons](#weapons)
- [Boxes](#boxes)
- [Flags](#flags)
- [Utilitaires](#utilitaires)
- [Config directe](#config-directe)
- [Exemples pratiques](#exemples-pratiques)

---

## Global

Contrôle l'état général de l'ESP.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetEnabled(v)` | `bool` | Active / désactive tout l'ESP |
| `SetTeamCheck(v)` | `bool` | Ne montre que les ennemis (équipes différentes) |
| `SetMaxDistance(v)` | `number` | Distance max en studs avant que l'ESP disparaisse |
| `SetFontSize(v)` | `number` | Taille de tous les textes ESP |

```lua
getgenv().ESPAPI.SetEnabled(true)
getgenv().ESPAPI.SetTeamCheck(true)
getgenv().ESPAPI.SetMaxDistance(300)
getgenv().ESPAPI.SetFontSize(13)
```

---

## FadeOut

Contrôle le comportement de disparition progressive.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetFadeOnDistance(v)` | `bool` | L'ESP devient transparent selon la distance |
| `SetFadeOnDeath(v)` | `bool` | L'ESP disparaît quand le joueur meurt |
| `SetFadeOnLeave(v)` | `bool` | L'ESP disparaît quand le joueur quitte |

```lua
getgenv().ESPAPI.SetFadeOnDistance(true)
getgenv().ESPAPI.SetFadeOnDeath(false)
getgenv().ESPAPI.SetFadeOnLeave(false)
```

---

## Options

Options générales de comportement.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetFriendCheck(v)` | `bool` | Affiche un tag (F) pour les amis |
| `SetFriendCheckRGB(v)` | `Color3` | Couleur du tag ami |

```lua
getgenv().ESPAPI.SetFriendCheck(true)
getgenv().ESPAPI.SetFriendCheckRGB(Color3.fromRGB(0, 255, 0))
```

---

## Chams

Highlight 3D visible à travers les murs.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetChams(enabled, fillRGB, outlineRGB)` | `bool, Color3?, Color3?` | Active les chams + couleurs optionnelles |
| `SetChamsThermal(v)` | `bool` | Effet de respiration (pulsation de transparence) |
| `SetChamsVisCheck(v)` | `bool` | `true` = visible seulement si pas derrière un mur, `false` = toujours visible |
| `SetChamsFillAlpha(v)` | `number 0–100` | Transparence du fill (0 = opaque, 100 = invisible) |
| `SetChamsOutAlpha(v)` | `number 0–100` | Transparence de l'outline |

```lua
-- Chams rouge toujours visibles, pas de thermal
getgenv().ESPAPI.SetChams(true, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255))
getgenv().ESPAPI.SetChamsThermal(false)
getgenv().ESPAPI.SetChamsVisCheck(false)  -- wallhack
getgenv().ESPAPI.SetChamsFillAlpha(50)
getgenv().ESPAPI.SetChamsOutAlpha(0)
```

---

## Names

Affichage du nom du joueur au-dessus de la box.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetNames(enabled, color)` | `bool, Color3?` | Active les noms + couleur optionnelle |
| `SetNamesRGB(v)` | `Color3` | Change uniquement la couleur |

```lua
getgenv().ESPAPI.SetNames(true, Color3.fromRGB(255, 255, 255))
getgenv().ESPAPI.SetNamesRGB(Color3.fromRGB(255, 165, 0))
```

---

## Healthbar

Barre de vie sur le côté gauche de la box.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetHealthbar(enabled, color)` | `bool, Color3?` | Active la healthbar + couleur texte optionnelle |
| `SetHealthText(v)` | `bool` | Affiche le % de vie en chiffre |
| `SetHealthLerp(v)` | `bool` | Couleur dynamique selon la vie (vert → rouge) |
| `SetHealthTextRGB(v)` | `Color3` | Couleur fixe du texte de vie |
| `SetHealthbarWidth(v)` | `number` | Épaisseur de la barre (défaut: 2.5) |

```lua
getgenv().ESPAPI.SetHealthbar(true)
getgenv().ESPAPI.SetHealthText(true)
getgenv().ESPAPI.SetHealthLerp(true)   -- couleur auto selon hp
getgenv().ESPAPI.SetHealthbarWidth(3)
```

---

## Distances

Affichage de la distance entre toi et le joueur.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetDistances(enabled, pos, color)` | `bool, string?, Color3?` | Active + position + couleur |
| `SetDistancePos(v)` | `"Text"` ou `"Bottom"` | `"Text"` = dans le nom, `"Bottom"` = sous la box |
| `SetDistancesRGB(v)` | `Color3` | Couleur du texte de distance |

```lua
getgenv().ESPAPI.SetDistances(true, "Bottom", Color3.fromRGB(255, 255, 255))
getgenv().ESPAPI.SetDistances(true, "Text")   -- affiche [123m] dans le nom
```

---

## Weapons

Affichage de l'arme tenue par le joueur.

| Fonction | Paramètres | Description |
|---|---|---|
| `SetWeapons(enabled, color)` | `bool, Color3?` | Active les weapons + couleur optionnelle |
| `SetWeaponsRGB(v)` | `Color3` | Couleur du texte weapon |
| `SetWeaponsGradient(v)` | `bool` | Active le dégradé sur le texte weapon |

```lua
getgenv().ESPAPI.SetWeapons(true, Color3.fromRGB(119, 120, 255))
getgenv().ESPAPI.SetWeaponsGradient(true)
```

---

## Boxes

Box 2D autour du joueur. Trois types : Full (rectangle), Corner (coins), Filled (rempli).

| Fonction | Paramètres | Description |
|---|---|---|
| `SetBoxesFull(enabled, color)` | `bool, Color3?` | Rectangle complet autour du joueur |
| `SetBoxesCorner(enabled, color)` | `bool, Color3?` | Coins uniquement (style moderne) |
| `SetBoxesFilled(enabled, alpha, color)` | `bool, number?, Color3?` | Fond semi-transparent dans la box |
| `SetBoxesAnimate(enabled, speed)` | `bool, number?` | Rotation animée du gradient |
| `SetBoxesGradient(enabled, rgb1, rgb2)` | `bool, Color3?, Color3?` | Dégradé sur l'outline |
| `SetBoxesGradFill(enabled, rgb1, rgb2)` | `bool, Color3?, Color3?` | Dégradé sur le fond |
| `SetBoxesSpeed(v)` | `number` | Vitesse de rotation du gradient animé |
| `SetBoxesFilledAlpha(v)` | `number 0–1` | Transparence du fond (0 = opaque, 1 = invisible) |
| `SetBoxesCornerRGB(v)` | `Color3` | Couleur des coins uniquement |

```lua
-- Style corners blanc, fond violet transparent
getgenv().ESPAPI.SetBoxesFull(false)
getgenv().ESPAPI.SetBoxesCorner(true, Color3.fromRGB(255, 255, 255))
getgenv().ESPAPI.SetBoxesFilled(true, 0.8, Color3.fromRGB(119, 120, 255))

-- Style gradient animé
getgenv().ESPAPI.SetBoxesFull(true)
getgenv().ESPAPI.SetBoxesGradFill(true, Color3.fromRGB(119, 120, 255), Color3.fromRGB(0, 0, 0))
getgenv().ESPAPI.SetBoxesAnimate(true, 300)
```

---

## Flags

Texte de flags custom (ex: infos supplémentaires sur le joueur).

| Fonction | Paramètres | Description |
|---|---|---|
| `SetFlags(v)` | `bool` | Active / désactive les flags |

```lua
getgenv().ESPAPI.SetFlags(true)
```

---

## Utilitaires

Fonctions supplémentaires essentielles à une bonne API ESP.

| Fonction | Paramètres | Description |
|---|---|---|
| `Refresh()` | — | Recrée l'ESP pour tous les joueurs actuels |
| `SetPreset(name)` | `string` | Applique un preset complet (`"default"`, `"minimal"`, `"competitive"`, `"rage"`) |
| `GetConfig()` | — | Retourne la table config complète (pour debug ou sauvegarde) |
| `Reset()` | — | Remet tous les paramètres aux valeurs par défaut |

```lua
getgenv().ESPAPI.Refresh()
getgenv().ESPAPI.SetPreset("minimal")
getgenv().ESPAPI.SetPreset("competitive")
getgenv().ESPAPI.SetPreset("rage")

local cfg = getgenv().ESPAPI.GetConfig()
print(cfg.MaxDistance)

getgenv().ESPAPI.Reset()
```

### Presets disponibles

| Preset | Description |
|---|---|
| `"default"` | Paramètres d'origine du script |
| `"minimal"` | Noms + healthbar uniquement, pas de box |
| `"competitive"` | Corners + noms + healthbar, distance dans le nom |
| `"rage"` | Tout activé, chams wallhack, max distance 9999 |

---

## Config directe

Si tu veux modifier un paramètre qui n'a pas de fonction dédiée, accède directement à la table :

```lua
local cfg = getgenv().ESPAPI.Config

-- Exemples
cfg.MaxDistance = 500
cfg.Drawing.Healthbar.GradientRGB1 = Color3.fromRGB(255, 0, 0)
cfg.Drawing.Healthbar.GradientRGB2 = Color3.fromRGB(255, 165, 0)
cfg.Drawing.Healthbar.GradientRGB3 = Color3.fromRGB(0, 255, 0)
cfg.Drawing.Boxes.RotationSpeed = 150
cfg.Options.FriendcheckRGB = Color3.fromRGB(0, 200, 255)
```

---

## Exemples pratiques

### Tout désactiver sauf les chams
```lua
local A = getgenv().ESPAPI
A.SetBoxesFull(false)
A.SetBoxesCorner(false)
A.SetBoxesFilled(false)
A.SetNames(false)
A.SetHealthbar(false)
A.SetDistances(false)
A.SetWeapons(false)
A.SetFlags(false)
A.SetChams(true, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 255))
A.SetChamsVisCheck(false)  -- wallhack
```

### Style minimaliste
```lua
local A = getgenv().ESPAPI
A.SetPreset("minimal")
-- ou manuellement :
A.SetBoxesFull(false)
A.SetBoxesCorner(true, Color3.fromRGB(255, 255, 255))
A.SetBoxesFilled(false)
A.SetNames(true, Color3.fromRGB(255, 255, 255))
A.SetHealthbar(true)
A.SetHealthLerp(true)
A.SetDistances(true, "Text")
A.SetWeapons(false)
A.SetChams(false)
```

### Style rage (tout visible, longue distance)
```lua
local A = getgenv().ESPAPI
A.SetEnabled(true)
A.SetMaxDistance(9999)
A.SetTeamCheck(false)
A.SetChams(true, Color3.fromRGB(255, 0, 0), Color3.fromRGB(255, 255, 0))
A.SetChamsThermal(false)
A.SetChamsVisCheck(false)
A.SetBoxesFull(true, Color3.fromRGB(255, 0, 0))
A.SetBoxesCorner(true, Color3.fromRGB(255, 255, 0))
A.SetBoxesFilled(true, 0.85, Color3.fromRGB(255, 0, 0))
A.SetNames(true, Color3.fromRGB(255, 255, 255))
A.SetHealthbar(true)
A.SetHealthLerp(true)
A.SetDistances(true, "Bottom")
A.SetWeapons(true, Color3.fromRGB(255, 165, 0))
```

---

> **Note :** Toutes les couleurs utilisent `Color3.fromRGB(r, g, b)` avec des valeurs entre 0 et 255.  
> Les paramètres marqués `?` sont optionnels — si non fournis, la valeur actuelle est conservée.
