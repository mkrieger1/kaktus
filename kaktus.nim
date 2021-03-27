import random, strutils, strformat, times, math

type
  Rechenart = enum
    Plus
    Minus
    Mal

  Aufgabe = object
    art: Rechenart
    a, b: int

  EingabeArt = enum
    Zahl
    KeineZahl

  Eingabe = object
    case art: EingabeArt
    of Zahl:
      zahl: int
    of KeineZahl:
      text: string

  Nochmal = enum
    NochneAufgabe
    KeineAufgabeMehr

  Ergebnis = enum
    Richtig
    Falsch

  Ergebnisliste = array[Ergebnis, Natural]

proc zufallsAufgabe: Aufgabe =
  let rechenart = rand(Rechenart.low..Rechenart.high)  # TODO macro?
  let bereich =
    if rechenart == Mal:
      1..15
    else:
      1..100
  Aufgabe(art: rechenart, a: rand(bereich), b: rand(bereich))

proc zeige(aufgabe: Aufgabe) =
  let symbol =
    case aufgabe.art:
    of Plus: '+'
    of Minus: '-'
    of Mal: '*'
  echo fmt"{aufgabe.a} {symbol} {aufgabe.b} = ?"

func rechne(aufgabe: Aufgabe): int =
  case aufgabe.art:
  of Plus: aufgabe.a + aufgabe.b
  of Minus: aufgabe.a - aufgabe.b
  of Mal: aufgabe.a * aufgabe.b

proc nimmZahl: Eingabe =
  let text = stdin.readLine
  try:
    Eingabe(art: Zahl, zahl: parseInt(text))
  except ValueError:
    Eingabe(art: KeineZahl, text: text)

proc fragNochmal: Nochmal =
  let text = stdin.readLine
  case text.toLower:
  of "j", "ja":
    NochneAufgabe
  else:
    KeineAufgabeMehr

proc stellAufgabe(ergebnisse: var Ergebnisliste): Nochmal =
  let aufgabe = zufallsAufgabe()
  let richtig = rechne aufgabe
  zeige aufgabe

  let eingabe = nimmZahl()
  case eingabe.art:
  of Zahl:
    if eingabe.zahl == richtig:
      echo "richtig :)"
      inc ergebnisse[Richtig]
    else:
      echo "falsch :("
      inc ergebnisse[Falsch]
    NochneAufgabe
  of KeineZahl:
    echo eingabe.text, " ist keine Zahl. Nochmal?"
    fragNochmal()

func score (ergebnisse: Ergebnisliste, dauer: Duration): float =
  ergebnisse[Richtig].float.pow(1.5) / dauer.inMilliseconds.float * 1e6

func alsMinuten (dauer: Duration): string =
  let parts = dauer.toParts
  fmt"{parts[Minutes]}:{parts[Seconds]:02d} Minuten"

proc spiel =
  randomize()
  var ergebnisse: Ergebnisliste
  let startZeit = now()
  while stellAufgabe(ergebnisse) == NochneAufgabe:
    discard
  let dauer = now() - startZeit
  echo(
    '\n',
    fmt"{ergebnisse[Richtig]} richtige und " &
    fmt"{ergebnisse[Falsch]} falsche Ergebnisse in " &
    fmt"{dauer.alsMinuten} " &
    fmt"(Score: {score(ergebnisse, dauer):.1f})"
  )

when isMainModule:
  spiel()
