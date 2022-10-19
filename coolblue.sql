SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';


CREATE SCHEMA IF NOT EXISTS `Coolblue` DEFAULT CHARACTER SET utf8 ;
USE `Coolblue` ;

-- -----------------------------------------------------
-- Table `Coolblue`.`Klant`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Klant` (
  `klant_ID` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(255) NOT NULL,
  `adres` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`klant_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Categorie`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Categorie` (
  `categorie_ID` INT NOT NULL AUTO_INCREMENT,
  `naam` VARCHAR(255) NOT NULL,
  `omschrijving` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`categorie_ID`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Magazijn`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Magazijn` (
  `magazijn_ID` INT NOT NULL AUTO_INCREMENT,
  `adres` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`magazijn_ID`)
)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Product`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Product` (
  `prod_ID` INT NOT NULL AUTO_INCREMENT,
  `categorie_ID` INT NOT NULL,
  `magazijn_ID` INT NOT NULL,
  `naam` VARCHAR(255) NOT NULL,
  `omschrijving` VARCHAR(255) NOT NULL,
  `prijs` DECIMAL(10,2) NOT NULL,
  `voorraad` INT(3) NOT NULL,
  `bedrijf` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`prod_ID`),
  INDEX `fk_Product_Category1_idx` (`categorie_ID` ASC) VISIBLE,
  INDEX `fk_Producten_Magazijn1_idx` (`magazijn_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_Category1`
    FOREIGN KEY (`categorie_ID`)
    REFERENCES `Coolblue`.`Categorie` (`categorie_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Producten_Magazijn1`
    FOREIGN KEY (`magazijn_ID`)
    REFERENCES `Coolblue`.`Magazijn` (`magazijn_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
    ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Orders` (
  `order_ID` INT NOT NULL AUTO_INCREMENT,
  `prod_ID` INT NOT NULL,
  `klant_ID` INT NOT NULL,
  `order_datum` DATE NOT NULL,
  `kwantiteit` INT(3) NOT NULL,
  `prijs` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`order_ID`),
  INDEX `fk_Product_copy1_Product1_idx` (`prod_ID` ASC) VISIBLE,
  INDEX `fk_Orders_Klanten1_idx` (`klant_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Product_copy1_Product1`
    FOREIGN KEY (`prod_ID`)
    REFERENCES `Coolblue`.`Product` (`prod_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_Klanten1`
    FOREIGN KEY (`klant_ID`)
    REFERENCES `Coolblue`.`Klant` (`klant_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Bestelling`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Bestelling` (
  `bestelling_ID` INT NOT NULL AUTO_INCREMENT,
  `klant_ID` INT NOT NULL,
  `bezorg_adres` VARCHAR(255) NOT NULL,
  `prijs_totaal` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`bestelling_ID`),
  INDEX `fk_Bestelling_Klanten1_idx` (`klant_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Bestelling_Klanten1`
    FOREIGN KEY (`klant_ID`)
    REFERENCES `Coolblue`.`Klant` (`klant_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Bezorger`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Bezorger` (
  `bezorger_ID` INT NOT NULL AUTO_INCREMENT,
  `magazijn_ID` INT NOT NULL,
  `naam` VARCHAR(255) NOT NULL,
  `adres` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`bezorger_ID`),
  INDEX `fk_Bezorgers_Magazijnen1_idx` (`magazijn_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Bezorgers_Magazijnen1`
    FOREIGN KEY (`magazijn_ID`)
    REFERENCES `Coolblue`.`Magazijn` (`magazijn_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Inpakker`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Inpakker` (
  `inpakker_ID` INT NOT NULL AUTO_INCREMENT,
  `magazijn_ID` INT NOT NULL,
  `naam` VARCHAR(255) NOT NULL,
  `adres` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`inpakker_ID`),
  INDEX `fk_Bezorgers_Magazijnen1_idx` (`magazijn_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Bezorgers_Magazijnen10`
    FOREIGN KEY (`magazijn_ID`)
    REFERENCES `Coolblue`.`Magazijn` (`magazijn_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Bezorger_bestelling_geschiedenis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Bezorger_bestelling_geschiedenis` (
  `bezorger_ID` INT NOT NULL,
  `bestelling_ID` INT NOT NULL,
  `bezorg_datum` DATE NOT NULL,
  PRIMARY KEY (`bezorger_ID`, `bestelling_ID`),
  INDEX `fk_Bezorger_bestelling_geschiedenis_Bestellingen1_idx` (`bestelling_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Bezorger_bestelling_geschiedenis_Bezorgers1`
    FOREIGN KEY (`bezorger_ID`)
    REFERENCES `Coolblue`.`Bezorger` (`bezorger_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Bezorger_bestelling_geschiedenis_Bestellingen1`
    FOREIGN KEY (`bestelling_ID`)
    REFERENCES `Coolblue`.`Bestelling` (`bestelling_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Inpakker_bestelling_geschiedenis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Inpakker_bestelling_geschiedenis` (
  `inpakker_ID` INT NOT NULL,
  `bestelling_ID` INT NOT NULL,
  `bezorg_datum` DATE NOT NULL,
  PRIMARY KEY (`inpakker_ID`, `bestelling_ID`),
  INDEX `fk_Inpakker_bestelling_geschiedenis_Bestelling1_idx` (`bestelling_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Inpakker_bestelling_geschiedenis_Inpakker1`
    FOREIGN KEY (`inpakker_ID`)
    REFERENCES `Coolblue`.`Inpakker` (`inpakker_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Inpakker_bestelling_geschiedenis_Bestelling1`
    FOREIGN KEY (`bestelling_ID`)
    REFERENCES `Coolblue`.`Bestelling` (`bestelling_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Betaling`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Betaling` (
  `betaling_ID` INT NOT NULL AUTO_INCREMENT,
  `klant_ID` INT NOT NULL,
  `bestelling_ID` INT NOT NULL,
  `betaling_datum` DATE NOT NULL,
  `prijs` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`betaling_ID`),
  INDEX `fk_Betalingen_Klanten1_idx` (`klant_ID` ASC) VISIBLE,
  INDEX `fk_Betalingen_Bestellingen1_idx` (`bestelling_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Betalingen_Klanten1`
    FOREIGN KEY (`klant_ID`)
    REFERENCES `Coolblue`.`Klant` (`klant_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Betalingen_Bestellingen1`
    FOREIGN KEY (`bestelling_ID`)
    REFERENCES `Coolblue`.`Bestelling` (`bestelling_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Orders_bij_bestelling`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Orders_bij_bestelling` (
  `order_ID` INT NOT NULL,
  `bestelling_ID` INT NOT NULL,
  PRIMARY KEY (`bestelling_ID`, `order_ID`),
  INDEX `fk_Orders_bij_bestelling_Bestelling1_idx` (`bestelling_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Orders_bij_bestelling_Order1`
    FOREIGN KEY (`order_ID`)
    REFERENCES `Coolblue`.`Orders` (`order_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Orders_bij_bestelling_Bestelling1`
    FOREIGN KEY (`bestelling_ID`)
    REFERENCES `Coolblue`.`Bestelling` (`bestelling_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Coolblue`.`Klant_bestelling_geschiedenis`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Coolblue`.`Klant_bestelling_geschiedenis` (
  `bestelling_ID` INT NOT NULL,
  `klant_ID` INT NOT NULL,
  `bezorg_datum` DATE NOT NULL,
  `prijs` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`bestelling_ID`, `klant_ID`),
  INDEX `fk_Klant_bestelling_geschiedenis_Bestelling1_idx` (`bestelling_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Klant_bestelling_geschiedenis_Klant1`
    FOREIGN KEY (`klant_ID`)
    REFERENCES `Coolblue`.`Klant` (`klant_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Klant_bestelling_geschiedenis_Bestelling1`
    FOREIGN KEY (`bestelling_ID`)
    REFERENCES `Coolblue`.`Bestelling` (`bestelling_ID`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
