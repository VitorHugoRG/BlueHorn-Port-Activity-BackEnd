create sequence pais_country_id_seq
    as integer;

alter sequence pais_country_id_seq owner to postgres;

create sequence porto_port_id_seq
    as integer;

alter sequence porto_port_id_seq owner to postgres;

create sequence tipo_carga_carga_id_seq
    as integer;

alter sequence tipo_carga_carga_id_seq owner to postgres;

create sequence data_calendario_data_id_seq
    as integer;

alter sequence data_calendario_data_id_seq owner to postgres;

create sequence movimentacao_movimentacao_id_seq
    as integer;

alter sequence movimentacao_movimentacao_id_seq owner to postgres;

create sequence portcalls_portcalls_id_seq
    as integer;

alter sequence portcalls_portcalls_id_seq owner to postgres;

create sequence importacao_import_id_seq
    as integer;

alter sequence importacao_import_id_seq owner to postgres;

create sequence exportacao_export_id_seq
    as integer;

alter sequence exportacao_export_id_seq owner to postgres;

create table pais
(
    country_id serial,
    name       text    not null,
    iso3       char(3) not null,
    primary key ()
);

alter table pais
    owner to postgres;

alter sequence pais_country_id_seq owned by pais.country_id;

create unique index pais_pkey
    on pais (country_id);

create table porto
(
    port_id    serial,
    name       text    not null,
    country_id integer not null
        references ??? (),
    latitude   numeric,
    longitude  numeric,
    primary key ()
);

alter table porto
    owner to postgres;

alter sequence porto_port_id_seq owned by porto.port_id;

create unique index porto_pkey
    on porto (port_id);

create table tipo_carga
(
    carga_id serial,
    nome     text not null,
    primary key ()
);

alter table tipo_carga
    owner to postgres;

alter sequence tipo_carga_carga_id_seq owned by tipo_carga.carga_id;

create unique index tipo_carga_pkey
    on tipo_carga (carga_id);

create table data_calendario
(
    data_id serial,
    data    date not null,
    primary key ()
);

alter table data_calendario
    owner to postgres;

alter sequence data_calendario_data_id_seq owned by data_calendario.data_id;

create unique index data_calendario_pkey
    on data_calendario (data_id);

create table movimentacao
(
    movimentacao_id serial,
    port_id         integer not null
        references ??? (),
    data_id         integer not null
        references ??? (),
    primary key ()
);

alter table movimentacao
    owner to postgres;

alter sequence movimentacao_movimentacao_id_seq owned by movimentacao.movimentacao_id;

create unique index movimentacao_pkey
    on movimentacao (movimentacao_id);

create table portcalls
(
    portcalls_id    serial,
    movimentacao_id integer not null
        references ??? (),
    carga_id        integer not null
        references ??? (),
    quantidade      integer not null,
    primary key ()
);

alter table portcalls
    owner to postgres;

alter sequence portcalls_portcalls_id_seq owned by portcalls.portcalls_id;

create unique index portcalls_pkey
    on portcalls (portcalls_id);

create table importacao
(
    import_id       serial,
    movimentacao_id integer not null
        references ??? (),
    carga_id        integer not null
        references ??? (),
    volume          numeric not null,
    primary key ()
);

alter table importacao
    owner to postgres;

alter sequence importacao_import_id_seq owned by importacao.import_id;

create unique index importacao_pkey
    on importacao (import_id);

create table exportacao
(
    export_id       serial,
    movimentacao_id integer not null
        references ??? (),
    carga_id        integer not null
        references ??? (),
    volume          numeric not null,
    primary key ()
);

alter table exportacao
    owner to postgres;

alter sequence exportacao_export_id_seq owned by exportacao.export_id;

create unique index exportacao_pkey
    on exportacao (export_id);

create view vw_daily_activity_v2
            (port_code, port_name, country_code, country_name, latitude, longitude, cargo_type_id, cargo_type, date,
             import_volume, export_volume)
as
SELECT p.port_id                           AS port_code,
       p.name                              AS port_name,
       pa.iso3                             AS country_code,
       pa.name                             AS country_name,
       p.latitude,
       p.longitude,
       tc.carga_id                         AS cargo_type_id,
       tc.nome                             AS cargo_type,
       dc.data                             AS date,
       COALESCE(sum(i.volume), 0::numeric) AS import_volume,
       COALESCE(sum(e.volume), 0::numeric) AS export_volume
FROM logistica.movimentacao m
         LEFT JOIN logistica.porto p ON m.port_id = p.port_id
         LEFT JOIN logistica.pais pa ON p.country_id = pa.country_id
         LEFT JOIN logistica.data_calendario dc ON m.data_id = dc.data_id
         LEFT JOIN logistica.importacao i ON m.movimentacao_id = i.movimentacao_id
         LEFT JOIN logistica.exportacao e ON m.movimentacao_id = e.movimentacao_id
         LEFT JOIN logistica.tipo_carga tc ON tc.carga_id = COALESCE(i.carga_id, e.carga_id)
GROUP BY p.port_id, p.name, p.latitude, p.longitude, pa.iso3, pa.name, tc.carga_id, tc.nome, dc.data;

alter table vw_daily_activity_v2
    owner to postgres;

create view vw_daily_activity_
            (portcode, portname, countrycode, countryname, latitude, longitude, cargotypeid, cargotype, date,
             importvolume, exportvolume)
as
SELECT p.port_id                           AS portcode,
       p.name                              AS portname,
       pa.iso3                             AS countrycode,
       pa.name                             AS countryname,
       p.latitude,
       p.longitude,
       tc.carga_id                         AS cargotypeid,
       tc.nome                             AS cargotype,
       dc.data                             AS date,
       COALESCE(sum(i.volume), 0::numeric) AS importvolume,
       COALESCE(sum(e.volume), 0::numeric) AS exportvolume
FROM logistica.movimentacao m
         LEFT JOIN logistica.porto p ON m.port_id = p.port_id
         LEFT JOIN logistica.pais pa ON p.country_id = pa.country_id
         LEFT JOIN logistica.data_calendario dc ON m.data_id = dc.data_id
         LEFT JOIN logistica.importacao i ON m.movimentacao_id = i.movimentacao_id
         LEFT JOIN logistica.exportacao e ON m.movimentacao_id = e.movimentacao_id
         LEFT JOIN logistica.tipo_carga tc ON tc.carga_id = COALESCE(i.carga_id, e.carga_id)
GROUP BY p.port_id, p.name, p.latitude, p.longitude, pa.iso3, pa.name, tc.carga_id, tc.nome, dc.data;

alter table vw_daily_activity_
    owner to postgres;


