#### Konfigurace

**Vstupni tabulka** - na vstupu je ocekavana prave 1 tabulka libovolneho jmena (komponenta v ni i zpetne updatuje zaznamy).
Vstupni tabulka musi obsahovat minimalne tyto sloupce: `JSON_FILE_NAME`, `STATUS`, `RETURN_CODE`, `LAST_CHANGE_DATETIME`

**Vstupni JSON soubory**

Je na uzivateli aby definoval input mapping tak, ze zahrne vsechny JSON soubory, ktere jsou definovane ve sloupci `JSON_FILE_NAME` vstupni tabulky, v opacnem pripade validace selze. 
Input mapping muze vlozit vice souboru stejneho jmena, aplikace zpracuje vzdy ten nejaktualnejsi.