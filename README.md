# German Names Mod

## Deutsche Namen fuer Dorfbewohner in Foundation

Dieser Mod ersetzt die Standard-Namenslisten von Foundation durch deutsche bzw.
deutsch klingende Namen mit mittelalterlich wirkenden Spitznamen.

Seit Version 1.1.0 ueberschreibt der Mod alle aktuellen Foundation-`NAME_LIST_*`
Assets, darunter `NAME_LIST_GERMAN`. Dadurch funktioniert er auch mit aktuellen
Foundation-Versionen, die mehrere sprachspezifische Namenslisten verwenden.

Beispiele:

```text
Rosa die Goldene
Klaus der Graue
Maximilian Goldlocke
Christiane Schafhirt
Philip der Freudige
Tilda Kraehenblick
Max der Einfache
```

Das Spiel wird beim Start mit jeweils 5000 Maenner- und Frauennamen versorgt.
In seltenen Einzelfaellen koennen Namen doppelt vergeben werden.

## Installation

Der Mod kann direkt aus dem Mod-Menue in Foundation heruntergeladen und
installiert werden. Dieser Ordner enthaelt den Quelltext fuer mod.io.

## Entwicklung

Die Mod-Struktur folgt der aktuellen Foundation-Dokumentation:

- `mod.json` enthaelt die frueh geladenen Metadaten.
- `mod.lua` ist der Einstiegspunkt.
- `scripts/name.lua` erzeugt die Namen und ueberschreibt die Foundation-Assets.
- `scripts/name_data/` enthaelt die Namens- und Spitznamenlisten.
- `generated_ids.lua` wird mit ausgeliefert, damit Asset-IDs stabil bleiben.

Fuehre vor einem Release die lokale Validierung aus:

```powershell
powershell -ExecutionPolicy Bypass -File tests/validate_mod.ps1
```

## Links

[Download mod from mod.io](https://mod.io/g/foundation/m/german-villager-names)
