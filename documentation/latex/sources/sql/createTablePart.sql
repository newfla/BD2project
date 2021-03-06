
--Temporary table to store csv records--
CREATE TABLE if not exists temp_table(
  test_id int,
  date Date,
  time Time,
  relative_s int,
  co_concentration_vol_per double precision,
  co2_concentration_vol_perc double precision,
  nox_concentration_ppm double precision,
  h2O_conc_vol_perc double precision,
  a_f double precision,
  exh_flow_corr_m3_min double precision,
  exh_flow_corr_m3_s double precision,
  exh_Temp_degC double precision,
  exh_press_kPa double precision,
  amb_temp_degC double precision,
  amb_press_kPa double precision,
  amb_humid_RH double precision,
  altitude_m double precision,
  velocity_km_h double precision,
  battery_V double precision,
  co_mass_g_s double precision,
  co2_mass_g_s double precision,
  nox_mass_g_s double precision,
  fuel_g_s double precision,
  power_kW double precision,
  speed_km_h double precision,
  voltage_V double precision,
  engine_coolant_temperature_by_ecu_degC double precision,
  fuel_pressure_by_ecu_kPa double precision,
  engine_RPM_by_ecu_rpm double precision,
  vehicle_speed_by_ecu_km_h double precision,
  vehicle_speed_by_ecu_m_s double precision,
  distance_m double precision,
  intake_air_temperature_by_ecu_degC double precision,
  maf_air_flow_rate_by_ecu_grams_sec double precision,
  maf_air_flow_rate_by_ecu_m3_s double precision,
  fuel_rail_pressure_by_ecu_kPa double precision,
  fuel_rail_pressure_diesel_by_ecu_kPa double precision,
  commande_EGR_by_ecu_perc double precision,
  barometric_pressure_by_ecu_kPa double precision,
  ambient_air_temperature_by_ecu_degC double precision,
  fuel_rail_pressure_Time_by_ecu_kPa double precision,
  engine_oil_temperature_by_ecu_degC double precision,
  engine_fuel_rate_by_ecu_L_h double precision,
  actual_engine_by_ecu_perc double precision,
  engine_reference_torque_by_ecu_Nm double precision
);

--Season ENUM--
DROP TYPE if exists seasons;
CREATE TYPE seasons as ENUM('autumn','winter','spring','summer');

--Date Hierarchy Table--
CREATE TABLE if not exists date_hierarchy(
  date_key Date UNIQUE ,
  month smallint,
  season seasons,
  year smallint
);

--Time Hierarchy Table--
CREATE TABLE if not exists time_hierarchy(
  step_key int,
  minute smallint,
  hour smallint
);

--Distance Hierarchy Table--
CREATE TABLE  if not exists distance_hierarchy(
  km_key int UNIQUE,
  km_5 int,
  km_25 int,
  km_50 int
);

--Acquisition Fact General Table--
CREATE TABLE if not exists acquisition_fact_general(
  row_id bigserial,
  test_id int,
  date_key date,
  step_key int,
  km_key int,
  amb_temp_degC double precision,
  amb_press_kPa double precision,
  amb_humid_RH double precision,
  altitude_m double precision,
  velocity_km_h double precision,
  battery_V double precision,
  fuel_g_s double precision,
  power_kW double precision,
  speed_km_h double precision,
  voltage_V double precision,
  distance_m double precision
);

--Acquisition Fact Flow Table--
CREATE TABLE if not exists acquisition_fact_flow(
  row_id bigserial,
  test_id int,
  date_key date,
  step_key int,
  km_key int,
  a_f double precision,
  exh_flow_corr_m3_min double precision,
  exh_flow_corr_m3_s double precision,
  exh_Temp_degC double precision,
  exh_press_kPa double precision
);

--Acquisition Fact Particles Table--
CREATE TABLE if not exists acquisition_fact_particles(
  row_id bigserial,
  test_id int,
  date_key date,
  step_key int,
  km_key int,
  co_concentration_vol_per double precision,
  co2_concentration_vol_perc double precision,
  nox_concentration_ppm double precision,
  h2O_conc_vol_perc double precision,
  co_mass_g_s double precision,
  co2_mass_g_s double precision,
  nox_mass_g_s double precision
);


--Acquisition Fact ECU Table--
CREATE TABLE if not exists acquisition_fact_ecu(
  row_id bigserial,
  test_id int,
  date_key date,
  step_key int,
  km_key int,
  engine_coolant_temperature_by_ecu_degC double precision,
  fuel_pressure_by_ecu_kPa double precision,
  engine_RPM_by_ecu_rpm double precision,
  vehicle_speed_by_ecu_km_h double precision,
  vehicle_speed_by_ecu_m_s double precision,
  intake_air_temperature_by_ecu_degC double precision,
  maf_air_flow_rate_by_ecu_grams_sec double precision,
  maf_air_flow_rate_by_ecu_m3_s double precision,
  fuel_rail_pressure_by_ecu_kPa double precision,
  fuel_rail_pressure_diesel_by_ecu_kPa double precision,
  commande_EGR_by_ecu_perc double precision,
  barometric_pressure_by_ecu_kPa double precision,
  ambient_air_temperature_by_ecu_degC double precision,
  fuel_rail_pressure_Time_by_ecu_kPa double precision,
  engine_oil_temperature_by_ecu_degC double precision,
  engine_fuel_rate_by_ecu_L_h double precision,
  actual_engine_by_ecu_perc double precision,
  engine_reference_torque_by_ecu_Nm double precision
);

--Index for fact General table--
CREATE INDEX if not exists acquisition_fact_general_date_index on acquisition_fact_general using hash(date_key);

CREATE INDEX if not exists acquisition_fact_general_step_index on acquisition_fact_general using hash(step_key);

CREATE INDEX if not exists acquisition_fact_general_km_index on acquisition_fact_general using hash(km_key);


--Index for fact Flow table--
CREATE INDEX if not exists acquisition_fact_flow_date_index on acquisition_fact_flow using hash(date_key);

CREATE INDEX if not exists acquisition_fact_flow_step_index on acquisition_fact_flow using hash(step_key);

CREATE INDEX if not exists acquisition_fact_flow_km_index on acquisition_fact_flow using hash(km_key);


--Index for fact Particles table--
CREATE INDEX if not exists acquisition_fact_particles_date_index on acquisition_fact_particles using hash(date_key);

CREATE INDEX if not exists acquisition_fact_particles_step_index on acquisition_fact_particles using hash(step_key);

CREATE INDEX if not exists acquisition_fact_particles_km_index on acquisition_fact_particles using hash(km_key);

--Index for fact Ecu table--
CREATE INDEX if not exists acquisition_fact_ecu_date_index on acquisition_fact_ecu using hash(date_key);

CREATE INDEX if not exists acquisition_fact_ecu_step_index on acquisition_fact_ecu using hash(step_key);

CREATE INDEX if not exists acquisition_fact_ecu_km_index on acquisition_fact_ecu using hash(km_key);