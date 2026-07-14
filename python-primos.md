# Script Python — Números Primos 🐍

## Descrição
Script Python que encontra todos os números primos entre 1 e 250 e salva em arquivo.

## Script
```python
primes = []
for num in range(2, 251):
    is_prime = True
    for i in range(2, num):
        if num % i == 0:
            is_prime = False
            break
    if is_prime:
        primes.append(num)

print(primes)

with open('results.txt', 'w') as f:
    for p in primes:
        f.write(str(p) + '\n')
```

## Comandos
```bash
python3 primes.py                      # executa o script
cat results.txt                        # visualiza os resultados
```

## Resultado
Números primos entre 1 e 250:
2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101, 103, 107, 109, 113, 127, 131, 137, 139, 149, 151, 157, 163, 167, 173, 179, 181, 191, 193, 197, 199, 211, 223, 227, 229, 233, 239, 241

## Caminho do arquivo
/home/ec2-user/primes.py
