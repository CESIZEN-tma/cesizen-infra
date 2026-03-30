-- ----------------------------------------------------------
-- Base schema - structure managed by EF Core migrations.
-- Migrations 1 and 4 are pre-marked as applied at startup
-- because this file already contains their resulting schema.
-- Migrations 2 (admin auth tables) and 3 (FailedLoginAttempts)
-- are applied automatically by MigrateAsync on first run.
-- ----------------------------------------------------------


CREATE TABLE user_saved_configurations (
  id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  inhalation INTEGER NOT NULL,
  retention1 INTEGER NOT NULL,
  exhalation INTEGER NOT NULL,
  retention2 INTEGER NOT NULL,
  duration_minutes INTEGER NOT NULL,
  difficulty INTEGER NOT NULL,
  objective VARCHAR(50) NOT NULL,
  guidance_type VARCHAR(50) NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  CONSTRAINT user_saved_configurations_pk PRIMARY KEY (id)
);


CREATE TABLE quizz (
  id UUID NOT NULL,
  nom VARCHAR(255) NOT NULL,
  active BOOLEAN NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  CONSTRAINT quizz_pk PRIMARY KEY (id)
);


CREATE TABLE navigation_menu (
  id UUID NOT NULL,
  position INTEGER NOT NULL,
  label VARCHAR(100) NOT NULL,
  url TEXT NOT NULL,
  currently_editing BOOLEAN NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  CONSTRAINT navigation_menu_pk PRIMARY KEY (id)
);


CREATE TABLE passwords_infos (
  id UUID NOT NULL,
  attempt_count INTEGER NOT NULL,
  last_login TIMESTAMPTZ NOT NULL,
  last_reset TIMESTAMPTZ NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  CONSTRAINT passwords_infos_pk PRIMARY KEY (id)
);


CREATE TABLE information_tags (
  id UUID NOT NULL,
  label VARCHAR(255) NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  CONSTRAINT information_tags_pk PRIMARY KEY (id)
);


CREATE TABLE administrators (
  id UUID NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash TEXT NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  member_since TIMESTAMPTZ NOT NULL,
  thumbnail_url TEXT,
  locked_until TIMESTAMPTZ,
  account_activated BOOLEAN NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_navigation_menu UUID,
  CONSTRAINT administrators_pk PRIMARY KEY (id),
  CONSTRAINT email_admin_unq UNIQUE (email),
  CONSTRAINT administrators_id_navigation_menu_fk FOREIGN KEY (id_navigation_menu) REFERENCES navigation_menu (id) ON DELETE SET NULL
);


CREATE TABLE admin_logs (
  id UUID NOT NULL,
  action_code TEXT NOT NULL,
  entity_type VARCHAR(255) NOT NULL,
  targeted_entity_id UUID NOT NULL,
  description TEXT NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_administrator UUID NOT NULL,
  CONSTRAINT admin_logs_pk PRIMARY KEY (id),
  CONSTRAINT admin_logs_id_administrator_fk FOREIGN KEY (id_administrator) REFERENCES administrators (id)
);


CREATE TABLE password_history (
  id UUID NOT NULL,
  password_hash TEXT NOT NULL,
  changed_at TIMESTAMPTZ NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_passwords_infos UUID NOT NULL,
  CONSTRAINT password_history_pk PRIMARY KEY (id),
  CONSTRAINT password_history_id_passwords_infos_fk FOREIGN KEY (id_passwords_infos) REFERENCES passwords_infos (id)
);


CREATE TABLE questions (
  id UUID NOT NULL,
  text TEXT NOT NULL,
  position INTEGER NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_quizz UUID NOT NULL,
  CONSTRAINT questions_pk PRIMARY KEY (id),
  CONSTRAINT questions_id_quizz_fk FOREIGN KEY (id_quizz) REFERENCES quizz (id)
);


-- users includes IdPasswordsInfos and IdPasswordsInfosNavigationId
-- added by migration 4 (SyncModelChanges), pre-applied via init.sql
CREATE TABLE users (
  id UUID NOT NULL,
  email VARCHAR(255) NOT NULL,
  password_hash TEXT NOT NULL,
  first_name VARCHAR(255) NOT NULL,
  last_name VARCHAR(255) NOT NULL,
  member_since TIMESTAMPTZ NOT NULL,
  thumbnail_url TEXT,
  locked_until TIMESTAMPTZ,
  account_activated BOOLEAN NOT NULL,
  active BOOLEAN NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_user_saved_configurations UUID,
  "IdPasswordsInfos" UUID,
  "IdPasswordsInfosNavigationId" UUID,
  CONSTRAINT users_pk PRIMARY KEY (id),
  CONSTRAINT email_unq UNIQUE (email),
  CONSTRAINT users_id_user_saved_configurations_fk FOREIGN KEY (id_user_saved_configurations) REFERENCES user_saved_configurations (id) ON DELETE SET NULL,
  CONSTRAINT "FK_users_passwords_infos_IdPasswordsInfosNavigationId" FOREIGN KEY ("IdPasswordsInfosNavigationId") REFERENCES passwords_infos (id)
);


CREATE TABLE information_pages (
  id UUID NOT NULL,
  title VARCHAR(100) NOT NULL,
  description TEXT NOT NULL,
  content TEXT NOT NULL,
  content_type VARCHAR(255) NOT NULL,
  currently_editing BOOLEAN NOT NULL,
  status VARCHAR(255) NOT NULL,
  active BOOLEAN NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_administrators UUID NOT NULL,
  CONSTRAINT information_pages_pk PRIMARY KEY (id),
  CONSTRAINT information_pages_id_administrators_fk FOREIGN KEY (id_administrators) REFERENCES administrators (id)
);


CREATE TABLE configurations (
  id UUID NOT NULL,
  name VARCHAR(255) NOT NULL,
  inhalation INTEGER NOT NULL,
  retention1 INTEGER NOT NULL,
  exhalation INTEGER NOT NULL,
  retention2 INTEGER NOT NULL,
  duration_minutes INTEGER NOT NULL,
  difficulty INTEGER NOT NULL,
  objective VARCHAR(50) NOT NULL,
  guidance_type VARCHAR(50) NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_administrators UUID NOT NULL,
  CONSTRAINT configurations_pk PRIMARY KEY (id),
  CONSTRAINT configurations_id_administrators_fk FOREIGN KEY (id_administrators) REFERENCES administrators (id)
);


CREATE TABLE session (
  id UUID NOT NULL,
  token TEXT NOT NULL,
  consumed BOOLEAN NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_users UUID NOT NULL,
  CONSTRAINT session_pk PRIMARY KEY (id),
  CONSTRAINT session_id_users_fk FOREIGN KEY (id_users) REFERENCES users (id)
);


CREATE TABLE responses_options (
  id UUID NOT NULL,
  label VARCHAR(255) NOT NULL,
  position INTEGER NOT NULL,
  targeted_field VARCHAR(255) NOT NULL,
  operation VARCHAR(255) NOT NULL,
  value VARCHAR(255) NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_questions UUID NOT NULL,
  CONSTRAINT responses_options_pk PRIMARY KEY (id),
  CONSTRAINT responses_options_id_questions_fk FOREIGN KEY (id_questions) REFERENCES questions (id)
);


CREATE TABLE email_confirmation_tokens (
  id UUID NOT NULL,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  consumed BOOLEAN NOT NULL,
  consumed_at TIMESTAMPTZ,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_users UUID NOT NULL,
  CONSTRAINT email_confirmation_tokens_pk PRIMARY KEY (id),
  CONSTRAINT email_confirmation_tokens_id_users_fk FOREIGN KEY (id_users) REFERENCES users (id)
);


CREATE TABLE password_reset_tokens (
  id UUID NOT NULL,
  token TEXT NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  consumed BOOLEAN NOT NULL,
  consumed_at TIMESTAMPTZ,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  id_users UUID NOT NULL,
  CONSTRAINT password_reset_tokens_pk PRIMARY KEY (id),
  CONSTRAINT password_reset_tokens_id_users_fk FOREIGN KEY (id_users) REFERENCES users (id)
);


CREATE TABLE auth (
  id UUID NOT NULL,
  id_session UUID NOT NULL,
  CONSTRAINT auth_pk PRIMARY KEY (id, id_session),
  CONSTRAINT auth_id_fk FOREIGN KEY (id) REFERENCES administrators (id),
  CONSTRAINT auth_id_session_fk FOREIGN KEY (id_session) REFERENCES session (id)
);


CREATE TABLE bookmark (
  id UUID NOT NULL,
  id_configurations UUID NOT NULL,
  creation_time TIMESTAMPTZ NOT NULL,
  update_time TIMESTAMPTZ,
  deletion_time TIMESTAMPTZ,
  CONSTRAINT bookmark_pk PRIMARY KEY (id, id_configurations),
  CONSTRAINT bookmark_id_fk FOREIGN KEY (id) REFERENCES users (id),
  CONSTRAINT bookmark_id_configurations_fk FOREIGN KEY (id_configurations) REFERENCES configurations (id)
);


CREATE TABLE tagged (
  id UUID NOT NULL,
  id_information_tags UUID NOT NULL,
  CONSTRAINT tagged_pk PRIMARY KEY (id, id_information_tags),
  CONSTRAINT tagged_id_fk FOREIGN KEY (id) REFERENCES information_pages (id),
  CONSTRAINT tagged_id_information_tags_fk FOREIGN KEY (id_information_tags) REFERENCES information_tags (id)
);


-- Indexes
CREATE INDEX token_idx ON password_reset_tokens (token);
CREATE INDEX email_idx ON users (email);
CREATE INDEX email_admin_idx ON administrators (email);
CREATE INDEX "IX_admin_logs_id_administrator" ON admin_logs (id_administrator);
CREATE INDEX "IX_administrators_id_navigation_menu" ON administrators (id_navigation_menu);
CREATE INDEX "IX_auth_id_session" ON auth (id_session);
CREATE INDEX "IX_bookmark_id_configurations" ON bookmark (id_configurations);
CREATE INDEX "IX_configurations_id_administrators" ON configurations (id_administrators);
CREATE INDEX "IX_email_confirmation_tokens_id_users" ON email_confirmation_tokens (id_users);
CREATE INDEX "IX_information_pages_id_administrators" ON information_pages (id_administrators);
CREATE INDEX "IX_password_history_id_passwords_infos" ON password_history (id_passwords_infos);
CREATE INDEX "IX_password_reset_tokens_id_users" ON password_reset_tokens (id_users);
CREATE INDEX "IX_questions_id_quizz" ON questions (id_quizz);
CREATE INDEX "IX_responses_options_id_questions" ON responses_options (id_questions);
CREATE INDEX "IX_session_id_users" ON session (id_users);
CREATE INDEX "IX_tagged_id_information_tags" ON tagged (id_information_tags);
CREATE INDEX "IX_users_id_user_saved_configurations" ON users (id_user_saved_configurations);
CREATE INDEX "IX_users_IdPasswordsInfosNavigationId" ON users ("IdPasswordsInfosNavigationId");
