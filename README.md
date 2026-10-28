# German Names Mod

## Deutsche Namen für Dorfbewohner in Foundation

Dieser Mod ersetzt die Standard-Namenslisten von Foundation durch deutsche bzw.
deutsch klingende Namen mit mittelalterlich wirkenden Spitznamen.

Seit Version 1.1.0 überschreibt der Mod alle aktuellen Foundation-`NAME_LIST_*`
Assets, darunter `NAME_LIST_GERMAN`.

## Kompatibilität

Stand 28.10.2026: Die neueste in den offiziellen Steam-Ankündigungen aufgeführte
Version ist **Foundation 1.12.0.16** (23.10.2026). Die acht überschriebenen
Asset-IDs und die Eigenschaften `MaleNameList` / `FemaleNameList` stimmen mit
der aktuellen Modding-Dokumentation überein. Im Changelog für 1.12 ist keine
Änderung dieser Schnittstelle aufgeführt. Eine Anpassung des Mod-Codes ist
nach diesem Abgleich nicht erforderlich.

Der Lua-Ausführungstest prüft den echten Einstiegspunkt mit einer simulierten
Foundation-API, alle acht Overrides und jeweils 5000 gültige Namen pro
Geschlecht, einschließlich der Randwerte der Zufallsauswahl. Das bestätigt
die Skriptfunktion, ersetzt aber keinen Test im Spiel. Das Laden unter
1.12.0.16 sowie Namen neu einwandernder Dorfbewohner sind noch im Spiel zu prüfen.
Andere Mods, die dieselben Namenslisten überschreiben, können das Ergebnis
beeinflussen.

Quellen:

- [Offizielle Updates](https://steamcommunity.com/app/690830/announcements/)
- [NAME_LIST-Assets](https://www.polymorph.games/foundation/modding/assets/name_list)
- [NAME_LIST-Eigenschaften](https://www.polymorph.games/foundation/modding/api/name_list)
- [Modding-Changelog 1.12](https://www.polymorph.games/foundation/modding/changelog/1.12)

Beispiele:

```text
Rosa die Goldene
Klaus der Graue
Maximilian Goldlocke
Christiane Schafhirt
Philip der Freudige
Tilda Krähenblick
Max der Einfache
```

Das Spiel wird beim Start mit jeweils 5000 Männer- und Frauennamen versorgt.
In seltenen Einzelfällen können Namen doppelt vergeben werden.

## Installation

Der Mod kann direkt aus dem Mod-Menü in Foundation heruntergeladen und
installiert werden. Dieser Ordner enthält den Quelltext für mod.io.

Das aktuelle GitHub-Paket ist **v1.1.0**:
[german_names_mod_v1.1.0.zip](https://github.com/elsni/german_names_mod/releases/download/v1.1.0/german_names_mod_v1.1.0.zip).
Das ZIP enthält die Mod-Dateien direkt im Hauptverzeichnis, einschließlich
`generated_ids.lua` und aller Namenslisten unter `scripts/name_data/`.

## Entwicklung

Die Mod-Struktur folgt der aktuellen Foundation-Dokumentation:

- `mod.json` enthält die früh geladenen Metadaten.
- `mod.lua` ist der Einstiegspunkt.
- `scripts/name.lua` erzeugt die Namen und überschreibt die Foundation-Assets.
- `scripts/name_data/` enthält die Namens- und Spitznamenlisten.
- `generated_ids.lua` wird mit ausgeliefert, damit Asset-IDs stabil bleiben.

Führe vor einem Release die lokale Validierung aus:

Lua-Ausführungstest (Lua 5.4, aus dem Projektverzeichnis):

```sh
lua tests/test_mod.lua
```

Zusätzliche Strukturprüfung unter Windows/PowerShell:

```powershell
powershell -ExecutionPolicy Bypass -File tests/validate_mod.ps1
```

## Links

[Download mod from mod.io](https://mod.io/g/foundation/m/german-villager-names)
