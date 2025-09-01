-- Create a table named ff14skill_attributes in the ff14skills database
CREATE TABLE ff14skill_attributes (
  id SERIAL PRIMARY KEY,
  action_name TEXT,
  level_acquired TEXT,
  type_of_action TEXT,
  "cast" TEXT,
  recast DECIMAL(4, 1),
  mp_cost INTEGER,
  radius TEXT,
  effect TEXT
);
