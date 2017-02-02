# RADY, SET, DINNER 
[![BCH compliance](https://bettercodehub.com/edge/badge/10533176/TafelTaferelen)]
(https://bettercodehub.com)

 ![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-01-27 om 14.40.46.png)

To do plan for better code: 

* Viewcontroller Hoofdmenu (als eerst naam  veranderen naar engels) 
  Voor het aanwezig klikken aan tafel heb ik momenteel heel veel verschillende functies, en die functies hebben ongeveer een lengte van 60 regels. 
  Dit moet veel makkelijker kunnen! van het weekend hier naar kijken, mocht het mezelf niet lukken. -> Julian Slacken 
  
* alle (voor zo ver dat logisch is) dubbele code verwijderen. Heb nu heel vaak gekopieerd en geplakt om te kijken of het werkte, 
als het werkte heb ik het vervolgens nooit meer aangepast en zo laten staan 

* iets bedenken waardoor ik informatie van de huidige user kan opslaan (de info die niet veranderd) scheelt met ophalen uit firebase. 

* functies schrijven voor bijvoorheeld het ophalen van groepID. Doe dit nu zo een 15 x in mijn hele project en elke keer doe ik weer hetzelfde 
MOET MAKKELIJKER KUNNEN 

* Dus vooral belangrijk bij mij, FUNCTIES KORTER MAKEN. voor alle if else statements aparte functies maken. HOOFDMENU moet veel eenvoudiger qua code 
duplicates eruit halen, en namen van functies veranderen in meer beschrijvende namen. 


**VERVOLG**
Voor het verbeteren van mijn code ben ik eerst alle dubbele code uit mijn projetc gaan halen. Deze heb ik in een aparte file gezet genaamd extensions.swift. Daarna ben ik al mijn files doorgelopen en gekeken of alles wat er in staat nog nodig was. Alle variabele die ik uiteindelijk toch niet heb gebruikt heb ik weg gehaald etc. 

Hierna heb ik mijn project weer door beteer code gehaald met het volgende resultaat: 

 ![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-01-31 om 14.09.29.png)

Met als conclusie dat mijn functies nog steeds te lang zijn en simpeler moeten worden geschreven. Om dit te realiseren heb ik geprobeerd de funties die alle data ophaald uit FireBase ook in een aparte file te zetten zodat ik deze gemakkelijker in alle viewcontrollers kon aanroepen. Na dit voor een lange tijd te hebben geprobeerd kwam ik erachter dat dat ook niet de oplossing was. Dit omdat de functies al returnen voordat de waarde daadwerkelijk is opgehaald uit Firebase. Na ook nog wat te hebben geprobeerd met Completion blocks, tot de conclusie gekomen dat ik het hiermee ook niet ging redden. 

Daarom uiteindelijk al mijn firebase functies opgesplits in kleinere overzichtelijker functies. Hierdoor is het voor een buitenstaander nu makkelijker mijn code te lezen en is het voor mij ook makkelijker om wanneer er iets veranderd moet worden ik niet door een functie van 60 lijnen heen moet, maar nu slechts een functie van10 lijnen code. 

Na met julian mijn functies te hebben aangepast voor het aanwezig klikken op tafel (zie final report voor meer uitleg) kwam de volgende score uit bettercode: 

![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.07.20.png)

Als laatste heb ik nog alle namen aangepast om deze meer beschrijvend en ondersteunend te maken. 


