# READY, SET, DINNER
Dé app voor al jouw diner plannen! 

Femke van Son 
105331176 

In opdracht van: [Minor programmeren Universiteit van Amsterdam](http://www.mprog.nl)

Eindproject jan 2017 

## Concept 

Dit is dé app om ervoor te zorgen dat jij en je vrienden/ familie door alle drukte heen elkaar nog steeds kunnen zien. 
En niet alleen maar via de telefoon. Met 1 minuutje werk hebben jij en je vrienden een eigen omgeving gecreëerd waarin diners kunnen worden gepland, menu’s worden besproken en zelfs een tafelschikking kan worden gemaakt.

**Ready, Set, DINNER!** 

## De App 

Binnen de app is het mogelijk om een account aan te maken om vervolgens een groep te vormen met maximaal 10 vrienden. Wanneer je in een groep zit kan je een datum. locatie en chef kiezen voor jullie volgende diner. De datum kan eenvoudig worden opgeslagen in je agenda om het plannen van het diner zo makkelijk mogelijk te houden. Op het hoofdscherm kan je jezelf aanwezig klikken aan de diner tafel. De gebruiker kan ten alle tijden uit de groep stappen, nieuwe gebruikers toevoegen of andere gegevens veranderen. 

![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.42.13.png)![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.34.52.png)

![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.30.43.png)![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.34.34.png)
![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.31.02.png)![ScreenShot](https://raw.github.com/10533176/Tafel-Taferelen/master/doc/Schermafbeelding 2017-02-02 om 11.34.14.png)

## Copyright
© Femke van Son. Alle rechten voorbehouden. Tenzij anders vermeld berusten alle rechten van de documenten in deze repository bij Femke van Son. Zie LICENSE.md voor verdere informatie.

## Better Code Hub 

[![BCH compliance](https://bettercodehub.com/edge/badge/10533176/TafelTaferelen)](https://bettercodehub.com)

# Installation of the Project

- Download xcode 8.1
- Create a [Firebase](https://firebase.google.com) Account and create a new project 
  * use the following settings (FireBase -> database -> rules): 
      {
      "rules": {
        ".read": true,
        ".write": true
      }
    }
    
- Download the GitHub project 
- Open project directory in terminal 
- Enter 'pod install' in terminal 
- Open the project workspace 
- download and insert the 'GoogleService-Info.plist' from Firebase in the Xcode project
- run the project on iphone 6 screen




