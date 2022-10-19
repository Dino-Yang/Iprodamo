import mysql.connector
from faker import Faker
import random
from mysql.connector import Error


# pickRandom wordt gebruikt voor het genereren van test data
def pickRandom(amount, dataType):
    fake = Faker("nl_NL")
    execute = None
    if dataType == "adres":
        execute = fake.address
    elif dataType == "bedrijf":
        execute = fake.company
    elif dataType == "naam":
        execute = fake.name
    elif dataType == "email":
        execute = fake.ascii_safe_email
    elif dataType == "datum":
        execute = fake.date
    returnList = []
    for i in range(0, amount):
        x = execute()
        while x in returnList:
            x = execute()
        returnList.append(x)
    return returnList


# createMagazijn vult de tabel Magazijn met data
def createMagazijn(curs):
    dataAdres = pickRandom(4, "adres")
    for i in range(0, 4):
        sql = "INSERT INTO magazijn (adres) VALUES (%s)"
        val = [dataAdres[i]]
        curs.execute(sql, val)


# createCategorie vult de tabel Categorie met data
def createCategorie(curs):
    dataNaam = ["Laptops, desktops & monitoren", "Zakelijk", "Gaming",
                "Netwerk"]
    dataOmschrijving = ["Laptops, desktops & monitoren", "Zakelijk producten",
                        "Gaming producten", "Netwerk & internet"]
    for i in range(0, 4):
        sql = "INSERT INTO categorie (naam,omschrijving) VALUES (%s,%s)"
        val = [dataNaam[i], dataOmschrijving[i]]
        curs.execute(sql, val)


# createProduct vult de tabel Product met data
def createProduct(curs):
    amount = 100
    naamGedeelte = ["Lamp-", "Laptop-", "Wifi booster-", "Bureaus-"]
    dataNaam = []
    dataOmschrijving = []
    dataPrijs = []
    dataCategory = []
    dataVoorraad = []
    dataMagazijn = []
    dataBedrijf = pickRandom(amount, "bedrijf")
    for i in range(0, amount):
        x = random.choice(naamGedeelte) + str(random.randint(1, amount))
        dataNaam.append(x)
        dataOmschrijving.append(x)
        dataCategory.append(random.randint(1, 4))
        dataVoorraad.append(random.randint(1, 999))
        dataMagazijn.append(random.randint(1, 4))
        dataPrijs.append(round(random.uniform(1.99, 1999.99), 2))

    for i in range(0, amount):
        sql = "INSERT INTO product (categorie_ID, magazijn_ID, naam, " \
              "omschrijving, prijs, voorraad, bedrijf) VALUES (%s,%s,%s,%s," \
              "%s,%s,%s) "
        val = [dataCategory[i], dataMagazijn[i], dataNaam[i],
               dataOmschrijving[i], dataPrijs[i], dataVoorraad[i],
               dataBedrijf[i]]
        curs.execute(sql, val)


# createKlant vult de tabel Klant met data
def createKlant(curs):
    amount = 100
    dataNaam = pickRandom(amount, "naam")
    dataAdres = pickRandom(amount, "adres")
    dataEmail = pickRandom(amount, "email")
    for i in range(0, amount):
        sql = "INSERT INTO klant (naam,adres,email) VALUES (%s,%s,%s)"
        val = [dataNaam[i], dataAdres[i], dataEmail[i]]
        curs.execute(sql, val)


# createOrder vult de tabel Orders met data
def createOrder(curs):
    amount = 100
    dataProduct = []
    dataKlant = []
    dataDatum = pickRandom(100, "datum")
    dataKwantiteit = []
    dataPrijs = []

    for i in range(0, amount):
        x = random.randint(1, 100)
        aantal = random.randint(1, 10)
        dataProduct.append(x)
        dataKwantiteit.append(aantal)
        curs.execute("SELECT prijs FROM product where prod_ID = " + str(x))
        prijsVanProduct = curs.fetchone()
        dataPrijs.append(prijsVanProduct[0] * aantal)
        dataKlant.append(random.randint(1, 100))

    for i in range(0, amount):
        sql = "INSERT INTO orders (prod_ID,klant_ID,order_datum,kwantiteit, prijs) VALUES (%s,%s,%s,%s,%s) "
        val = [dataProduct[i], dataKlant[i], dataDatum[i], dataKwantiteit[i],
               dataPrijs[i]]
        curs.execute(sql, val)


# calcPrice berekent de attribuut totaal_prijs in de tabel Bestelling
def calcPrice(curs):
    amount = 50

    for i in range(1, amount + 1):
        curs.execute(
            "SELECT order_ID FROM orders_bij_bestelling where bestelling_ID = "
            + str(i))
        listOrders = curs.fetchall()
        prijsVanBestelling = 0
        for x in range(len(listOrders)):
            curs.execute("SELECT prijs FROM orders where order_ID = " + str(
                listOrders[x][0]))
            prijsVanOrder = curs.fetchone()
            prijsVanBestelling += prijsVanOrder[0]
        sql = "UPDATE bestelling SET prijs_totaal = (%s) WHERE bestelling_ID = (%s)"
        val = [prijsVanBestelling, i]
        curs.execute(sql, val)


# createOrder_bij_bestelling vult de tabel Orders_bij_bestelling
def createOrder_bij_bestelling(curs):
    orderList = list(range(1, 101))
    bestellingList = list(range(1, 51))
    orderIndex = 0
    for i in range(len(bestellingList)):
        for x in range(2):
            sql = "INSERT INTO orders_bij_bestelling (order_ID, bestelling_ID) VALUES (%s,%s) "
            val = [orderList[orderIndex], bestellingList[i]]
            orderIndex += 1
            curs.execute(sql, val)


# createBestelling vult de tabel Bestelling
def createBestelling(curs):
    amount = 50
    dataKlantID = []
    dataKlantNaam = []
    dataAdres = []

    for i in range(0, amount):
        x = random.randint(1, 100)
        dataKlantID.append(x)
        curs.execute("SELECT naam FROM klant where klant_ID = " + str(x))
        naamVanKlant = curs.fetchone()
        dataKlantNaam.append(naamVanKlant[0])
        curs.execute("SELECT adres FROM klant where klant_ID = " + str(x))
        adresVanKlant = curs.fetchone()
        dataAdres.append(adresVanKlant[0])

    for i in range(0, amount):
        sql = "INSERT INTO bestelling (klant_ID,bezorg_adres, prijs_totaal) VALUES (%s,%s,%s) "
        val = [dataKlantID[i], dataAdres[i], 1.00]
        curs.execute(sql, val)


try:
    db = mysql.connector.connect(host='localhost',
                                 database='Coolblue',
                                 user='root',
                                 password='root')
    if db.is_connected():
        db_Info = db.get_server_info()
        print("Connected to MySQL Server version ", db_Info)
        cursor = db.cursor()
        cursor.execute("select database();")
        record = cursor.fetchone()
        print("You're connected to database: ", record)
        createMagazijn(cursor)
        createCategorie(cursor)
        createProduct(cursor)
        createKlant(cursor)
        createOrder(cursor)
        createBestelling(cursor)
        createOrder_bij_bestelling(cursor)
        calcPrice(cursor)
        db.commit()
        print("Fake data inserted!")

except Error as e:
    print("Error while connecting to MySQL", e)
finally:
    if db.is_connected():
        cursor.close()
        db.close()
        print("MySQL connection is closed")
