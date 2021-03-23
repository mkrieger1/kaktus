import random, strutils, strformat

randomize()

type
  Rechenart = enum
    Plus
    Minus
    Mal

  Rechenoperation = proc (a, b: int): int {.noSideEffect.}

  Aufgabe = object
    symbol: char
    rechnung: Rechenoperation

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
  else:
    echo "falsch :("

stellAufgabe()
