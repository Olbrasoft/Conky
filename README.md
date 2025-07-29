# Conky

Kolekce Conky konfigurací pro Linux desktop.

## Projekty

### conky-grapes

Pokročilá Conky konfigurace s lua skripty, která zobrazuje systémové informace v podobě grafických kruhů.

![Náhled](conky-grapes/conky.png)

#### Funkce
- Monitoring teploty, 8 CPU (až 16 jader) každý kruh 2 thready, disků (až 3 filesystémy), paměti (RAM a swap)
- Síťové statistiky (automatický výběr výchozího rozhraní)
- Informace o baterii (pokud je k dispozici)
- Vizuální upozornění na vysokou teplotu, nízké místo na disku a slabou baterii
- Přednastavené barevné schéma s možností přizpůsobení
- Možnost výběru různých barev pro kruhy, titulky sekcí a text

#### Požadavky
- conky-full
- Fonty: Michroma.ttf, Play-Bold.ttf, Play-Regular.ttf (součástí projektu)

#### Instalace a použití
1. Nainstalujte conky-full
2. Naklonujte nebo zkopírujte conky-grapes do ~/conky/conky-grapes
3. Nainstalujte fonty z projektu
4. Použijte `create_config.py` pro generování konfigurace (použijte `-h` pro nápovědu)
5. Spusťte Conky s vygenerovanou konfigurací

Více informací najdete v [dokumentaci conky-grapes](conky-grapes/README.md).

## Licence

Projekty v této kolekci jsou dostupné pod různými licencemi - viz jednotlivé projekty pro detaily.
