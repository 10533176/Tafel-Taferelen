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
- profielfoto kunnen laten zien binnen account (ayanna heeft hiermee geholpen met een tutorial van youtube. LINK: ) 
- Tijdens presentatie op probleem gekomen hoe ik het voor elkaar ga krijgen dat er verschillende groepen zijn binnen gebruikers
- Nieuw Probleem: 
  * chatten binnen 'groep' (nog steeds) mogelijk maken
  na daily standup tip van martijn gekregen om groupen aan te maken met unieke ID en die ook opte slaan bij de user. Proberen of het hiermee lukt! 
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

# day 10
- probleem met deelnemers tableview is opgelost !
vandaag gepresenteerd -> daaruit kwamen de punten 
* nieuwe backbutton maken (vanuit navigationBar)
* iets bedenken wat ik op mijn hoofdscherm wil hebben 
probleem is dat ik de hele tijd twijfel.. vind het oorspronkelijke idee met ana tafel klikken nog wel steeds het leukst. Maar maak me een beetje zorgen om het implementeren van deze optie.
wanneer ik dit doe moet ik wss 10 verschillende buttons maken en image view's en array's en wanneer iemand zijn profiel foto veranderd 
of wanneer iemand de groep verlaat moet deze variable ook een update krijgen. 


# day 11
Vandaag gewerkt aan alle losse kleine dingen die nog niet werkte: 
- gebruikers werden niet goed in nieuwe groep gezet/ verwijderd 
- nu kloppen alle acties omtrent gebruiker toevoegen/ verwijderen wel 
- chat array kwam niet goed inbeeld. Is nu gefixed door tip van julian om Date() te gebruiken als key instead of auth.id 
- keyboard laat zich nu op het juiste moment zien en verbegt zich ook wanneer dat moet 
- wachtwoord veranderen uit de functionaliteit gehaald. had voor mij wienig toegevoegde waarde omdat het wel mogelijk is je password te resetten als je deze kwijt bent 
- bedenken of ik wil toestaan groep naam te veranderen/ email te veranderen. 
 
Planning: 

Morgen echt bedanken hoe ik het hoofdmenu wil hebben. Veel tijd besteden aan de vormgeving. Bedenken hoe ik mijn code opgeruimeder en netter krijg voor hogere score. 
Nadenken of ik extra functionaliteit wil: 
* datum direct in agende kunnen zetten
* notificatie als iemand iets veranders/ toevoegt? 

# day 12
-kan nu datepicker gebruiken voor selecteren datum 
- kan datum opslaan in agenda 
- loading wannee rnog niet geladen --> 
  ** HIER NOG WEL VOOR CHECKEN IN ALLE VIEWS **
- table view kunnen aanvragen als je wilt checken of er nieuwe berichten zijn 

TE DOEN 
- loading verbeteen 
- zorgen dat niet elke afzender Lois is 
- app mooi maken 
- keuze maken voor hoofdmenu 
Probleem van vandaag: 
het toevoegen van de datum in kalender duurde ellendig lang doordat het steeds de verkeerde datum pakte, pakte automatisch de datum van vandaag. of als die degekozen datum ging opslaan was het niet in het juiste formaat. met date.formatter uiteindelijk dit probleem kunnen oplossen. 

 # day 13
 - App nieuw design gemaakt
had eerst foto's van internet gehaald en daarmee logo's en pagina's mee proberen te maken. Maar door lage resoluties zag het er vooral goedkoop uit. 
Daarom uiteindelijk met illustrator eigen design gemaakt met eigen logo. 
- bedacht hoe ik mijn hoofdmenu wil. 
Ookal is het qua code wss niet de makkelijkste oplossing ga ik toch voor de tafel waaraan je jezelf aanwezig kan klikken. Dit wil ik morgen gaan implementeren 
- loading is in alle views verbeterd (geen alert meer, maar in appdelegate nu code waarmee hele view even op freeze wortd gezet) code thanks to ayanna. 
 * wel iets vreemds:* probeerde dit ook in het hoofdmenu, alleen wanneer ik hier dezelfde functies aan roep die in alle andere veiws wel werken kreeg ik hier het probleem dat het beeld nooit van de freeze wordt afgehaald. WANN TIJD OVER: CHECKEN OF IK DIT KAN FIXEN 
 - datum aangepast naar nederlandse versie
 en gekozen om app in het engels te doen, vind het nederlands er lelijk uit zien. Dus ook andere naam bedacht dan TafelTaferelen
 
 
 morgen: 
 - implementeren van code om jezelf op aanwezig te klikken aan tafel 
 
 oude design van de app: 
 
 
 ![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-01-26 om 20.28.39.png)
 ![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-01-26 om 20.28.55.png)
 
 # day 14
 - Gelukt om jezelf aanwezig te klikken aan tafel. MAAR: 
  * probleem: 
  heb heel lang over nagedacht hoe ik dit moets doen. kon uiteindelijk niks anders verzinnen dan dat ik voor elk boord een aparte image view nodig zou hebben 
  om de code enigzins te beperken en om het mogelijk te maken te laten zien heb ik daarom gekozen voor een maximum van een groep van 10. 
  nu heb ik wel lelijke code doordat ik 10 imageviews heb. 
  ook heb ik 10 buttons aangemaakt voor elk bord dat kan worden aangeklikt. Oftewel LELIJKE CODE. zie zelf op dit moment niet hoe ik dit mooier zou kunnen krijgen 
  bij tijd over vragen aan julian/ martijn 
  
  ANDER PROBLEEM: 
  alhoewel je nu mensen aan tafel kan zetten update die nog niet goed wanneer je profiel foto wordt veranderd of wanneer je groep verlaat 
  oplossing morgen maken!! 
  idee: 
  leave group: 
  readin tableSetting --> make an array of tableSetting. --> loop door array heen, if value == pf huidige user, tableSetting[at that point] = "" 
  set new value to tableSetting 
  
  change profile pic:
  before saving 
  readin tableSetting --> make an array of tableSetting. --> loop door array heen, if value == pf huidige user, tableSetting[at that point] = "" EN DAN PAS OPLOSSEN!!
  
  als ik hier tijd voor heb dit morgen doen anders van het weekend 
  
 
  # day 15
  
  * profiel foto wordt veranderd/ verijwderd als je profiel foto veranderd/ groep verlaat. 
  * enige punt is wel dat op een of andere manier er iets geks gebeurd met plek 0 aan de tafel. 
  Wanneer deze leeg is en je op aanwezig klikt wordt deze gevuld met die url, maar dit gebeurd ook op de plek waar je je nieuwe plek aantikt. checken waarom die dit doet. MAAR eerst code mooier maken/ verbeteren. dan pas kleine bugs eruit halen 
  Begin gemaakt aan verslag 
  
  # day 16 
  AAN TAFEL KLIKKEN WERKT! dankzij julian heb ik collections gebruikt, hierdoor is en mijn code 3x zo kort geworden EN is de bug met plek 0 aan de tafel opgelost (kwam door dubbele connectie aan button) DUS nu kan je eindelijk goed ana tafel klikken!
  
  ALLE FILES GECLEANED. door een extension te maken heb ik veel dubbele code weg kunnen halen (van ene 5 voor bettercode zit ik nu op een 8!) heb dit ook geprobeerd voor de procedures van firebase. Ben hier heel lang mee bezig geweest, maar na heel veel google werk en probeer werk erachter gekomen dat dat asynchroon heel kut loopt met (UITLEG STACKOVERFLOW WAAROM DIT NIET KAN) firebase. Dus nu als oplossing apartje functies maken om in de diepe wordtels van firebase te komen. Hierdoor wel minder mooie code, maar het werkt iniedergeval! 
  
 Ook gezorgd dat de chat iets gebruikervriendelijker is, je kan nu scrollen naar boven en zodra je een bericht stuurt, scrollt de tableview weer naar beneden. 
  
 en thanks to lois makkelijke manier gevonden (functie in extensie) om keyboard te verstoppen wanneer er ergens op het beeld wordt getikt voor de login view en sign up view. Uiteindelijk deze ook toegepast bij mijn NewGroup view. (hier giung scherm eerst omhoog) maar vond het er mooier uitzien als je dit gewoon met wegtikken kon doen omdat niet perse het hele scherm in beeld moet blijven voor deze view. 
  
  MORGEN: Verslag schrijven, laatste code check doen. (eventueel nog kijken of ik een laad plaatje erin kan krijgen bij het hoofdmenu) 
  voorderest werkt alles! 
  
  # Day 17 
  
 Vandaag aan het werk aan het verslag, maar nu doet mn tablesetting het niet meer, kan ik geen mensen toevoegen, worden mensen die de groep verlaten niet goed verwijderd. KIJKEN WAAROM ALLES KUT WERKT en optijd oplossen voordat alles morgen ingeleverd moet worden 
 




