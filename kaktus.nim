import random, strutils, strformat, times

type
  Rechenart = enum
    Plus
    Minus
    Mal

  Rechenoperation = proc (a, b: int): int {.noSideEffect.}

  Aufgabe = object
    symbol: char
    rechnung: Rechenoperation

  Ergebnis = enum
    Richtig
    Falsch

const
  aufgaben = [
    Plus: Aufgabe(
      symbol: '+',
      rechnung: proc (a, b: int): int = a + b
    ),
    Minus: Aufgabe(
      symbol: '-',
      rechnung: proc (a, b: int): int = a - b
    ),
    Mal: Aufgabe(
      symbol: '*',
      rechnung: proc (a, b: int): int = a * b
    )
  ]

var
  ergebnisse: array[Richtig..Falsch, int]
  startZeit: DateTime

proc nimmZahl: int =
  while true:
    let text = readLine(stdin)
    try:
      return parseInt(text)
    except ValueError:
      echo text, " ist keine Zahl"

proc stellAufgabe =
  let rechenart = rand(Plus..Mal)
  let bereich =
    if rechenart == Mal:
      1..15
    else:
      1..100

  let a = rand(bereich)
  let b = rand(bereich)

  let aufgabe = aufgaben[rechenart]
  let richtig = aufgabe.rechnung(a, b)

  echo fmt"{a} {aufgabe.symbol} {b} = ?"

  if nimmZahl() == richtig:
    echo "richtig :)"
    inc ergebnisse[Richtig]
  else:
    echo "falsch :("
    inc ergebnisse[Falsch]

proc schluss {.noconv.} =
  let dauer = (now() - startZeit).toParts
  echo(
    '\n',
    fmt"{ergebnisse[Richtig]} richtige und " &
    fmt"{ergebnisse[Falsch]} falsche Ergebnisse in " &
    fmt"{dauer[Minutes]}:{dauer[Seconds]:02d} Minuten"
  )
  quit()


randomize()
setControlCHook(schluss)

startZeit = now()
while true:
  stellAufgabe()
