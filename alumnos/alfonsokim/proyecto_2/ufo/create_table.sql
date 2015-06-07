create table sightings_dirty (
    line_number integer,
    date_time_str varchar,
    city_str varchar,
    state_str varchar,
    summary varchar,
    report text,
    shape varchar,
    duration_str varchar,
    posted_str varchar
);

create table sightings (
    line_number integer,
    date_time timestamp with time zone,
    city_str varchar,
    state_str varchar,
    summary varchar,
    report text,
    shape varchar,
    duration_str varchar,
    posted_str varchar
);

