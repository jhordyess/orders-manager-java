-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: mariadb
-- Generation Time: Sep 06, 2022 at 12:20 AM
-- Server version: 10.4.26-MariaDB-1:10.4.26+maria~ubu2004
-- PHP Version: 8.0.23

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `orders-man`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `aco_empty` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 5 then
      update pedido set acuenta=total(idp) where id=idp;
    ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Si no fue enviado no puede quitarse el saldo';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `aco_envpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 2 then
      update pedido_estado set terminado_in=now(),enviado_in=now() where id=idp;
    ELSEIF idd = 3 then
      update pedido_estado set en_mora_in=null,pendiente_in=now(),terminado_in=now(),enviado_in=now() where id=idp;
    ELSEIF idd = 4 then
      update pedido_estado set enviado_in=now() where id=idp;
    end if;
    call aco_empty(st1);
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `bucll` (IN `st1` NVARCHAR(12), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  SELECT lo.id into idp from producto_clase as lo where lo.nombre=st1 LIMIT 1;
  UPDATE producto_clase as yuy set yuy.habil=rm where yuy.id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `buprro` (IN `st1` NVARCHAR(20), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
  UPDATE producto as yuy set yuy.habil=rm where yuy.id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ccla` (IN `st1` NVARCHAR(12))   BEGIN
SELECT pro.nombre AS co,
pro.habil as hb
from producto_clase as pro
WHERE pro.nombre=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ccla_var` (IN `st1` NVARCHAR(20))   BEGIN
select uve.nombre as nam,uve.grupo as glu,if(iner.id is null,0,1) as sw FROM (select pc.id_variante as id from prodclase_variante as pc inner join producto_clase as ip on ip.id=pc.id_producto_clase where ip.nombre=st1) as iner RIGHT join varis as uve on uve.id=iner.id order by uve.grupo,uve.nombre;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cclvaros` (IN `st1` NVARCHAR(12), IN `tsts` LONGTEXT)   BEGIN
DECLARE front TEXT DEFAULT NULL;
DECLARE frontlen INT DEFAULT NULL;
DECLARE tag TEXT DEFAULT NULL;

DECLARE med TEXT DEFAULT NULL;
DECLARE fronti INT DEFAULT NULL;
DECLARE supa TEXT DEFAULT NULL;

DECLARE gat TEXT DEFAULT NULL;

DECLARE idp int default null;
DECLARE curr int;
IF st1 !='' AND tsts!='' THEN
  SELECT lo.id into idp from producto_clase as lo where lo.nombre=st1 LIMIT 1;
  IF idp is not null THEN
  delete from prodclase_variante where id_producto_clase=idp;
    iterator : LOOP
        IF LENGTH(TRIM(`tsts`)) = 0 OR `tsts` IS NULL THEN
            LEAVE iterator;
        END IF;
        SET front = SUBSTRING_INDEX(`tsts`, ',', 1);
        SET fronti = LENGTH(front);
        SET tag = TRIM(front);

        SET med = SUBSTRING_INDEX(`tag`, ':', 1);
        SET frontlen = LENGTH(med);
        SET supa = INSERT (`tag`, 1, (frontlen+1), '');
        iterar : LOOP
          IF LENGTH(TRIM(`supa`)) = 0 OR `supa` IS NULL THEN
            LEAVE iterar;
          END IF;
          SET gat = SUBSTRING_INDEX(`supa`, '-', 1);
          SET frontlen = LENGTH(gat);
          CALL cclvaro_s(med,gat,idp);
          SET `supa` = INSERT (`supa`, 1, (frontlen+1), '');
        END LOOP;

        SET `tsts` = INSERT (`tsts`, 1, (fronti+1), '');
    END LOOP;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'La clase no existe';
  END IF;
ELSE
  IF tsts='' THEN
    SELECT lo.id into idp from producto_clase as lo where lo.nombre=st1 LIMIT 1;
    select count(id_producto_clase) into frontlen from prodclase_variante where id_producto_clase=idp;
    IF frontlen is not null and frontlen!=0 THEN
      DELETE from prodclase_variante where id_producto_clase=idp;
    END IF;
  else
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cclvaro_s` (IN `clase` TEXT, IN `vari` TEXT, IN `idcla` INT)   BEGIN
DECLARE idm int default null;
DECLARE idga int default null;
IF clase !='' and  vari!='' and idcla is not null THEN
  SELECT lo.id into idm from varis as lo where lo.nombre=vari and lo.grupo=clase LIMIT 1;
  IF idm is null THEN
    SELECT lo.id into idm from variante as lo where lo.nombre=vari LIMIT 1;
    IF idm is null THEN
      select id into idga from variante_clase where nombre=clase LIMIT 1;
      IF idga is null THEN
        INSERT into variante_clase values(null,clase);
        select LAST_INSERT_ID() into idga;
      END IF;
      INSERT into variante values(null,vari,1,idga);
      select LAST_INSERT_ID() into idm;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Variante existente';
    END IF;
  END IF;
  INSERT INTO prodclase_variante values(idcla,idm);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Asociacion erronea';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chdieve` (IN `st1` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE id2 int default null;
DECLARE num int default '0';
IF st1 !='' THEN
  select pc.id into idp from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
  select pc.id into id2 from evento as pc where pc.nombre LIKE st1 LIMIT 1;
  IF id2 is null then
    select pc.id_cliente into id2 from distribuidor as pc where pc.id=idp LIMIT 1;
select pc.recordar into num from distribuidor as pc where pc.id=idp LIMIT 1;

    INSERT INTO evento values(null,st1,num,id2);
    UPDATE pedido_tipo set id_distrib=null,id_evento=LAST_INSERT_ID() WHERE id_distrib=idp;
    DELETE from distribuidor where id=idp;
    
  else
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un evento con ese nombre';
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chdir` (IN `st1` NVARCHAR(50), IN `st2` NVARCHAR(100))   BEGIN
DECLARE idp int default null;
DECLARE id2 int default null;
IF st1 !='' AND st2!='' THEN
 select pc.id into idp from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
select pc.id into id2 from cliente as pc where pc.nombre LIKE st2 LIMIT 1;
  UPDATE distribuidor SET id_cliente=id2 WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chevdi` (IN `st1` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE id2 int default null;
DECLARE num int default '0';
IF st1 !='' THEN
  select pc.id into idp from evento as pc where pc.nombre LIKE st1 LIMIT 1;
  select pc.id into id2 from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
  IF id2 is null then
    select pc.id_cliente into id2 from evento as pc where pc.id=idp LIMIT 1;
select pc.recordar into num from evento as pc where pc.id=idp LIMIT 1;

    INSERT INTO distribuidor values(null,st1,num,id2);
    UPDATE pedido_tipo set id_evento=null,id_distrib=LAST_INSERT_ID() WHERE id_evento=idp;
    DELETE from evento where id=idp;
    
  else
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ya existe un distribuidor con ese nombre';
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `chrep` (IN `st1` NVARCHAR(50), IN `st2` NVARCHAR(100))   BEGIN
DECLARE idp int default null;
DECLARE id2 int default null;
IF st1 !='' AND st2!='' THEN
 select pc.id into idp from evento as pc where pc.nombre LIKE st1 LIMIT 1;
select pc.id into id2 from cliente as pc where pc.nombre LIKE st2 LIMIT 1;
  UPDATE evento SET id_cliente=id2 WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cli` (IN `st1` NVARCHAR(100))   BEGIN
SELECT t.na,t.ci,t.cel,t.eml,t.fac,t.sw FROM clies AS t
WHERE t.`na`=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clidist` (IN `st1` NVARCHAR(100), IN `st2` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
DECLARE idd int default null;
DECLARE idc int default null;
IF st1 !='' AND st2!='' THEN
select pc.id into idc from cliente as pc where pc.nombre LIKE st1 LIMIT 1;
 select pc.id into idd from distribuidor as pc where pc.nombre LIKE st2 AND pc.recordar=rm LIMIT 1;
IF idc is not null THEN
IF idd is null THEN
CALL neDist(st2,rm);
select LAST_INSERT_ID() into idd;
END IF;
UPDATE cliente SET recordar=1 WHERE id=idc;
  UPDATE distribuidor SET id_cliente=idc WHERE id=idd;
ELSE
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No encontrado';
END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `clieven` (IN `st1` NVARCHAR(100), IN `st2` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
DECLARE idd int default null;
DECLARE idc int default null;
IF st1 !='' AND st2!='' THEN
select pc.id into idc from cliente as pc where pc.nombre LIKE st1 LIMIT 1;
 select pc.id into idd from evento as pc where pc.nombre LIKE st2 AND pc.recordar=rm LIMIT 1;
IF idc is not null THEN
IF idd is null THEN
CALL neDist(st2,rm);
select LAST_INSERT_ID() into idd;
END IF;
UPDATE cliente SET recordar=1 WHERE id=idc;
  UPDATE evento SET id_cliente=idc WHERE id=idd;
ELSE
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No encontrado';
END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `cncpp` (IN `st1` NVARCHAR(7), IN `tst` LONGTEXT)   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd < 6 and idd > 0 then
      INSERT INTO pedido_e_cancelado values(idp,now(),null,idd,tst);
    ELSEIF idd = 6 then
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Cont` (IN `st1` NVARCHAR(30))   BEGIN
SELECT t.`name`,t.rem FROM  conts AS t
WHERE t.`name`=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delCont` (IN `st1` NVARCHAR(30))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from medio_contacto as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_medio_con) into cant from pedido where pedido.id_medio_con=idp group by id_medio_con LIMIT 1;
  IF cant=0 then
    DELETE from medio_contacto where id=idp;
  else
    set @jj = CONCAT(cant,' pedidos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delDest` (IN `st1` NVARCHAR(30))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from lugar_destino as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_lugar_des) into cant from pedido where pedido.id_lugar_des=idp group by id_lugar_des LIMIT 1;
  IF cant=0 then
    DELETE from lugar_destino where id=idp;
  else
    set @jj = CONCAT(cant,' pedidos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delPay` (IN `st1` NVARCHAR(30))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from medio_de_pago as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_medio_pag) into cant from pedido where pedido.id_medio_pag=idp group by id_medio_pag LIMIT 1;
  IF cant=0 then
    DELETE from medio_de_pago where id=idp;
  else
    set @jj = CONCAT(cant,' pedidos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `delpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  SELECT lo.id into idp from pedido as lo where lo.recibo_nro=st1;
  IF idp is not null then
    DELETE FROM pedido_e_cancelado where id=idp;
    DELETE FROM pedido_estado where id=idp;
    DELETE FROM pedido_tipo where id=idp;
    DELETE FROM detalle where id_pedido=idp;
    DELETE FROM pedido where id=idp;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Dest` (IN `st1` NVARCHAR(30))   BEGIN
SELECT t.`name`,t.rem FROM  dests AS t
WHERE t.`name`=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dis` (IN `st1` NVARCHAR(50))   BEGIN
SELECT t.`nam`,t.sw FROM dist AS t
WHERE t.`nam`=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dispro` (IN `st1` NVARCHAR(7), IN `tst` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
DECLARE idax int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  select id into idax from distribuidor where nombre=tst limit 1;
  IF idp is not null and idd is not null and idax is not null then
    IF idd = 0 then
      update pedido_tipo set id_evento=null,id_distrib=idax where id=idp;
    ELSEIF idd = 2 then
      update pedido_tipo set id_regular=null,id_distrib=idax where id=idp;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `dtrpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 6 then
      update pedido_e_cancelado set fecha_out=now() where id=idp and fecha_out is null;
    else
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elclien` (IN `st1` NVARCHAR(100))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
DECLARE dos int default null;
IF st1 !='' THEN
  select pc.id,pc.id_tarjeta into idp,dos from cliente as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_regular) into cant from pedido_tipo where pedido_tipo.id_regular=idp group by id_regular LIMIT 1;
  IF cant=0 and dos is null then
    DELETE from cliente where id=idp;
  elseif dos is not null then
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente posee tarjeta';
  else
    set @jj = CONCAT(cant,' pedidos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elcll` (IN `st1` NVARCHAR(12))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from producto_clase as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_producto_clase) into cant from producto where producto.id_producto_clase=idp group by id_producto_clase LIMIT 1;
  IF cant=0 then
    SELECT count(id_producto_clase) into cant from prodclase_variante where prodclase_variante.id_producto_clase=idp group by id_producto_clase LIMIT 1;
    IF cant=0 then
      DELETE from producto_clase where id=idp;
    ELSE
      set @jj = CONCAT(cant,' variantes son dependientes');
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
    END IF;
  else
    set @jj = CONCAT(cant,' productos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elcls` (IN `st1` NVARCHAR(20))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
  UPDATE producto set id_producto_clase=null where id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elcvar` (IN `st1` NVARCHAR(12))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from variante as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_variante) into cant from detalle_variante where detalle_variante.id_variante=idp group by id_variante LIMIT 1;
  IF cant=0 then
    SELECT count(id_variante) into cant from prodclase_variante where prodclase_variante.id_variante=idp group by id_variante LIMIT 1;
    IF cant=0 then
      DELETE from variante where id=idp;
    ELSE
      set @jj = CONCAT(cant,' clases son dependientes');
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
    END IF;
  else
    set @jj = CONCAT(cant,' detalles son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eldist` (IN `st1` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_distrib) into cant from pedido_tipo where pedido_tipo.id_distrib=idp group by id_distrib LIMIT 1;
  IF cant=0 then
    DELETE from distribuidor where id=idp;
  else
    set @jj = CONCAT(cant,' pedidos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eleven` (IN `st1` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  select pc.id into idp from evento as pc where pc.nombre LIKE st1 LIMIT 1;
  SELECT count(id_evento) into cant from pedido_tipo where pedido_tipo.id_evento=idp group by id_evento LIMIT 1;
  IF cant=0 then
    DELETE from evento where id=idp;
  else
    set @jj = CONCAT(cant,' pedidos son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elprro` (IN `st1` NVARCHAR(20))   BEGIN
DECLARE idp int default null;
DECLARE cant int default '0';
IF st1 !='' THEN
  SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
  select count(det.id_producto) into cant from detalle as det where det.id_producto=idp group by det.id_producto limit 1;
  IF cant=0 then
    call prtg(st1,'');
    DELETE from producto where id=idp;
  else
    set @jj = CONCAT(cant,' detalles son dependientes');
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @jj;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elrdist` (IN `st1` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
  IF idp is not null then
    update distribuidor set id_cliente=null where id=idp;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `elreven` (IN `st1` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from evento as pc where pc.nombre LIKE st1 LIMIT 1;
  IF idp is not null then
    update evento set id_cliente=null where id=idp;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `envpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 2 then
      update pedido_estado set terminado_in=now(),enviado_in=now() where id=idp;
    ELSEIF idd = 3 then
      update pedido_estado set en_mora_in=null,pendiente_in=now(),terminado_in=now(),enviado_in=now() where id=idp;
    ELSEIF idd = 4 then
      update pedido_estado set enviado_in=now() where id=idp;
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `eve` (IN `st1` NVARCHAR(50))   BEGIN
SELECT t.`nam`,t.sw FROM even AS t
WHERE t.`nam`=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `evepro` (IN `st1` NVARCHAR(7), IN `tst` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
DECLARE idax int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  select id into idax from evento where nombre=tst limit 1;
  IF idp is not null and idd is not null and idax is not null then
    IF idd = 1 then
      update pedido_tipo set id_distrib=null,id_evento=idax where id=idp;
    ELSEIF idd = 2 then
      update pedido_tipo set id_regular=null,id_evento=idax where id=idp;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_geo` (IN `isn` NVARCHAR(7))   BEGIN
select CONCAT(ST_X(gi.geo),',',ST_Y(gi.geo)) as jh3 from pedido as gi WHERE gi.recibo_nro=isn;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_geon` (IN `isn` NVARCHAR(7))   BEGIN
select IF(ST_X(gi.geo) IS NULL,'',ST_X(gi.geo)) as tre,IF(ST_Y(gi.geo)IS NULL,'',ST_Y(gi.geo)) AS cua from pedido as gi WHERE gi.recibo_nro=isn LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_ped_1` (IN `isn` NVARCHAR(7))   BEGIN
select p.extra,p.acuenta,if(mc.nombre is null,'',mc.nombre) AS medco,
	if(ld.nombre is null,'',ld.nombre) AS lugde,
        if(mp.nombre is null,'',mp.nombre) AS pays,if(p.comentarioA is null,'',p.comentarioA),if(p.comentarioB is null,'',p.comentarioB), DATE_FORMAT(p.fecha_pa_enviar,'%Y-%m-%d'),if(CONCAT(ST_X(p.geo),',',ST_Y(p.geo)) is null,'',CONCAT(ST_X(p.geo),',',ST_Y(p.geo))),p.descuento
FROM pedido AS p
LEFT JOIN medio_contacto AS mc ON mc.id = p.id_medio_con
LEFT JOIN lugar_destino AS ld ON ld.id = p.id_lugar_des
LEFT JOIN medio_de_pago AS mp ON mp.id = p.id_medio_pag
where p.recibo_nro=isn;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_ped_s` (IN `isn` INT)   BEGIN
SELECT DATE_FORMAT(pe.entrante_in, '%Y-%m-%d') AS a,
	IF (
		pe.pendiente_in IS NULL,
		DATE_FORMAT(pe.en_mora_in, '%Y-%m-%d'),
		DATE_FORMAT(pe.pendiente_in, '%Y-%m-%d')
		) AS b,
	DATE_FORMAT(pe.terminado_in, '%Y-%m-%d') AS c,
	DATE_FORMAT(pe.enviado_in, '%Y-%m-%d') AS d,
	IF (
		pe.en_mora_in IS not NULL,
		'1',
		'0'
		) AS sw1,
	IF (
		pes.id IS NOT NULL,
		'1',
		'0'
		) AS sw2
FROM pedido_estado AS pe
LEFT JOIN ped_x AS pes ON pes.id = pe.id
where pe.id=isn;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_ped_t` (IN `isn` INT)   BEGIN
declare zz int default null;
SELECT vls(pt.id_evento,pt.id_regular,pt.id_distrib) into zz from pedido_tipo as pt where pt.id=isn limit 1;
IF zz is not null THEN
  IF zz=0 THEN
    select '','','','','','','','',e.nombre,e.recordar,'','' from evento as e inner join pedido_tipo as pt on pt.id_evento=e.id where pt.id=isn LIMIT 1;
  ELSEIF zz=1 THEN
    select '','','','','','','','','','',e.nombre,e.recordar from distribuidor as e inner join pedido_tipo as pt on pt.id_distrib=e.id where pt.id=isn LIMIT 1;
  ELSEIF zz=2 THEN 
    select e.nombre,e.ci,e.celular,e.email,e.face,e.recordar,'','','','','','' from cliente as e inner join pedido_tipo as pt on pt.id_regular=e.id where pt.id=isn LIMIT 1;
  ELSEIF zz=3 THEN 
    select e.nombre,e.ci,e.celular,e.email,e.face,e.recordar,ev.nombre,'','','','','' from cliente as e inner join pedido_tipo as pt on pt.id_regular=e.id inner join evento as ev on ev.id=pt.id_evento where pt.id=isn LIMIT 1;
  ELSEIF zz=4 THEN 
    select e.nombre,e.ci,e.celular,e.email,e.face,e.recordar,'',ev.nombre,'','','','' from cliente as e inner join pedido_tipo as pt on pt.id_regular=e.id inner join distribuidor as ev on ev.id=pt.id_distrib where pt.id=isn LIMIT 1;
  ELSE
    SELECT '','','','','','','','','','','','';
  END IF;
ELSE
    SELECT '','','','','','','','','','','','';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `gravar` (IN `st1` NVARCHAR(12), IN `nme` NVARCHAR(15))   BEGIN
DECLARE idp int default null;
DECLARE idvc int default null;
IF st1 !='' THEN
 select pc.id into idp from variante as pc where pc.nombre LIKE st1 LIMIT 1;
 select pc.id into idvc from variante_clase as pc where pc.nombre LIKE nme LIMIT 1;
 UPDATE variante SET id_variante_clase=idvc WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `habvar` (IN `st1` NVARCHAR(12), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
 select pc.id into idp from variante as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE variante SET habil=rm WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `in_geo` (IN `isn` INT, IN `eml` NVARCHAR(255))   BEGIN
IF isn is not null and isn>=0 and eml!='' THEN
    set @xd=CONCAT('POINT(',eml,')');
    UPDATE pedido set geo=(PointFromText(@xd)) where id=isn;
ELSE
 UPDATE pedido set geo=NULL where id=isn;

END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `item_p1` (IN `idp` INT)   BEGIN
declare ida int default null;
declare idb int default null;
declare idc int default null;

declare cli nvarchar(100) DEFAULT '-';
declare cel nvarchar(10) DEFAULT '-';
declare cins nvarchar(15) DEFAULT '-';

declare destino nvarchar(20) DEFAULT '-';
declare com nvarchar(220) DEFAULT '';
declare tota double DEFAULT 0;
declare aco double DEFAULT 0;
select IF(comentarioB is null or comentarioB ='','-',comentarioB),total(id),acuenta into com,tota,aco from pedido where id=idp limit 1;
select pt.id_evento,pt.id_regular,pt.id_distrib into ida,idb,idc from pedido_tipo AS pt where pt.id=idp LIMIT 1;
IF ida IS NOT NULL AND idb IS NULL AND idc IS NULL then
  select IF(c.celular is null or c.celular ='','-',c.celular),IF(c.ci is null or c.ci ='','-',c.ci),IF(c.nombre is null or c.nombre ='',CONCAT(e.nombre,' (E)'),c.nombre) into cel,cins,cli from evento as e left join cliente as c on c.id=e.id_cliente where e.id=ida limit 1;
ELSEIF idb IS NOT NULL then
  select IF(c.celular is null or c.celular ='','-',c.celular),IF(c.ci is null or c.ci ='','-',c.ci),IF(c.nombre is null or c.nombre ='','-',c.nombre) into cel,cins,cli from cliente as c where c.id=idb limit 1;
ELSEIF ida IS NULL AND idb IS NULL AND idc IS NOT NULL then
  select IF(c.celular is null or c.celular ='','-',c.celular),IF(c.ci is null or c.ci ='','-',c.ci),IF(c.nombre is null or c.nombre ='',CONCAT(e.nombre,' (D)'),c.nombre) into cel,cins,cli from distribuidor as e left join cliente as c on c.id=e.id_cliente where e.id=idc limit 1;
end if;
select IF(ld.nombre is null or ld.nombre ='','-',ld.nombre) into destino from pedido as p left join lugar_destino as ld on ld.id=p.id_lugar_des where p.id=idp LIMIT 1;
SELECT cli,cel,cins,destino,com,tota,aco;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lst_clien` ()   BEGIN
select cli.nombre as na
from cliente as cli where recordar=1
UNION
select ct.numero from cliente as c inner join cliente_tarjeta ct on ct.id=c.id_tarjeta where ct.sw=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lst_dist` ()   BEGIN
SELECT c.nombre as non FROM distribuidor as c where c.recordar=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `lst_even` ()   BEGIN
SELECT c.nombre as non FROM evento as c where c.recordar=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mddnpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  IF idp is not null and idd is not null then
    IF idd = 4 then
      update pedido_tipo set id_regular=null where id=idp;
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mevvpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  IF idp is not null and idd is not null then
    IF idd = 3 then
      update pedido_tipo set id_regular=null where id=idp;
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mpvContR` (IN `st1` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from medio_contacto as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE medio_contacto SET recordar=rm WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mpvDestR` (IN `st1` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from lugar_destino as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE lugar_destino SET recordar=rm WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mpvPayR` (IN `st1` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from medio_de_pago as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE medio_de_pago SET recordar=rm WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mrrpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 1 then
      update pedido_estado set en_mora_in=now() where id=idp;
    else
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mvdes` (IN `st1` NVARCHAR(7), IN `rm` NVARCHAR(20))   BEGIN
DECLARE idp int default null;
IF st1 !='' AND rm!='' THEN
  SELECT lo.id into idp from lugar_destino as lo where lo.nombre=rm;
  IF idp is not null then
    UPDATE pedido as yuy set yuy.id_lugar_des=idp where yuy.recibo_nro=st1;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mvdnpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  IF idp is not null and idd is not null then
    IF idd = 4 then
      update pedido_tipo set id_distrib=null where id=idp;
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mvenpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  IF idp is not null and idd is not null then
    IF idd = 3 then
      update pedido_tipo set id_evento=null where id=idp;
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mvmed` (IN `st1` NVARCHAR(7), IN `rm` NVARCHAR(30))   BEGIN
DECLARE idp int default null;
IF st1 !='' AND rm!='' THEN
  SELECT lo.id into idp from medio_contacto as lo where lo.nombre=rm;
  IF idp is not null then
    UPDATE pedido as yuy set yuy.id_medio_con=idp where yuy.recibo_nro=st1;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `mvpay` (IN `st1` NVARCHAR(7), IN `rm` NVARCHAR(30))   BEGIN
DECLARE idp int default null;
IF st1 !='' AND rm!='' THEN
  SELECT lo.id into idp from medio_de_pago as lo where lo.nombre=rm;
  IF idp is not null then
    UPDATE pedido as yuy set yuy.id_medio_pag=idp where yuy.recibo_nro=st1;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `ndipro` (IN `st1` NVARCHAR(7), IN `tst` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
DECLARE idax int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  select id into idax from distribuidor where nombre=tst limit 1;
  IF idp is not null and idd is not null and idax is not null then
    IF idd = 2 then
      update pedido_tipo set id_distrib=idax where id=idp;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nd_detalle` (IN `idp` INT, IN `coes` NVARCHAR(20), IN `talla` NVARCHAR(12), IN `cant` INT, IN `presu` DOUBLE(10,1))   BEGIN
declare id_tall int default null;
declare id_prod int default null;

declare id_detali int default null;
if coes !='' and talla !='' then
	select id into id_prod from producto where codigo=coes limit 1;
	if id_prod is null then
		insert into producto(codigo) values(coes);
		select LAST_INSERT_ID() into id_prod;
	end if;
	select id into id_tall from variante where nombre like talla limit 1;
	if id_tall is null then

		insert into variante(nombre,id_variante_clase) values(talla,1);
		select LAST_INSERT_ID() into id_tall;
	end if;
	insert into detalle values(null,idp,id_prod,presu,cant);
	select LAST_INSERT_ID() into id_detali;
	insert into detalle_variante values(id_detali,id_tall);
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nd_estado` (IN `idp` INT, IN `fecha_entrante` DATE, IN `fecha_apro_rech` DATE, IN `enviado` DATE, IN `cnc` TINYINT)   BEGIN
declare id_tall int default null;
declare id_prod int default null;
declare recibi nvarchar(7) default null;
declare teak int default null;
select recibo_nro into recibi from pedido where id=idp limit 1;

if idp is not null and recibi is not null then
	update pedido_estado set entrante_in=fecha_entrante,pendiente_in=fecha_apro_rech,en_mora_in=null,terminado_in=enviado,enviado_in=enviado where id=idp;
	
	select id into teak from pedido_e_cancelado where id=idp and fecha_out is null limit 1;
	if cnc = 1 and teak is null then
		call cncpp(recibi,'Cancelado mediante el panel de editor.');
	elseif cnc=0 and teak is not null then
	  update pedido_e_cancelado set fecha_out=now() where id=idp and fecha_out is null;


	end if;
else 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error por uso de pedido';
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nd_ped` (IN `recibo` NVARCHAR(7), IN `contacto` NVARCHAR(30), IN `destino` NVARCHAR(20), IN `pago` NVARCHAR(30), IN `fecha_envio` DATE, IN `comenA` LONGTEXT, IN `comenB` NVARCHAR(200), IN `eml` NVARCHAR(255), IN `desco` DOUBLE(3,2), IN `acuen` DOUBLE(10,1), IN `xtra` DOUBLE(10,1))   BEGIN
declare `idp` int default null;
declare `id_c` int default null;
declare `id_d` int default null;
declare `id_p` int default null;
declare `autoinc` int default null;
IF recibo !='' then
	select id into idp from pedido where recibo_nro=recibo;
	if idp is not null then
		select id into id_c from medio_contacto where nombre like contacto limit 1;
		if id_c is null and contacto!='' then
			insert into medio_contacto(nombre) values(contacto);
			select LAST_INSERT_ID() into id_c;
		end if;
		select id into id_d from lugar_destino where nombre like destino limit 1;
		if id_d is null and destino!='' then
			insert into lugar_destino(nombre) values(destino);
			select LAST_INSERT_ID() into id_d;
		end if;
		select id into id_p from medio_de_pago where nombre like pago limit 1;
		if id_p is null and pago!='' then
			insert into medio_de_pago(nombre) values(pago);
			select LAST_INSERT_ID() into id_p;
		end if;
		update pedido set descuento=desco,acuenta=acuen,extra=xtra,fecha_pa_enviar=fecha_envio,comentarioA=comenA,comentarioB=comenB,id_medio_pag=id_p,id_medio_con=id_c,id_lugar_des=id_d where id=idp;
		call in_geo(idp,eml);
		
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
	end if;
else 
	select id into id_c from medio_contacto where nombre like contacto limit 1;
		if id_c is null and contacto!='' then
			insert into medio_contacto(nombre) values(contacto);
			select LAST_INSERT_ID() into id_c;
		end if;
		select id into id_d from lugar_destino where nombre like destino limit 1;
		if id_d is null and destino!='' then
			insert into lugar_destino(nombre) values(destino);
			select LAST_INSERT_ID() into id_d;
		end if;
		select id into id_p from medio_de_pago where nombre like pago limit 1;
		if id_p is null and pago!='' then
			insert into medio_de_pago(nombre) values(pago);
			select LAST_INSERT_ID() into id_p;
		end if;
    -- TODO table_schema remove
		SELECT AUTO_INCREMENT INTO autoinc FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'orders-man' AND TABLE_NAME = 'pedido';
		set @jj = autoinc+4000;
		INSERT INTO pedido(descuento,acuenta,extra,fecha_pa_enviar,comentarioA,comentarioB,id_medio_pag,id_medio_con,id_lugar_des,recibo_nro) VALUES (desco,acuen,xtra,fecha_envio,comenA,comenB,id_p,id_c,id_d,@jj);
		select LAST_INSERT_ID() into idp;
		call in_geo(idp,eml);
		INSERT INTO pedido_estado(id,entrante_in) values(idp,NOW());
		INSERT INTO pedido_tipo(id) values(idp);
	
end if;
select idp as jh3;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neccl` (IN `code` NVARCHAR(12), IN `rm` TINYINT(1), IN `emm` LONGTEXT)   BEGIN
IF code !='' THEN
  INSERT INTO producto_clase values (null,code,rm);
  CALL cclvaros(code,emm);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neclien` (IN `nam` NVARCHAR(100), IN `cis` NVARCHAR(15), IN `cel` NVARCHAR(10), IN `emp` NVARCHAR(255), IN `fak` NVARCHAR(255), IN `rm` TINYINT(1))   BEGIN
IF nam !='' THEN
  INSERT INTO cliente values(null,nam,cis,cel,null,rm,emp,fak);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nedist` (IN `nam` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
IF nam !='' THEN
  INSERT INTO distribuidor values(null,nam,rm,null);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neeven` (IN `nam` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
IF nam !='' THEN
  INSERT INTO evento values(null,nam,rm,null);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neoCont` (IN `nam` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
IF nam !='' THEN
  INSERT INTO medio_contacto values(null,nam,rm);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neoDest` (IN `nam` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
IF nam !='' THEN
  INSERT INTO lugar_destino values(null,nam,rm);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neoPay` (IN `nam` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
IF nam !='' THEN
  INSERT INTO medio_de_pago values(null,nam,rm);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `neprro` (IN `code` NVARCHAR(20), IN `rm` TINYINT(1), IN `des` TEXT, IN `clas` NVARCHAR(12), IN `hb` TINYINT(1), IN `emm` LONGTEXT)   BEGIN
DECLARE idp int default null;
IF code !='' THEN
  INSERT INTO producto(codigo,descripcion,habil) values (code,des,rm);
  select LAST_INSERT_ID() into idp;
  CALL prclsv(idp,clas,hb);
  CALL prtg(code,emm);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nevar` (IN `nam` NVARCHAR(12), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF nam !='' THEN
    select vula.id into idp from variante_clase as vula where vula.nombre='Tallas';
    INSERT INTO variante values(null,nam,rm,idp);
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No aceptado';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `nevpro` (IN `st1` NVARCHAR(7), IN `tst` NVARCHAR(50))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
DECLARE idax int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  select id into idax from evento where nombre=tst limit 1;
  IF idp is not null and idd is not null and idax is not null then
    IF idd = 2 then
      update pedido_tipo set id_evento=idax where id=idp;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `norpro` (IN `st1` NVARCHAR(7), IN `tst` NVARCHAR(100))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
DECLARE idax int default null;
IF st1 !='' THEN
  SELECT lo.id,vls(tp.id_evento, tp.id_regular, tp.id_distrib) into idp,idd from pedido as lo INNER JOIN pedido_tipo AS tp ON tp.id = lo.id where lo.recibo_nro=st1;
  select id into idax from cliente where nombre=tst limit 1;
  IF idp is not null and idd is not null and idax is not null then
    IF idd = 0 then
      update pedido_tipo set id_evento=null,id_regular=idax where id=idp;
    ELSEIF idd = 1 then
      update pedido_tipo set id_distrib=null,id_regular=idax where id=idp;
    ELSE
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `Pay` (IN `st1` NVARCHAR(30))   BEGIN
SELECT t.`name`,t.rem FROM  pays AS t
WHERE t.`name`=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pedir_dist` (IN `idp` INT, IN `coes` NVARCHAR(50), IN `sw` TINYINT)   BEGIN
declare id_distro int default null;
if coes !='' then
	select id into id_distro from distribuidor where nombre like coes limit 1;
	if id_distro is not null then
		update distribuidor set recordar=sw where id=id_distro;
	else
		INSERT INTO distribuidor(nombre,recordar) values(coes,sw);
		select LAST_INSERT_ID() into id_distro;
	end if;
	update pedido_tipo set id_evento=null,id_regular=null,id_distrib=id_distro where id=idp;
ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede completar transaccion.';
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pedir_evele` (IN `idp` INT, IN `coes` NVARCHAR(50), IN `sw` TINYINT)   BEGIN
declare id_evele int default null;
if coes !='' then
	select id into id_evele from evento where nombre like coes limit 1;
	if id_evele is not null then
		update evento set recordar=sw where id=id_evele;
	else
		INSERT INTO evento(nombre,recordar) values(coes,sw);
		select LAST_INSERT_ID() into id_evele;
	end if;
	update pedido_tipo set id_evento=id_evele,id_regular=null,id_distrib=null where id=idp;
else
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede completar transaccion.';
end if;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pedir_nor` (IN `idp` INT, IN `nam` NVARCHAR(100), IN `cis` NVARCHAR(15), IN `cel` NVARCHAR(10), IN `fak` NVARCHAR(255), IN `emp` NVARCHAR(255), IN `rm` TINYINT(1), IN `tevento` NVARCHAR(50), IN `tdistrib` NVARCHAR(50))   BEGIN
declare id_clintar int default null;
declare id_eventar int default null;
declare id_distrar int default null;
if tdistrib is not null and tevento is not null then
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No puede completar transaccion.';
else
	select c.id into id_clintar from cliente as c inner join cliente_tarjeta ct on ct.id=c.id_tarjeta where ct.sw=1 and ct.numero=nam limit 1;
	IF id_clintar is null then
		select id into id_clintar from cliente where nombre like nam limit 1;
		IF id_clintar is null then
			INSERT INTO cliente(nombre,ci,celular,face,email,recordar) values(nam,cis,cel,fak,emp,rm);
			select LAST_INSERT_ID() into id_clintar;
		else
			update cliente set ci=cis,celular=cel,recordar=rm,email=emp,face=fak where id=id_clintar;
		end if;
	end if;
	if tdistrib is not null then
		select id into id_distrar from distribuidor where nombre like tdistrib limit 1;
		if id_distrar is null then
			INSERT INTO distribuidor(nombre,recordar) values(tdistrib,1);
		select LAST_INSERT_ID() into id_distrar;
		end if;
	end if;
	if tevento is not null then
		select id into id_eventar from evento where nombre like tevento limit 1;
		if id_eventar is null then
			INSERT INTO evento(nombre,recordar) values(tevento,1);
			select LAST_INSERT_ID() into id_eventar;
		end if;
	end if;
	update pedido_tipo set id_evento=id_eventar,id_regular=id_clintar,id_distrib=id_distrar where id=idp;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `pndpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 1 then
      update pedido_estado set pendiente_in=now() where id=idp;
    ELSEIF idd = 3 then
      update pedido_estado set en_mora_in=null,pendiente_in=now() where id=idp;
    else
      SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Corrompido';
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prcls` (IN `st1` NVARCHAR(20), IN `ccl` NVARCHAR(12))   BEGIN
DECLARE idp int default null;
DECLARE idc int default null;
DECLARE curr int default null;
IF st1 !='' THEN
  IF ccl!='' THEN
    SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
    SELECT tt.id into idc from producto_clase as tt where tt.nombre=ccl LIMIT 1;
    update producto as jo set jo.id_producto_clase=idc where jo.id=idp;
  END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prclsv` (IN `st1` INT, IN `ccl` NVARCHAR(12), IN `hb` TINYINT(1))   BEGIN
DECLARE idc int default null;
IF st1 is not null THEN
  IF ccl!='' THEN
    SELECT tt.id into idc from producto_clase as tt where tt.nombre=ccl LIMIT 1;
    IF idc is null THEN
      INSERT into producto_clase values(null,ccl,hb);
      select LAST_INSERT_ID() into idc;
    END IF;
    update producto as jo set jo.id_producto_clase=idc where jo.id=st1;
  ELSE
    update producto as jo set jo.id_producto_clase=null where jo.id=st1;
  END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc` (IN `st1` NVARCHAR(20))   BEGIN
SELECT pro.codigo AS co,
pro.habil as hb,
IF(pro.descripcion is null,'',pro.descripcion) as ds,
IF(pc.nombre is null,'',pc.nombre) as na,
IF(pc.habil is null,'',pc.habil) as bh
from producto as pro
left join producto_clase as pc on pc.id=pro.id_producto_clase
WHERE pro.codigo=st1 limit 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `proc_tag` (IN `st1` NVARCHAR(20))   BEGIN
select pop.nombre as nam,IF(tab.idp is null,'0','1') as zit from producto_tag as pop
left join (select pt.id_producto_tag as idp from producto as pro
inner join producto_tag_producto as pt on pt.id_producto=pro.id
WHERE pro.codigo=st1 group by pt.id_producto_tag) as tab on tab.idp=pop.id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `prtg` (IN `st1` NVARCHAR(20), IN `tsts` LONGTEXT)   BEGIN
DECLARE front TEXT DEFAULT NULL;
DECLARE frontlen INT DEFAULT NULL;
DECLARE tag TEXT DEFAULT NULL;

DECLARE idp int default null;
DECLARE idt int;
DECLARE curr int;
IF st1 !='' AND tsts!='' THEN
  SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
  IF idp is not null THEN
    DELETE from producto_tag_producto where id_producto=idp;
    iterator : LOOP
        IF LENGTH(TRIM(`tsts`)) = 0 OR `tsts` IS NULL THEN
            LEAVE iterator;
        END IF;
        SET front = SUBSTRING_INDEX(`tsts`, '-', 1);
        SET frontlen = LENGTH(front);
        SET tag = TRIM(front);
        set idt=null;

        SELECT lt.id into idt from producto_tag as lt where lt.nombre=tag LIMIT 1;
        IF idt is null THEN
          INSERT INTO producto_tag values(null,tag);
          select LAST_INSERT_ID() into idt;
        END IF;
        INSERT INTO producto_tag_producto(id_producto_tag,id_producto) values (idt,idp);

        SET `tsts` = INSERT (`tsts`, 1, (frontlen+1), '');
    END LOOP;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El producto no existe';
  END IF;
ELSE
  IF tsts='' THEN
    SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
    select count(id_producto) into frontlen from producto_tag_producto where id_producto=idp;
    IF frontlen is not null and frontlen!=0 THEN
      DELETE from producto_tag_producto where id_producto=idp;
    END IF;
  else
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
  END IF;
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_clien` ()   BEGIN
SELECT na,ci,cel,eml,fac from clies where sw=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_tallas` ()   BEGIN
SELECT vv.nombre FROM varis as vv where vv.grupo='Tallas' and vv.habil=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_x_mes` ()   begin
SELECT CONCAT (
		Month(pe.enviado_in),
		',',
		year(pe.enviado_in)
		) AS inf,
	SUM(p.acuenta) AS tot,
	SUM(total(p.id)) AS con
FROM pedido AS p
INNER JOIN pedido_estado AS pe ON pe.id = p.id
LEFT JOIN ped_x AS pcc ON pcc.id = p.id
WHERE pcc.id IS NULL
	AND pe.enviado_in IS NOT NULL
	AND pe.en_mora_in IS NULL
GROUP BY inf
ORDER BY pe.enviado_in;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `p_x_semana` ()   begin
SELECT CONCAT (
		Week(pe.enviado_in, 5),
		',',
		year(pe.enviado_in)
		) AS inf,
	SUM(p.acuenta) AS tot,
	SUM(total(p.id)) AS con
FROM pedido AS p
INNER JOIN pedido_estado AS pe ON pe.id = p.id
LEFT JOIN ped_x AS pcc ON pcc.id = p.id
WHERE pcc.id IS NULL
	AND pe.enviado_in IS NOT NULL
	AND pe.en_mora_in IS NULL
GROUP BY inf
ORDER BY pe.enviado_in;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `recib_p1` (IN `idp` INT)   BEGIN
declare ida int default null;
declare idb int default null;
declare idc int default null;

declare cli nvarchar(100) DEFAULT '-';
declare cel nvarchar(10) DEFAULT '-';
declare fch nvarchar(12) DEFAULT '-';
declare com nvarchar(220) DEFAULT '';
declare desco double DEFAULT 0;
declare aco double DEFAULT 0;
declare plu double DEFAULT 0;
select DATE_FORMAT(fecha_pa_enviar, '%e-%m-%Y'),IF(comentarioB is null or comentarioB ='','-',comentarioB),descuento,acuenta,extra into fch,com,desco,aco,plu from pedido where id=idp limit 1;
select pt.id_evento,pt.id_regular,pt.id_distrib into ida,idb,idc from pedido_tipo AS pt where pt.id=idp LIMIT 1;
IF ida IS NOT NULL AND idb IS NULL AND idc IS NULL then
  select IF(c.celular is null or c.celular ='','-',c.celular),IF(c.nombre is null or c.nombre ='',CONCAT(e.nombre,' (E)'),c.nombre) into cel,cli from evento as e left join cliente as c on c.id=e.id_cliente where e.id=ida limit 1;
ELSEIF idb IS NOT NULL then
  select IF(c.celular is null or c.celular ='','-',c.celular),IF(c.nombre is null or c.nombre ='','-',c.nombre) into cel,cli from cliente as c where c.id=idb limit 1;
ELSEIF ida IS NULL AND idb IS NULL AND idc IS NOT NULL then
  select IF(c.celular is null or c.celular ='','-',c.celular),IF(c.nombre is null or c.nombre ='',CONCAT(e.nombre,' (D)'),c.nombre) into cel,cli from distribuidor as e left join cliente as c on c.id=e.id_cliente where e.id=idc limit 1;
end if;
SELECT cli,cel,fch,com,aco,plu,desco;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `recib_p2` (IN `idp` INT)   BEGIN
select pro.codigo,vv.nombre,d.cantidad,d.pre_unida from detalle as d 
inner join producto as pro on pro.id=d.id_producto
INNER join detalle_variante as dd on dd.id_detalle=d.id
inner join variante as vv on vv.id=dd.id_variante
where d.id_pedido=idp;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `r_clas` ()   BEGIN
SELECT cs.nombre AS nos,
	cs.habil AS sw
FROM producto_clase AS cs;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `r_dist` ()   BEGIN
SELECT c.nombre as non,c.recordar as sw FROM distribuidor as c where c.recordar=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `r_even` ()   BEGIN
SELECT c.nombre as non,c.recordar as sw FROM evento as c where c.recordar=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_clas` ()   BEGIN
SELECT c.nombre AS name,
	c.nombre AS code
FROM producto_clase AS c;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_clien` ()   BEGIN
SELECT CONCAT(c.nombre,', E->',count(e.id_cliente),', D->',count(d.id_cliente)) as name, c.nombre as code FROM cliente as c left join evento as e on c.id=e.id_cliente left join distribuidor as d on c.id=d.id_cliente  where c.recordar=1 group by c.id;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_Dist` ()   BEGIN
SELECT c.nombre as name,c.nombre as code FROM distribuidor as c where c.recordar=1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_Even` ()   BEGIN
SELECT evento.nombre AS name,
	evento.nombre AS code
FROM evento
WHERE evento.recordar = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_pContac` ()   BEGIN
SELECT nombre AS name,
	nombre AS code
FROM medio_contacto
WHERE recordar = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_pDestin` ()   BEGIN
SELECT nombre AS name,
	nombre AS code
FROM lugar_destino
WHERE recordar = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_pPay` ()   BEGIN
SELECT nombre AS name,
	nombre AS code
FROM medio_de_pago
WHERE recordar = 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_tag` ()   BEGIN
SELECT c.nombre as name,c.nombre as code FROM producto_tag as c;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `s_vaclas` ()   BEGIN
SELECT vc.nombre AS name,
	vc.nombre AS code
FROM variante_clase AS vc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `terpp` (IN `st1` NVARCHAR(7))   BEGIN
DECLARE idp int default null;
DECLARE idd int default null;
IF st1 !='' THEN
  SELECT lo.id,lo.estado into idp,idd from ped_gral2 as lo where lo.recib=st1;
  IF idp is not null and idd is not null then
    IF idd = 2 then
      update pedido_estado set terminado_in=now() where id=idp;
    ELSEIF idd = 3 then
      update pedido_estado set en_mora_in=null,pendiente_in=now(),terminado_in=now() where id=idp;
    end if;
  end if;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `uccll` (IN `st1` NVARCHAR(12), IN `code` NVARCHAR(12), IN `rm` TINYINT(1), IN `emm` LONGTEXT)   BEGIN
DECLARE idp int default null;
IF st1 !='' AND code !='' THEN
  SELECT lo.id into idp from producto_clase as lo where lo.nombre=st1 LIMIT 1;
  IF idp is not null THEN 
    CALL cclvaros(st1,emm);
    UPDATE producto_clase as yuy set yuy.nombre=code,yuy.habil=rm where yuy.id=idp;
  ELSE
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe producto';
  END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upclien` (IN `st1` NVARCHAR(100), IN `nam` NVARCHAR(100), IN `cis` NVARCHAR(15), IN `cel` NVARCHAR(10), IN `emp` NVARCHAR(255), IN `fak` NVARCHAR(255), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
DECLARE curr int default null;
DECLARE dos int default null;
IF st1 !='' AND nam !='' THEN
SELECT c.id,cliRepre(c.id),c.id_tarjeta into idp,curr,dos from cliente as c where c.nombre=st1 LIMIT 1;
IF dos is null then 
UPDATE cliente SET nombre=nam,ci=cis,celular=cel,email=emp,face=fak WHERE id=idp;
else
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente tiene tarjeta, asi que no puede alterar.';
end if;
IF curr=0 THEN
UPDATE cliente SET recordar=rm WHERE id=idp;
ELSE
IF rm=0 THEN
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente es representante, asi que no puede alterar: recordar.';
END IF;
END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upclienr` (IN `st1` NVARCHAR(100), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
DECLARE curr int default null;
DECLARE dos int default null;
IF st1 !='' THEN
  select pc.id,cliRepre(pc.id),pc.id_tarjeta into idp,curr,dos from cliente as pc where pc.nombre = st1 LIMIT 1;
IF curr=0 and dos is null THEN
UPDATE cliente SET recordar=rm WHERE id=idp;
ELSE
SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'El cliente es representante, o cliente destacado';
END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updist` (IN `st1` NVARCHAR(50), IN `nam` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
 select pc.id into idp from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE distribuidor SET recordar=rm,nombre=nam WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updistr` (IN `st1` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
 select pc.id into idp from distribuidor as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE distribuidor SET recordar=rm WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upeven` (IN `st1` NVARCHAR(50), IN `nam` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
 select pc.id into idp from evento as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE evento SET recordar=rm,nombre=nam WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upevenr` (IN `st1` NVARCHAR(50), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
 select pc.id into idp from evento as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE evento SET recordar=rm WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upprro` (IN `st1` NVARCHAR(20), IN `code` NVARCHAR(20), IN `rm` TINYINT(1), IN `des` TEXT, IN `clas` NVARCHAR(12), IN `hb` TINYINT(1), IN `emm` LONGTEXT)   BEGIN
DECLARE idp int default null;
IF st1 !='' AND code !='' THEN
SELECT lo.id into idp from producto as lo where lo.codigo=st1 LIMIT 1;
IF idp is not null THEN 
CALL prclsv(idp,clas,hb);
CALL prtg(st1,emm);
UPDATE producto as yuy set yuy.codigo=code,yuy.habil=rm,yuy.descripcion=des where yuy.id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No existe producto';
END IF;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upyContR` (IN `st1` NVARCHAR(30), IN `nam` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from medio_contacto as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE medio_contacto SET recordar=rm,nombre=nam WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upyDestR` (IN `st1` NVARCHAR(30), IN `nam` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from lugar_destino as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE lugar_destino SET recordar=rm,nombre=nam WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `upyPayR` (IN `st1` NVARCHAR(30), IN `nam` NVARCHAR(30), IN `rm` TINYINT(1))   BEGIN
DECLARE idp int default null;
IF st1 !='' THEN
  select pc.id into idp from medio_de_pago as pc where pc.nombre LIKE st1 LIMIT 1;
  UPDATE medio_de_pago SET recordar=rm,nombre=nam WHERE id=idp;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `vare` (IN `st1` NVARCHAR(12))   BEGIN
select pc.nombre,pc.grupo,pc.habil from varis as pc where pc.nombre LIKE st1 LIMIT 1;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `varupd` (IN `st1` NVARCHAR(12), IN `nam` NVARCHAR(12), IN `rm` TINYINT(1))   BEGIN
DECLARE ide int default null;
IF st1 !='' AND nam!='' THEN
  select pc.id into ide from variante as pc where pc.nombre LIKE st1 LIMIT 1;
    UPDATE variante set nombre=nam,habil=rm where id=ide;
ELSE
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'VALOR INCORRECTO';
END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `vermi` (IN `st1` NVARCHAR(7), IN `nts` TINYINT)   begin
declare zz int default null;
declare idm int default null;
SELECT vls(pt.id_evento,pt.id_regular,pt.id_distrib),p.id into zz,idm FROM pedido as p inner join pedido_tipo as pt on pt.id=p.id where p.recibo_nro=st1 limit 1;
IF zz is not null and idm is not null THEN
  IF zz=0 THEN
    IF nts=1 THEN
      select IF(c.celular  is null or c.celular ='' or c.celular ='-','',c.celular) as jh3 from pedido_tipo as pt inner join evento as e on pt.id_evento=e.id left join cliente as c on c.id=e.id_cliente where pt.id=idm limit 1;
    ELSEIF nts=2 THEN
      select IF(c.face  is null or c.face ='' or c.face ='-','',c.face) as jh3 from pedido_tipo as pt inner join evento as e on pt.id_evento=e.id left join cliente as c on c.id=e.id_cliente where pt.id=idm limit 1;
    ELSEIF nts=3 THEN
      select IF(c.email  is null or c.email ='' or c.email ='-','',c.email) as jh3 from pedido_tipo as pt inner join evento as e on pt.id_evento=e.id left join cliente as c on c.id=e.id_cliente where pt.id=idm limit 1;
    END IF;
  ELSEIF zz=1 THEN
    IF nts=1 THEN
      select IF(c.celular  is null or c.celular ='' or c.celular ='-','',c.celular) as jh3 from pedido_tipo as pt inner join distribuidor as e on pt.id_distrib=e.id left join cliente as c on c.id=e.id_cliente where pt.id=idm limit 1;
    ELSEIF nts=2 THEN
      select IF(c.face  is null or c.face ='' or c.face ='-','',c.face) as jh3 from pedido_tipo as pt inner join distribuidor as e on pt.id_distrib=e.id left join cliente as c on c.id=e.id_cliente where pt.id=idm limit 1;
    ELSEIF nts=3 THEN
      select IF(c.email  is null or c.email ='' or c.email ='-','',c.email) as jh3 from pedido_tipo as pt inner join distribuidor as e on pt.id_distrib=e.id left join cliente as c on c.id=e.id_cliente where pt.id=idm limit 1;
    END IF;
  ELSEIF zz=2 or zz=3 or zz=4 THEN
    IF nts=1 THEN
      select IF(c.celular  is null or c.celular ='' or c.celular ='-','',c.celular) as jh3 from pedido_tipo as pt inner join cliente as c on c.id=pt.id_regular where pt.id=idm limit 1;
    ELSEIF nts=2 THEN
      select IF(c.face  is null or c.face ='' or c.face ='-','',c.face) as jh3 from pedido_tipo as pt inner join cliente as c on c.id=pt.id_regular where pt.id=idm limit 1;
    ELSEIF nts=3 THEN
      select IF(c.email  is null or c.email ='' or c.email ='-','',c.email) as jh3 from pedido_tipo as pt inner join cliente as c on c.id=pt.id_regular where pt.id=idm limit 1;
    END IF;
  ELSE
    SELECT '' as jh3;
  END IF;
END IF;
end$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `web_cli` (IN `idt` INT, IN `strs` TINYINT, IN `nombrar` NVARCHAR(100), IN `celus` NVARCHAR(10), IN `emp` NVARCHAR(255))   BEGIN
DECLARE idc int default null;
DECLARE has int default null;
IF idt>0 and idt<101 and idt is not null and nombrar is not null then
  select c.id into idc from cliente as c where c.nombre like nombrar;
  select c.id into has from cliente as c where c.id_tarjeta=idt;
  if has is null and idc is null then
    insert into cliente(nombre,celular,email,id_tarjeta,recordar,ci) values (nombrar,celus,emp,idt,0,'-');
    update cliente_tarjeta set sw=strs,fecha_modificacion=NOW() where id=idt;
  elseif has is not null and idc is not null and has=idc then
    update cliente set email=emp,celular=celus,recordar=0,ci='-' where id=idc;
    update cliente_tarjeta set sw=strs,fecha_modificacion=NOW() where id=idt;
  else
    SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valores para tarjeta no aceptado';
  end if;
else
  SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Valores para tarjeta no aceptado';
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `web_ran` ()   BEGIN
SET @rank=0;
SELECT cn.id_tarjeta as `key`,@rank:=@rank+1 as `nvl`
FROM (
	SELECT sum(obt.acuenta) AS nvl,
		pt.id_regular AS idc
	FROM obt_validos AS obt
	INNER JOIN pedido_tipo AS pt ON pt.id = obt.id
	WHERE pt.id_evento IS NULL
		AND pt.id_regular IS NOT NULL
		AND pt.id_distrib IS NULL
	GROUP BY pt.id_regular
	) AS tot
INNER JOIN cliente AS cn ON cn.id = tot.idc
INNER JOIN cliente_tarjeta AS ct ON ct.id = cn.id_tarjeta
WHERE ct.sw = 1 ORDER BY tot.nvl desc LIMIT 3;
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `clasGVr` (`id` INT) RETURNS TEXT CHARSET utf8 NO SQL BEGIN
DECLARE vl TEXT default '';
SELECT GROUP_CONCAT(DISTINCT ttb.grupo SEPARATOR ';')
INTO vl
FROM prodclase_variante AS rel
INNER JOIN varis AS ttb 
	ON ttb.id = rel.id_variante
WHERE rel.id_producto_clase = id
GROUP BY rel.id_producto_clase;

RETURN vl;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `cliRepre` (`id` INT) RETURNS TINYINT(4) NO SQL BEGIN
DECLARE vl int default '0';
DECLARE a int default '0';
DECLARE b int default '0';
SELECT count(e.id_cliente) into a FROM distribuidor as e where e.id_cliente=id group by e.id_cliente;
SELECT count(e.id_cliente) into b FROM evento as e where e.id_cliente=id group by e.id_cliente;
SET vl=a+b;
RETURN vl;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `proTags` (`id` INT) RETURNS TEXT CHARSET utf8 NO SQL BEGIN
DECLARE vl TEXT default '';
SELECT GROUP_CONCAT(uno.nombre SEPARATOR ';')
INTO vl
FROM producto_tag AS uno
INNER JOIN producto_tag_producto AS rel ON rel.id_producto_tag = uno.id
WHERE rel.id_producto = id
GROUP BY rel.id_producto;

RETURN vl;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `total` (`ids` INT) RETURNS DOUBLE NO SQL BEGIN
DECLARE vl DOUBLE default '0';
DECLARE tot DOUBLE default '0';
DECLARE perc DOUBLE default '0';
select sum(cantidad*pre_unida) into vl from detalle where id_pedido=ids;
select ROUND((extra+vl),1) as sd,descuento into tot,perc from pedido where id=ids LIMIT 1;
return(SELECT ROUND((tot-(tot*perc)),1));
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `vls` (`ida` INT, `idb` INT, `idc` INT) RETURNS TINYINT(4) NO SQL BEGIN
DECLARE vl int default null;
IF ida IS NOT NULL AND idb IS NULL AND idc IS NULL THEN
  SET vl = 0;
ELSEIF ida IS NULL AND idb IS NULL AND idc IS NOT NULL THEN
  SET vl = 1;
ELSEIF ida IS NULL AND idb IS NOT NULL AND idc IS NULL THEN
  SET vl = 2;
ELSEIF ida IS NOT NULL AND idb IS NOT NULL AND idc IS NULL THEN
  SET vl = 3;
ELSEIF ida IS NULL AND idb IS NOT NULL AND idc IS NOT NULL THEN
  SET vl = 4;
END IF;
RETURN vl;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `vls2` (`ida` INT, `idb` INT, `idc` INT) RETURNS TEXT CHARSET utf8 NO SQL BEGIN
declare cli nvarchar(100) DEFAULT '-';IF ida IS NOT NULL AND idb IS NULL AND idc IS NULL then
  select IF(c.nombre is null or c.nombre ='',CONCAT(e.nombre,' (E)'),c.nombre) into cli from evento as e left join cliente as c on c.id=e.id_cliente where e.id=ida limit 1;
ELSEIF idb IS NOT NULL then
  select IF(c.nombre is null or c.nombre ='','-',c.nombre) into cli from cliente as c where c.id=idb limit 1;
ELSEIF ida IS NULL AND idb IS NULL AND idc IS NOT NULL then
  select IF(c.nombre is null or c.nombre ='',CONCAT(e.nombre,' (D)'),c.nombre) into cli from distribuidor as e left join cliente as c on c.id=e.id_cliente where e.id=idc limit 1;
end if;
RETURN cli;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Stand-in structure for view `cclas`
-- (See below for the actual view)
--
CREATE TABLE `cclas` (
`nom` varchar(12)
,`gru` text
,`cant` bigint(21)
,`cosa` decimal(54,0)
,`habil` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `cliente`
--

CREATE TABLE `cliente` (
  `id` int(11) NOT NULL,
  `nombre` varchar(100) NOT NULL,
  `ci` varchar(15) DEFAULT NULL,
  `celular` varchar(10) DEFAULT NULL,
  `id_tarjeta` int(11) DEFAULT NULL,
  `recordar` tinyint(1) NOT NULL,
  `email` varchar(255) CHARACTER SET utf8 DEFAULT NULL,
  `face` varchar(255) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cliente`
--

INSERT INTO `cliente` (`id`, `nombre`, `ci`, `celular`, `id_tarjeta`, `recordar`, `email`, `face`) VALUES
(1, 'Jhordy Gavinchu', '-', '123123123', NULL, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cliente_tarjeta`
--

CREATE TABLE `cliente_tarjeta` (
  `id` int(11) NOT NULL,
  `numero` varchar(16) NOT NULL,
  `sw` tinyint(1) NOT NULL DEFAULT 0,
  `fecha_modificacion` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `clies`
-- (See below for the actual view)
--
CREATE TABLE `clies` (
`na` varchar(100)
,`ci` varchar(15)
,`cel` varchar(10)
,`eml` varchar(255)
,`fac` varchar(255)
,`sw` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `conts`
-- (See below for the actual view)
--
CREATE TABLE `conts` (
`name` varchar(30)
,`rem` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `dests`
-- (See below for the actual view)
--
CREATE TABLE `dests` (
`name` varchar(20)
,`rem` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `detalle`
--

CREATE TABLE `detalle` (
  `id` int(11) NOT NULL,
  `id_pedido` int(11) NOT NULL,
  `id_producto` int(11) DEFAULT NULL,
  `pre_unida` double(10,1) NOT NULL,
  `cantidad` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `detalle_variante`
--

CREATE TABLE `detalle_variante` (
  `id_detalle` int(11) NOT NULL,
  `id_variante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `dist`
-- (See below for the actual view)
--
CREATE TABLE `dist` (
`nam` varchar(50)
,`name` varchar(100)
,`ci` varchar(15)
,`cel` varchar(10)
,`sw` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `distribuidor`
--

CREATE TABLE `distribuidor` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `recordar` tinyint(1) NOT NULL DEFAULT 1,
  `id_cliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `distribuidor`
--

INSERT INTO `distribuidor` (`id`, `nombre`, `recordar`, `id_cliente`) VALUES
(1, 'Mayorista 1', 1, NULL);

-- --------------------------------------------------------

--
-- Stand-in structure for view `even`
-- (See below for the actual view)
--
CREATE TABLE `even` (
`nam` varchar(50)
,`name` varchar(100)
,`ci` varchar(15)
,`cel` varchar(10)
,`sw` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `evento`
--

CREATE TABLE `evento` (
  `id` int(11) NOT NULL,
  `nombre` varchar(50) NOT NULL,
  `recordar` tinyint(1) NOT NULL DEFAULT 1,
  `id_cliente` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `evento`
--

INSERT INTO `evento` (`id`, `nombre`, `recordar`, `id_cliente`) VALUES
(1, 'Event 1', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `lugar_destino`
--

CREATE TABLE `lugar_destino` (
  `id` int(11) NOT NULL,
  `nombre` varchar(20) NOT NULL,
  `recordar` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `lugar_destino`
--

INSERT INTO `lugar_destino` (`id`, `nombre`, `recordar`) VALUES
(1, 'Tarija', 1),
(2, 'Sucre', 1);

-- --------------------------------------------------------

--
-- Table structure for table `medio_contacto`
--

CREATE TABLE `medio_contacto` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `recordar` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medio_contacto`
--

INSERT INTO `medio_contacto` (`id`, `nombre`, `recordar`) VALUES
(1, 'Whatsapp', 1),
(2, 'Facebook', 1);

-- --------------------------------------------------------

--
-- Table structure for table `medio_de_pago`
--

CREATE TABLE `medio_de_pago` (
  `id` int(11) NOT NULL,
  `nombre` varchar(30) NOT NULL,
  `recordar` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `medio_de_pago`
--

INSERT INTO `medio_de_pago` (`id`, `nombre`, `recordar`) VALUES
(1, 'Tigo Money', 1);

-- --------------------------------------------------------

--
-- Stand-in structure for view `obt_validos`
-- (See below for the actual view)
--
CREATE TABLE `obt_validos` (
`id` int(11)
,`enviado_in` date
,`acuenta` double(10,1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `pays`
-- (See below for the actual view)
--
CREATE TABLE `pays` (
`name` varchar(30)
,`rem` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `pedido`
--

CREATE TABLE `pedido` (
  `id` int(11) NOT NULL,
  `fecha_pa_enviar` date NOT NULL,
  `acuenta` double(10,1) NOT NULL DEFAULT 0.0,
  `extra` double(10,1) NOT NULL DEFAULT 0.0,
  `descuento` double(3,2) NOT NULL DEFAULT 0.00,
  `comentarioA` longtext DEFAULT NULL,
  `comentarioB` varchar(200) DEFAULT NULL,
  `recibo_nro` varchar(7) NOT NULL,
  `id_medio_pag` int(11) DEFAULT NULL,
  `id_medio_con` int(11) DEFAULT NULL,
  `id_lugar_des` int(11) DEFAULT NULL,
  `geo` point DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pedido_estado`
--

CREATE TABLE `pedido_estado` (
  `id` int(11) NOT NULL,
  `entrante_in` date NOT NULL,
  `pendiente_in` date DEFAULT NULL,
  `en_mora_in` date DEFAULT NULL,
  `terminado_in` date DEFAULT NULL,
  `enviado_in` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pedido_e_cancelado`
--

CREATE TABLE `pedido_e_cancelado` (
  `id` int(11) NOT NULL,
  `fecha_in` date NOT NULL,
  `fecha_out` date DEFAULT NULL,
  `stado_in` tinyint(1) NOT NULL DEFAULT 1,
  `notas` longtext DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `pedido_tipo`
--

CREATE TABLE `pedido_tipo` (
  `id` int(11) NOT NULL,
  `id_evento` int(11) DEFAULT NULL,
  `id_regular` int(11) DEFAULT NULL,
  `id_distrib` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_cancer`
-- (See below for the actual view)
--
CREATE TABLE `ped_cancer` (
`recib` varchar(7)
,`names` text
,`tipo` tinyint(4)
,`total` double
,`can` bigint(21)
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_dist`
-- (See below for the actual view)
--
CREATE TABLE `ped_dist` (
`recib` varchar(7)
,`name` varchar(50)
,`estado` int(2)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_entra`
-- (See below for the actual view)
--
CREATE TABLE `ped_entra` (
`recib` varchar(7)
,`names` text
,`tipo` tinyint(4)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_enviado`
-- (See below for the actual view)
--
CREATE TABLE `ped_enviado` (
`recib` varchar(7)
,`names` text
,`tipo` tinyint(4)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`envi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_enviadod`
-- (See below for the actual view)
--
CREATE TABLE `ped_enviadod` (
`recib` varchar(7)
,`names` text
,`tipo` tinyint(4)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`envi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_even`
-- (See below for the actual view)
--
CREATE TABLE `ped_even` (
`recib` varchar(7)
,`name` varchar(50)
,`estado` int(2)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_gral`
-- (See below for the actual view)
--
CREATE TABLE `ped_gral` (
`id` int(11)
,`idmp` int(11)
,`recibo_nro` varchar(7)
,`names` text
,`tipo` tinyint(4)
,`aconta` double(10,1)
,`total` double
,`penvi` bigint(17)
,`entra` bigint(17)
,`pendi` bigint(17)
,`moran` bigint(17)
,`termi` bigint(17)
,`envi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_gral2`
-- (See below for the actual view)
--
CREATE TABLE `ped_gral2` (
`id` int(11)
,`recib` varchar(7)
,`estado` int(2)
,`total` double
,`penvi` bigint(17)
,`entra` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_moras`
-- (See below for the actual view)
--
CREATE TABLE `ped_moras` (
`recib` varchar(7)
,`tipo` tinyint(4)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_nordi`
-- (See below for the actual view)
--
CREATE TABLE `ped_nordi` (
`recib` varchar(7)
,`cli` varchar(117)
,`name` varchar(50)
,`estado` int(2)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_norev`
-- (See below for the actual view)
--
CREATE TABLE `ped_norev` (
`recib` varchar(7)
,`cli` varchar(117)
,`name` varchar(50)
,`estado` int(2)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_norm`
-- (See below for the actual view)
--
CREATE TABLE `ped_norm` (
`recib` varchar(7)
,`cli` varchar(117)
,`estado` int(2)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_pendien`
-- (See below for the actual view)
--
CREATE TABLE `ped_pendien` (
`recib` varchar(7)
,`names` text
,`tipo` tinyint(4)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_term`
-- (See below for the actual view)
--
CREATE TABLE `ped_term` (
`recib` varchar(7)
,`tipo` tinyint(4)
,`total` double
,`entra` bigint(17)
,`penvi` bigint(17)
,`termi` bigint(17)
,`medco` varchar(30)
,`lugde` varchar(20)
,`pays` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `ped_x`
-- (See below for the actual view)
--
CREATE TABLE `ped_x` (
`id` int(11)
);

-- --------------------------------------------------------

--
-- Table structure for table `prodclase_variante`
--

CREATE TABLE `prodclase_variante` (
  `id_producto_clase` int(11) NOT NULL,
  `id_variante` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `producto`
--

CREATE TABLE `producto` (
  `id` int(11) NOT NULL,
  `codigo` varchar(20) NOT NULL,
  `id_producto_clase` int(11) DEFAULT NULL,
  `descripcion` text DEFAULT NULL,
  `habil` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `producto`
--

INSERT INTO `producto` (`id`, `codigo`, `id_producto_clase`, `descripcion`, `habil`) VALUES
(1, 'silla', NULL, NULL, 1);

-- --------------------------------------------------------

--
-- Table structure for table `producto_clase`
--

CREATE TABLE `producto_clase` (
  `id` int(11) NOT NULL,
  `nombre` varchar(12) NOT NULL,
  `habil` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `producto_clase`
--

INSERT INTO `producto_clase` (`id`, `nombre`, `habil`) VALUES
(1, 'blancas', 1);

-- --------------------------------------------------------

--
-- Table structure for table `producto_tag`
--

CREATE TABLE `producto_tag` (
  `id` int(11) NOT NULL,
  `nombre` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `producto_tag`
--

INSERT INTO `producto_tag` (`id`, `nombre`) VALUES
(2, 'basquet'),
(1, 'futbol');

-- --------------------------------------------------------

--
-- Table structure for table `producto_tag_producto`
--

CREATE TABLE `producto_tag_producto` (
  `id_producto_tag` int(11) NOT NULL,
  `id_producto` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Stand-in structure for view `prody`
-- (See below for the actual view)
--
CREATE TABLE `prody` (
`codigo` varchar(20)
,`clase` varchar(12)
,`tags` text
,`cantidad` decimal(32,0)
,`habil` tinyint(1)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `s_pcontac`
-- (See below for the actual view)
--
CREATE TABLE `s_pcontac` (
`name` varchar(30)
,`cod` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `s_pdestin`
-- (See below for the actual view)
--
CREATE TABLE `s_pdestin` (
`name` varchar(20)
,`cod` varchar(20)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `s_ppay`
-- (See below for the actual view)
--
CREATE TABLE `s_ppay` (
`name` varchar(30)
,`cod` varchar(30)
);

-- --------------------------------------------------------

--
-- Stand-in structure for view `varen`
-- (See below for the actual view)
--
CREATE TABLE `varen` (
`nom` varchar(12)
,`cnn` bigint(21)
,`habil` tinyint(1)
);

-- --------------------------------------------------------

--
-- Table structure for table `variante`
--

CREATE TABLE `variante` (
  `id` int(11) NOT NULL,
  `nombre` varchar(12) NOT NULL,
  `habil` tinyint(1) NOT NULL DEFAULT 1,
  `id_variante_clase` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `variante`
--

INSERT INTO `variante` (`id`, `nombre`, `habil`, `id_variante_clase`) VALUES
(1, 'S', 1, 1),
(2, 'M', 1, 1),
(3, 'L', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `variante_clase`
--

CREATE TABLE `variante_clase` (
  `id` int(11) NOT NULL,
  `nombre` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `variante_clase`
--

INSERT INTO `variante_clase` (`id`, `nombre`) VALUES
(1, 'Tallas');

-- --------------------------------------------------------

--
-- Stand-in structure for view `varis`
-- (See below for the actual view)
--
CREATE TABLE `varis` (
`id` int(11)
,`nombre` varchar(12)
,`habil` tinyint(1)
,`grupo` varchar(15)
);

-- --------------------------------------------------------

--
-- Structure for view `cclas`
--
DROP TABLE IF EXISTS `cclas`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cclas`  AS SELECT `pro`.`nombre` AS `nom`, `clasGVr`(`pro`.`id`) AS `gru`, if(`tab`.`cnt` is null,0,`tab`.`cnt`) AS `cant`, if(`joda`.`cnt` is null,0,`joda`.`cnt`) AS `cosa`, `pro`.`habil` AS `habil` FROM `producto_clase` AS `pro` left join (select count(`pros`.`id_producto_clase`) AS `cnt`,`pros`.`id_producto_clase` AS `idp` from `producto` AS `pros` where `pros`.`id_producto_clase` is not null group by `pros`.`id_producto_clase`) AS `tab` on `tab`.`idp` = `pro`.`id` left join (select sum(`fin`.`cant`) AS `cnt`,`fin`.`cl` AS `idm` from (select if(`pros`.`cnt` is null,0,`pros`.`cnt`) AS `cant`,`po`.`id_producto_clase` AS `cl` from (select sum(`det`.`cantidad`) AS `cnt`,`det`.`id_producto` AS `idp` from `detalle` AS `det` group by `det`.`id_producto`) AS `pros` RIGHT JOIN `producto` AS `po` on `po`.`id` = `pros`.`idp`) AS `fin` where `fin`.`cl` is not null group by `fin`.`cl`) AS `joda` on `joda`.`idm` = `pro`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `clies`
--
DROP TABLE IF EXISTS `clies`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `clies`  AS SELECT `cli`.`nombre` AS `na`, `cli`.`ci` AS `ci`, `cli`.`celular` AS `cel`, `cli`.`email` AS `eml`, `cli`.`face` AS `fac`, `cli`.`recordar` AS `sw` FROM `cliente` AS `cli`;

-- --------------------------------------------------------

--
-- Structure for view `conts`
--
DROP TABLE IF EXISTS `conts`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `conts`  AS SELECT `medio_contacto`.`nombre` AS `name`, `medio_contacto`.`recordar` AS `rem` FROM `medio_contacto`;

-- --------------------------------------------------------

--
-- Structure for view `dests`
--
DROP TABLE IF EXISTS `dests`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dests`  AS SELECT `lugar_destino`.`nombre` AS `name`, `lugar_destino`.`recordar` AS `rem` FROM `lugar_destino`;

-- --------------------------------------------------------

--
-- Structure for view `dist`
--
DROP TABLE IF EXISTS `dist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `dist`  AS SELECT `e`.`nombre` AS `nam`, `c`.`nombre` AS `name`, `c`.`ci` AS `ci`, `c`.`celular` AS `cel`, `e`.`recordar` AS `sw` FROM (`distribuidor` AS `e` left join `cliente` AS `c` on(`c`.`id` = `e`.`id_cliente`))  ;

-- --------------------------------------------------------

--
-- Structure for view `even`
--
DROP TABLE IF EXISTS `even`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `even`  AS SELECT `e`.`nombre` AS `nam`, `c`.`nombre` AS `name`, `c`.`ci` AS `ci`, `c`.`celular` AS `cel`, `e`.`recordar` AS `sw` FROM (`evento` AS `e` left join `cliente` AS `c` on(`c`.`id` = `e`.`id_cliente`))  ;

-- --------------------------------------------------------

--
-- Structure for view `obt_validos`
--
DROP TABLE IF EXISTS `obt_validos`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `obt_validos`  AS SELECT `p`.`id` AS `id`, `pe`.`enviado_in` AS `enviado_in`, `p`.`acuenta` AS `acuenta` FROM `pedido` AS `p` inner join `pedido_estado` AS `pe` on `pe`.`id` = `p`.`id` left join `ped_x` AS `pcc` on `pcc`.`id` = `p`.`id` WHERE `pcc`.`id` is null AND `pe`.`enviado_in` is not null AND `pe`.`en_mora_in` is null AND `p`.`acuenta` = `total`(`p`.`id`);


-- --------------------------------------------------------

--
-- Structure for view `pays`
--
DROP TABLE IF EXISTS `pays`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `pays`  AS SELECT `medio_de_pago`.`nombre` AS `name`, `medio_de_pago`.`recordar` AS `rem` FROM `medio_de_pago`;

-- --------------------------------------------------------

--
-- Structure for view `ped_cancer`
--
DROP TABLE IF EXISTS `ped_cancer`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_cancer`  AS SELECT `p`.`recibo_nro` AS `recib`, `vls2`(`tp`.`id_evento`,`tp`.`id_regular`,`tp`.`id_distrib`) AS `names`, `vls`(`tp`.`id_evento`,`tp`.`id_regular`,`tp`.`id_distrib`) AS `tipo`, `total`(`p`.`id`) AS `total`, `pcc`.`cnt` AS `can`, unix_timestamp(`pe`.`entrante_in`) AS `entra`, unix_timestamp(`p`.`fecha_pa_enviar`) AS `penvi`, if(`mc`.`nombre` is null,'',`mc`.`nombre`) AS `medco`, if(`ld`.`nombre` is null,'',`ld`.`nombre`) AS `lugde` FROM `pedido` AS `p` INNER JOIN `pedido_tipo` AS `tp` ON `tp`.`id` = `p`.`id` INNER JOIN `pedido_estado` AS `pe` on `pe`.`id` = `p`.`id` LEFT JOIN `medio_contacto` AS `mc` on `mc`.`id` = `p`.`id_medio_con` LEFT JOIN `lugar_destino` `ld` ON `ld`.`id` = `p`.`id_lugar_des` LEFT JOIN (select `pe`.`id` AS `id`,count(`sd`.`id`) AS `cnt` from `ped_x` AS `sd` INNER JOIN `pedido_e_cancelado` AS `pe` on `pe`.`id` = `sd`.`id` group by `sd`.`id`) AS `pcc` on `pcc`.`id` = `p`.`id` WHERE `pcc`.`id` is not null;

-- --------------------------------------------------------

--
-- Structure for view `ped_dist`
--
DROP TABLE IF EXISTS `ped_dist`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_dist`  AS SELECT `p`.`recib` AS `recib`, `e`.`nombre` AS `name`, `p`.`estado` AS `estado`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, `p`.`pays` AS `pays` FROM `ped_gral2` AS `p` INNER JOIN `pedido_tipo` AS `pt` on `pt`.`id` = `p`.`id` INNER JOIN `distribuidor` AS `e` on `e`.`id` = `pt`.`id_distrib` WHERE `pt`.`id_evento` is null AND `pt`.`id_regular` is null AND `pt`.`id_distrib` is not null;

-- --------------------------------------------------------

--
-- Structure for view `ped_entra`
--
DROP TABLE IF EXISTS `ped_entra`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_entra`  AS SELECT `p`.`recibo_nro` AS `recib`, `p`.`names` AS `names`, `p`.`tipo` AS `tipo`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde` FROM `ped_gral` AS `p` WHERE `p`.`entra` is not null AND `p`.`pendi` is null AND `p`.`moran` is null AND `p`.`termi` is null AND `p`.`envi` is null  ;

-- --------------------------------------------------------

--
-- Structure for view `ped_enviado`
--
DROP TABLE IF EXISTS `ped_enviado`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_enviado`  AS SELECT `p`.`recibo_nro` AS `recib`, `p`.`names` AS `names`, `p`.`tipo` AS `tipo`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`envi` AS `envi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, if(`mp`.`nombre` is null,'',`mp`.`nombre`) AS `pays` FROM `ped_gral` AS `p` left join `medio_de_pago` AS `mp` ON `mp`.`id` = `p`.`idmp` WHERE `p`.`envi` is not null AND `p`.`moran` is null AND `p`.`aconta` = `p`.`total`;

-- --------------------------------------------------------

--
-- Structure for view `ped_enviadod`
--
DROP TABLE IF EXISTS `ped_enviadod`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_enviadod`  AS SELECT `p`.`recibo_nro` AS `recib`, `p`.`names` AS `names`, `p`.`tipo` AS `tipo`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`envi` AS `envi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, if(`mp`.`nombre` is null,'',`mp`.`nombre`) AS `pays` FROM `ped_gral` AS `p` left join `medio_de_pago` AS `mp` on `mp`.`id` = `p`.`idmp` WHERE `p`.`envi` is not null AND `p`.`moran` is null AND `p`.`aconta` != `p`.`total`;

-- --------------------------------------------------------

--
-- Structure for view `ped_even`
--
DROP TABLE IF EXISTS `ped_even`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_even`  AS SELECT `p`.`recib` AS `recib`, `e`.`nombre` AS `name`, `p`.`estado` AS `estado`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, `p`.`pays` AS `pays` FROM `ped_gral2` AS `p` INNER JOIN `pedido_tipo` AS `pt` ON `pt`.`id` = `p`.`id` inner join `evento` AS `e` on `e`.`id` = `pt`.`id_evento` WHERE `pt`.`id_evento` is not null AND `pt`.`id_regular` is null AND `pt`.`id_distrib` is null;

-- --------------------------------------------------------

--
-- Structure for view `ped_gral`
--
DROP TABLE IF EXISTS `ped_gral`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_gral`  AS SELECT `p`.`id` AS `id`, `p`.`id_medio_pag` AS `idmp`, `p`.`recibo_nro` AS `recibo_nro`, `vls2`(`tp`.`id_evento`,`tp`.`id_regular`,`tp`.`id_distrib`) AS `names`, `vls`(`tp`.`id_evento`,`tp`.`id_regular`,`tp`.`id_distrib`) AS `tipo`, `p`.`acuenta` AS `aconta`, `total`(`p`.`id`) AS `total`, unix_timestamp(`p`.`fecha_pa_enviar`) AS `penvi`, unix_timestamp(`pe`.`entrante_in`) AS `entra`, unix_timestamp(`pe`.`pendiente_in`) AS `pendi`, unix_timestamp(`pe`.`en_mora_in`) AS `moran`, unix_timestamp(`pe`.`terminado_in`) AS `termi`, unix_timestamp(`pe`.`enviado_in`) AS `envi`, if(`mc`.`nombre` is null,'',`mc`.`nombre`) AS `medco`, if(`ld`.`nombre` is null,'',`ld`.`nombre`) AS `lugde` FROM `pedido` AS `p` INNER JOIN `pedido_tipo` AS `tp` on `tp`.`id` = `p`.`id` INNER JOIN `pedido_estado` `pe` on `pe`.`id` = `p`.`id` left join `medio_contacto` AS `mc` on `mc`.`id` = `p`.`id_medio_con` left join `lugar_destino` AS  `ld` on `ld`.`id` = `p`.`id_lugar_des` left join `ped_x` AS `pcc` on `pcc`.`id` = `p`.`id` WHERE `pcc`.`id` is null;

-- --------------------------------------------------------

--
-- Structure for view `ped_gral2`
--
DROP TABLE IF EXISTS `ped_gral2`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_gral2`  AS SELECT `p`.`id` AS `id`, `p`.`recibo_nro` AS `recib`, if(`pes`.`id` is not null,6,case when `e`.`entrante_in` is not null and `e`.`pendiente_in` is null and `e`.`en_mora_in` is null and `e`.`terminado_in` is null and `e`.`enviado_in` is null then 1 when `e`.`entrante_in` is not null and `e`.`pendiente_in` is not null and `e`.`en_mora_in` is null and `e`.`terminado_in` is null and `e`.`enviado_in` is null then 2 when `e`.`entrante_in` is not null and `e`.`pendiente_in` is null and `e`.`en_mora_in` is not null and `e`.`terminado_in` is null and `e`.`enviado_in` is null then 3 when `e`.`entrante_in` is not null and `e`.`pendiente_in` is not null and `e`.`en_mora_in` is null and `e`.`terminado_in` is not null and `e`.`enviado_in` is null then 4 when `e`.`entrante_in` is not null and `e`.`pendiente_in` is not null and `e`.`en_mora_in` is null and `e`.`terminado_in` is not null and `e`.`enviado_in` is not null then 5 else -1 end) AS `estado`, `total`(`p`.`id`) AS `total`, unix_timestamp(`p`.`fecha_pa_enviar`) AS `penvi`, unix_timestamp(`e`.`entrante_in`) AS `entra`, if(`mc`.`nombre` is null,'',`mc`.`nombre`) AS `medco`, if(`ld`.`nombre` is null,'',`ld`.`nombre`) AS `lugde`, if(`mp`.`nombre` is null,'',`mp`.`nombre`) AS `pays` FROM `pedido` AS `p` INNER JOIN `pedido_estado` AS `e` on `e`.`id` = `p`.`id` left join `ped_x` AS `pes` on `pes`.`id` = `p`.`id` left join `medio_contacto` AS `mc` on `mc`.`id` = `p`.`id_medio_con` left join `lugar_destino` AS `ld` on `ld`.`id` = `p`.`id_lugar_des` left join `medio_de_pago` AS `mp` on `mp`.`id` = `p`.`id_medio_pag`;

-- --------------------------------------------------------

--
-- Structure for view `ped_moras`
--
DROP TABLE IF EXISTS `ped_moras`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_moras`  AS SELECT `p`.`recibo_nro` AS `recib`, `p`.`tipo` AS `tipo`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde` FROM `ped_gral` AS `p` WHERE `p`.`moran` is not null AND `p`.`pendi` is null AND `p`.`termi` is null AND `p`.`envi` is null  ;

-- --------------------------------------------------------

--
-- Structure for view `ped_nordi`
--
DROP TABLE IF EXISTS `ped_nordi`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_nordi`  AS SELECT `p`.`recib` AS `recib`, concat(`c`.`nombre`,', ',if(`c`.`ci` is null,'',`c`.`ci`)) AS `cli`, `e`.`nombre` AS `name`, `p`.`estado` AS `estado`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, `p`.`pays` AS `pays` FROM `ped_gral2` AS `p` INNER JOIN `pedido_tipo` AS `pt` on `pt`.`id` = `p`.`id` INNER JOIN `distribuidor` AS `e` on `e`.`id` = `pt`.`id_distrib` INNER JOIN `cliente` AS `c` on `c`.`id` = `pt`.`id_regular` WHERE `pt`.`id_evento` is null AND `pt`.`id_regular` is not null AND `pt`.`id_distrib` is not null;

-- --------------------------------------------------------

--
-- Structure for view `ped_norev`
--
DROP TABLE IF EXISTS `ped_norev`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_norev`  AS SELECT `p`.`recib` AS `recib`, concat(`c`.`nombre`,', ',if(`c`.`ci` is null,'',`c`.`ci`)) AS `cli`, `e`.`nombre` AS `name`, `p`.`estado` AS `estado`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, `p`.`pays` AS `pays` FROM `ped_gral2` AS `p` INNER JOIN `pedido_tipo` AS `pt` on `pt`.`id` = `p`.`id` INNER JOIN `evento` AS `e` on `e`.`id` = `pt`.`id_evento` INNER JOIN `cliente` AS `c` on `c`.`id` = `pt`.`id_regular` WHERE `pt`.`id_evento` is not null AND `pt`.`id_regular` is not null AND `pt`.`id_distrib` is null;

-- --------------------------------------------------------

--
-- Structure for view `ped_norm`
--
DROP TABLE IF EXISTS `ped_norm`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_norm`  AS SELECT `p`.`recib` AS `recib`, concat(`c`.`nombre`,', ',if(`c`.`ci` is null,'',`c`.`ci`)) AS `cli`, `p`.`estado` AS `estado`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, `p`.`pays` AS `pays` FROM `ped_gral2` AS `p` INNER JOIN `pedido_tipo` AS `pt` on `pt`.`id` = `p`.`id` INNER JOIN `cliente` AS `c` on `c`.`id` = `pt`.`id_regular` WHERE `pt`.`id_evento` is null AND `pt`.`id_regular` is not null AND `pt`.`id_distrib` is null;

-- --------------------------------------------------------

--
-- Structure for view `ped_pendien`
--
DROP TABLE IF EXISTS `ped_pendien`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_pendien`  AS SELECT `p`.`recibo_nro` AS `recib`, `p`.`names` AS `names`, `p`.`tipo` AS `tipo`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, if(`mp`.`nombre` is null,'',`mp`.`nombre`) AS `pays` FROM `ped_gral` AS `p` left join `medio_de_pago` AS `mp` on `mp`.`id` = `p`.`idmp` WHERE `p`.`pendi` is not null AND `p`.`moran` is null AND `p`.`termi` is null AND `p`.`envi` is null;

-- --------------------------------------------------------

--
-- Structure for view `ped_term`
--
DROP TABLE IF EXISTS `ped_term`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_term`  AS SELECT `p`.`recibo_nro` AS `recib`, `p`.`tipo` AS `tipo`, `p`.`total` AS `total`, `p`.`entra` AS `entra`, `p`.`penvi` AS `penvi`, `p`.`termi` AS `termi`, `p`.`medco` AS `medco`, `p`.`lugde` AS `lugde`, if(`mp`.`nombre` is null,'',`mp`.`nombre`) AS `pays` FROM `ped_gral` AS `p` left join `medio_de_pago` AS `mp` on `mp`.`id` = `p`.`idmp` WHERE `p`.`termi` is not null AND `p`.`moran` is null AND `p`.`envi` is null;

-- --------------------------------------------------------

--
-- Structure for view `ped_x`
--
DROP TABLE IF EXISTS `ped_x`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `ped_x`  AS SELECT `pec`.`id` AS `id` FROM `pedido_e_cancelado` AS `pec` WHERE `pec`.`fecha_out` is null GROUP BY `pec`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `prody`
--
DROP TABLE IF EXISTS `prody`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `prody`  AS SELECT `pro`.`codigo` AS `codigo`, `cla`.`nombre` AS `clase`, `proTags`(`pro`.`id`) AS `tags`, if(`tab`.`cnt` is null,0,`tab`.`cnt`) AS `cantidad`, `pro`.`habil` AS `habil` FROM `producto` AS `pro` left join `producto_clase` AS `cla` on `cla`.`id` = `pro`.`id_producto_clase` left join (select sum(`det`.`cantidad`) AS `cnt`,`det`.`id_producto` AS `idp` from `detalle` AS `det` group by `det`.`id_producto`) AS `tab` on `tab`.`idp` = `pro`.`id`  ;

-- --------------------------------------------------------

--
-- Structure for view `s_pcontac` -- ?FIXME unknown use, difference AS `cod`
--
DROP TABLE IF EXISTS `s_pcontac`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `s_pcontac`  AS SELECT `medio_contacto`.`nombre` AS `name`, `medio_contacto`.`nombre` AS `cod` FROM `medio_contacto` WHERE `medio_contacto`.`recordar` = 11;

-- --------------------------------------------------------

--
-- Structure for view `s_pdestin` -- ?FIXME unknown use, difference AS `cod`
--
DROP TABLE IF EXISTS `s_pdestin`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `s_pdestin`  AS SELECT `lugar_destino`.`nombre` AS `name`, `lugar_destino`.`nombre` AS `cod` FROM `lugar_destino` WHERE `lugar_destino`.`recordar` = 11;

-- --------------------------------------------------------

--
-- Structure for view `s_ppay` -- ?FIXME unknown use, difference AS `cod`
--
DROP TABLE IF EXISTS `s_ppay`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `s_ppay`  AS SELECT `medio_de_pago`.`nombre` AS `name`, `medio_de_pago`.`nombre` AS `cod` FROM `medio_de_pago` WHERE `medio_de_pago`.`recordar` = 11;

-- --------------------------------------------------------

--
-- Structure for view `varen`
--
DROP TABLE IF EXISTS `varen`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `varen`  AS SELECT `pro`.`nombre` AS `nom`, if(`tcb`.`cnn` is null,0,`tcb`.`cnn`) AS `cnn`, `pro`.`habil` AS `habil` FROM `varis` AS `pro` left join (select `detalle_variante`.`id_variante` AS `idc`,count(`detalle_variante`.`id_variante`) AS `cnn` from `detalle_variante` group by `detalle_variante`.`id_variante`) AS `tcb` on `tcb`.`idc` = `pro`.`id`;

-- --------------------------------------------------------

--
-- Structure for view `varis`
--
DROP TABLE IF EXISTS `varis`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `varis`  AS SELECT `v`.`id` AS `id`, `v`.`nombre` AS `nombre`, `v`.`habil` AS `habil`, `vc`.`nombre` AS `grupo` FROM `variante` AS `v` left join `variante_clase` AS `vc` on `v`.`id_variante_clase` = `vc`.`id`;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cliente`
--
ALTER TABLE `cliente`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD UNIQUE KEY `id_tarjeta` (`id_tarjeta`),
  ADD KEY `cli_tar_fk` (`id_tarjeta`);

--
-- Indexes for table `cliente_tarjeta`
--
ALTER TABLE `cliente_tarjeta`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `detalle`
--
ALTER TABLE `detalle`
  ADD PRIMARY KEY (`id`),
  ADD KEY `de_pe_fk` (`id_pedido`),
  ADD KEY `de_di_fk` (`id_producto`);

--
-- Indexes for table `detalle_variante`
--
ALTER TABLE `detalle_variante`
  ADD UNIQUE KEY `id_detalle` (`id_detalle`),
  ADD KEY `de_de_fk` (`id_variante`);

--
-- Indexes for table `distribuidor`
--
ALTER TABLE `distribuidor`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `cli_dis_pk` (`id_cliente`);

--
-- Indexes for table `evento`
--
ALTER TABLE `evento`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `cli_eve_pk` (`id_cliente`);

--
-- Indexes for table `lugar_destino`
--
ALTER TABLE `lugar_destino`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indexes for table `medio_contacto`
--
ALTER TABLE `medio_contacto`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indexes for table `medio_de_pago`
--
ALTER TABLE `medio_de_pago`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indexes for table `pedido`
--
ALTER TABLE `pedido`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `recibo_nro` (`recibo_nro`),
  ADD KEY `pe_mp_fk` (`id_medio_pag`),
  ADD KEY `pe_mc_fk` (`id_medio_con`),
  ADD KEY `pe_ld_fk` (`id_lugar_des`);

--
-- Indexes for table `pedido_estado`
--
ALTER TABLE `pedido_estado`
  ADD UNIQUE KEY `id` (`id`);

--
-- Indexes for table `pedido_e_cancelado`
--
ALTER TABLE `pedido_e_cancelado`
  ADD KEY `pe_ec_fk` (`id`);

--
-- Indexes for table `pedido_tipo`
--
ALTER TABLE `pedido_tipo`
  ADD UNIQUE KEY `id` (`id`),
  ADD KEY `pt_ev_fk` (`id_evento`),
  ADD KEY `pt_cl_fk` (`id_regular`),
  ADD KEY `pt_di_fk` (`id_distrib`);

--
-- Indexes for table `prodclase_variante`
--
ALTER TABLE `prodclase_variante`
  ADD KEY `pro_var_fk` (`id_variante`),
  ADD KEY `por_dis_fk` (`id_producto_clase`);

--
-- Indexes for table `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `codigo` (`codigo`),
  ADD KEY `dpro_cl_fk` (`id_producto_clase`);

--
-- Indexes for table `producto_clase`
--
ALTER TABLE `producto_clase`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indexes for table `producto_tag`
--
ALTER TABLE `producto_tag`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- Indexes for table `producto_tag_producto`
--
ALTER TABLE `producto_tag_producto`
  ADD KEY `tag_pro_fk` (`id_producto_tag`),
  ADD KEY `pro_pro_fk` (`id_producto`);

--
-- Indexes for table `variante`
--
ALTER TABLE `variante`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`),
  ADD KEY `var_vac_fk` (`id_variante_clase`);

--
-- Indexes for table `variante_clase`
--
ALTER TABLE `variante_clase`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nombre` (`nombre`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cliente`
--
ALTER TABLE `cliente`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `cliente_tarjeta`
--
ALTER TABLE `cliente_tarjeta`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `detalle`
--
ALTER TABLE `detalle`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `distribuidor`
--
ALTER TABLE `distribuidor`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `evento`
--
ALTER TABLE `evento`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lugar_destino`
--
ALTER TABLE `lugar_destino`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `medio_contacto`
--
ALTER TABLE `medio_contacto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `medio_de_pago`
--
ALTER TABLE `medio_de_pago`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `pedido`
--
ALTER TABLE `pedido`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `producto`
--
ALTER TABLE `producto`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `producto_clase`
--
ALTER TABLE `producto_clase`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `producto_tag`
--
ALTER TABLE `producto_tag`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `variante`
--
ALTER TABLE `variante`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `variante_clase`
--
ALTER TABLE `variante_clase`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cliente`
--
ALTER TABLE `cliente`
  ADD CONSTRAINT `cli_tar_fk` FOREIGN KEY (`id_tarjeta`) REFERENCES `cliente_tarjeta` (`id`);

--
-- Constraints for table `detalle`
--
ALTER TABLE `detalle`
  ADD CONSTRAINT `de_di_fk` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`),
  ADD CONSTRAINT `de_pe_fk` FOREIGN KEY (`id_pedido`) REFERENCES `pedido` (`id`);

--
-- Constraints for table `detalle_variante`
--
ALTER TABLE `detalle_variante`
  ADD CONSTRAINT `de_de_fk` FOREIGN KEY (`id_variante`) REFERENCES `variante` (`id`),
  ADD CONSTRAINT `de_var_fk` FOREIGN KEY (`id_detalle`) REFERENCES `detalle` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `distribuidor`
--
ALTER TABLE `distribuidor`
  ADD CONSTRAINT `cli_dis_pk` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id`);

--
-- Constraints for table `evento`
--
ALTER TABLE `evento`
  ADD CONSTRAINT `cli_eve_pk` FOREIGN KEY (`id_cliente`) REFERENCES `cliente` (`id`);

--
-- Constraints for table `pedido`
--
ALTER TABLE `pedido`
  ADD CONSTRAINT `pe_ld_fk` FOREIGN KEY (`id_lugar_des`) REFERENCES `lugar_destino` (`id`),
  ADD CONSTRAINT `pe_mc_fk` FOREIGN KEY (`id_medio_con`) REFERENCES `medio_contacto` (`id`),
  ADD CONSTRAINT `pe_mp_fk` FOREIGN KEY (`id_medio_pag`) REFERENCES `medio_de_pago` (`id`);

--
-- Constraints for table `pedido_estado`
--
ALTER TABLE `pedido_estado`
  ADD CONSTRAINT `pe_es_fk` FOREIGN KEY (`id`) REFERENCES `pedido` (`id`);

--
-- Constraints for table `pedido_e_cancelado`
--
ALTER TABLE `pedido_e_cancelado`
  ADD CONSTRAINT `pe_ec_fk` FOREIGN KEY (`id`) REFERENCES `pedido` (`id`);

--
-- Constraints for table `pedido_tipo`
--
ALTER TABLE `pedido_tipo`
  ADD CONSTRAINT `pe_ti_fk` FOREIGN KEY (`id`) REFERENCES `pedido` (`id`),
  ADD CONSTRAINT `pt_cl_fk` FOREIGN KEY (`id_regular`) REFERENCES `cliente` (`id`),
  ADD CONSTRAINT `pt_di_fk` FOREIGN KEY (`id_distrib`) REFERENCES `distribuidor` (`id`),
  ADD CONSTRAINT `pt_ev_fk` FOREIGN KEY (`id_evento`) REFERENCES `evento` (`id`);

--
-- Constraints for table `prodclase_variante`
--
ALTER TABLE `prodclase_variante`
  ADD CONSTRAINT `por_dis_fk` FOREIGN KEY (`id_producto_clase`) REFERENCES `producto_clase` (`id`),
  ADD CONSTRAINT `pro_var_fk` FOREIGN KEY (`id_variante`) REFERENCES `variante` (`id`);

--
-- Constraints for table `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `dpro_cl_fk` FOREIGN KEY (`id_producto_clase`) REFERENCES `producto_clase` (`id`);

--
-- Constraints for table `producto_tag_producto`
--
ALTER TABLE `producto_tag_producto`
  ADD CONSTRAINT `pro_pro_fk` FOREIGN KEY (`id_producto`) REFERENCES `producto` (`id`),
  ADD CONSTRAINT `tag_pro_fk` FOREIGN KEY (`id_producto_tag`) REFERENCES `producto_tag` (`id`);

--
-- Constraints for table `variante`
--
ALTER TABLE `variante`
  ADD CONSTRAINT `var_vac_fk` FOREIGN KEY (`id_variante_clase`) REFERENCES `variante_clase` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;