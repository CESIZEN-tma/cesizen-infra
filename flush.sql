DO $$
DECLARE
    v_admin_id            UUID;
    v_admin_email         TEXT;
    v_admin_hash          TEXT;
    v_admin_first_name    TEXT;
    v_admin_last_name     TEXT;
    v_admin_member_since  TIMESTAMPTZ;
    v_admin_creation_time TIMESTAMPTZ;
BEGIN
    -- Récupérer le premier admin existant
    SELECT id, email, password_hash, first_name, last_name, member_since, creation_time
    INTO v_admin_id, v_admin_email, v_admin_hash, v_admin_first_name, v_admin_last_name, v_admin_member_since, v_admin_creation_time
    FROM administrators
    LIMIT 1;

    IF v_admin_id IS NULL THEN
        RAISE EXCEPTION 'Aucun administrateur trouvé. Démarrez l''API au moins une fois d''abord.';
    END IF;

    -- =========================================================
    -- TRUNCATE (ordre respectant les FK)
    -- =========================================================
    TRUNCATE TABLE
        responses_options,
        questions,
        quizz,
        tagged,
        information_pages,
        information_tags,
        navigation_menu,
        configurations
    RESTART IDENTITY CASCADE;

    -- =========================================================
    -- RESTORE ADMIN (wiped by cascade)
    -- =========================================================
    INSERT INTO administrators (
        id,
        email,
        password_hash,
        first_name,
        last_name,
        member_since,
        account_activated,
        creation_time,
        "FailedLoginAttempts"
    )
    VALUES (
        v_admin_id,
        v_admin_email,
        v_admin_hash,
        v_admin_first_name,
        v_admin_last_name,
        v_admin_member_since,
        true,
        v_admin_creation_time,
        0
    );

    RAISE NOTICE 'Seed CesiZen terminé avec succès.';
END $$;