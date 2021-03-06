# language: de

Funktionalität: Modell Eigenschaften

  Grundlage:
    Angenommen Personas existieren
    Und man ist "Mike"

  @javascript
  Szenario: Eigenschaften erstellen
  Angenommen ich erstelle ein Modell und gebe die Pflichtfelder an
  Wenn ich Eigenschaften hinzufügen und die Felder mit den Platzhaltern Schlüssel und Wert angebe
  Und ich die Eigenschaften sortiere
  Und ich das Modell speichere
  Dann sind die Eigenschaften gemäss Sortierreihenfolge für dieses Modell gespeichert

  @javascript
  Szenario: Eigenschaften editieren
  Angenommen ich editiere ein Modell
  Wenn ich Eigenschaften hinzufügen und die Felder mit den Platzhaltern Schlüssel und Wert angebe
  Und ich bestehende Eigenschaften ändere
  Und ich die Eigenschaften sortiere
  Und ich das Modell speichere
  Dann sind die Eigenschaften gemäss Sortierreihenfolge für das geänderte Modell gespeichert

  @javascript
  Szenario: Eigenschaften löschen
  Angenommen ich editiere ein Modell welches bereits Eigenschaften hat
  Wenn ich eine oder mehrere bestehende Eigenschaften lösche
  Und ich das Modell speichere
  Dann sind die Eigenschaften gemäss Sortierreihenfolge für das geänderte Modell gespeichert