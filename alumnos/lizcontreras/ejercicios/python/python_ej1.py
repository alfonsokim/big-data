#!/usr/bin/env python

def fibonacci(x):
  if n == 0:
    return 0
  elif n == 1:
    return 1
  else:
    return fibonacci(n-1) + fibonacci(n-2)

if __name__ == "__main__":
  import sys
  x = int(sys.argv[1])
  print fibonacci(x)
