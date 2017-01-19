# Tafel Taferelen
Dé app voor al jouw dinner plannen! 

**Daily Process** 

# day 2
- definitieve plan voor App staat vast 
- Design is beschreven per UI view controller 
- Firebase account aangemaakt 
- Begonnen met code schrijven voor new account aanmaken 
- Probleem waar ik nu tegen aan loop: 
  * Hoe ik een profiel foto makkelijk kan opslaan in Firebase 
  * photolibrary werkend krijgen in de app 

planning voor morgen: 

Deze problemen morgen oplossen + Overzichtelijk schema maken voor DESIGN.md 

# day 3
- Vandaag nieuw account aanmaken gelukt met profiel foto + wordt juist opgeslagen 
- Schema gemaakt voor DESIGN.md + toegevoegd 
  * In design wel tegen het probleem aangelopen dat ik niet goed weet hoe ik groepen kan gaan aanmaken en dat vrienden elkaar kunnen toevoegen 

Planning voor morgen: 

Alle view controllers aanmaken 
Nadenken over opmaak van de app en waar mogelijk al mooi maken 
Code schrijven om gebruikers in te loggen 

# day 4
- Vandaag bijna alle view controllers aangemaakt (op 'groep maken' na) 
- Opmaak app redelijk gelukt, al gaat er wss nog wel veel aangepast worden 
- Gebruikers kunnen nu inloggen 
- Nieuw Probleem: 
  * chatten binnen 'groep' mogelijk maken
  * wss doen met Firebase 
  * hoe krijg ik de Imassege icoontjes? 

Planning voor morgen: 

view controller voor groepen aanmaken 
uitzoeken hoe ik chatten kan laten werken 
proberen of ik proefielfoto kan laten zien binnen 'account' van gebruiker 

# day 5
- profielfoto kunnen laten zien binnen account
- Tijdens presentatie op probleem gekomen hoe ik het voor elkaar ga krijgen dat er verschillende groepen zijn binnen gebruikers
- Nieuw Probleem: 
  * chatten binnen 'groep' (nog steeds) mogelijk maken
  * wss doen met Firebase 
  * hoe krijg ik de Imassege icoontjes? 

Planning voor maandag:

Datascructuur juist krijgen om groepen aan te kunnen maken 
Groepen aan kunnen maken 
Alles juist opslaan in fire base 

# day 6
- groepen kunnen aangemaakt worden! 
- firebase structuur klopt 
  * is nog wel wat omslachtig dus kijken of dit sneller/ makkelijker kan 
- kan ook data lezen vanuit de groepen 
- naam/ pf in beeld gekregen in tableview voor nieuwe groep 

Planning voor Dinsdag:

Alle info vanuit 'groepen' inlezen in hoofdscherm 
zorgen dat view voor wann groep bestaat up to date is (dus daar ook pf/ naam van alle members) 
alert functie schrijven die gebruikbaar is voor alle views 

# day 7
- als groepen aangemaakt zijn kunnen nieuwe gebruikers toegevoegd worden
- op meeste plekken waar nodig is staat alert functie die werkt 
- info over het diner kan gewijzigd worden 
- groepinfo tabel werkt ook 
  * probleem is dat de groepinfo tabel niet altijd goed wordt laten zien 
   denk dat dit ligt aan firebase omdat niet alle gebruikers nu dezelfde variabele hebben (MORGEN CHECKEN) 
  * probleem van vandaag was het kunnen bepalen of een gebruiker bestaat, en zo ja of die al in een groep zit 
  * uiteindelijk opgelost door losse functies te maken en die omstebeurt aan te roepen 

Planning voor Woensdag:

Probleem met deelnemers tableview oplossen. Alles er iets mooier uit gaan laten zien 
Beginnen met het maken van de chat. 

# day 8
- !! probleem met deelnemers tableview is nog niet opgelost 
- Chat werkt soort van, berichten kunnen geplaatst worden en gelezen 
 * ziet er vooral nog heel lelijk uit, dus morgen verder met dit aanpassen 

 * Probleem vandaag was vooral met de chat, doordat het in de firebase database lastig was op te slaan. heb nu unieke chatID en uniek   bericht ID. Hiermee werkt het wel. alleen nog kijken hoe ik het goed kan laten zien in app zelf 
 * nu heb ik als afzender userID, dit moet veranderd worden naar naam of naar foto (naam lijkt me makkelijker) 

Planning voor Woensdag:

chat goed werkend krijgen en er mooi uit laten zien. Wanneer ik tijd over heb hele database wissen en kijken of probleem met tableview voor het laten van groepen dan is opgelost. 


# day 9
- !! probleem met deelnemers tableview is nog niet opgelost 
- uitloggen werkt 
- gebruikers kunnen hun wachtwoord resetten 
- tableview voor chat zie je nu wel goed 
- MAAR PLUS PUNT: alle functie's die werken wel zo goed als (hier en daar wat bugs) 
 PROBLEEM: vind mn app er vooral heel lelijk uitzien. Wil de chat mooier maken, iets anders dan overduidelijke tableview. En nu gaan nadenken over hoe ik het hoofdmenu er mooi wil laten uitzien. 
 
Planning: 

Morgen presenteren en proberen de app er mooier uit te gaan laten zien.
 
 





