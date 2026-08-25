# Traducción al español — Pokémon Oro, Plata y Cristal (gen1recomp)

Mod de traducción al español para **Pokémon Gold, Silver y Crystal** en
[**gen1recomp**](https://github.com/bryanthaboi/gen1recomp) (el remake/remaster
que corre Pokémon Rojo/Azul/Amarillo y los Gen 2 a través de un motor unificado).

> **Versión del mod:** `v0.1.0`
> **Juegos:** Oro · Plata · Cristal

![cover]()

---

### 📍 Hogar del proyecto

Este repositorio es **la única casa** de las traducciones al español de gen1recomp
(Rojo/Azul/Amarillo y Oro/Plata/Cristal). Las próximas versiones se suben here,
como **actualizaciones del mismo mod** (nombre fijo, versión incrementada) sin
crear repos ni nombres nuevos. Cada mod tiene su carpeta y su release `.zip`.

- [Changelog](CHANGELOG.md) — historial de cambios de todos los mods.

---

## Descripción

Este mod traduce al español **todos los diálogos, menús, nombres, estados de
batalla, radio del Pokegear y pantalla de nombres** de Pokémon Oro, Plata y
Cristal. Incluye también la **intro del Profesor Oak** y los diálogos propios
del Cristal (móvil/Pokegear, historia de Suicune, CRIATURAS, etc.).

Está construido sobre el sistema de mods de `pokemon-love2d` (Mod API 2), por
lo que se instala como cualquier otro mod y **convive** con los demás (sprites,
música, UI, etc.).

## Características

- ✅ **Diálogos** de Oro, Plata y **Cristal** traducidos (99,2 % de cobertura).
- ✅ **Intro del Profesor Oak** en español (vía `intro.oak_speech`).
- ✅ **Nombres de movimientos, objetos y entrenadores**.
- ✅ **Estados de batalla** (PSN, BRN, …) en el HUD.
- ✅ **Emisoras de radio** del Pokegear.
- ✅ **Nombres de lugares** del mapa y **decoraciones** de la habitación.
- ✅ **Cadenas del motor** (batalla, menús, Pokémon Center, etc.).
- ✅ **Fuente personalizada** con glifos españoles (letras acentuadas).
- ✅ **Pantalla de nombres** con acentos.
- 🐶 Los **nombres de Pokémon** se mantienen en inglés (idénticos en ambos
  idiomas y así se conservan las búsquedas/Pokédex).

## Instalación

1. **Descarga** el `.zip` desde *Releases*.
2. **Desactiva** cualquier otra traducción de Oro/Plata (p. ej. un mod
   `translation-es-goldsilver`) para evitar traducciones duplicadas.
3. **Extrae** el contenido del `.zip` en la carpeta de mods de gen1recomp:
   ```
   <gen1recomp>/.local/share/pokemon-love2d/mods/translation-es-goldilvercrystal/
   ```
   (el zip ya trae la raíz plana: `manifest.json`, `main.lua`, `lang/`, `assets/`).
4. En el **lanzador de mods** de gen1recomp, **activa** `translation-es-goldilvercrystal`.
5. Inicia el juego (Oro, Plata o Cristal) y listo. ✅

### Alternativa (gestor de mods)
Si tu gen1recomp tiene un gestor de mods con "instalar desde zip", úsalo para
importar el `.zip` directamente.

## Compatibilidad

- **Juegos:** Gold, Silver, Crystal (Gen 2).
- **Motor:** gen1recomp (Mod API 2). Recomendado `>= 0.2.0`, probado en la
  versión que ya soporta Gen 2 (Cristal).
- Se aplica la capa de diálogo correcta según el juego que se esté ejecutando
  (`gold` → `gold_dialogue`, `silver` → `silver_dialogue`,
  `crystal` → `crystal_dialogue`).

## Cobertura de la traducción

| Catálogo | Estado |
|---|---|
| `dialogue` (Oro/Plata/Cristal) | 99,2 % |
| `strings` (motor) | ✅ |
| `item_names` / `move_names` / `trainer_names` | ✅ |
| `status_labels` (HUD de estado) | ✅ |
| `radio_channels` / `landmarks` / `decorations` | ✅ |
| `naming` (pantalla de nombres) | ✅ |
| `oak_speech` (intro) | ✅ |

**Nota:** unas ~32 cadenas del Cristal (texto del centro móvil POKéCOM no usado
en el Cristal internacional y algún diálogo suelto) quedan en inglés de
*fallback*; el juego es jugable al 100 % en todo momento.

## Créditos

- **Fransis** — traducción y adaptación del mod.
- [**PokeCorpus**](https://github.com/abcboy101/poke-corpus) — textos oficiales
  de los juegos (español) , de los que se extrajeron los diálogos.
- [**gen1recomp**](https://github.com/bryanthaboi/gen1recomp) — motor y sistema
  de mods (incluido `modkit`).

## Licencia

Este mod (las traducciones derivadas de PokeCorpus) se distribuye bajo
**GPL-3.0**. Consulta [LICENSE](LICENSE).

- El contenido de los juegos (texto original en inglés) **no se redistribuye**:
  las traducciones solo llevan los textos en español y las claves del juego, de
  acuerdo con el flujo de `modkit` (el inglés queda solo en la hoja de trabajo
  local, fuera de la publicación).
- El motor gen1recomp es **MIT**; PokeCorpus es **GPL-3.0**.

## Build / regeneración (opcional)

Para regenerar los catálogos desde PokeCorpus y el dataset de gen1recomp:

1. Clonar `bryanthaboi/gen1recomp` y `abcboy101/poke-corpus`.
2. Volcar el `text.lua` del dataset de Cristal (offsets → inglés) con `luajit`.
3. Emparejar el inglés con el corpus español normalizando los marcadores
   (`<LINE>` → `\n`, `<PARA>` → `\012`, `<CONT>` → `\011`, `#MON` → `POKéMON`, …).
4. Escribir `lang/crystal_dialogue.lua` y empaquetar con `modkit pack`.
