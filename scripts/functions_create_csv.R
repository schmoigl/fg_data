# functions #############
create_fb1 = function(){
  wds_conn <- odbcConnect("wds")
  sql = "
      SELECT
          a.\"SeriesDate\"
          , a.\"SeriesValue\" AS de -- diese zeile einfach auskommentieren, wenn ohne de gebraucht
          , b.\"SeriesValue\" AS eu
          , c.\"SeriesValue\" AS usa
      FROM
          (select * from mb_timeseriesdata_zmq('gen_u22_wdiffdlr')) a
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_u22_wdifferr')) b
          ON a.\"SeriesDate\" = b.\"SeriesDate\"
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_u22_wdiffusr')) c
          ON a.\"SeriesDate\" = c.\"SeriesDate\"
      WHERE
          a.\"SeriesDate\" >= '2008-01-01'
      ORDER BY
          a.\"SeriesDate\"
  "
  
  data <- sqlQuery(wds_conn, sql)
  close(wds_conn)
  rm(sql, wds_conn)
  data$de = as.character(round(data$de, 1))
  data$eu = as.character(round(data$eu, 1))
  data$usa = as.character(round(data$usa, 1))
  print(data)

  write.table(x = data, file = 'daten_fb1.csv', row.names = F, na = "", sep = ";", quote = F)
  l('fb1 csv ready')
}

create_fb2 = function(){
  wds_conn <- odbcConnect("wds")
  sql = "
  SELECT
      a.\"SeriesDate\"
      , ROUND((a.\"SeriesValue\" / 1000)::numeric,3) AS     unselb_besch_1000
      , ROUND(b.\"SeriesValue\"::numeric,3) AS            al_quote
  FROM
      (select * from mb_timeseriesdata_zmq('gen_absegm')) a
      INNER JOIN
      (select * from mb_timeseriesdata_zmq('gen_aalrgm')) b
      ON a.\"SeriesDate\" = b.\"SeriesDate\"
  WHERE
      a.\"SeriesDate\" >= '2015-01-01'
  ORDER BY
      a.\"SeriesDate\"
  ;
  "
  data <- sqlQuery(wds_conn, sql)
  close(wds_conn)
  rm(sql, wds_conn)
  print(data)
  
  write.table(x = data, file = 'daten_fb2.csv', row.names = F, na = "", sep = ";", quote = F)
  l('fb2 csv ready')
}

create_fb3 = function(){
  wds_conn <- odbcConnect("wah")
  sql = "
  SELECT
      a.\"SeriesDate\"
  
      , a.\"SeriesValue\" / b.\"SeriesValue\" * 100 as OMW  --Oesterreichs Marktanteil am OECD-34-Export in die Welt
      , c.\"SeriesValue\" / d.\"SeriesValue\" * 100 as OMEU --Oesterreichs Marktanteil am OECD-34-Export in die EU-28
  
      , (a.\"SeriesValue\" - c.\"SeriesValue\") / (b.\"SeriesValue\" - d.\"SeriesValue\") * 100 AS OMEEU--Oesterreichs Marktanteil am OECD-34-Export in die Extra-EU-28
  
      FROM
      (select * from mb_timeseriesdata_zmq('dot_122_txg_fob_usd_001_a')) a
      INNER JOIN (select * from mb_timeseriesdata_zmq('dot_001_txg_fob_usd_001_a')) b ON a.\"SeriesDate\" = b.\"SeriesDate\"
      INNER JOIN (select * from mb_timeseriesdata_zmq('dot_122_txg_fob_usd_eu28_a')) c ON a.\"SeriesDate\" = c.\"SeriesDate\"
      INNER JOIN (select * from mb_timeseriesdata_zmq('dot_001_txg_fob_usd_eu28_a')) d ON a.\"SeriesDate\" = d.\"SeriesDate\"
  WHERE
      a.\"SeriesDate\" >= '2008-01-01'
  ORDER BY
      a.\"SeriesDate\"
  ;
  "
  data_ah <- sqlQuery(wds_conn, sql)
  close(wds_conn)
  wds_conn <- odbcConnect("wds")
  
  sql = "
  SELECT
      a.\"SeriesDate\"
      , a.\"SeriesValue\" AS BrAusgFE -- Bruttoinlandsausgaben für F&E
      , b.\"SeriesValue\" AS AusgFE -- Ausgaben des Unternehmenssektors für F&E
      , c.\"SeriesValue\" / d.\"SeriesValue\" / 1000 AS ProdBesch-- Produktion je Beschäftigten
  FROM
      (select * from mb_timeseriesdata_zmq('gen_u37_fuebip')) a
      INNER JOIN (select * from mb_timeseriesdata_zmq('gen_u37_fueinbip')) b ON a.\"SeriesDate\" = b.\"SeriesDate\"
      LEFT OUTER JOIN (
          select
              TO_DATE(TO_CHAR(\"SeriesDate\",'YYYY'), 'YYYY') AS \"SeriesDate\"
              , SUM(\"SeriesValue\") AS \"SeriesValue\"
          from mb_timeseriesdata_zmq('kon_eh_______apwtot_10_c_m')
          GROUP BY
              TO_DATE(TO_CHAR(\"SeriesDate\",'YYYY'), 'YYYY')
      ) c ON a.\"SeriesDate\" = c.\"SeriesDate\"
      LEFT OUTER JOIN
      (
          select
              TO_DATE(TO_CHAR(\"SeriesDate\",'YYYY'), 'YYYY') AS \"SeriesDate\"
              , AVG(\"SeriesValue\") AS \"SeriesValue\"
          from mb_timeseriesdata_zmq('kon_eh__uns_tot_____10_c_m')
          GROUP BY
              TO_DATE(TO_CHAR(\"SeriesDate\",'YYYY'), 'YYYY')
      ) d ON a.\"SeriesDate\" = d.\"SeriesDate\"
  WHERE
      a.\"SeriesDate\" >= '2008-01-01'
  ORDER BY
      a.\"SeriesDate\"
  ;
  "
  data_wds <- sqlQuery(wds_conn, sql)
  close(wds_conn)
  rm(sql, wds_conn)
  
  setDT(data_wds)
  setDT(data_ah)
  
  data = merge(data_ah, data_wds, by.x = c('SeriesDate'), by.y = c('SeriesDate'))
  
  print(data)
  
  write.table(x = data, file = 'daten_fb3.csv', row.names = F, na = "", sep = ";", quote = F)
  l('fb3 csv ready')
}

create_fb5 = function(){
  wds_conn <- odbcConnect("wds")
  
  # sql = "select * from mb_timeseriesdata_zmq('gen_ab01i190')"
  # d <- sqlQuery(wds_conn, sql)
  # setDT(d)
  # d
  
  # gen_sgveem, gen_sgvbim, gen_sgvgam, gen_sgvmpm, gen_sgvkom
  # gen_sgvssm, gen_o10bipmr
  sql = "
      SELECT
            a.\"SeriesDate\"
          , round(cast(a.\"SeriesValue\" / 1000 as numeric), 2) AS Wasserkraft
          , round(cast(b.\"SeriesValue\" / 1000 as numeric), 2) AS Biomasse
          , round(cast(c.\"SeriesValue\" / 1000 as numeric), 2) AS Gas
          , round(cast(d.\"SeriesValue\" / 1000 as numeric), 2) AS Mineralöl
          , round(cast(e.\"SeriesValue\" / 1000 as numeric), 2) AS Kohle
          , f.\"SeriesValue\" AS PrimEnVerbr
          , g.\"SeriesValue\" AS BIP
      FROM
          (select * from mb_timeseriesdata_zmq('gen_sgveem')) a --Wasserkraft
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_sgvbim')) b --biomasse
          ON a.\"SeriesDate\" = b.\"SeriesDate\"
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_sgvgam')) c --gas
          ON a.\"SeriesDate\" = c.\"SeriesDate\"
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_sgvmpm')) d --Mineralöl
          ON a.\"SeriesDate\" = d.\"SeriesDate\"
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_sgvkom')) e --Kohle
          ON a.\"SeriesDate\" = e.\"SeriesDate\"
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_sgvssm')) f
          ON a.\"SeriesDate\" = f.\"SeriesDate\"
          INNER JOIN
          (select * from mb_timeseriesdata_zmq('gen_o10bipmr')) g
          ON a.\"SeriesDate\" = g.\"SeriesDate\"
      WHERE
          a.\"SeriesDate\" >= '1995-01-01'
      ORDER BY
          a.\"SeriesDate\"
  "
  
  data_wds <- sqlQuery(wds_conn, sql)
  
  close(wds_conn)
  rm(sql, wds_conn)
  
  setDT(data_wds)
  data_wds[,`:=`(
      primI = round(primenverbr / data_wds$primenverbr[1] * 100, 2)
    , bipI  = round(bip / data_wds$bip[1] * 100, 2)
  )]
  data_wds$primenverbr = NULL
  data_wds$bip = NULL

  print(data_wds)
  
  write.table(x = data_wds, file = 'daten_fb5.csv', row.names = F, na = "", sep = ";", quote = F)
  l('fb5 csv ready')
}

uploadToWebServer = function(file){
  
  loadPackages(c('ssh'))
  
  host = 'wifo.ac.at'
  print(paste(Sys.time(), 'ssh start upload to', host))
  ssh_con = ssh_connect(host = host)
  l(print(ssh_con), lL = 2)
  
  # command
  #out <- ssh_exec_wait(ssh_con, command = 'whoami')
  
  # upload
  scp_upload(session = ssh_con
             , files = file
             , to = "/home/boehs/wwa_graphik"
             , verbose = F)
  
  ssh::ssh_disconnect(session = ssh_con)
  l(paste(Sys.time(), 'ssh upload done'), lL = 2)
}
