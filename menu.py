menu

def menu():
    option = -1
    while option != 0:
        print("1. Somar")
        print("2. Subtrair")
        print("3. Multiplicar")
        print("4. Dividir")
        print("0. Sair")



 option = int(input("Escolha uma opção: "))

     if option == 1:
            print("Soma")
        elif option == 2:
            print("Subtração")
        elif option == 3:
            print("Multiplicação")
        elif option == 4:
            print("Divisão")
