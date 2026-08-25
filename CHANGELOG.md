# Changelog

Cambios de las traducciones al español para gen1recomp. Este proyecto vive (y
se actualiza) en un solo sitio:

> **Repo:** [arcadematicas/traduccion-gen1recomp-pokemon-espa-ol](https://github.com/arcadematicas/traduccion-gen1recomp-pokemon-espa-ol)

El formato sigue [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y
el versionado de cada mod en `manifest.json`.

---

## [0.1.0] — 2026-08-25 — `translation-es-goldilvercrystal`

Primera versión publicada del mod combinado.

### Añadido
- Mod único **`translation-es-goldilvercrystal`** para **Oro, Plata y Cristal**
  (antes Oro/Plata iba aparte y Cristal no existía).
- Capa de diálogo por versión (`GameVersion.get()`): `gold_dialogue`,
  `silver_dialogue` y `crystal_dialogue`.
- **`crystal_dialogue.lua`** (nuevo): 3968/4000 diálogos del Cristal traduccidos
  (99,2 %), reutilizando el español de Oro/Plata para el texto compartido y
  PokeCorpus para lo específico del Cristal.
- **Intro del Profesor Oak** en español (hook `intro.oak_speech.started`).
- Catálogos compartidos (items, movimientos, entrenadores, estados de batalla,
  radio del Pokegear, lugares del mapa, decoraciones, cadenas del motor,
  pantalla de nombres con acentos).

### Corregido
- Saltos de línea/página del Cristal (los `\n`, `\012`, `\011` ahora se
  definen bien; antes el texto "saltaba").

### Fuentes
- Textos de PokeCorpus (`corpus/GoldSilver` y `corpus/Crystal`).

---

## Anteriores (otros mods del mismo repo)

Estos ya existían en el repo y siguen disponibles; se documentan aquí por
trazabilidad:

- `RBY v0.5.1` — traducción Rojo/Azul/Amarillo (`translation-es`).
- `v0.2.0Gold` — `translation-es-gold`.
- `v0.1OroPlata` — `translation-es-goldsilver` (versión Oro/Plata anterior).

> Las próximas versiones se añadirán aquí **en este mismo repo** y subiendo el
> `.zip` como nuevo release (mismo nombre de mod, versión incrementada), sin
> crear repos ni nombres nuevos.
