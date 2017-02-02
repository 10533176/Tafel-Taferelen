## READY, SET, DINNER
Dé app voor al jouw dinner plannen! 

Dit is dé app om ervoor te zorgen dat jij en je vrienden/ familie door alle drukte heen elkaar nog steeds kunnen zien.  
Met 1 minuutje werk hebben jij en je vrienden een eigen omgeving gecreëerd waarin diners kunnen worden gepland, 
menu’s worden besproken en zelfs een tafelschikking kan worden gemaakt. 
Ready, set, DINNER! 

![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.30.43.png)

# DESIGN

![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Design Diagram.png)


_Design Beslissingen_ 

* Verbeter punten volgend project

Voor een volgend programmeer project zal ik van te voren beter nadenken over het design. 
Toen ik begon aan dit project was ik heel enthausiats over het idee en wou zo snel mogelijk alle functionaliteit implementeren. 
Hierdoor heb ik niet altijd gekozen voor de beste en mooiste oplossing, maar vaker voor de snelste oplossing. 
Als ik er nu op terug kijk had ik voor de gebruikers en voor de groepen graag objecten aangemaakt. 
Doordat ik dit nu niet gedaan heb moet ik constant uit Firebase alle informatie ophalen. Los van de dubbele code, 
maakt dit mijn app ook een stuk slomer. Doordat het constant de zelfde informatie in elke view opnieuw moet ophalen. 
Alhoewel mijn app goed werkt, was het gebruikers vriendelijker geweest als die sneller was. En was mijn code ook beter en 
overzichtelijker geweest als ik gebruik had gemaakt van objecten. 

Voor nu is het oke dat alle functies in de viewcontrollers zitten, omdat er met deze verder  niks gedaan gata worden en die nu wle goed werkt. Maar in mijn volgende app ga ik zeker gebruik maken van het MVC model zodat alle functionaliteit niet in de viewcontrollers zit, waardoor het veel makkelijker is om bij ander formaat schermen of andere dingen die veranderd moeten worden in de app aan te passen. 

Ik had dit graag nog gedaan voor deze app maar helaas had ik me dit iets te laat bedacht en was het te kort dag om het allemaal te gaan veranderen. 

* verbeterd tijdens dit project 

Wat ik wel heb verbeterd in de afgelopen vier weken is het schrijven van korte stukke code. In het begin had ik functies van soms wel 70 
lijnen code. Met veel if en if else statements. Deze heb ik (bijna) allemaal om weten te zetten in kortere units code en met minder if/ else statements 
Hierdoor omschrijven de namen van mijn functies voor het grootse gedeelte wat er gebeurd in de code. Hierdoor is het voor anderen nu 
makkelijker om mijn code te lezen. 
En één van de beste verbeteringen in mijn code is het veranderen van de functies rondom het aanwezig klikken op tafel. Doordat ik geen 
andere manier kon bedenken om dit optelossen had ik 10 imageviews gemaakt en 5 functies van ongeveer 40 lijnen code waar vrijwel de hele 
tijd dezelfde dingen gebeuren, maar dan voor een andere imageview. Dankzij de hulp van julian heb ik de 10 imageviews omgezet naar een collection view. Dit scheelt ongeveer 3x de hoeveelheid code van wat het was. En maakt het voor andere een stuk makkelijker om te lezen! 

 
# PROCESS
Het proces van de afgelopen vier weken wat heeft geleid tot mijn eindproduct heeft verschillende fases gekend. 

_Het idee:_ 

De eerste fase was het creëren van een idee. Dit idee is tot stand gekomen omdat het mij opviel dat ik er in mijn omgeving wel altijd pogingen worden gedaan om etentjes met elkaar te plannen, 
maar dit vervolgens maanden kan duren of überhaupt niet gebeurd. Doordat iedereen nu zelfs al te druk is om überhaupt een etentje te plannen, laat staan om daadwerkelijk met elkaar te eten. 
Het is ondertussen algemene kennis wat te veel stress en te weinig sociale contacten met een mens kan doen. Het percentage jongeren wat lijdt aan een depressie, burn out of sociaal isolement blijft groeien. 
Nee wees niet bang, ik heb geen ideologische fantasieën over dat deze app dat percentage gaat verlagen, maar wel dat deze app een tool is om ervoor te zorgen dat jij en je vrienden elkaar iets vaker kunnen zien. 

_De Features_ 

Als oorspronkelijk plan had ik heel veel feautures bedacht die uiteindelijk niet zijn gelukt: 

* datum prikken op zelfde manier als datumprikker.nl
* kunnen chatten met je vrienden om vrijwel zelfde manier als Imasseages 
* wanneer de datum van het diner verlopen is kunnen invoeren wie er hoe veel heeft betaald 
* vervolgens automatisch mail sturen naar alle groepsleden met hoeveel geld ze vershculdigd zijn aan wie 
* In meerdere groepen tegelijker tijd kunnen zitten 
* notificaties krijgen wanneer een groepslid iets veranderd in je groeps gegevens 

Alhoewel ik nog steeds denk dat al deze feautures mijn app echt tot een betere app zouden maken, weet ik ook dat dit me nooit gelukt was binnen 4 weken. Wie weet dat ik dit in de toekomst er nog allemaal bij ga maken. Want dan zou ik wel echt een volledige app hebben en het gebruik van 3 verschillende apps (whatsapp, datumprikker, wiebetaaltwat) beperken tot 1 overzichtelijke app die momenteel nog niet op de markt is. 

De feautures die nu in de app zitten, zijn beperkt, maar werken daarom wel foutloos. En het zijn de noodzakelijke feautures om deze app werkend te krijgen. Daarom ben ik blij met de features die ik voorang heb gegeven waardoor ik nu een bugloze foed werkende app heb die nog steeds iets toevoegd aan het huidige app aanbod. 

_Design_ 

Zie verbeter punten onder kopje design. 

Extra verbeter punt: 
Ik check momenteel of een gebruiker wel bestaat door alle email adressen in een lijst te gooien in firebase. 
Wanneer er een nieuwe gebruiker aan een groep wordt toegevoegd loopt die deze hele lijst door om te checken of die erin zit. 
Voor nu werkt dit prima, maar wanneer deze app echt gebruikt zou gaan worden zou het met een grote email lijst te lang duren om op die manier te checken of de gebruiker bestaat. Voor een volgende keer zou ik dit op een andere manier aanpakken. 

_Vormgeving_ 

Alhoewel we deze app natuurlijk vooral maken voor het leren van goed code schrijven. Vond ik het ook belangrijk dat mijn app er goed uitzou zien en gebruikervriendelijk zou zijn. 
Ik ben begonnen met een vormgeving door afbeeldingen van internet te halen en hiermee geprobeerd een eigen design te maken. 
zie foto's hier onder: 

![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-01-26 om 20.28.55.png)

Doordat de afbeeldingen van internet kwamen waren ze te klein voor de viewcontrollers. Hierdoor zag het er vrij goedkoop en amateuristisch uit. Omdat ik toch heel graag een app wou inleveren waar ik trots op was heb ik in illustrator een eigen design gemaakt die meer past bij het idee van de app. 
Verder heb ik ervoor gekozen om in de app geen landschap view toe te staan. Doordat het in verschillende views dan uberhaupt niet meer mogelijk was om alles in beeld te krijgen, en ik verder geen functionaliteit zag in het kunnen kantelen van je scherm voor deze app heb ik gekozen deze functie uit te zetten. 
Voor het vormgeven van mijn app heb ik rekening gehouden met het formaat van een iphone 6. Door de vullende afbeeldingen en het onleesbaar worden van verschillende labels of foto's zal mijn app alleen goed runnen op een iphone 6/ 7 scherm. 


_Overall Process_ 

Aan het begin ging alles vrij moeizaam en duurde het lang voordat iets werkte. Toen ik de structuur van mijn data in firebase eenmaal had uitgedacht ging dit gelukkig een stuk sneller en kon ik makkelijker functies implementeren. Doordat ik zonder goed na te denken over het design snel functies ben gaan implementeren ben ik niet volleidg tevreden over mijn huidige design. Dit zou ik in de toekomst anders gaan doen. Ook zal ik dan alle features waar ik nu nog niet aan ben toegekomen willen implementeren. 
Ik ben voor mijn app denk ik het langs bezig geweest met het juist werkend krijgen van het aanweizg klikken aan de tafel. Wel heel blij dat ik dit stuk erin heb gelaten omdat het wel echt iets extra's geeft aan mn app. 
Maar uiteindelijk ben ik wel blij met het eindresultaat en vooral dat alle features die er nu inzitten ook echt goed werken! 






