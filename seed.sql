-- =============================================================
-- CesiZen — Seed data
-- Prérequis : lancer l'API au moins une fois (admin créé par le C# seeder)
-- Champs quiz valides : inhalation | retention1 | exhalation | retention2
--                       durationminutes | difficulty | objective | guidancetype
-- Opérations numériques : SET | ADD | MULTIPLY   — texte : SET
-- Valeurs par défaut   : 4 | 4 | 4 | 4 | 5 | 1 | "Relaxation" | "Visual"
-- =============================================================

DO $$
DECLARE
    v_admin_id            UUID;
    v_admin_email         TEXT;
    v_admin_hash          TEXT;
    v_admin_first_name    TEXT;
    v_admin_last_name     TEXT;
    v_admin_member_since  TIMESTAMPTZ;
    v_admin_creation_time TIMESTAMPTZ;

    -- ── Tags ──────────────────────────────────────────────────────────────
    tag_stress        UUID := gen_random_uuid();
    tag_anxiete       UUID := gen_random_uuid();
    tag_respiration   UUID := gen_random_uuid();
    tag_coh_card      UUID := gen_random_uuid();
    tag_sommeil       UUID := gen_random_uuid();
    tag_mindfulness   UUID := gen_random_uuid();
    tag_bien_etre     UUID := gen_random_uuid();
    tag_energie       UUID := gen_random_uuid();
    tag_concentration UUID := gen_random_uuid();
    tag_sante         UUID := gen_random_uuid();

    -- ── Pages ─────────────────────────────────────────────────────────────
    p_stress_comprendre  UUID := gen_random_uuid();
    p_stress_burnout     UUID := gen_random_uuid();
    p_stress_travail     UUID := gen_random_uuid();
    p_anxiete_crises     UUID := gen_random_uuid();
    p_anxiete_tcc        UUID := gen_random_uuid();
    p_resp_bases         UUID := gen_random_uuid();
    p_resp_coh           UUID := gen_random_uuid();
    p_resp_crise         UUID := gen_random_uuid();
    p_resp_478           UUID := gen_random_uuid();
    p_resp_box           UUID := gen_random_uuid();
    p_sommeil_cycles     UUID := gen_random_uuid();
    p_sommeil_stress     UUID := gen_random_uuid();
    p_mind_intro         UUID := gen_random_uuid();
    p_mind_quotidien     UUID := gen_random_uuid();
    p_energie_alim       UUID := gen_random_uuid();
    p_energie_hydrat     UUID := gen_random_uuid();
    p_sport              UUID := gen_random_uuid();
    p_immuno             UUID := gen_random_uuid();

    -- ── Menus racine ──────────────────────────────────────────────────────
    m_sante_h    UUID := gen_random_uuid();
    m_resp_h     UUID := gen_random_uuid();
    m_sommeil_h  UUID := gen_random_uuid();
    m_mind_h     UUID := gen_random_uuid();
    m_energie_h  UUID := gen_random_uuid();
    m_apropos_h  UUID := gen_random_uuid();
    m_contact    UUID := gen_random_uuid();
    m_legal      UUID := gen_random_uuid();

    -- ── Sous-menus → Santé mentale ────────────────────────────────────────
    m_stress         UUID := gen_random_uuid();
    m_burnout        UUID := gen_random_uuid();
    m_anxiete        UUID := gen_random_uuid();
    m_tcc            UUID := gen_random_uuid();
    m_stress_travail UUID := gen_random_uuid();

    -- ── Sous-menus → Respiration ──────────────────────────────────────────
    m_resp_bases UUID := gen_random_uuid();
    m_resp_coh   UUID := gen_random_uuid();
    m_resp_crise UUID := gen_random_uuid();
    m_resp_478   UUID := gen_random_uuid();
    m_resp_box   UUID := gen_random_uuid();

    -- ── Sous-menus → Sommeil ──────────────────────────────────────────────
    m_sommeil    UUID := gen_random_uuid();
    m_som_stress UUID := gen_random_uuid();

    -- ── Sous-menus → Pleine conscience ───────────────────────────────────
    m_mind_intro UUID := gen_random_uuid();
    m_mind_quot  UUID := gen_random_uuid();

    -- ── Sous-menus → Énergie & Nutrition ─────────────────────────────────
    m_alim       UUID := gen_random_uuid();
    m_hydrat     UUID := gen_random_uuid();
    m_sport_m    UUID := gen_random_uuid();
    m_immuno_m   UUID := gen_random_uuid();

    -- ── Sous-menus → À propos ─────────────────────────────────────────────
    m_mission    UUID := gen_random_uuid();
    m_equipe     UUID := gen_random_uuid();
    m_partenaires UUID := gen_random_uuid();

    -- ── Sous-menus → Légal ───────────────────────────────────────────────
    m_mentions   UUID := gen_random_uuid();
    m_confidential UUID := gen_random_uuid();

    -- ── Configurations admin ──────────────────────────────────────────────
    c1 UUID := gen_random_uuid();
    c2 UUID := gen_random_uuid();
    c3 UUID := gen_random_uuid();
    c4 UUID := gen_random_uuid();
    c5 UUID := gen_random_uuid();
    c6 UUID := gen_random_uuid();
    c7 UUID := gen_random_uuid();

    -- ── Quizzes ──────────────────────────────────────────────────────────
    q1 UUID := gen_random_uuid();
    q2 UUID := gen_random_uuid();
    q3 UUID := gen_random_uuid();
    q4 UUID := gen_random_uuid();
    q5 UUID := gen_random_uuid();

    qq UUID;

BEGIN
    SELECT id, email, password_hash, first_name, last_name, member_since, creation_time
    INTO v_admin_id, v_admin_email, v_admin_hash, v_admin_first_name, v_admin_last_name, v_admin_member_since, v_admin_creation_time
    FROM administrators LIMIT 1;

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
    INSERT INTO administrators (id, email, password_hash, first_name, last_name, member_since, account_activated, creation_time, "FailedLoginAttempts")
    VALUES (v_admin_id, v_admin_email, v_admin_hash, v_admin_first_name, v_admin_last_name, v_admin_member_since, true, v_admin_creation_time, 0);

    -- =========================================================
    -- TAGS
    -- =========================================================
    INSERT INTO information_tags (id, label, creation_time) VALUES
        (tag_stress,        'Stress',              NOW()),
        (tag_anxiete,       'Anxiété',             NOW()),
        (tag_respiration,   'Respiration',         NOW()),
        (tag_coh_card,      'Cohérence cardiaque', NOW()),
        (tag_sommeil,       'Sommeil',             NOW()),
        (tag_mindfulness,   'Pleine conscience',   NOW()),
        (tag_bien_etre,     'Bien-être',           NOW()),
        (tag_energie,       'Énergie',             NOW()),
        (tag_concentration, 'Concentration',       NOW()),
        (tag_sante,         'Santé',               NOW())
    ON CONFLICT DO NOTHING;

    -- =========================================================
    -- INFORMATION PAGES
    -- =========================================================

    -- Santé mentale — Stress
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES

    (p_stress_comprendre, 'Comprendre le stress',
    'Les mécanismes du stress et comment y répondre efficacement.',
    '<h2>Qu''est-ce que le stress ?</h2>
<p>Le stress est une réaction de l''organisme face à une situation perçue comme exigeante. En quantité raisonnable, il est un moteur. Chronique, il devient un ennemi.</p>
<h2>Le cycle du stress</h2>
<p>Face à un stresseur, le cerveau libère cortisol et adrénaline : cœur qui s''accélère, muscles tendus, respiration superficielle. Ce mécanisme ancestral de survie devient problématique quand il est activé en permanence.</p>
<h2>Les 3 stades (Selye)</h2>
<ul>
  <li><strong>Alarme :</strong> mobilisation des ressources.</li>
  <li><strong>Résistance :</strong> l''organisme tente de s''adapter.</li>
  <li><strong>Épuisement :</strong> les réserves sont à sec.</li>
</ul>
<h2>Que faire ?</h2>
<p>Identifier ses stresseurs, pratiquer la respiration guidée et maintenir des routines de récupération (sommeil, activité physique, pleine conscience).</p>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_stress_burnout, 'Reconnaître le burnout',
    'Comment identifier l''épuisement professionnel avant qu''il ne soit trop tard.',
    '<h2>Burnout : définition</h2>
<p>Le burnout, ou épuisement professionnel, est un syndrome résultant d''un stress chronique au travail. L''OMS le reconnaît comme un phénomène occupationnel depuis 2019.</p>
<h2>Les signes avant-coureurs</h2>
<ul>
  <li>Fatigue intense qui ne disparaît pas au repos.</li>
  <li>Cynisme et détachement vis-à-vis du travail.</li>
  <li>Sentiment d''inefficacité et perte de confiance.</li>
  <li>Troubles du sommeil, irritabilité, maux de tête.</li>
</ul>
<h2>Les 3 dimensions (Maslach)</h2>
<ol>
  <li><strong>Épuisement émotionnel :</strong> sentiment d''être vidé.</li>
  <li><strong>Dépersonnalisation :</strong> attitude froide envers les autres.</li>
  <li><strong>Réduction de l''accomplissement personnel.</strong></li>
</ol>
<h2>Prévention</h2>
<p>Poser des limites claires, prendre des pauses régulières, pratiquer la cohérence cardiaque et ne pas hésiter à consulter un professionnel.</p>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_stress_travail, 'Gérer le stress au travail',
    'Stratégies concrètes pour réduire la pression professionnelle au quotidien.',
    '<h2>Pourquoi le travail stresse-t-il autant ?</h2>
<p>Charge excessive, manque d''autonomie, conflits relationnels, insécurité… Le modèle de Karasek identifie deux facteurs clés : la demande psychologique et la latitude décisionnelle.</p>
<h2>Techniques rapides</h2>
<h3>La règle des 2 minutes</h3>
<p>Si une tâche prend moins de 2 minutes, faites-la immédiatement. Sinon, planifiez-la. Cela réduit l''accumulation mentale.</p>
<h3>La respiration avant une réunion</h3>
<p>3 cycles de cohérence cardiaque (5s/5s) suffisent à abaisser significativement votre niveau de cortisol.</p>
<h2>Organisation</h2>
<ul>
  <li>Décomposez les grands projets en micro-tâches.</li>
  <li>Bloquez des plages de travail profond sans interruption.</li>
  <li>Finissez la journée avec un rituel de déconnexion.</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id);

    -- Santé mentale — Anxiété
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES

    (p_anxiete_crises, 'Gérer les crises d''anxiété',
    'Techniques d''urgence pour traverser une crise d''anxiété ou une attaque de panique.',
    '<h2>Qu''est-ce qu''une crise d''anxiété ?</h2>
<p>Une crise d''anxiété est une montée soudaine d''une peur intense accompagnée de symptômes physiques : palpitations, oppression thoracique, vertiges, sensation d''irréalité.</p>
<h2>Technique d''ancrage 5-4-3-2-1</h2>
<p>Pendant la crise, nommez :</p>
<ul>
  <li>5 choses que vous <strong>voyez</strong></li>
  <li>4 choses que vous <strong>touchez</strong></li>
  <li>3 choses que vous <strong>entendez</strong></li>
  <li>2 choses que vous <strong>sentez</strong></li>
  <li>1 chose que vous <strong>goûtez</strong></li>
</ul>
<h2>La respiration carrée</h2>
<p>Inspirez 4s → retenez 4s → expirez 4s → retenez 4s. Ce pattern régule le système nerveux autonome en moins de 2 minutes.</p>
<h2>Ce qu''il ne faut pas faire</h2>
<ul>
  <li>Ne pas fuir systématiquement la situation anxiogène.</li>
  <li>Ne pas hyperventiler.</li>
  <li>Se rappeler : une crise d''anxiété est inconfortable mais pas dangereuse.</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_anxiete_tcc, 'La thérapie cognitive et comportementale (TCC)',
    'Comment la TCC aide à restructurer les pensées anxieuses.',
    '<h2>Qu''est-ce que la TCC ?</h2>
<p>La TCC est une approche psychothérapeutique qui agit sur les pensées dysfonctionnelles et les comportements d''évitement. Elle est la plus étudiée scientifiquement pour les troubles anxieux.</p>
<h2>Le triangle pensées-émotions-comportements</h2>
<p>Nos pensées influencent nos émotions, qui influencent nos comportements. En modifiant les pensées automatiques négatives, on modifie la réponse émotionnelle.</p>
<h2>Exercice : la restructuration cognitive</h2>
<ol>
  <li>Identifiez la pensée automatique (ex : "je vais échouer").</li>
  <li>Évaluez sa réalité : quelle preuve ? Quelle contre-preuve ?</li>
  <li>Formulez une pensée alternative réaliste.</li>
</ol>
<h2>Quand consulter ?</h2>
<p>Si l''anxiété impacte significativement votre vie quotidienne, un suivi TCC est recommandé. Une série de 8 à 20 séances est généralement suffisante.</p>',
    'html', false, 'published', true, NOW(), v_admin_id);

    -- Respiration
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES

    (p_resp_bases, 'Les bases de la respiration consciente',
    'Comprendre le lien entre respiration et système nerveux.',
    '<h2>Respiration et système nerveux</h2>
<p>La respiration est le seul processus autonome que nous pouvons contrôler consciemment. En modifiant notre rythme respiratoire, nous influençons directement le système nerveux autonome.</p>
<h2>Deux modes</h2>
<ul>
  <li><strong>Sympathique (stress) :</strong> respiration rapide et thoracique. Prépare au combat ou à la fuite.</li>
  <li><strong>Parasympathique (repos) :</strong> respiration lente et abdominale. Favorise la récupération.</li>
</ul>
<h2>Comment respirer correctement ?</h2>
<ol>
  <li>Posez une main sur le ventre, l''autre sur la poitrine.</li>
  <li>Inspirez par le nez : le ventre doit se soulever, pas la poitrine.</li>
  <li>Expirez lentement par la bouche. L''expiration doit être plus longue que l''inspiration.</li>
</ol>
<p>5 minutes de respiration abdominale abaissent la fréquence cardiaque et réduisent le cortisol.</p>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_resp_coh, 'La cohérence cardiaque',
    'La technique de respiration la plus étudiée pour réduire le stress.',
    '<h2>Définition</h2>
<p>La cohérence cardiaque est un état physiologique dans lequel la variabilité de la fréquence cardiaque se synchronise avec la respiration. Elle améliore la communication cœur-cerveau.</p>
<h2>La règle des 365</h2>
<ul>
  <li><strong>3</strong> fois par jour</li>
  <li><strong>6</strong> respirations par minute (5s inspiration / 5s expiration)</li>
  <li><strong>5</strong> minutes par session</li>
</ul>
<h2>Bénéfices prouvés</h2>
<ul>
  <li>Réduction du cortisol jusqu''à 23 % après 3 mois.</li>
  <li>Meilleure régulation émotionnelle.</li>
  <li>Amélioration de la qualité du sommeil.</li>
  <li>Renforcement immunitaire.</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_resp_crise, 'Respiration en situation de crise',
    'Techniques de respiration rapides pour les moments d''urgence émotionnelle.',
    '<h2>Quand on est submergé</h2>
<p>En situation de crise, la respiration s''emballe. Reprendre le contrôle de sa respiration est le levier le plus rapide pour interrompre la spirale.</p>
<h2>Technique 1 : Expiration prolongée</h2>
<p>Inspirez 4 secondes par le nez, expirez 6 à 8 secondes par la bouche. L''expiration plus longue active le nerf vague en moins de 30 secondes.</p>
<h2>Technique 2 : Respiration physiologique (soupir)</h2>
<p>Prenez une grande inspiration, puis une petite inspiration supplémentaire, puis expirez lentement tout l''air. Scientifiquement validé par Stanford comme le moyen le plus rapide de réduire le stress aigu.</p>
<h2>Technique 3 : Respiration carrée</h2>
<p>4s inspiration → 4s rétention → 4s expiration → 4s rétention. Utilisée par les Navy SEALs pour rester calmes sous pression extrême.</p>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_resp_478, 'La respiration 4-7-8',
    'La méthode 4-7-8 du Dr Andrew Weil contre l''anxiété et pour un meilleur endormissement.',
    '<h2>La respiration 4-7-8</h2>
<p>Développée par le Dr <strong>Andrew Weil</strong>, cette technique est surnommée le « tranquillisant naturel du système nerveux ».</p>
<ol>
  <li>Inspirer par le nez pendant <strong>4 secondes</strong></li>
  <li>Retenir son souffle pendant <strong>7 secondes</strong></li>
  <li>Expirer par la bouche pendant <strong>8 secondes</strong></li>
</ol>
<h2>Quand l''utiliser ?</h2>
<ul>
  <li>Pour s''endormir en moins de 2 minutes</li>
  <li>En cas de montée d''anxiété</li>
  <li>Avant une situation stressante (examen, prise de parole)</li>
</ul>
<p>Commencez par 4 cycles maximum, puis augmentez progressivement jusqu''à 8 cycles.</p>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_resp_box, 'Box Breathing : la technique des forces spéciales',
    'Utilisé par les Navy SEALs pour maintenir leur calme dans les situations à haute pression.',
    '<h2>Le box breathing ou respiration en boîte</h2>
<p>Popularisée par les <strong>forces spéciales américaines</strong>, cette technique tire son nom de la forme carrée de son cycle.</p>
<h2>Le cycle</h2>
<ol>
  <li>Inspiration par le nez : <strong>4 s</strong></li>
  <li>Rétention poumons pleins : <strong>4 s</strong></li>
  <li>Expiration par le nez : <strong>4 s</strong></li>
  <li>Rétention poumons vides : <strong>4 s</strong></li>
</ol>
<h2>Pourquoi ça fonctionne ?</h2>
<p>Les phases de rétention stimulent le nerf vague. L''effet est une <strong>réduction immédiate de la fréquence cardiaque</strong> et une clarté mentale accrue.</p>
<h2>Cas d''usage idéaux</h2>
<ul>
  <li>Avant une réunion importante ou un examen</li>
  <li>Lors d''une situation de crise</li>
  <li>Pour se reconcentrer après une interruption</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id);

    -- Sommeil
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES

    (p_sommeil_cycles, 'Les cycles du sommeil',
    'Comprendre l''architecture du sommeil pour mieux récupérer.',
    '<h2>Structure d''une nuit de sommeil</h2>
<p>Le sommeil se déroule en cycles de 90 minutes environ, répétés 4 à 6 fois par nuit. Chaque cycle comprend :</p>
<ul>
  <li><strong>Sommeil léger (N1-N2) :</strong> transition entre veille et sommeil profond.</li>
  <li><strong>Sommeil profond (N3) :</strong> récupération physique, consolidation immunitaire.</li>
  <li><strong>Sommeil paradoxal (REM) :</strong> rêves, consolidation mémorielle.</li>
</ul>
<h2>Pourquoi se lever à la fin d''un cycle ?</h2>
<p>Se réveiller en milieu de sommeil profond provoque une inertie du sommeil. En calculant ses cycles (multiples de 90 min + 15 min d''endormissement), on optimise la fraîcheur au réveil.</p>
<h2>Les ennemis du sommeil profond</h2>
<ul>
  <li>Alcool (perturbe le REM).</li>
  <li>Température > 19°C.</li>
  <li>Lumière bleue dans l''heure précédant le coucher.</li>
  <li>Repas copieux tardifs.</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_sommeil_stress, 'Stress et sommeil : le cercle vicieux',
    'Comment le stress perturbe le sommeil et comment briser ce cycle.',
    '<h2>Le lien bidirectionnel</h2>
<p>Le stress perturbe le sommeil, et le manque de sommeil augmente la réactivité au stress. Ce cercle vicieux est l''un des facteurs les plus fréquents dans les troubles anxieux.</p>
<h2>Ce qui se passe la nuit quand on est stressé</h2>
<ul>
  <li>Le cortisol reste élevé → difficulté à s''endormir.</li>
  <li>Le sommeil profond est réduit → récupération incomplète.</li>
  <li>Le REM est fragmenté → consolidation émotionnelle altérée.</li>
</ul>
<h2>Rituel pré-sommeil</h2>
<ol>
  <li>1h avant : extinction des écrans.</li>
  <li>30 min avant : lecture légère ou étirements doux.</li>
  <li>15 min avant : cohérence cardiaque (5 min) + scan corporel.</li>
</ol>',
    'html', false, 'published', true, NOW(), v_admin_id);

    -- Pleine conscience
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES

    (p_mind_intro, 'Introduction à la pleine conscience',
    'Qu''est-ce que le mindfulness et pourquoi le pratiquer ?',
    '<h2>Définition</h2>
<p>La pleine conscience (mindfulness) est la capacité à porter son attention sur le moment présent, de façon intentionnelle et sans jugement. Popularisée en Occident par Jon Kabat-Zinn.</p>
<h2>Les bénéfices validés</h2>
<ul>
  <li>Réduction de l''anxiété et des symptômes dépressifs.</li>
  <li>Meilleure gestion de la douleur chronique.</li>
  <li>Augmentation de l''attention et de la concentration.</li>
  <li>Développement de la résilience émotionnelle.</li>
</ul>
<h2>Méditation de la respiration — 5 minutes</h2>
<ol>
  <li>Asseyez-vous, dos droit, yeux fermés.</li>
  <li>Portez l''attention sur les sensations de la respiration.</li>
  <li>Quand l''esprit s''égare, ramenez-le doucement — sans jugement.</li>
  <li>Répétez pendant 5 minutes.</li>
</ol>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_mind_quotidien, 'Pleine conscience au quotidien',
    'Intégrer le mindfulness dans les activités de tous les jours.',
    '<h2>Le piège du pilote automatique</h2>
<p>Nous passons une grande partie de notre journée en mode "automatique" — mangeons sans goûter, marchons sans voir. La pleine conscience propose de sortir de ce mode.</p>
<h2>Exercices du quotidien</h2>
<h3>La pleine conscience en mangeant</h3>
<p>Mangez un repas par jour sans écran. Observez les couleurs, les textures, les saveurs. Ce simple exercice réduit le grignotage émotionnel.</p>
<h3>La marche consciente</h3>
<p>Portez attention à chaque pas, au contact du sol, aux sons autour de vous. 10 minutes suffisent à recentrer l''esprit.</p>
<h3>La pause de 3 minutes</h3>
<p>3 fois par jour : 1 min pour observer vos pensées, 1 min sur la respiration, 1 min sur votre corps entier.</p>',
    'html', false, 'published', true, NOW(), v_admin_id);

    -- Énergie & Nutrition
    INSERT INTO information_pages (id, title, description, content, content_type, currently_editing, status, active, creation_time, id_administrators) VALUES

    (p_energie_alim, 'Alimentation et énergie mentale',
    'Comment ce que vous mangez influence votre humeur et votre niveau de stress.',
    '<h2>Le cerveau, grand consommateur d''énergie</h2>
<p>Le cerveau représente 2 % de notre masse corporelle mais consomme 20 % de notre énergie. La qualité de notre alimentation influence directement nos capacités cognitives.</p>
<h2>Les aliments pro-sérénité</h2>
<ul>
  <li><strong>Oméga-3</strong> (poissons gras, noix, lin) : réduisent l''inflammation.</li>
  <li><strong>Magnésium</strong> (légumineuses, amandes, chocolat noir) : régulateur clé du système nerveux.</li>
  <li><strong>Tryptophane</strong> (œufs, banane, dinde) : précurseur de la sérotonine.</li>
</ul>
<h2>Ce qu''il faut limiter</h2>
<ul>
  <li>Sucres rapides (pics glycémiques → fatigue et irritabilité).</li>
  <li>Caféine excessive (amplifie la réponse au stress).</li>
  <li>Alcool (perturbateur du sommeil et anxiogène à long terme).</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_energie_hydrat, 'Hydratation et concentration',
    'L''impact souvent sous-estimé de l''hydratation sur les capacités mentales.',
    '<h2>La déshydratation, ennemi discret</h2>
<p>Une déshydratation de seulement 1 à 2 % du poids corporel suffit à réduire les performances cognitives, augmenter la fatigue et dégrader l''humeur.</p>
<h2>Besoins quotidiens</h2>
<p>1,5 à 2 litres d''eau par jour en conditions normales, davantage par temps chaud ou lors d''effort physique.</p>
<h2>Stratégies pour boire plus</h2>
<ul>
  <li>Commencer la journée par un grand verre d''eau à jeun.</li>
  <li>Avoir toujours une bouteille visible sur son bureau.</li>
  <li>Associer l''hydratation à des moments clés (avant chaque réunion).</li>
</ul>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_sport, 'Respiration et performance sportive',
    'Optimisez vos performances sportives grâce à des techniques de respiration adaptées.',
    '<h2>La respiration : le levier sous-estimé de la performance</h2>
<h3>Avant l''effort : activation</h3>
<p>5 minutes de respiration rythmée prépare votre système cardiovasculaire sans l''épuiser.</p>
<h3>Pendant l''effort</h3>
<ul>
  <li><strong>Course à pied :</strong> 3 foulées inspiration, 2 foulées expiration.</li>
  <li><strong>Musculation :</strong> expirez à l''effort, inspirez au retour.</li>
  <li><strong>Sports de combat :</strong> courtes expirations forcées à chaque technique.</li>
</ul>
<h3>Après l''effort : récupération</h3>
<p>Une session de 5 minutes de cohérence cardiaque dans les 30 minutes suivant l''effort accélère le retour à la normale de la fréquence cardiaque.</p>',
    'html', false, 'published', true, NOW(), v_admin_id),

    (p_immuno, 'Respiration et système immunitaire',
    'Des recherches récentes montrent que la respiration consciente peut renforcer notre immunité.',
    '<h2>Respiration et immunité : ce que dit la science</h2>
<p>La méthode Wim Hof a mis en lumière un lien inattendu : des <strong>exercices de respiration consciente peuvent moduler le système immunitaire</strong>.</p>
<h2>L''étude de référence (2014)</h2>
<p>Des participants entraînés à la méthode Wim Hof ont reçu une injection d''endotoxine. Résultat : leur réponse inflammatoire était <strong>deux fois moins intense</strong> que celle du groupe contrôle.</p>
<h2>Application pratique</h2>
<ul>
  <li>Pratiquez la cohérence cardiaque quotidiennement pour maintenir un niveau de cortisol bas.</li>
  <li>En période de stress intense, augmentez la durée de vos sessions à 10 minutes.</li>
</ul>
<p><em>Note : ces pratiques sont complémentaires aux soins médicaux et ne les remplacent pas.</em></p>',
    'html', false, 'published', true, NOW(), v_admin_id);

    -- =========================================================
    -- TAGGED — relations pages <-> tags
    -- =========================================================
    INSERT INTO tagged (id, id_information_tags) VALUES
        (p_stress_comprendre, tag_stress),   (p_stress_comprendre, tag_bien_etre),
        (p_stress_burnout,    tag_stress),   (p_stress_burnout,    tag_anxiete),
        (p_stress_travail,    tag_stress),   (p_stress_travail,    tag_bien_etre),   (p_stress_travail, tag_respiration),
        (p_anxiete_crises,    tag_anxiete),  (p_anxiete_crises,    tag_stress),      (p_anxiete_crises, tag_respiration),
        (p_anxiete_tcc,       tag_anxiete),  (p_anxiete_tcc,       tag_bien_etre),
        (p_resp_bases,        tag_respiration), (p_resp_bases,     tag_bien_etre),   (p_resp_bases,     tag_sante),
        (p_resp_coh,          tag_respiration), (p_resp_coh,       tag_coh_card),    (p_resp_coh,       tag_stress),
        (p_resp_crise,        tag_respiration), (p_resp_crise,     tag_anxiete),     (p_resp_crise,     tag_coh_card),
        (p_resp_478,          tag_respiration), (p_resp_478,       tag_sommeil),     (p_resp_478,       tag_anxiete),
        (p_resp_box,          tag_respiration), (p_resp_box,       tag_concentration),(p_resp_box,      tag_stress),
        (p_sommeil_cycles,    tag_sommeil),  (p_sommeil_cycles,    tag_bien_etre),   (p_sommeil_cycles, tag_sante),
        (p_sommeil_stress,    tag_sommeil),  (p_sommeil_stress,    tag_stress),      (p_sommeil_stress, tag_anxiete),
        (p_mind_intro,        tag_mindfulness),(p_mind_intro,      tag_bien_etre),   (p_mind_intro,     tag_anxiete),
        (p_mind_quotidien,    tag_mindfulness),(p_mind_quotidien,  tag_bien_etre),   (p_mind_quotidien, tag_concentration),
        (p_energie_alim,      tag_energie),  (p_energie_alim,      tag_bien_etre),   (p_energie_alim,   tag_sante),
        (p_energie_hydrat,    tag_energie),  (p_energie_hydrat,    tag_stress),      (p_energie_hydrat, tag_concentration),
        (p_sport,             tag_sante),    (p_sport,             tag_energie),     (p_sport,          tag_respiration),
        (p_immuno,            tag_sante),    (p_immuno,            tag_respiration), (p_immuno,         tag_bien_etre)
    ON CONFLICT DO NOTHING;

    -- =========================================================
    -- NAVIGATION MENUS (avec parent_id pour les sous-menus)
    -- =========================================================

    -- Racines (parent_id = NULL)
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_sante_h,   NULL, 1, 'Santé mentale',       NULL,               false, NOW()),
        (m_resp_h,    NULL, 2, 'Respiration',          NULL,               false, NOW()),
        (m_sommeil_h, NULL, 3, 'Sommeil',              NULL,               false, NOW()),
        (m_mind_h,    NULL, 4, 'Pleine conscience',    NULL,               false, NOW()),
        (m_energie_h, NULL, 5, 'Énergie & Nutrition',  NULL,               false, NOW()),
        (m_apropos_h, NULL, 6, 'À propos',             NULL,               false, NOW()),
        (m_contact,   NULL, 7, 'Contact',              '/contact',         false, NOW()),
        (m_legal,     NULL, 8, 'Informations légales', NULL,               false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → Santé mentale
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_stress,   m_sante_h, 1, 'Comprendre le stress',  'cesizen://info-page/883642a9-74a7-43ed-aea4-380091685a29' , false, NOW()),
        (m_burnout,  m_sante_h, 2, 'Reconnaître le burnout','cesizen://info-page/' || p_stress_burnout::text,    false, NOW()),
        (m_anxiete,  m_sante_h, 3, 'Gérer son anxiété',     'cesizen://info-page/' || p_anxiete_crises::text,   false, NOW()),
        (m_tcc,      m_sante_h, 4, 'Thérapie cognitive TCC','cesizen://info-page/' || p_anxiete_tcc::text,      false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → Respiration
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_resp_bases, m_resp_h, 1, 'Les bases',             'cesizen://info-page/' || p_resp_bases::text, false, NOW()),
        (m_resp_coh,   m_resp_h, 2, 'Cohérence cardiaque',   'cesizen://info-page/' || p_resp_coh::text,   false, NOW()),
        (m_resp_crise, m_resp_h, 3, 'En situation de crise', 'cesizen://info-page/' || p_resp_crise::text, false, NOW()),
        (m_resp_478,   m_resp_h, 4, 'Technique 4-7-8',       'cesizen://info-page/' || p_resp_478::text,   false, NOW()),
        (m_resp_box,   m_resp_h, 5, 'Box Breathing',         'cesizen://info-page/' || p_resp_box::text,   false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → Sommeil
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_sommeil,    m_sommeil_h, 1, 'Les cycles du sommeil', 'cesizen://info-page/' || p_sommeil_cycles::text, false, NOW()),
        (m_som_stress, m_sommeil_h, 2, 'Stress et sommeil',     'cesizen://info-page/' || p_sommeil_stress::text, false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → Pleine conscience
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_mind_intro, m_mind_h, 1, 'Introduction', 'cesizen://info-page/' || p_mind_intro::text,     false, NOW()),
        (m_mind_quot,  m_mind_h, 2, 'Au quotidien', 'cesizen://info-page/' || p_mind_quotidien::text, false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → Énergie & Nutrition
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_alim,    m_energie_h, 1, 'Alimentation & humeur', 'cesizen://info-page/' || p_energie_alim::text,  false, NOW()),
        (m_hydrat,  m_energie_h, 2, 'Hydratation',           'cesizen://info-page/' || p_energie_hydrat::text,false, NOW()),
        (m_sport_m, m_energie_h, 3, 'Sport & récupération',  'cesizen://info-page/' || p_sport::text,         false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → À propos (pas de page associée, liens nuls)
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_mission,     m_apropos_h, 1, 'Notre mission',    NULL, false, NOW()),
        (m_equipe,      m_apropos_h, 2, 'L''équipe',        NULL, false, NOW()),
        (m_partenaires, m_apropos_h, 3, 'Nos partenaires',  NULL, false, NOW())
    ON CONFLICT DO NOTHING;

    -- Sous-menus → Informations légales (pas de page associée, liens nuls)
    INSERT INTO navigation_menu (id, parent_id, position, label, url, currently_editing, creation_time) VALUES
        (m_mentions,     m_legal, 1, 'Mentions légales',            NULL, false, NOW()),
        (m_confidential, m_legal, 2, 'Politique de confidentialité', NULL, false, NOW())
    ON CONFLICT DO NOTHING;

    -- =========================================================
    -- CONFIGURATIONS ADMIN (pour le dashboard backoffice)
    -- =========================================================
    INSERT INTO configurations (id, name, inhalation, retention1, exhalation, retention2, duration_minutes, difficulty, objective, guidance_type, creation_time, id_administrators) VALUES
        (c1, 'Cohérence cardiaque 5-5',    5, 0, 5, 0,  5, 1, 'Relaxation',  'Visual',   NOW(), v_admin_id),
        (c2, 'Box Breathing 4-4-4-4',      4, 4, 4, 4,  5, 2, 'Focus',       'Visual',   NOW(), v_admin_id),
        (c3, 'Respiration 4-7-8',          4, 7, 8, 0,  8, 2, 'Sommeil',     'Audio',    NOW(), v_admin_id),
        (c4, 'Relaxation profonde 4-4-6-2',4, 4, 6, 2, 10, 3, 'Relaxation',  'Audio',    NOW(), v_admin_id),
        (c5, 'Énergie matinale 4-0-4-0',   4, 0, 4, 0,  5, 1, 'Énergie',     'Visual',   NOW(), v_admin_id),
        (c6, 'Anti-stress express 3-0-6-0',3, 0, 6, 0,  3, 1, 'Relaxation',  'Haptique', NOW(), v_admin_id),
        (c7, 'Concentration avancée 4-4-4-4-avancé', 4, 4, 4, 4, 15, 4, 'Focus', 'Visual', NOW(), v_admin_id)
    ON CONFLICT DO NOTHING;

    -- =========================================================
    -- QUIZZES
    -- Champs valides : inhalation | retention1 | exhalation | retention2
    --                  durationminutes | difficulty | objective | guidancetype
    -- =========================================================
    INSERT INTO quizz (id, nom, active, creation_time) VALUES
        (q1, 'Évaluation de mon niveau de stress',    true, NOW()),
        (q2, 'Préparer un meilleur sommeil',           true, NOW()),
        (q3, 'Booster ma concentration',               true, NOW()),
        (q4, 'Gestion d''une crise d''anxiété',        true, NOW()),
        (q5, 'Récupération après effort sportif',      true, NOW())
    ON CONFLICT DO NOTHING;

    -- ─────────────────────────────────────────────────────────
    -- QUIZ 1 : Niveau de stress → ajuste exhalation & durationminutes
    -- ─────────────────────────────────────────────────────────
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment décrivez-vous votre niveau de stress en ce moment ?', 1, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Très stressé(e), débordé(e)',        1, 'exhalation',     'add', '3', NOW(), qq),
        (gen_random_uuid(), 'Modérément stressé(e)',              2, 'exhalation',     'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Légèrement stressé(e), mais ça va', 3, 'exhalation',     'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Calme et serein(e)',                 4, 'exhalation',     'set', '4', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Depuis combien de temps ressentez-vous cela ?', 2, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Plus d''une semaine (stress chronique)', 1, 'durationminutes', 'add', '5', NOW(), qq),
        (gen_random_uuid(), 'Quelques jours',                         2, 'durationminutes', 'add', '3', NOW(), qq),
        (gen_random_uuid(), 'Seulement aujourd''hui',                 3, 'durationminutes', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'C''est ponctuel, pas d''habitude',       4, 'durationminutes', 'set', '5', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Ressentez-vous des tensions physiques (nuque, épaules, mâchoire) ?', 3, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, très prononcées',  1, 'retention1', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Oui, modérées',          2, 'retention1', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Légères',                3, 'retention1', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Non, aucune tension',    4, 'retention1', 'set', '2', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quel est votre objectif pour cette séance ?', 4, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Me détendre et relâcher la pression', 1, 'objective', 'set', 'Relaxation', NOW(), qq),
        (gen_random_uuid(), 'Retrouver ma concentration',          2, 'objective', 'set', 'Focus',      NOW(), qq),
        (gen_random_uuid(), 'Recharger mes batteries',             3, 'objective', 'set', 'Énergie',    NOW(), qq),
        (gen_random_uuid(), 'Préparer un meilleur sommeil',        4, 'objective', 'set', 'Sommeil',    NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment préférez-vous être guidé(e) ?', 5, NOW(), q1);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Visuellement (animation, barre)',  1, 'guidancetype', 'set', 'Visual',   NOW(), qq),
        (gen_random_uuid(), 'Par le son (musique, bip)',        2, 'guidancetype', 'set', 'Audio',    NOW(), qq),
        (gen_random_uuid(), 'Par vibrations/haptique',          3, 'guidancetype', 'set', 'Haptique', NOW(), qq),
        (gen_random_uuid(), 'Pas de guidage, je gère seul(e)', 4, 'guidancetype', 'set', 'Aucun',    NOW(), qq);
    END;

    -- ─────────────────────────────────────────────────────────
    -- QUIZ 2 : Préparer le sommeil → ajuste inhalation, exhalation, durationminutes, objective
    -- ─────────────────────────────────────────────────────────
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quel est votre principal problème de sommeil ?', 1, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'J''ai du mal à m''endormir (ruminations)', 1, 'exhalation',     'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Je me réveille la nuit sans raison',        2, 'retention2',     'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Je me réveille trop tôt le matin',          3, 'durationminutes','add', '5', NOW(), qq),
        (gen_random_uuid(), 'Mon sommeil n''est pas réparateur',         4, 'durationminutes','add', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Votre esprit a-t-il tendance à s''emballer le soir ?', 2, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, pensées incessantes',                    1, 'exhalation', 'add', '3', NOW(), qq),
        (gen_random_uuid(), 'Parfois, quand je suis stressé(e)',           2, 'exhalation', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Rarement',                                    3, 'exhalation', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Non, je m''endors facilement d''habitude',   4, 'exhalation', 'set', '5', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quelle durée de séance vous convient avant de dormir ?', 3, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), '5 minutes maximum',    1, 'durationminutes', 'set', '5',  NOW(), qq),
        (gen_random_uuid(), '10 minutes',           2, 'durationminutes', 'set', '10', NOW(), qq),
        (gen_random_uuid(), '15 minutes',           3, 'durationminutes', 'set', '15', NOW(), qq),
        (gen_random_uuid(), '20 minutes ou plus',   4, 'durationminutes', 'set', '20', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Préférez-vous la lumière éteinte pendant l''exercice ?', 4, NOW(), q2);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, obscurité totale, guidage sonore',   1, 'guidancetype', 'set', 'Audio',    NOW(), qq),
        (gen_random_uuid(), 'Légère veilleuse, je regarde l''écran',   2, 'guidancetype', 'set', 'Visual',   NOW(), qq),
        (gen_random_uuid(), 'Je ferme les yeux, vibrations suffisent', 3, 'guidancetype', 'set', 'Haptique', NOW(), qq),
        (gen_random_uuid(), 'Je n''utilise pas d''écran le soir',      4, 'guidancetype', 'set', 'Audio',    NOW(), qq);
    END;

    -- ─────────────────────────────────────────────────────────
    -- QUIZ 3 : Concentration → ajuste inhalation, durationminutes, difficulty, objective
    -- ─────────────────────────────────────────────────────────
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Comment décrivez-vous votre niveau d''énergie en ce moment ?', 1, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Épuisé(e), j''ai besoin d''un coup de fouet',1, 'inhalation', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Un peu fatigué(e)',                           2, 'inhalation', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Énergie normale, je veux optimiser',          3, 'inhalation', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Énergique, je veux rester dans cet état',    4, 'inhalation', 'set', '3', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Dans quel contexte faites-vous cet exercice ?', 2, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Avant une tâche demandant de la concentration', 1, 'objective', 'set', 'Focus',      NOW(), qq),
        (gen_random_uuid(), 'Avant un effort physique',                       2, 'objective', 'set', 'Énergie',    NOW(), qq),
        (gen_random_uuid(), 'Pour rester alerte en fin de journée',          3, 'objective', 'set', 'Énergie',    NOW(), qq),
        (gen_random_uuid(), 'En pause pour me ressourcer',                   4, 'objective', 'set', 'Relaxation', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Combien de temps pouvez-vous consacrer à cet exercice ?', 3, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), '2-3 minutes (pause éclair)',    1, 'durationminutes', 'set', '3',  NOW(), qq),
        (gen_random_uuid(), '5 minutes',                    2, 'durationminutes', 'set', '5',  NOW(), qq),
        (gen_random_uuid(), '10 minutes',                   3, 'durationminutes', 'set', '10', NOW(), qq),
        (gen_random_uuid(), 'Pas de contrainte de temps',   4, 'durationminutes', 'set', '8',  NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous de l''expérience avec les exercices de respiration ?', 4, NOW(), q3);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Débutant(e) complet(e)',                   1, 'difficulty', 'set', '1', NOW(), qq),
        (gen_random_uuid(), 'Quelques séances derrière moi',            2, 'difficulty', 'set', '2', NOW(), qq),
        (gen_random_uuid(), 'Pratique régulière (plusieurs semaines)',  3, 'difficulty', 'set', '3', NOW(), qq),
        (gen_random_uuid(), 'Pratique avancée',                         4, 'difficulty', 'set', '4', NOW(), qq);
    END;

    -- ─────────────────────────────────────────────────────────
    -- QUIZ 4 : Gestion anxiété → ajuste exhalation, inhalation, retention1, durationminutes, guidancetype
    -- ─────────────────────────────────────────────────────────
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'À quel point vous sentez-vous anxieux/se en ce moment ?', 1, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Très fortement (palpitations, oppression)', 1, 'exhalation', 'set', '8', NOW(), qq),
        (gen_random_uuid(), 'Modérément (agitation intérieure)',          2, 'exhalation', 'set', '6', NOW(), qq),
        (gen_random_uuid(), 'Légèrement (nervosité)',                     3, 'exhalation', 'set', '5', NOW(), qq),
        (gen_random_uuid(), 'Peu, je veux prévenir l''anxiété',          4, 'exhalation', 'set', '4', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous des sensations physiques (souffle court, gorge serrée) ?', 2, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, très prononcées', 1, 'inhalation', 'set', '3', NOW(), qq),
        (gen_random_uuid(), 'Oui, modérées',        2, 'inhalation', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Légères',              3, 'inhalation', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Non, plutôt mental',   4, 'inhalation', 'set', '5', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Avez-vous tendance à hyperventiler sous stress ?', 3, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, je respire très vite', 1, 'retention1', 'set', '1', NOW(), qq),
        (gen_random_uuid(), 'Parfois',                   2, 'retention1', 'set', '2', NOW(), qq),
        (gen_random_uuid(), 'Rarement',                  3, 'retention1', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Non, jamais',               4, 'retention1', 'set', '4', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quelle durée de séance vous semble accessible maintenant ?', 4, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), '1-2 minutes seulement',          1, 'durationminutes', 'set', '2',  NOW(), qq),
        (gen_random_uuid(), '5 minutes',                      2, 'durationminutes', 'set', '5',  NOW(), qq),
        (gen_random_uuid(), '10 minutes',                     3, 'durationminutes', 'set', '10', NOW(), qq),
        (gen_random_uuid(), 'Pas de limite, je veux que ça passe', 4, 'durationminutes', 'set', '15', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Êtes-vous dans un endroit où vous pouvez sortir votre téléphone ?', 5, NOW(), q4);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, seul(e) dans un endroit calme',      1, 'guidancetype', 'set', 'Visual',   NOW(), qq),
        (gen_random_uuid(), 'Dans un lieu public (transports, couloir)',2, 'guidancetype', 'set', 'Haptique', NOW(), qq),
        (gen_random_uuid(), 'Au bureau avec des collègues',             3, 'guidancetype', 'set', 'Visual',   NOW(), qq),
        (gen_random_uuid(), 'Je ne peux pas sortir mon téléphone',     4, 'guidancetype', 'set', 'Aucun',    NOW(), qq);
    END;

    -- ─────────────────────────────────────────────────────────
    -- QUIZ 5 : Récupération sportive → ajuste inhalation, exhalation, durationminutes, objective
    -- ─────────────────────────────────────────────────────────
    DECLARE qq UUID;
    BEGIN
    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Quel type d''effort venez-vous de réaliser ?', 1, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Effort intense (HIIT, sport de combat, sprint)', 1, 'inhalation', 'add', '2', NOW(), qq),
        (gen_random_uuid(), 'Endurance modérée (course, vélo, natation)',      2, 'inhalation', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Entraînement de force (musculation)',             3, 'inhalation', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Activité légère (marche, yoga, stretching)',      4, 'inhalation', 'set', '4', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Combien de temps après l''effort pratiquez-vous ?', 2, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Immédiatement (< 5 min après l''effort)', 1, 'objective', 'set', 'Relaxation', NOW(), qq),
        (gen_random_uuid(), 'Dans les 30 minutes',                     2, 'objective', 'set', 'Relaxation', NOW(), qq),
        (gen_random_uuid(), '1 heure après',                           3, 'objective', 'set', 'Énergie',    NOW(), qq),
        (gen_random_uuid(), 'Le soir, pour la récupération nocturne',  4, 'objective', 'set', 'Sommeil',    NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Ressentez-vous des tensions musculaires importantes ?', 3, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, importantes',          1, 'durationminutes', 'add', '5', NOW(), qq),
        (gen_random_uuid(), 'Oui, légères',              2, 'durationminutes', 'add', '3', NOW(), qq),
        (gen_random_uuid(), 'Non, effort modéré',        3, 'durationminutes', 'set', '5', NOW(), qq),
        (gen_random_uuid(), 'Non, exercice très léger',  4, 'durationminutes', 'set', '5', NOW(), qq);

    qq := gen_random_uuid();
    INSERT INTO questions (id, text, position, creation_time, id_quizz) VALUES (qq, 'Votre fréquence cardiaque est-elle encore élevée ?', 4, NOW(), q5);
    INSERT INTO responses_options (id, label, position, targeted_field, operation, value, creation_time, id_questions) VALUES
        (gen_random_uuid(), 'Oui, toujours très élevée',              1, 'exhalation', 'add', '3', NOW(), qq),
        (gen_random_uuid(), 'Oui, légèrement au-dessus de la normale',2, 'exhalation', 'add', '1', NOW(), qq),
        (gen_random_uuid(), 'Revenue à la normale',                    3, 'exhalation', 'set', '4', NOW(), qq),
        (gen_random_uuid(), 'Je ne sais pas',                          4, 'exhalation', 'set', '5', NOW(), qq);
    END;

    RAISE NOTICE 'Seed CesiZen terminé avec succès.';
END $$;
