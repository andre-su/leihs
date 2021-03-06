# language: de

Funktionalität: Werteliste

  Um eine konforme Werteliste aushändigen zu können
  möchte ich als Verleiher
  das mir das System für eine Auswahl eine Werteliste zur verfügung stellen kann

  Grundlage:
    Angenommen Personas existieren
    Und man ist "Pius"
    Und man öffnet eine Werteliste

  @javascript
  Szenario: Was ich auf der Werteliste sehen möchte
    Dann möchte ich die folgenden Bereiche in der Werteliste sehen:
    | Bereich          |
    | Datum            |
    | Titel            |
    | Ausleihender     |
    | Verleier         |
    | Liste            |

  @javascript
  Szenario: Der Inhalt der Werte-Liste
    Dann beinhaltet die Werte-Liste folgende Spalten:
    | Spaltenname     |
    | Laufende Nummer |
    | Inventarcode    |
    | Modellname      |
    | End Datum       |
    | Anzahl          |
    | Wert            |
    Und die Modelle in der Werteliste sind alphabetisch sortiert
