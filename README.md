EDC Validator
=============

Description

**Table of contents:**

[TOC]



## Konfigurace

**Vstupni tabulka** 

Na vstupu je ocekavana prave 1 tabulka libovolneho jmena (komponenta v ni i zpetne updatuje zaznamy).
Vstupni tabulka musi obsahovat minimalne tyto sloupce: `JSON_FILE_NAME`, `STATUS`, `RETURN_CODE`, `LAST_CHANGE_DATETIME`

**Vstupni JSON soubory**

Je na uzivateli aby definoval input mapping tak, ze zahrne vsechny JSON soubory, ktere jsou definovane ve sloupci `JSON_FILE_NAME` vstupni tabulky, v opacnem pripade validace selze. 
Input mapping muze vlozit vice souboru stejneho jmena, aplikace zpracuje vzdy ten nejaktualnejsi.

Output
======

List of tables, foreign keys, schema.

Development
-----------

If required, change local data folder (the `CUSTOM_FOLDER` placeholder) path to
your custom path in the `docker-compose.yml` file:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    volumes:
      - ./:/code
      - ./CUSTOM_FOLDER:/data
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Clone this repository, init the workspace and run the component with following
command:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
git clone git@bitbucket.org:kds_consulting_team/kds-team.app-edc-validator.git kds-team.app-edc-validator
cd kds-team.app-edc-validator
docker-compose build
docker-compose run --rm dev
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Run the test suite and lint check using this command:

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
docker-compose run --rm test
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Integration
===========

For information about deployment and integration with KBC, please refer to the
[deployment section of developers
documentation](https://developers.keboola.com/extend/component/deployment/)
