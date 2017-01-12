# Tafel Taferelen 
Dé app voor al jouw dinner plannen! 

# Design 

**Inloggen/ Nieuw Account** 

Met behulp van FireBase kunnen gebruikers een account aanmaken. 
Bij het aanmaken van een nieuw account zullen er de volgende dingen moeten worden ingevuld: 
- Naam
- Email (deze moet uniek zijn) 
- Wachtwoord 

Wanneer iemand voor het eerst inlogd/ account aanmaakt: 
- optie krijgen om deel te nemen aan een bestaande groep 
- optie krijgen om nieuwe groep aan te maken 

*Probleem:*
Ik zie nog niet helemaal voor me hoe ik groepen met verschillende gebruikers kan aanmaken in firebase. Het liefst een beheerder hebben, 
die elke nieuwe deelnemer die mee wilt doen moet goedkeuren. 
En moet je dan altijd unieke groepsnaam aanmaken? 
En wat is het maximum aaantal deelnemers van een groep 
Hoe kan je vrienden toevoegen aan groep? 
OFTEWEL: uitzoeken hoe ik verschillende vriendengroepen binnen app ga realiseren 

**Hoofdscherm**

Op het hoofdscherm is je groep je zien 
Met volgend gepland dinner 
Tafel met de grootte van je groep 
jezelf kunnen inschrijven voor het diner door op vrije plek aan de tafel te klikken 
- dit doen door stoel als button te maken, wanneer je er op klikt komt er een alert: Wil je je inschrijven voor het diner van "blabla", wanneer voor optie JA wordt gekozen komt de naam van die persoon bij het bordje te staan
Diner specificaties kunnen aanklikken 
- wanneer je hier op klikt wordt je doorverwezen naar het volgende scherm 

- Wanneer er geen diner is gepland is hier een optie om een diner te plannen 
- Hoe ga ik het doen met datum? eerst een datum prikker eraan vooraf? of gewoon altijd de datum kunnen veranderen? 

**Diner specificaties**
Volgende scherm. 
Hier kunnen alle leden van de groep komen. En wijzigingen aanbrengen in alle variablen

- Locatie 
- Kok 
- Menu 
- Chat om menu te bespreken 
  * Uitzoeken hoe ik dit ga doen, met firebase een optie om berichten te sturen en dat andere gebruikers (binnen de groep) ook meteen kunnen zien wat er gebeurd. 
  * Wil ik ook een notificatie sturen als iemand aan het chatten is? 

**Overige opties**
- Mail versturen wanneer account wordt aangemaakt met gegevens 
- Mail versturen als iemand een nieuw diner inplant (OF NOTIFICATIE?)
- voor elkaar krijgen dat als het diner voorbij is (dus de datum) Alle gegevens worden gewist.

Schermafbeelding 2017-01-11 om 19.44.26.png
